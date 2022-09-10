Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA265B435D
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 02:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiIJATm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 20:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIJATk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 20:19:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57222870E
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 17:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662769177; x=1694305177;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=xyz5JeYdb/4rK1VMWG2UVvKMDjy2vF8hFAS/JYvTCKM=;
  b=Ocp8S3HtaQKxahr+A2p+ioYP1ZfLO5ESeL0wpZSfjIDejaw8xWV8YVF0
   /WPzhWMUabfwsjOQkaLQixIUEn8+TfQ0aEHI6n6AfAzDwNMdqPW6/RghQ
   cEQhTdNnboFyc3XpJDMki+p/oNRtQay0gz4QlSTmKSbTjU88E1Hge1btC
   ryuBDvglWCtES4q+wJhsKYEsA1BfPwVDazeNdHC7nUq8ASrToHUW4pG2w
   rPynH73/a9VLXzWeQesw21KpdQ1XUM4AVPy9YSl4zPdj6AB43ZFJDJgei
   z/57hWnaVTtAqwtH9plHtjfZ56oXX0HzbhcCILUZfOgxjX+nDGXuslhnx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10465"; a="298932775"
X-IronPort-AV: E=Sophos;i="5.93,304,1654585200"; 
   d="scan'208";a="298932775"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 17:19:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,304,1654585200"; 
   d="scan'208";a="677373674"
Received: from amalikzx-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.8.242])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 17:19:36 -0700
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
In-Reply-To: <20220907205711.hmvp7nbyyp7c73u5@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-3-vladimir.oltean@nxp.com>
 <87bksi31j4.fsf@intel.com> <20220819161252.62kx5e7lw3rrvf3m@skbuf>
 <87mtbutr5s.fsf@intel.com> <20220907205711.hmvp7nbyyp7c73u5@skbuf>
Date:   Fri, 09 Sep 2022 17:19:35 -0700
Message-ID: <87edwk3wtk.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Tue, Aug 23, 2022 at 05:35:11PM -0700, Vinicius Costa Gomes wrote:
>> Yes, as the limits are not in the UAPI this is a minor point, agreed.
>> 
>> What I am concerned is about use cases not handled by IEEE 802.1Q, for
>> example, thinking about that other thread about PCP/DSCP: how about a
>> network that wants to have as many priorities as the DSCP field (6 bits)
>> allows, together with frame preemption (in the future we may have
>> hardware that supports that). I am only thinking that we should not
>> close that door.
>> 
>> Again, minor point.
>
> Since Linux seems to have settled on TC_PRIO_MAX, TC_QOPT_MAX_QUEUE
> constants of 16 rather than the 8 you'd expect, I guess I don't have
> that big of a problem to also expose 16 admin-status values for FP.
> I can limit the drivers I have to only look at the first 8 entries.
> But what do 16 priorities mean to ethtool? 16 priorities are a tc thing.
> Does ethtool even have a history of messing with packet priorities?
> What am I even doing? lol.
>

That's a good point. ethtool doesn't has a history of knowing about
priorities (and what they even mean). But I like the flexibility that
this approach provides.

>> Sorry if I made you go that deep in the spec.
>> 
>> I was only trying to say that for some implementations it's
>> difficult/impossible to have totally orthogonal priorities vs. queue
>> assignments, and that the commit message needs to take that into account
>> (because the API introduced in this commit is implementation
>> independent).
>
> Yes, the comment is totally valid. However, between "difficult" and
> "impossible" there is a big leap, and if it is really impossible, I'd
> like to know precisely why.
>

Sometimes the enemy of good is perfect (in this case precisely). Perhaps
aiming for "good enough" understanding?

