Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2225B7F24
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 04:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiINC7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 22:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiINC7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 22:59:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE0138AA
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 19:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663124373; x=1694660373;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=zz42kkNHvWTfWEVlfassoNdOoE1s+LHCODrge8u50Yw=;
  b=lYYRv4BlEuycdw4rPwqNENxFaKIOKd07ibcYU/ARxmMkucNd2T7AmXL3
   zGz+HFIXbRVMzB2drW5ExedbRNObNRxee5mmDvDrcCbpBiURtjG0BvwUh
   isW6l9b8miXh5HQ9ZrVbZYsWsZDazkn3Yyl1WRvUqZ199cqpmQj2TBRiH
   9LBs7UAGnhkAC0AQNnvHGbLwPtezSCOuFaZbyPfGxipYqXhFOx6VAtMR9
   2Nk9X3URsXONRzxUeLxeY7KTsq/Y7UXR26cgThKS+wga3qH78Ltzn2zkV
   6y5+a1efn9rLxI1n+qxZeo0I+S03l7do2UqII9o6g0iszHu1fMXp3iJcs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="278047628"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="278047628"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 19:59:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="647203145"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 19:59:29 -0700
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
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Richie Pearn <richard.pearn@nxp.com>
Subject: Re: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
In-Reply-To: <20220910163619.fchn6kwgtvaszgcb@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-3-vladimir.oltean@nxp.com>
 <87bksi31j4.fsf@intel.com> <20220819161252.62kx5e7lw3rrvf3m@skbuf>
 <87mtbutr5s.fsf@intel.com> <20220907205711.hmvp7nbyyp7c73u5@skbuf>
 <87edwk3wtk.fsf@intel.com> <20220910163619.fchn6kwgtvaszgcb@skbuf>
Date:   Tue, 13 Sep 2022 19:59:29 -0700
Message-ID: <87o7viiru6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Sep 09, 2022 at 05:19:35PM -0700, Vinicius Costa Gomes wrote:
>> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
>>=20
>> > On Tue, Aug 23, 2022 at 05:35:11PM -0700, Vinicius Costa Gomes wrote:
>> >> Yes, as the limits are not in the UAPI this is a minor point, agreed.
>> >>=20
>> >> What I am concerned is about use cases not handled by IEEE 802.1Q, for
>> >> example, thinking about that other thread about PCP/DSCP: how about a
>> >> network that wants to have as many priorities as the DSCP field (6 bi=
ts)
>> >> allows, together with frame preemption (in the future we may have
>> >> hardware that supports that). I am only thinking that we should not
>> >> close that door.
>> >>=20
>> >> Again, minor point.
>> >
>> > Since Linux seems to have settled on TC_PRIO_MAX, TC_QOPT_MAX_QUEUE
>> > constants of 16 rather than the 8 you'd expect, I guess I don't have
>> > that big of a problem to also expose 16 admin-status values for FP.
>> > I can limit the drivers I have to only look at the first 8 entries.
>> > But what do 16 priorities mean to ethtool? 16 priorities are a tc thin=
g.
>> > Does ethtool even have a history of messing with packet priorities?
>> > What am I even doing? lol.
>>=20
>> That's a good point. ethtool doesn't has a history of knowing about
>> priorities (and what they even mean). But I like the flexibility that
>> this approach provides.
>
> Fair. On the other hand, we need to weigh the pros and cons of moving
> the adminStatus to other places.
>
> dcbnl
>
> - pro: is a hardware-only interface, just like ethtool, which is
>   suitable for a hardware-only feature like FP
>
> - pro: knows about priorities (app table, PFC). I keep coming back to
>   PFC as an example because it has the absolute exact same problems as
>   FP, which is that it is defined per priority, but there is a "NOTE 2 -
>   Mixing PFC and non-PFC priorities in the same queue results in non-PFC
>   traffic being paused causing congestion spreading, and therefore is
>   not recommended."
>
> - con: I think the dcbnl app table has the same limitation that
>   priorities go only up to 8 (the comment above struct dcb_app says
>   "@priority: 3-bit unsigned integer indicating priority for IEEE")
>
> - con: where do dcbnl's responsibilities begin, and where do they end,
>   exactly? My understanding is that DCB and TSN are exactly the same
>   kind of thing, i.e. extensions to 802.1Q (and 802.3, in case of TSN)
>   which were made in order to align Ethernet (and bridges) with a set of
>   vertical use cases which weren't quite possible before. All is well,
>   except TSN was integrated quite differently into the Linux kernel,
>   i.o.w. we don't have a "tsnnl" like there is a "dcbnl", but things are
>   much more fine-grained, and integrated with the subsystem that they
>   extend, rather than creating a subsystem aligned to a use case. So the
>   question becomes, is anything we're doing here, for TSN, extending
>   DCB? With Microchip's desire to add non-standard APP table selectors
>   for VLAN PCP/DEI prioritization, I think the general movement is
>   towards more reuse of dcbnl constructs, and towards forgetting that
>   dcbnl is for DCB. But there are many things I don't understand about
>   dcbnl, for example why is it possible to set an interface's prio-tc
>   map using dcb, and what does it even mean in relationship to
>   tc-mqprio, tc-taprio etc (or even with "priomap" from tc-ets).
>

