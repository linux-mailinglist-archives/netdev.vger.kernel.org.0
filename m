Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCE059F03A
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 02:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiHXAfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 20:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiHXAfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 20:35:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E54B47B82
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 17:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661301313; x=1692837313;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=5buj8+rJug6earxveM30VqSXVjtlYFGW1c9J1Ncyi98=;
  b=Bm8f4ATAM8RCkBdxLUG7IrenH3C0CMgfmYYggoUycLgO2igB8oYsZi2z
   7LQcbTvTXywXM7yBgLi05q4CXn3GDhdbj1a+0cI9a5Fovfg2oP0xbJT/E
   VOMr+4Z1EmXrZnEtZXxamV2M6smrLeRYc9YTl0c5fbZIq6/r4SnXLEvpR
   Y4h0YE86WfpTJLV3yN4CQtlvUoJlxNqDTD0UNJHzxpNzP87v+RRa9uwvh
   eYEJ4WpwWhuiaSBVqOUCGxTXSdV/uVJdzMiGoSpaI89Zwb8WH8Sc18x80
   v1SIkrALBrsJqPKRfrETYI9pFl6AKuhj55bH/kaMwTyB8X9lxvrAnH/AM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="280804659"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="280804659"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:35:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="751877757"
Received: from lsolis1-mobl2.amr.corp.intel.com (HELO vcostago-mobl3) ([10.251.29.239])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:35:11 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
In-Reply-To: <20220819161252.62kx5e7lw3rrvf3m@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-3-vladimir.oltean@nxp.com>
 <87bksi31j4.fsf@intel.com> <20220819161252.62kx5e7lw3rrvf3m@skbuf>
Date:   Tue, 23 Aug 2022 17:35:11 -0700
Message-ID: <87mtbutr5s.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Wed, Aug 17, 2022 at 04:15:11PM -0700, Vinicius Costa Gomes wrote:
>> I liked that in the API sense, using this "prio" concept we gain more
>> flexibility, and we can express better what the hardware you work with
>> can do, i.e. priority (for frame preemption purposes?) and queues are
>> orthogonal.
>>=20
>> The problem I have is that the hardware I work with is more limited (as
>> are some stmmac-based NICs that I am aware of) frame preemption
>> capability and "priority" are attached to queues.
>
> Don't get me wrong, enetc also has "priority" attached to TX rings
> (enetc_set_bdr_prio). Then there is another register which maps a TX
> priority to a traffic class. This could be altered by the "map" property
> of tc-mqprio, but in practice it isn't. The only supported prio->tc map
> is "map 0 1 2 3 4 5 6 7".
>
> This is to say, enetc does not have a per-packet priority that gets
> passed via BD metadata, but rather, packets inherit the configured
> priority of the ring (Linux TX queue).
>

