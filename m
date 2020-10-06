Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE638284AB3
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 13:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgJFLQR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Oct 2020 07:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFLQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 07:16:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9CEC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 04:16:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kPkww-0004p1-KD; Tue, 06 Oct 2020 13:16:06 +0200
Date:   Tue, 6 Oct 2020 13:16:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     nusiddiq@redhat.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, davem@davemloft.net,
        Aaron Conole <aconole@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: Re: [PATCH net-next] net: openvswitch: Add support to lookup invalid
 packet in ct action.
Message-ID: <20201006111606.GA18203@breakpoint.cc>
References: <20201006083355.121018-1-nusiddiq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201006083355.121018-1-nusiddiq@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nusiddiq@redhat.com <nusiddiq@redhat.com> wrote:
> From: Numan Siddique <nusiddiq@redhat.com>
> 
> For a tcp packet which is part of an existing committed connection,
> nf_conntrack_in() will return err and set skb->_nfct to NULL if it is
> out of tcp window. ct action for this packet will set the ct_state
> to +inv which is as expected.

This is because from conntrack p.o.v., such TCP packet is NOT part of
the existing connection.

For example, because it is considered part of a previous incarnation
of the same connection.

> But a controller cannot add an OVS flow as
> 
> table=21,priority=100,ct_state=+inv, actions=drop
> 
> to drop such packets. That is because when ct action is executed on other
> packets which are not part of existing committed connections, ct_state
> can be set to invalid. Few such cases are:
>    - ICMP reply packets.

Can you elaborate? Echo reply should not be invalid. Conntrack should
mark it as established (unless such echo reply came out of the blue).

>    - TCP SYN/ACK packets during connection establishment.

SYN/ACK should also be established state.
INVALID should only be matched for packets that were never seen
by conntrack, or that are deemed out of date / corrupted.

> To distinguish between an invalid packet part of committed connection
> and others, this patch introduces as a new ct attribute
> OVS_CT_ATTR_LOOKUP_INV. If this is set in the ct action (without commit),
> it tries to find the ct entry and if present, sets the ct_state to
> +inv,+trk and also sets the mark and labels associated with the
> connection.
> 
> With this,  a controller can add flows like
> 
> ....
> ....
> table=20,ip, action=ct(table=21, lookup_invalid)
> table=21,priority=100,ct_state=+inv+trk,ct_label=0x2/0x2 actions=drop
> table=21,ip, actions=resubmit(,22)
> ....
> ....

What exactly is the feature/problem that needs to be solved?
I suspect this would help me to provide better feedback than the
semi-random comments below .... :-)

My only problem with how conntrack does things ATM is that the ruleset
cannot distinguish:

1. packet was not even seen by conntrack
2. packet matches existing connection, but is "bad", for example:
  - contradicting tcp flags
  - out of window
  - invalid checksum

There are a few sysctls to modify default behaviour, e.g. relax window
checks, or ignore/skip checksum validation.

The other problem i see (solveable for sure by yet-another-sysctl but i
see that as last-resort) is usual compatibility problem:

ct state invalid drop
ct mark gt 0 accept

If standard netfilter conntrack were to set skb->_nfct e.g. even if
state is invalid, we could still make the above work via some internal
flag.

But if you reverse it, you get different behaviour:

ct mark gt 0 accept
ct state invalid drop

First rule might now accept out-of-window packet even when "be_liberal"
sysctl is off.
