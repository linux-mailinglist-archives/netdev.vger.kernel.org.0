Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4436A471E8
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 21:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfFOTTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 15:19:46 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:35566 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfFOTTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 15:19:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hcEDF-0003GL-7P; Sat, 15 Jun 2019 21:19:41 +0200
Message-ID: <e487656b854ca999d14eb8072e5553eb2676a9f4.camel@sipsolutions.net>
Subject: Re: VLAN tags in mac_len
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        jhs@mojatatu.com, David Ahern <dsahern@gmail.com>,
        Zahari Doychev <zahari.doychev@linux.com>,
        Simon Horman <simon.horman@netronome.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date:   Sat, 15 Jun 2019 21:19:39 +0200
In-Reply-To: <20190615151913.cgrfyflwwnhym4u2@ast-mbp.dhcp.thefacebook.com> (sfid-20190615_171920_335500_51B18C20)
References: <68c99662210c8e9e37f198ddf8cb00bccf301c4b.camel@sipsolutions.net>
         <20190615151913.cgrfyflwwnhym4u2@ast-mbp.dhcp.thefacebook.com>
         (sfid-20190615_171920_335500_51B18C20)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

Sorry for messing up your address btw, not sure where I dug that one
up...

> >  1) Make the bridge code use skb->mac_len instead of ETH_HLEN. This
> >     works for this particular case, but breaks some other cases;
> >     evidently some places exist where skb->mac_len isn't even set to
> >     ETH_HLEN when a packet gets to the bridge. I don't know right now
> >     what that was, I think probably somebody who's CC'ed reported that.
> > 
> >  2) Let tc_act_vlan() just pull ETH_HLEN instead of skb->mac_len, but
> >     this is rather asymmetric and strange, and while it works for this
> >     case it may cause confusion elsewhere.
> > 
> >  2b) Toshiaki said it might be better to make that code *remember*
> >      mac_len and then use it to push and pull (so not caring about the
> >      change made by skb_vlan_push()), but that ultimately leads to
> >      confusion and if you have TC push/pop combinations things just get
> >      completely out of sync and die
> > 
> >  3) Make skb_vlan_push()/_pop() just not change mac_len at all. So far
> >     this also addresses the issue, but it's likely that this will break
> >     OVS, and I don't know how it'd affect BPF. Quite possibly like TC
> >     does and is broken, but perhaps not.
> > 
> > 
> > But now we're stuck. Depending on how you look at it, all of these seem
> > sort of reasonable, or not.
> > 
> > Ultimately, the issue seems to be that we couldn't really decide whether
> > VLAN tags (and probably MPLS tags, for that matter) are covered by
> > mac_len or not. At least not consistently on ingress and egress.
> > eth_type_trans() doesn't take them into account, so of course on simple
> > ingress mac_len will only cover the ETH_HLEN.
> > 
> > If you have an accelerated tag and then push it into the SKB, it will
> > *not* be taken into account in mac_len. OTOH, if you have a new tag and
> > use skb_vlan_push() then it *will* be taken into account.
> > 
> > 
> > I'm trending towards solution (3), because if we consider other
> > combinations of VLAN push/pop in TC, I think we can end up in a very
> > messy situation today. For example, POP/PUSH seems like it should be a
> > no-op, but it isn't due to the mac_len, *unless* it can use the HW accel
> > only (i.e. only a single tag).
> > 
> > I think then to propose such a patch though we'd have to figure out
> > where the BPF case is, and to keep OVS working probably either add an
> > argument ("bool adjust_mac_len") to the function signatures, or just do
> > the adjustments in OVS code after calling them?
> > 
> > 
> > Any other thoughts?
> 
> imo skb_vlan_push() should still change mac_len.
> tc, ovs, bpf use it and expect vlan to be part of L2.

I'm not sure tc really cares, but it *is* a reasonable argument to make.

Like I said, whichever way I look at the problem, a different solution
looks more reasonable ;-)

> There is nothing between L2 and L3 :)
> Hence we cannot say that vlan is not part of L2.
> Hence push/pop vlan must change mac_len, since skb->mac_len
> is kernel's definition of the length of L2 header.

I think we're getting to something here now. I actually thought about
this some more last night, and basically asked myself how I would design
it without all the legacy baggage.

I'm certainly not suggesting we should change anything here, but to me
it was a bit of a clarification to do this and then see where we differ
in our handling today.

Thinking along those lines, I sort of ended up with the following scheme
(just for the skb head, not the frags/fraglist):

          +------------------+----------------+---------------+
 headroom | eth | vlan | ... | IP  | TCP      | payload       | tailroom
          +------------------+----------------+---------------+