>> I, truly, admire your effort (and the time you took) and your
>> explanation. I think I understand where you come from better. Thank you.
>> 
>> Taking a few steps back (I don't like this expression, but anyway), I
>> think that strict conformance is not an objective of the Linux network
>> stack as a whole. What I mean by "not strict": that it doesn't try to
>> follow the letter of the "baggy pants" model that IEEE 802.* and friends
>> define. Being efficient/useful has a higher importance.
>> 
>> But being certifiable is a target/ideal, i.e. the "on the wire" and user
>> visible (statistics, etc) behavior can/"should be able" to be configured
>> to pass conformance tests or even better, interoperability tests.
>> 
>> Now back on track, in my mental model, this simplifies things to a
>> couple of questions that I ask myself about this RFC, in particular
>> about this priority idea:
>>  - Is this idea useful? My answer is yes.
>>  - Can this idea be used to configure a certifiable system? Also, yes.
>> 
>> So, I have no problems with it.
>> 
>
> I've taken quite a few steps back now, unfortunately I'm still back to
> where I was :)
>
> I've talked to more people within NXP, explained to them that the
> standard technically does not disallow the existence of FP for single
> queue devices, for this and that reason. The only responses I got varied
> from the equivalent of a frightened "brrr", to a resounding "no, that
> isn't what was intended". Of course I tried to dig deeper, and I was
> told that the configuration is per (PCP) priority because this is the
> externally visible label carried by packets, so an external management
> system that has to coordinate FP across a LAN does not need to know how
> many traffic classes each node has, or how the priorities map to the
> traffic classes. Only the externally visible behavior is important,
> which is that packets with priority (PCP) X are sent on the wire using a
> preemptable SFD or a normal SFD, because the configuration also affects
> what the other nodes in the network expect. You might contrast this with
> tc-taprio, where the open/closed gates really are defined per traffic
> class, and you might wonder why it wasn't important there for the
> configuration to also be handled using the externally-visible priority
> (PCP) as input. Yes, but with tc-taprio, you can schedule within your
> traffic classes all you want, but this does not change the externally
> visible appearance of a frame, so it doesn't matter. The scheduling is
> orthogonal to whether a packet will be sent as preemptable or not.
>
> Is this explanation satisfactory, and where does it leave us? For me it
> isn't, and it leaves me nowhere new, but it's the best I got.
>
> So ok, single TX queue devices with FP probably are possibly a fun
> physics class experiment, but practically minded vendors won't implement
> them. But does the alternate justification given change my design decision
> in any way (i.e. expose "preemptable priorities" in ethtool as opposed
> to "preemptable queues" in tc-mqprio and tc-taprio as you did)? No.
> It just becomes a matter of enforcing the recommended restriction that
> preemptable and express priorities shouldn't be mixed within the same
> traffic class, something which my current patch set does not do.
>
> [ yes, "should" is a technical term in IEEE standards which means "not
>   mandatory", and that's precisely how the constraint from 12.30.1.1.1
>   was formulated ]
>
> I guess when push comes to shove, somebody will have to answer the
> question of why was FP exposed in Linux by something other than what the
> standard defined it for (prio), and I wouldn't know how to answer that.
>

In my mind the answer is: because it's cool to support more use-cases
than the standard defines, Linux is still a vehicle for experimentation,
more space for our users to play.

>> >>  - Question: would it be against the intention of the API to have a 1:1
>> >>  map of priorities to queues?
>> >
>> > No; as mentioned, going through mqprio's "map" and "queues" to resolve
>> > the priority to a queue is something that I intended to be possible.
>> > Sure, it's not handy either. It would have been handier if the
>> > "admin-status" array was part of the tc-mqprio config, like you did in
>> > your RFC.
>> 
>> Just to be sure, say that my plan is that I document that for the igc
>> driver, the mapping of priorities for the "FP" command is prio (0) ->
>> queue (0), prio (1) -> queue (1), and so on. Note that the mqprio
>> mapping could be that "skb->priority" 10 goes to TC 1 which is mapped to
>> queue 0. Would this be ok?
>
> If skb->priority 10 goes to TC 1 via the prio_tc_map, and finally lands
> in queue 0 where your actual FP knob is, then I'd expect the driver to
> follow the reverse path between queue -> tc -> prios mapped to that tc.
> And I would not state that prio 0 is queue 0 and skb->priority values
> from the whole spectrum may land there, kthxbye. Also, didn't you say
> earlier that "lowest queue index (0) has highest priority"? In Linux,
> skb->priority 0 has lower priority that skb->priority 1. How does that
> work out?
>

Ah, sorry for the confusion, when I said "lowest queue index (0) has
highest priority" it was more in the sense that queue 0 has higher
precedence, packets from it are fetched first, that kind of thing.

> In fact, for both enetc and felix, I have to do this exact thing as you,
> except that my hardware knobs are halfway in the path (per tc, not per
> queue). The reason why I'm not doing it is because we only consider the
> 1:1 prio_tc_map, so we use "prio" and "tc" interchangeably.
>

Hm, that's interesting. I think that's a difference on how we are
modeling our traffic, here's one very common mqprio config for AVB use
cases:

$ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      hw 0

One priority for Class A traffic, one priority for Class B traffic and
multiple priorities mapped to a single TC, the rest is Best Effort and
it's mapped to multiple queues. The way we model traffic, TCs and
priorities are different concepts.

One important detail is that in TSN mode, we use the "priority" (meaning
precedence in this context) fetch order for the queues: queue 0 first,
then queue 1, and so on.