I see. Thanks for the explanation. Intel hardware (client/"not data
center", that is) is simpler, we only have one level of "ordering", and
we usually don't change the default: lowest queue index (0) has highest
priority, (1) has lower, and so on.

>> From the API perspective, it seems that I could say that "fp-prio" 0 is
>> associated with queue 0, fp-prio 1 to queue 1, and so on, and everything
>> will work.
>
> You have the tc-mqprio "queues" and "map" to juggle with, to end up
> configuring FP per queue based on the provided per-priority settings.
>
>> The only thing that I am not happy at all is that there are exactly 8
>> fp-prios.
>>=20
>> The Linux network stack is more flexible than what 802.1Q defines, think
>> skb->priority, number of TCs, as you said earlier, I would hate to
>> impose some almost artificial limits here. And in future we are going to
>> see TSN enabled devices with lots more queues.
>
> ~artificial limits~
>
> IEEE 802.1Q says:
>
> | 12.30.1.1 framePreemptionStatusTable structure and data types
> |=20
> | The framePreemptionStatusTable (6.7.2) consists of 8 framePreemptionAdm=
inStatus
> | values (12.30.1.1.1), one per priority.
>
> I'm more concerned about setting things straight than about the limits
> right now. I don't yet think everything is quite ok in that regard.
> The netlink format proposed here is in principle extensible for
> priorities > 7, if that will ever make sense.

Yes, as the limits are not in the UAPI this is a minor point, agreed.

What I am concerned is about use cases not handled by IEEE 802.1Q, for
example, thinking about that other thread about PCP/DSCP: how about a
network that wants to have as many priorities as the DSCP field (6 bits)
allows, together with frame preemption (in the future we may have
hardware that supports that). I am only thinking that we should not
close that door.

Again, minor point.

>
>>=20
>> In short:
>>  - Comment: this section of the RFC is hardware independent, this
>>  behavior of queues and priorities being orthogonal is only valid for
>>  some implementations;
>
> Yes, and IMO it can only be that way, if I were to be truthful to my
> interpretation of the intention 802.1Q spec (please contradict me if you
> have a different interpretation of it!).
>

Sorry if I made you go that deep in the spec.

I was only trying to say that for some implementations it's
difficult/impossible to have totally orthogonal priorities vs. queue
assignments, and that the commit message needs to take that into account
(because the API introduced in this commit is implementation
independent).

> Note that I do see contradictions in 802.1Q, and I don't know how to
> reconcile them. I've suppressed some of them for lack of a logical
> explanation. I'm mentioning this for transparency; I don't know
> everything either, but I need to make something out of what I do know.
>
> So 802.1Q says this:
>
> | 12.30.1.1.1 framePreemptionAdminStatus
> |
> | This parameter is the administrative value of the preemption status for
> | the priority. It takes value express if frames queued for the priority
> | are to be transmitted using the express service for the Port, or
> | preemptible if frames queued for the priority are to be transmitted
> | using the preemptible service for the Port and preemption is enabled for
> | the Port.
>
> So far so good. In 802.1Q definitions, priority is attached to a packet
> rather than to a traffic class / queue. But then the same clause continue=
s:
>
> | Priorities that all map to the same traffic class should be constrained
> | to use the same value of preemption status.
>
> Which seems to throw a wrench into everything.
>
> It raises two questions:
>
> (A) why is AdminStatus not per traffic class then?
> (B) why is the constraint there, what's it trying to protect against?
>
> I've asked around, and I got unsatisfactory answers to both questions.
>
> A seemingly competent answer given to (A) by Rui (CCed) is that the
> eMAC/pMAC selection on TX actually takes place in the MAC layer, in what
> is called by 802.1AC-2016 "MA_UNITDATA.request" (and what everybody else
> calls "MAC client xmit"). The parameters of this MAC service primitive
> are:
>
> MA_UNITDATA.request(destination_address,
> 		    source_address,
> 		    mac_service_data_unit,
> 		    priority)
>
> So since only "priority" is passed to the MAC service (and traffic class =
isn't),
> this means that the MAC service can only steer packets to eMAC/pMAC
> based on what it's given (i.e. priority).
>
> But upon closer investigation, this explanation doesn't appear to hold
> water very well. This is because clause 6.7.1 Support of the ISS by IEEE
> Std 802.3 (Ethernet) from 802.1Q says:
>
> | If frame preemption (6.7.2) is supported on a Port, then the IEEE 802.3
> | MAC provides the following two MAC service interfaces (99.4 of IEEE Std
> | 802.3br=E2=84=A2-2016 [B21]):
> |
> | a) A preemptible MAC (pMAC) service interface
> | b) An express MAC (eMAC) service interface
> |
> | For priority values that are identified in the frame preemption status
> | table (6.7.2) as preemptible, frames that are selected for transmission
> | shall be transmitted using the pMAC service instance, and for priority
> | values that are identified in the frame preemption status table as
> | express, frames that are selected for transmission shall be transmitted
> | using the eMAC service instance.
> | In all other respects, the Port behaves as if it is supported by a
> | single MAC service interface. In particular, all frames received by the
> | Port are treated as if they were received on a single MAC service
> | interface regardless of whether they were received on the eMAC service
> | interface or the pMAC service interface, except with respect to frame
> | preemption.
>
> So there you go, the MAC has to provide *two* service interfaces, so the
> 802.1Q upper layer (client of both) can just decide based on an internal
> criterion (like, say traffic class) into which service it sends a frame.
> So this can't be the reason.
>
> As for (B), it was suggested to me that 802.1Q that doesn't allow out of
> order transmission within the same queue/traffic class. After all,
> what's at play here is whether a single TX queue device can support FP
> or not. Supporting FP would mean reordering PT frames relative to ET
> frames.
>
> I think this explanation is unsatisfactory too. Here's the only
> reference I saw in 802.1Q to ordering guarantees. Basically those
> guarantees are all *per priority*, and since PT/ET is also per priority,
> I don't see why reordering there would violate this:
>
> | 6.5.3 Frame misordering
> | The MAC Service (IEEE Std 802.1AC) permits a negligible rate of
> | reordering of frames with a given priority for a given combination of
> | destination address, source address, and flow hash, if present,
> | transmitted on a given VLAN.
> | MA_UNITDATA.indication service primitives corresponding to
> | MA_UNITDATA.request primitives, with the same requested priority and for
> | the same combination of VLAN classification, destination address, source
> | address, and flow hash, if present, are received in the same order as
> | the request primitives were processed.
>
> So for anything to make sense for me at all, I simply had to block out
> that phrase from my mind. I'm posting the concern here, publicly, in
> case someone can enlighten me.
>