I don't know. I still have to learn more about DCB. I suppose HW that
has both TSN and DCB features is not too far in the future. So is it
possible that people are going to try to use them together? Does it make
sense? I don't know.

Here are some notes from a quick look at the code, anyone feel free to
correct me, or add anything.

Looking at two drivers code (mlx5 and ice) it seems that the dcbnl
prio-tc map has a similar objective to the netdev prio_tc_map (I am
looking at how that map feeds into each driver ndo_select_queue()), but
inside the driver and with more flexibility ("in the DSCP mode,
overwrite the skb->priority with this value and use this value for
netdev_tx_pick()", that kind of thing). So using tc-mqprio/tc-taprio
with 'dcb ets' 'prio-map' will send traffic to suprising traffic
classes/queues.=20

tc-ets priomap feels like another layer, you use that to setup buckets
in which run what seems to be burst protection algorithms, and this
happens after ndo_select_queue() runs, so this map seems almost
independent of the dcbnl prio-tc map (?).

>   $ dcb ets set dev eth0 prio-tc 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
>
>   Jakub had an answer which explained this in terms of Conway's law:
>   https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.109=
8888-1-vinicius.gomes@intel.com/#24870325
>   but as beautiful that answer is, as many questions it still leaves for
>   me. Like if we were to accept dcbnl as part of the UAPI for TSN, how
>   does this fact fit within our story that the already use the tc-taprio
>   map to map priorities to traffic classes?

Setting the 'dcb ets' "prio-tc" map together with tc-taprio or
tc-mqprio, doesn't make much sense, true. But if I am understanding the
code right, you could use that 'dcb' command, and configure frame
preemption via ethtool (for example) and it could work, without
tc-taprio or tc-mqprio to setup the prio:tc mapping.

Perhaps, for now, the solution is to disallow this as invalid, that you
can only have one such priority map configured, either dcb prio-map or
taprio/mqprio. Not sure.

For the long term, perhaps the solution is to have a single place that
does this mapping (from skb to traffic classes and then to queues) more
centralized. 'dcb' would populate that as would 'mqprio/taprio'. This
seems to imply that ndo_select_queue() is a escape hatch, that in the
ideal world it would not exist. Would this create worse problems?
(Reality is pointing that it doesn't seem that we can avoid making
drivers aware of this map, so this idea doesn't seem to help the
situation much)

>
> ethtool:
>
> - pro: is in the same subsystem as MAC merge layer configuration (for
>   which I have no doubts that ethtool is the right place)
>
> - pro: is not aligned to any specific vertical use case, like dcbnl is
>
> - con: knows nothing about priorities
>
> - con: for hardware where FP adminStatus is per traffic class rather
>   than per priority, we'll have to change the adminStatus not only from
>   changes made via ethtool to the FP adminStatus, but also from changes
>   made to the prio_tc_map (tc I guess?). But this may also be a subtle
>   pro for dcbnl, since that has its own prio_tc_map, so we'd remain
>   within the same subsystem?

If the driver also supports DCB, it will have the offload functions
implemented, so it be aware of changes in that map. The problem is now
mqprio, that if it isn't offloaded, the driver is not aware of any
changes. But mqprio doesn't implement .change(), which makes things a
bit easier.

'ethtool' is gaining my vote.

>
> tc (part of tc-mqprio and tc-taprio):
>
> - open question: does the FP adminStatus influence scheduling or not?
>   Normally I'd say no, adminStatus only decides whether the eMAC or pMAC
>   will be used to send a frame, and this is orthogonal to scheduling.
>   But 802.1Q says that "It should be noted that, other things being
>   equal, designating a priority as =E2=80=9Cexpress=E2=80=9D effectively =
increases its
>   priority above that of any priority designated as =E2=80=9Cpreemptible=
=E2=80=9D."
>   Is this phrase enough to justify a modification of the qdisc dequeue
>   method in, say, taprio, which would prioritize a lower priority qdisc
>   queue A over a higher one B, if A is express but B is preemptable?

I understood this as: if a preemptible packet (higher priority) and
expresss packet (lower priority) arrive at the MAC at the same time, the
express packet will finish transmitting before the preemptible, causing
the express packet to have an 'effective' higher priority.

I don't think we need to change anything on the dequeueing in the qdisc
side (and trying to solve it is going to be awkward, having to check the
neighbor qdiscs for packets being enqueued/peeked, ugh!).

(as a note: for i225, traffic in queues marked as express will only
preempt traffic from lower numbered queues, this behavior doesn't seem
to be forbidden by the standard)

>
> - pro: assuming that in lack of tc-mqprio or tc-taprio, an interface's
>   number of traffic classes will collapse to 1, then putting FP
>   adminStatus here makes it trivial to support hardware with FP per
>   traffic class
>
> - con: more difficult for user space to change FP adminStatus
>   independently of the current qdisc?
>
>> >> > No; as mentioned, going through mqprio's "map" and "queues" to reso=
lve
>> >> > the priority to a queue is something that I intended to be possible.
>> >> > Sure, it's not handy either. It would have been handier if the
>> >> > "admin-status" array was part of the tc-mqprio config, like you did=
 in
>> >> > your RFC.
>> >>=20
>> >> Just to be sure, say that my plan is that I document that for the igc
>> >> driver, the mapping of priorities for the "FP" command is prio (0) ->
>> >> queue (0), prio (1) -> queue (1), and so on. Note that the mqprio
>> >> mapping could be that "skb->priority" 10 goes to TC 1 which is mapped=
 to
>> >> queue 0. Would this be ok?
>> >
>> > If skb->priority 10 goes to TC 1 via the prio_tc_map, and finally lands
>> > in queue 0 where your actual FP knob is, then I'd expect the driver to
>> > follow the reverse path between queue -> tc -> prios mapped to that tc.
>> > And I would not state that prio 0 is queue 0 and skb->priority values
>> > from the whole spectrum may land there, kthxbye. Also, didn't you say
>> > earlier that "lowest queue index (0) has highest priority"? In Linux,
>> > skb->priority 0 has lower priority that skb->priority 1. How does that
>> > work out?
>> >
>>=20
>> Ah, sorry for the confusion, when I said "lowest queue index (0) has
>> highest priority" it was more in the sense that queue 0 has higher
>> precedence, packets from it are fetched first, that kind of thing.
>
> Fetched first by whom?
> In ENETC, the transmission selection chooses between TX BD rings whose
> configured priority maps to the same traffic class based on a weighted
> round robin dequeuing policy. Groups of TX BD rings of different
> priorities are in strict priority dequeuing relative to each other.
> And the number of the TX BD ring has nothing to do with its priority.

For the hardware I work with:
 - i210: two modes, (1) round robin, by default, or in (2) Qav-mode
   ("TSN), strict priority, fixed by the queue index.
 - i225/i226: two modes, (1) round robin, by default, or in (2) TSN
    mode, strict priority, configurable queue priority.

(to give the full picture, we can also configure how the descriptors are
going to be fetched from host memory, but as host memory is not usually
where the congestion happens, it's less important for this)

>
>> > In fact, for both enetc and felix, I have to do this exact thing as yo=
u,
>> > except that my hardware knobs are halfway in the path (per tc, not per
>> > queue). The reason why I'm not doing it is because we only consider the
>> > 1:1 prio_tc_map, so we use "prio" and "tc" interchangeably.
>> >
>>=20
>> Hm, that's interesting. I think that's a difference on how we are
>> modeling our traffic, here's one very common mqprio config for AVB use
>> cases:
>>=20
>> $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
>>       num_tc 3 \
>>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>       queues 1@0 1@1 2@2 \
>>       hw 0
>>=20
>> One priority for Class A traffic, one priority for Class B traffic and
>> multiple priorities mapped to a single TC, the rest is Best Effort and
>> it's mapped to multiple queues. The way we model traffic, TCs and
>> priorities are different concepts.
>
> So here's what I don't understand. Why do you need 16 priority values,
> when in the end you'll map them to only 3 egress traffic classes anyway?
>

Basically because of how prio_tc_map works and the fact that I want TC 0
to be mapped to queue 0. i.e. if an entry is not specified in the map,
it's going ot be mapped to TC 0. I want to avoid that, historically, in
our models, TC 0 is the "important" one.

>> One important detail is that in TSN mode, we use the "priority" (meaning
>> precedence in this context) fetch order for the queues: queue 0 first,
>> then queue 1, and so on.
>
> So the number of the queue is what actually contributes to the egress
> scheduling algorithm of your NIC? Strange. Tell me something so I'm sure
> I'm understanding you properly. netdev_pick_tx() will pick a TX queue
> using skb_tx_hash(), which hashes between the netdev queues mapped to
> the same traffic class as the traffic class that skb->priority is mapped =
to.
> In your case, you have 2@2 (2 TX queues for traffic class 2), call these
> queues 2 and 3. You're saying that hardware prioritizes queue 2 over 3.
> But the network stack doesn't know that. It hashes equally packets that
> go to tc 2 between queue 2 and queue 3. In our case, this misconfiguration
> would be immediately obvious, because we could have an offloaded tc-taprio
> schedule in ENETC, and Linux could be enqueuing into a ring that ultimate=
ly
> has a different schedule than software knows about. How does this work
> out for you?
>

More or less, repeating a bit what I said before, on i210 it was fixed,
on i225/i226 it can be changed, but we decided to keep the default, less
surprises for our users.

In (some of) our traffic models, the only kind of traffic class that we
allow to go through multiple queues is Best Effort.

And even that it works out because taprio "translates" from traffic
classes to queues when it sends the offload information to the driver,
i.e. the driver knows the schedule of queues, not traffic classes.

>> > * The enetc verification state machine is off by default. The felix
>> >   verification state machine is on by default. I guess we should figure
>> >   out a reasonable default for all drivers out there?
>> >
>>=20
>> From the language of IEEE 802.3 ("disableVerify" and friends), it seems
>> that the expectation is that verification is enabled by default. *But*
>> from a interoperability point of view, I would only enable verification
>> by default after some testing in the wild. Or only send the verify
>> packet if frame preemption is also enabled.=20
>
> I wonder whether the answer to this one is actually "Additional Ethernet
> Capabilities TLV" (802.3 clause 79.3.7). It would be good if we could
> all start off with FP/MM disabled, verification state machine included,
> until the LLDP daemon receives a TLV that says PreemptSupported and
> PreemptEnabled are true. If both local and remote preemption are
> supported and enabled, we tell the kernel to enable the MAC merge layer
> and kick off verification. In turn this will alter PreemptActive that
> gets set in future replies. I don't know, the flow may be different.
>

That's a good point (your understanding of the flow is similar to mine).
This seems a good idea. But we may have to wait for a bit until we have
a LLDP implementation that supports this.

>> > * For some reason, I notice that the verification state machine remains
>> >   FAILED on felix when it links to enetc and that has verification
>> >   enabled. I need to disable it on enetc, enable it again, and only th=
en
>> >   will the MAC merge interrupt on felix say that verification completed
>> >   successfully. I think I'll need to put a quirk in enetc_pl_mac_link_=
up()
>> >   to toggle verification off and on, if it was requested, in order for
>> >   this to be seamless to the user.
>> >
>> > If it's only these, nothing seems exactly major. However, I assume this
>> > is only the beginning. I fully expect there to be one more round of
>> > "why not dcbnl? why not tc?" nitpicks, for which I'm not exactly
>> > mentally ready (if credible arguments are to be put forward, I'd rather
>> > have them now while I haven't yet put in the extra work in the directi=
on
>> > I'm about to).
>>=20
>> I really know the feeling "not mentally ready".
>>=20
>> I am still in the "tc" camp. But I cannot deny that this interface seems
>> to work for the uses that we have in mind. That's (at least) good enough
>> for me ;-)
>
> To me right now, FP adminStatus is not exactly something that the
> scheduler is concerned with, and this is why tc is kind of my last
> choice. But I agree that it makes certain things simpler. Plus, it seems
> to be the only subsystem aware of 16 priorities and 16 traffic classes,
> which you seem to care about.

This is just food for thought, I am not expecting a reply, as it doesn't
help the review of the RFC.

Ideally, we wouldn't have that limit of 16 priorities or traffic
classes. I don't want to limit it even more. This "16" limit is already
going to require some creativity to handle some use cases in a medium
future, I am afraid.

I am already hearing coleagues talking about containers (think the
net_prio namespace) together with VMs, NICs with dozens of queues. All
of this with scheduled traffic. On the wire, the 8 PCP codepoints are
what we have, but internally/"inside the system", we might need more
granularity to organize all those applications.


Cheers,
--=20
Vinicius