^ skb->head_ptr
          ^ skb->l2_ptr
                             ^ skb->l3_ptr == skb->l2_ptr + skb->l2_len
                                    ...
                                              ^ skb->payload_ptr
                                                              ^ skb->tail

Now, I deliberately didn't put any "skb->data" here, because what we do
today is sort of confusing.

By getting rid of the "multi-use" skb->data in this scheme I think it
becomes clearer to think about.



On *egress*, all we really care about is this:

          +------------------+----------------+---------------+
 headroom | eth | vlan | ... | IP / TCP       | payload       | tailroom
          +------------------+----------------+---------------+
         
^ skb->data
                                         skb->data + skb->len 
^

On *ingress*, however, we hide some of the data (temporarily):

|--------- headroom ---------|
          +------------------+----------------+---------------+
          | eth | vlan | ... | IP / TCP       | payload       | tailroom
          +------------------+----------------+---------------+
          ^ skb->data - skb->mac_len
                             ^ skb->data
                                         skb->data + skb->len ^

which is somewhat confusing to me, and sort of causes all these
problems.

(It also makes it harder to reason about what data is actually valid in
the skb, although if mac_len is non-zero then it must be, but it means
you actually have less headroom and all).

If instead we just made it like the hypothetical scheme I outlined
above, then on traversing a layer we'd set the next layer pointer
appropriately, and then each layer would just use the right pointer:

 * bridge/ethernet driver/... would use l2_ptr
 * IP would use the l3_ptr
 * TCP would use the l4_ptr (didn't put that into the picture)
 * ...

Now we wouldn't have a problem with the VLAN tags, because we'd just
appropriate set/keep all the pointers - bridge doesn't even care where
l3_ptr is pointing, but for IP it would of course point to beyond the
VLAN tags.

(Now, if you wanted to implement this, you probably wouldn't have l2_ptr
but l2_offset etc. but that's an implementation detail.)

Now, why am I writing all this? Because I think it points out that
you're absolutely right - we should treat mac_len as part of the frame
if we're in anything that cares about L2 like bridge.

> Now as far as bridge... I think it's unfortunate that linux
> adopted 'vlan' as a netdevice model and that's where I think
> the problem is.

I'm not sure. I don't exactly know where the problem is if we fix bridge
according to the patch (1) above, which, btw, was discussed before:
https://lore.kernel.org/netdev/20190113135939.8970-1-zahari.doychev@linux.com/

Back then, Nikolay (whom I forgot to CC, fixed now) said:

> It breaks connectivity between bridge and
> members when vlans are used. The host generated packets going out of the bridge
> have mac_len = 0.

Which probably indicates that we're not even consistent with the egress
scheme I pointed out above, probably because we *also* have
hard_header_len?

Maybe somewhere early in the egress path we should set skb->mac_len to
dev->hard_header_len, and then use skb->mac_len consistently, and
consider that part of the skb (and not arbitrarily consider ETH_HLEN to
be part of the skb in bridge).

(This almost tempts me to actually try to implement the hypothetical SKB
scheme I described above, just so it's easier to understand what part
does what ... and to find where the issues like this occur)

> Typical bridge in the networking industry is a device that
> does forwarding based on L2. Which includes vlans.
> And imo that's the most appropriate way of configuring and thinking
> about bridge functionality.
> Whereas in the kernel there is a 'vlan' netdevice that 'eats'
> vlan tag and pretends that the rest is the same.
> So linux bridge kinda doesn't need to be vlan aware.
> CONFIG_BRIDGE_VLAN_FILTERING was the right step, but I haven't
> seen it being used and I'm not sure about state of things there.

I think that ends up being a question of semantics. You can consider an
"industry bridge" that you describe to be a combination of VLAN and
bridge netdevs, and so it's just a question of what exactly you consider
a "bridge" - does it have to be a single netdev or not.

> So your option 1 above is imo the best. The bridge needs to deal
> with skb->mac_len and full L2 header.

Yeah, I guess. We're back to square 1 ;-)

I'm not even sure I understand the bug that Nikolay described, because
br_dev_xmit() does:

        skb_reset_mac_header(skb);
        eth = eth_hdr(skb);
        skb_pull(skb, ETH_HLEN);

so after this we *do* end up with an SKB that has mac_len == ETH_HLEN,
if it was transmitted out the bridge netdev itself, and thus how would
the bug happen?

Thanks,
johannes