I, truly, admire your effort (and the time you took) and your
explanation. I think I understand where you come from better. Thank you.

Taking a few steps back (I don't like this expression, but anyway), I
think that strict conformance is not an objective of the Linux network
stack as a whole. What I mean by "not strict": that it doesn't try to
follow the letter of the "baggy pants" model that IEEE 802.* and friends
define. Being efficient/useful has a higher importance.

But being certifiable is a target/ideal, i.e. the "on the wire" and user
visible (statistics, etc) behavior can/"should be able" to be configured
to pass conformance tests or even better, interoperability tests.

Now back on track, in my mental model, this simplifies things to a
couple of questions that I ask myself about this RFC, in particular
about this priority idea:
 - Is this idea useful? My answer is yes.
 - Can this idea be used to configure a certifiable system? Also, yes.

So, I have no problems with it.

>>  - Question: would it be against the intention of the API to have a 1:1
>>  map of priorities to queues?
>
> No; as mentioned, going through mqprio's "map" and "queues" to resolve
> the priority to a queue is something that I intended to be possible.
> Sure, it's not handy either. It would have been handier if the
> "admin-status" array was part of the tc-mqprio config, like you did in
> your RFC.

Just to be sure, say that my plan is that I document that for the igc
driver, the mapping of priorities for the "FP" command is prio (0) ->
queue (0), prio (1) -> queue (1), and so on. Note that the mqprio
mapping could be that "skb->priority" 10 goes to TC 1 which is mapped to
queue 0. Would this be ok?

>
> But right now I'm trying to not close the possibility for single queue
> devices (which won't implement mqprio) to support FP, since I haven't
> seen anything convincing that would disprove such a hw design as
> infeasible. If someone could share some compelling insight into this it
> would be really appreciated.
>

The important part is that you didn't close that door. If someone is
brave enough to design that hw, it seems that it can be made to work,
and that's good enough.

>>  - Deal breaker: fixed 8 prios;
>
> idk, I don't think that's our biggest problem right now honestly.

Perhaps I am being too optimistic, but the way I see, your proposal is
already expressible enough to be used in a "certifiable" system. I was
too harsh with "deal breaker.

So, what is the biggest problem that you see?

Overall, no issues from my side.

Cheers,
--=20
Vinicius
