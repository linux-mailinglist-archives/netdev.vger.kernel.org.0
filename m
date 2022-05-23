Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E693D53185F
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiEWTws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiEWTwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:52:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D136E5F27A
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A4F3B812A7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA764C385A9;
        Mon, 23 May 2022 19:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653335560;
        bh=a8F7y3Wb2SeE2fziru0ZQaBVzrZZ3dbNNMmbwWWI/2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dEQjxyF1APq3uDoidTKHfUyRUmQ1W/Zr08ke0iE1x24d3ju+7ESWS9gNuYyqS98FA
         lXzC6MrsoaY5Yao5Bjc/2zi8dZbksu31OcMXyAZLWq9Sk2dC5kDRRkOi7XTjDHXGhq
         cNxJD4G69h+pDOOkKhrUwIUuEAyrMWgon0ybHyGEejjIAubN+tVMEW9bcXjMzrEec8
         ZDKtgGdmLL7e1po8hULbZYr1j6zEiWGOfoQxTbz2b+o2tl2GJFrUYhwXP25ERd9j7c
         yjWZVy5SVvjvnA3t4qmLyJr9Lq0z5j/agxifKVRPydbrqbM5n3uZpytb6nmeV4UGoB
         0uJaoLKwz80nQ==
Date:   Mon, 23 May 2022 12:52:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v5 00/11] ethtool: Add support for frame
 preemption
Message-ID: <20220523125238.6f73b9f5@kernel.org>
In-Reply-To: <20220521150304.3lhpraxpssjxfhai@skbuf>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
        <20220520153413.16c6830b@kernel.org>
        <20220521150304.3lhpraxpssjxfhai@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 May 2022 15:03:05 +0000 Vladimir Oltean wrote:
> > I disagree that queue mask belongs in ethtool. It's an attribute of 
> > a queue and should be attached to a queue.  
> 
> Sure, you have very strong reasons to disagree with that statement, if
> only the premise were true. But you have to understand that IEEE 802.1Q
> does not talk about preemptible queues, but about preemptible priorities.
> Here:
> 
> | 6.7.1 Support of the ISS by IEEE Std 802.3 (Ethernet)
> | 
> | For priority values that are identified in the frame preemption status table
> | (6.7.2) as preemptible, frames that are selected for transmission shall be
> | transmitted using the pMAC service instance, and for priority values that are
> | identified in the frame preemption status table as express, frames that are
> | selected for transmission shall be transmitted using the eMAC service instance.
> | In all other respects, the Port behaves as if it is supported by a single MAC
> | service interface. In particular, all frames received by the Port are treated
> | as if they were received on a single MAC service interface regardless of
> | whether they were received on the eMAC service interface or the pMAC service
> | interface, except with respect to frame preemption.
> | 
> | 6.7.2 Frame preemption
> | If the Port supports frame preemption, then a value of frame preemption status
> | is assigned to each value of priority via a frame preemption status table. The
> | possible values of frame preemption status are express or preemptible.
> | The frame preemption status table can be changed by management as described in
> | 12.30.1.1. The default value of frame preemption status is express for all
> | priority values.
> 
> For context, I probably need to point out the distinction that the spec
> makes between a priority and a traffic class.
> 
> A priority is a number assigned to a packet based on the VLAN PCP using
> the rules in clause 6.9.3 Priority Code Point encoding. In Linux, it is
> more or less equivalent to skb->priority.
> 
> A traffic class, on the other hand, is defined as basically synonimous
> with a TX priority queue, as follows:
> 
> | 3.268 traffic class: A classification used to expedite transmission of frames
> | generated by critical or time-sensitive services. Traffic classes are numbered
> | from zero through N-1, where N is the number of outbound queues associated with
> | a given Bridge Port, and 1 <= N <= 8, and each traffic class has a one-to-one
> | correspondence with a specific outbound queue for that Port. Traffic class 0
> | corresponds to nonexpedited traffic; nonzero traffic classes correspond to
> | expedited classes of traffic. A fixed mapping determines, for a given priority
> | associated with a frame and a given number of traffic classes, what traffic
> | class will be assigned to the frame.
> 
> A priority is translated into a traffic class using Table 8-5:
> Recommended priority to traffic class mappings, which in Linux would be
> handled using the tc-mqprio "map".
> 
> But attention, a priority TX queue is not the same as a netdev TX queue,
> but rather the same as a tc-mqprio traffic class (i.e. when you specify
> "queues count@offset" to mqprio, from Linux perspective there are "count"
> queues, from 802.1Q perspective there is only the "offset" queue (or TC).
> This is because we may have per-CPU queues, etc.
> 
> This is even spelled out in this note:
> 
> | NOTE 3 - A queue in this context is not necessarily a single FIFO data structure.
> | A queue is a record of all frames of a given traffic class awaiting
> | transmission on a given Bridge Port. The structure of this record is not
> | specified. The transmission selection algorithm (8.6.8) determines which
> | traffic class, among those classes with frames available for transmission,
> | provides the next frame for transmission. The method of determining which frame
> | within a traffic class is the next available frame is not specified beyond
> | conforming to the frame ordering requirements of this subclause. This allows a
> | variety of queue structures such as a single FIFO, or a set of FIFOs with one
> | for each pairing of ingress and egress ports (i.e., Virtual Output Queuing), or
> | a set of FIFOs with one for each VLAN or priority, or hierarchical structures.
> 
> I'm not sure how much of this was already clear and how much wasn't.
> I apologize if I'm not bringing new info to the table. I just want to
> point out what a "queue" is, and what a "priority" is.

Very useful, thanks!

> > The DCBNL parallel is flawed IMO because pause generation is Rx, not
> > Tx. There is no Rx queue in Linux, much less per-prio.  
> 
> First of all: we both know that PFC is not only about RX, right? :) Here:
> 
> | 8.6.8 Transmission selection
> | In a port of a Bridge or station that supports PFC, a frame of priority
> | n is not available for transmission if that priority is paused (i.e., if
> | Priority_Paused[n] is TRUE (see 36.1.3.2) on that port.
> | 
> | NOTE 1 - Two or more priorities can be combined in a single queue. In
> | this case if one or more of the priorities in the queue are paused, it
> | is possible for frames in that queue not belonging to the paused
> | priority to not be scheduled for transmission.
> | 
> | NOTE 2 - Mixing PFC and non-PFC priorities in the same queue results in
> | non-PFC traffic being paused causing congestion spreading, and therefore
> | is not recommended.
> 
> And that's kind of my whole point: PFC is per _priority_, not per
> "queue"/"traffic class". And so is frame preemption (right below, same
> clause). So the parallel isn't flawed at all. The dcbnl-pfc isn't in tc
> for a reason, and that isn't because we don't have RX netdev queues...
> And the reason why dcbnl-pfc isn't in tc is the same reason why ethtool
> frame preemption shouldn't, either.

My understanding is that DCBNL is not in ethtool is that it was built
primarily for converged Ethernet. ethtool being a netdev thing it's
largely confined to coarse interface configuration in such
environments, they certainly don't use TC to control RDMA queues.

To put it differently DCBNL separates RoCE and storage queues from
netdev queues (latter being lossy). It's Conway's law at work.

Frame preemption falls entirely into netdev land. We can use the right
interface rather than building a FW shim^W "generic" interface.

> | In a port of a Bridge or station that supports frame preemption, a frame
> | of priority n is not available for transmission if that priority is
> | identified in the frame preemption status table (6.7.2) as preemptible
> | and either the holdRequest object (12.30.1.5) is set to the value hold,
> | or the transmission of a prior preemptible frame has yet to complete
> | because it has been interrupted to allow the transmission of an express
> | frame.
> 
> So since the managed objects for frame preemption are stipulated by IEEE
> per priority:
> 
> | The framePreemptionStatusTable (6.7.2) consists of 8
> | framePreemptionAdminStatus values (12.30.1.1.1), one per priority.
> 
> I think it is only reasonable for Linux to expose the same thing, and
> let drivers do the priority to queue or traffic class remapping as they
> see fit, when tc-mqprio or tc-taprio or other qdiscs that change this
> mapping are installed (if their preemption hardware implementation is
> per TC or queue rather than per priority). After all, you can have 2
> priorities mapped to the same TC, but still have one express and one
> preemptible. That is to say, you can implement preemption even in single
> "queue" devices, and it even makes sense.

Honestly I feel like I'm missing a key detail because all you wrote
sounds like an argument _against_ exposing the queue mask in ethtool.
Neither the standard calls for it, nor is it convenient to the user
who sets the prio->tc and queue allocation in TC.

If we wanted to expose prio mask in ethtool, that's a different story.