> It can't even be any other way given the current code, since the struct
> tc_taprio_qopt_offload passed via ndo_setup_tc does not even contain the
> tc_mqprio_qopt sub-structure with the prio_tc_map. Drivers are probably
> expected to look, from the ndo_setup_tc hook, at their dev->prio_tc_map
> as changed by netdev_set_prio_tc_map() in taprio_change(). Why this API
> is different compared to struct tc_mqprio_qopt_offload, I don't know.

At least for igb and igc I never felt it was necessary to look at the
prio_tc_map. The core netstack will already enqueue each packet to the
right queue. All I need to know is how to configure each queue.

Also note that for igb and igc I didn't ndo_setup_tc for mqprio, because
the default behavior is fine, that's also why that taprio doesn't send
that information (but this is easily fixed).

This could be a consequence that prio_tc_map (and friends) was
introduced by Intel folks (long before my time) and this doesn't work
that well for other vendors.

>
> What prevents you from doing this? I'd like to understand as precisely
> as you can explain, to see how what I'm proposing really sounds when
> applied to Intel hardware.
>

If I am understanding you correctly, nothing prevents me from doing
that. It's just that everything worked out that from the driver side I
don't need to know about priorities, traffic classes, I only need to
care about queues.

That's why I for my "ethtool" proposal I focused on setting preemption
per queue, because the drivers I work with don't need to know about
anything else. But that can change if necessary. The cost doesn't seem
too big.

>> >>  - Deal breaker: fixed 8 prios;
>> >
>> > idk, I don't think that's our biggest problem right now honestly.
>> 
>> Perhaps I am being too optimistic, but the way I see, your proposal is
>> already expressible enough to be used in a "certifiable" system. I was
>> too harsh with "deal breaker.
>> 
>> So, what is the biggest problem that you see?
>> 
>> Overall, no issues from my side.
>
> Let me recap my action items out loud for v2 (some of them weren't
> discussed publicly per se).
>
> * Enforce the constraint recommended by 12.30.1.1.1, somewhere as a
>   static inline helper function that can be called by drivers, from the
>   tc-taprio/tc-mqprio and ethtool-fp code paths. Note that I could very
>   quickly run into a very deep rabbit hole here, if I actually bother to
>   offload to hardware (enetc) the prio_tc_map communicated from tc-mqprio.
>   I'll try to avoid that. I noticed that the mqprio_parse_opt() function
>   doesn't validate the provided queue offsets and count if hw offload is
>   requested (therefore allowing overlapping queue ranges). I really
>   dislike that, because it was probably done for a reason.
>

I agree with that mqprio offload lack of validation being weird.

+1 for the helper, those kind of functions help document a lot the
expectations.

> * Port the isochron script I have for enetc (endpoint) FP latency
>   measurements to kselftest format.
>
> * Do something such that eMAC/pMAC counters are also summed up somewhere
>   centrally by ethtool, and reported to the user either individually or
>   aggregated.
>
> * Reorganize the netlink UAPI such as to remove ETHTOOL_A_FP_PARAM_TABLE
>   and just have multiple ETHTOOL_A_FP_PARAM_ENTRY nests in the parent.
>

Another +1

> * The enetc verification state machine is off by default. The felix
>   verification state machine is on by default. I guess we should figure
>   out a reasonable default for all drivers out there?
>

From the language of IEEE 802.3 ("disableVerify" and friends), it seems
that the expectation is that verification is enabled by default. *But*
from a interoperability point of view, I would only enable verification
by default after some testing in the wild. Or only send the verify
packet if frame preemption is also enabled. 

> * For some reason, I notice that the verification state machine remains
>   FAILED on felix when it links to enetc and that has verification
>   enabled. I need to disable it on enetc, enable it again, and only then
>   will the MAC merge interrupt on felix say that verification completed
>   successfully. I think I'll need to put a quirk in enetc_pl_mac_link_up()
>   to toggle verification off and on, if it was requested, in order for
>   this to be seamless to the user.
>
> If it's only these, nothing seems exactly major. However, I assume this
> is only the beginning. I fully expect there to be one more round of
> "why not dcbnl? why not tc?" nitpicks, for which I'm not exactly
> mentally ready (if credible arguments are to be put forward, I'd rather
> have them now while I haven't yet put in the extra work in the direction
> I'm about to).

I really know the feeling "not mentally ready".

I am still in the "tc" camp. But I cannot deny that this interface seems
to work for the uses that we have in mind. That's (at least) good enough
for me ;-)


Cheers,
-- 
Vinicius
