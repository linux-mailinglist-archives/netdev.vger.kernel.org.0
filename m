Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549F2431FD5
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhJROgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhJROgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:36:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EC3C06161C;
        Mon, 18 Oct 2021 07:34:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mcTig-0007Ls-1l; Mon, 18 Oct 2021 16:34:30 +0200
Date:   Mon, 18 Oct 2021 16:34:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
Message-ID: <20211018143430.GB28644@breakpoint.cc>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
 <20211013092235.GA32450@breakpoint.cc>
 <20211015210448.GA5069@breakpoint.cc>
 <378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:

Hi David

TL;DR:
What is your take on the correct/expected behaviour with vrf+conntrack+nat?

> Thanks for jumping in, Florian.

NP.

Sorry for the wall of text below.

You can fast-forward to 'Possible solutions' if you want, but they key
question for me at the moment is the one above.

I've just submitted a selftest patch to nf.git that adds test
cases for the problem reported by Eugene + two masquerade/snat test
cases.

With net/net-next, first test fails and the other two work, after
revert its vice versa.

To get all three working there are a couple of possible solutions to
this but so far I don't have anything that is void of side effects.

It assumes revert of the problematic commit, i.e. no nf_reset_ct in
ingress path from VRF driver.

First, a summary of VRF+nf+conntrack interaction and where problems are.

The VRF driver invokes netfilter for output+postrouting hooks,
with outdev set to the vrf device. Afterwards, ip stack calls those
hooks again, with outdev set to lower device.

This is a problem when conntrack is used with IP masquerading.
With all nf_reset_ct() in vrf driver removed following will happen:

1. Conntrack only, no nat, locally generated traffic.

vrf driver calls output/postrouting hooks.
output creates new conntrack object and attaches it to skb.
postrouting confirms entry and places it into state table.

When hooks are called a second time by IP stack, no new conntrack lookup is
done because skb already has one attached to it.

2. When SNAT is used, this works as well, second iteration doesn't
   do connection tracking and re-uses nat settings done in iteration 1.

However there are caveats:
a) NAT rules that use something like '-o eth0' won't have any effect.
b) IP address matching in round 2 is 'broken', as the second round deals
with a rewritten skb (iph saddr already updated).

This is because when the hooks are invoked a second time, there already
is a NAT binding attached to the entry. This happens regardless of a
matching '-o vrfdevice' nat rule or not; when first round did not match
a nat rule, nat engine attaches a 'nat null binding'.

3) When Masquerade is used, things don't work at all.

This is because of nf_nat_oif_changed() triggering errnously in the nat
engine.  When masquerade is hit, the output interface index gets stored
in the conntrack entry.  When the interface index changes, its assumed
that a routing change took place and the connection has been broken
(masquerade picks saddr based on the output interface).

Therefore, NF_DROP gets returned.

In VRF case, this triggers because we see the skb twice, once with
ifindex == vrf and once with lower/physdev.

I suspect that this is what lead eb63ecc1706b3e094d0f57438b6c2067cfc299f2
(net: vrf: Drop conntrack data after pass through VRF device on Tx),
this added nf_reset() calls to the tx path.

This changes things as follows:

1. Conntrack only, no nat:
same as before, expect that the second round does a new conntrack lookup.
It will find the entry created by first iteration and use that.

2. With nat:
If first round has no matching nat rule, things work:
Second round will find existing entry and use it.
NAT rules on second iteration have no effect, just like before.

If first round had a matching nat rule, then the packet gets rewritten.
This means that the second round will NOT find an existing entry, and
conntrack tracks the flow a second time, this time with the post-nat
source address.

Because of this, conntrack will also detect a tuple collision when it
tries to insert the 'new flow incarnation', because the reply direction
of the 'first round flow' collides with the original direction of the
second iteration. This forces allocation of a new source port, so source
port translation is done.

This in turn breaks in reverse direction, because incoming/reply packet
only hits the connection tracking engine once, i.e. only the source
port translation is reversed.

To fix this, Lahav also added nf_reset_ct() to ingress processing to
undo the first round nat transformation as well.

... and that in turn breaks 'notrack', 'mark' or 'ct zone' assignments
done based on the incoming/lower device -- the nf_reset_ct zaps those
settings before round 2 so they have no effect anymore.

Possible solutions
==================

Taking a few steps back and ignoring 'backwards compat' for now, I think
that conntrack should process the flow only once.  VRF doesn't transform the
packets in any way and the only reason for the extra NF_HOOK() calls appear to
be so that users can match on the incoming/outgoing vrf interface.

a)
For locally generated packets, the most simple fix would be to mark
skb->nfct as 'untracked', and clear it again instead of nf_reset_ct().

This avoids the need to change anyting on conntrack/nat side.
The downside is that it becomes impossible to add nat mappings based
on '-o vrf', because conntrack gets bypassed in round 1.

For forwarding case (where OUTPUT hooks are not hit and
ingress path has attached skb->nfct), we would need to find a different
way to bypass conntrack.  One solution (least-LOC) is to nf_reset() and
then mark skb as untracked.  IP(6)CB should have FORWARD flag set that
can be used to detect this condition.

b)
make the nf_ct_reset calls in vrf tx path conditional.
Its possible to detect when a NAT rule was hit via ct->status bits.

When the NF_HOOK() calls invoked via VRF found a SNAT/MASQ rule,
don't reset the conntrack entry.

Downside 1: the second invocation is done with 'incorrect' ip source
address, OTOH that already happens at this time.

Downside 2: We need to alter conntrack/nat to avoid the 'oif has
changed' logic from kicking in.

I don't see other solutions at the moment.

For INPUT, users can also match the lower device via inet_sdif()
(original ifindex stored in IP(6)CB), but we don't have that
for output, and its not easy to add something because IPCB isn't
preserved between rounds 1 & 2.
