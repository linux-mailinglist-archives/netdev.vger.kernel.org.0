Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A66235C428
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhDLKjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:39:13 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:60637 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239411AbhDLKjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:39:11 -0400
X-Originating-IP: 78.45.89.65
Received: from [192.168.1.23] (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id B753120012;
        Mon, 12 Apr 2021 10:38:50 +0000 (UTC)
To:     Aaron Conole <aconole@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Joe Stringer <joe@cilium.io>, dev@openvswitch.org,
        Networking <netdev@vger.kernel.org>,
        Michael Cambria <mcambria@redhat.com>,
        Flavio Leitner <fbl@redhat.com>
References: <20210319204307.3128280-1-aconole@redhat.com>
 <CADa=Ryw==DwqWowBMSXqgBVc2zXH_FK_Ky+7n9Dz4EMhF8YANQ@mail.gmail.com>
 <f7tk0pcmru0.fsf@dhcp-25.97.bos.redhat.com>
 <ff7ca766-32c1-8156-42bf-cf4c6d1c9033@ovn.org>
 <f7to8emib25.fsf@dhcp-25.97.bos.redhat.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH] openvswitch: perform refragmentation for
 packets which pass through conntrack
Message-ID: <e9d5fb77-1960-b92c-9487-793873f6feeb@ovn.org>
Date:   Mon, 12 Apr 2021 12:38:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <f7to8emib25.fsf@dhcp-25.97.bos.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/21 2:22 PM, Aaron Conole wrote:
> Ilya Maximets <i.maximets@ovn.org> writes:
> 
>> On 4/8/21 10:41 PM, Aaron Conole wrote:
>>> Joe Stringer <joe@cilium.io> writes:
>>>
>>>> Hey Aaron, long time no chat :)
>>>
>>> Same :)
>>>
>>>> On Fri, Mar 19, 2021 at 1:43 PM Aaron Conole <aconole@redhat.com> wrote:
>>>>>
>>>>> When a user instructs a flow pipeline to perform connection tracking,
>>>>> there is an implicit L3 operation that occurs - namely the IP fragments
>>>>> are reassembled and then processed as a single unit.  After this, new
>>>>> fragments are generated and then transmitted, with the hint that they
>>>>> should be fragmented along the max rx unit boundary.  In general, this
>>>>> behavior works well to forward packets along when the MTUs are congruent
>>>>> across the datapath.
>>>>>
>>>>> However, if using a protocol such as UDP on a network with mismatching
>>>>> MTUs, it is possible that the refragmentation will still produce an
>>>>> invalid fragment, and that fragmented packet will not be delivered.
>>>>> Such a case shouldn't happen because the user explicitly requested a
>>>>> layer 3+4 function (conntrack), and that function generates new fragments,
>>>>> so we should perform the needed actions in that case (namely, refragment
>>>>> IPv4 along a correct boundary, or send a packet too big in the IPv6 case).
>>>>>
>>>>> Additionally, introduce a test suite for openvswitch with a test case
>>>>> that ensures this MTU behavior, with the expectation that new tests are
>>>>> added when needed.
>>>>>
>>>>> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
>>>>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>>>>> ---
>>>>> NOTE: checkpatch reports a whitespace error with the openvswitch.sh
>>>>>       script - this is due to using tab as the IFS value.  This part
>>>>>       of the script was copied from
>>>>>       tools/testing/selftests/net/pmtu.sh so I think should be
>>>>>       permissible.
>>>>>
>>>>>  net/openvswitch/actions.c                  |   2 +-
>>>>>  tools/testing/selftests/net/.gitignore     |   1 +
>>>>>  tools/testing/selftests/net/Makefile       |   1 +
>>>>>  tools/testing/selftests/net/openvswitch.sh | 394 +++++++++++++++++++++
>>>>>  4 files changed, 397 insertions(+), 1 deletion(-)
>>>>>  create mode 100755 tools/testing/selftests/net/openvswitch.sh
>>>>>
>>>>> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
>>>>> index 92a0b67b2728..d858ea580e43 100644
>>>>> --- a/net/openvswitch/actions.c
>>>>> +++ b/net/openvswitch/actions.c
>>>>> @@ -890,7 +890,7 @@ static void do_output(struct datapath *dp, struct sk_buff *skb, int out_port,
>>>>>                 if (likely(!mru ||
>>>>>                            (skb->len <= mru + vport->dev->hard_header_len))) {
>>>>>                         ovs_vport_send(vport, skb, ovs_key_mac_proto(key));
>>>>> -               } else if (mru <= vport->dev->mtu) {
>>>>> +               } else if (mru) {
>>>>>                         struct net *net = read_pnet(&dp->net);
>>>>>
>>>>>                         ovs_fragment(net, vport, skb, mru, key);
>>>>
>>>> I thought about this for a while. For a bit of context, my
>>>> recollection is that in the initial design, there was an attempt to
>>>> minimize the set of assumptions around L3 behaviour and despite
>>>> performing this pseudo-L3 action of connection tracking, attempt a
>>>> "bump-in-the-wire" approach where OVS is serving as an L2 switch and
>>>> if you wanted L3 features, you need to build them on top or explicitly
>>>> define that you're looking for L3 semantics. In this case, you're
>>>> interpreting that the combination of the conntrack action + an output
>>>> action implies that L3 routing is being performed. Hence, OVS should
>>>> act like a router and either refragment or generate ICMP PTB in the
>>>> case where MTU differs. According to the flow table, the rest of the
>>>> routing functionality (MAC handling for instance) may or may not have
>>>> been performed at this point, but we basically leave that up to the
>>>> SDN controller to implement the right behaviour. In relation to this
>>>> particular check, the idea was to retain the original geometry of the
>>>> packet such that it's as though there were no functionality performed
>>>> in the middle at all. OVS happened to do connection tracking (which
>>>> implicitly involved queueing fragments), but if you treat it as an
>>>> opaque box, you have ports connected and OVS is simply performing
>>>> forwarding between the ports.
>>>
>>> I've been going back and forth on this.  On the one hand, Open vSwitch
>>> is supposed to only care about 'just' the L2 forwarding, with some
>>> additional processing to assist.  After that, it's up to an L3 layer to
>>> really provide additional support, and the idea is that the controller
>>> or something else should really be guiding this higher level
>>> intelligence.
>>>
>>> The issue I have is that we do some of the high level intelligence here
>>> to support conntrack, and it's done in a way that is a bit unintuitive.
>>> As an example, you write:
>>>
>>>   ... the idea was to retain the original geometry of the packet such
>>>   that it's as though there were no functionality performed in the
>>>   middle at all
>>>
>>> But, the fragmentation engine isn't guaranteed to reassemble exactly the
>>> same packets.
>>>
>>> Consider the scenario where there is an upstream router that has
>>> performed it's own mitm fragmentation.  There can be a sequence of
>>> packets after that that looks like:
>>>
>>>   IPID == 1,  pkt 1 (1410 bytes), pkt 2 (64 bytes), pkt 3 (1000 bytes)
>>>
>>> When reassembled by the frag engine, we will only use the MRU as the
>>> guide, and that will spit out:
>>>
>>>   IPID == 1,  pkt 1 (1410 bytes), pkt 2 (1044 bytes)
>>>
>>> We will have reduced the number of packets moving through the network,
>>> and then aren't acting as a bump in the wire, but as a real entity.
>>>
>>> I even tested this:
>>>
>>>   04:28:47 root@dhcp-25
>>> /home/aconole/git/linux/tools/testing/selftests/net# grep 'IP
>>> 172.31.110.2' test_mismatched_mtu_with_conntrack/c1-pkts.cap
>>>   16:25:43.481072 IP 172.31.110.2.52352 > 172.31.110.1.ddi-udp-1: UDP, bad length 1901 > 1360
>>>   16:25:43.525972 IP 172.31.110.2 > 172.31.110.1: ip-proto-17
>>>   16:25:43.567272 IP 172.31.110.2 > 172.31.110.1: ip-proto-17
>>>   bash: __git_ps1: command not found
>>>   04:28:54 root@dhcp-25
>>> /home/aconole/git/linux/tools/testing/selftests/net# grep 'IP
>>> 172.31.110.2' test_mismatched_mtu_with_conntrack/s1-pkts.cap
>>>   16:25:43.567435 IP 172.31.110.2.52352 > 172.31.110.1.ddi-udp-1: UDP, bad length 1901 > 1360
>>>   16:25:43.567438 IP 172.31.110.2 > 172.31.110.1: ip-proto-17
>>>
>>> Additionally, because this happens transparently for the flow rule user,
>>> we need to run check_pkt_len() after every call to the conntrack action
>>> because there is really no longer a way to know whether the packet came
>>> in via a fragmented path.  I guess we could do something with
>>> ip.frag==first|later|no... selection rules to try and create a custom
>>> table for handling fragments - but that seems like it's a workaround for
>>> the conntrack functionality w.r.t. the fragmentation engine.
>>
>>
>> Maybe it makes no sense, so correct me if I'm wrong, but looking at the
>> defragmentation code I see that it does not touch original fragments.
> 
> I guess you're referring to the frag list that gets generated and stored
> in the skbuff shinfo?

I guess so. :)

> 
>> I mean, since it's not a IP_DEFRAG_LOCAL_DELIVER, skb still holds a list
>> of fragments with their original size.  Maybe we can fragment them based
>> on existing skb fragments instead of using the maximum fragment size and
>> get the same split as it was before defragmentation?
> 
> I think during conntrack processing we linearize the skbuff and then
> discard these fragments.  At least, I didn't look as deeply just now,
> but I did hack a check for the skbfraglist on output:
> 
>    if (skb_has_frag_list(skb)) {
>       printk(KERN_CRIT "SKB HAS A FRAG LIST");
>    }
> 
> And this print wasn't hit during the ovs output processing above.  So I
> assume we don't have the fraglist any more by the time output would
> happen. Are you asking if we can keep this list around to use?

Yes, it will be good if we can keep it somehow.  ip_do_fragment() uses
this list for fragmentation if it's available.

At least, it should be available right after ip_defrag().  If we can't
keep the list itself without modifying too much of the code, maybe we
can just memorize sizes and use them later for fragmentation.  Not sure
how the good implementation should look like, though.

Anyway, my point is that it looks more like a technical difficulty rather
than conceptual problem.

Another thing: It seems like very recently some very similar (to what OVS
does right now) fragmentation logic was added to net/sched/:
  c129412f74e9 ("net/sched: sch_frag: add generic packet fragment support.")

Do we have the same problem there?  We, likely, want the logic to be
consistent.  IIUC, this is the code that will be executed if OVS will
offload conntrack to TC, right?

And one more question here: How does CT offload capable HW works in this
case?  What is the logic around re-fragmenting there?  Is there some
common guideline on how solution should behave (looks like there is no
any, otherwise we would not have this discussion)?

> 
>>>> One of the related implications is the contrast between what happens
>>>> in this case if you have a conntrack action injected or not when
>>>> outputting to another port. If you didn't put a connection tracking
>>>> action into the flows when redirecting here, then there would be no
>>>> defragmentation or refragmentation. In that case, OVS is just
>>>> attempting to forward to another device and if the MTU check fails,
>>>> then bad luck, packets will be dropped. Now, with the interpretation
>>>> in this patch, it seems like we're trying to say that, well, actually,
>>>> if the controller injects a connection tracking action, then the
>>>> controller implicitly switches OVS into a sort of half-L3 mode for
>>>> this particular flow. This makes the behaviour a bit inconsistent.
>>>
>>> I agree, the behavior will be inconsistent w.r.t. L3.  But it is right
>>> now also.  And at least with this change we will be consistently
>>> inconsistent - the user requests ct() with the L3 functions that it
>>> implies.
>>>
>>> One other problem with the controller is the way we need to generate
>>> FRAGNEED packets in v4.  The spec is quite clear with DF=1, drop and
>>> generate.  With DF=0, it's less clear (at least after I re-checked RFC
>>> 791 I didn't see anything, but I might have missed it).  The controller
>>> will now receive all the traffic, I guess.  It's okay with TCP flows
>>> that set DF=1, but for UDP (maybe other protocols) that isn't the case.
>>>
>>>> Another thought that occurs here is that if you have three interfaces
>>>> attached to the switch, say one with MTU 1500 and two with MTU 1450,
>>>> and the OVS flows are configured to conntrack and clone the packets
>>>> from the higher-MTU interface to the lower-MTU interfaces. If you
>>>> receive larger IP fragments on the first interface and attempt to
>>>> forward on to the other interfaces, should all interfaces generate an
>>>> ICMPv6 PTB?
>>>
>>> I guess they would, for each destination.  I don't know if it's
>>> desirable, but I can see how it would generate a lot of traffic.  Then
>>> again, why should it?  Would conntrack determine that we have two
>>> interfaces to output: actions?
>>>
>>>> That doesn't seem quite right, especially if one of those
>>>> ports is used for mirroring the traffic for operational reasons while
>>>> the other path is part of the actual routing path for the traffic.
>>>
>>> I didn't consider the mirroring case.  I guess we would either need some
>>> specific metadata.  I don't know that anyone is making a mirror port
>>> this way, but I guess if the bug report comes in I'll look at it ;)
>>>
>>>> You'd end up with duplicate PTB messages for the same outbound
>>>> request. If I read right, this would also not be able to be controlled
>>>> by the OVS controller because when we call into ip6_fragment() and hit
>>>> the MTU-handling path, it will automatically take over and generate
>>>> the ICMP response out the source interface, without any reference to
>>>> the OVS flow table. This seems like it's further breaking the model
>>>> where instead of OVS being a purely programmable L2-like flow
>>>> match+actions pipeline, now depending on the specific actions you
>>>> inject (in particular combinations), you get some bits of the L3
>>>> functionality. But for full L3 functionality, the controller still
>>>> needs to handle the rest through the correct set of actions in the
>>>> flow.
>>>
>>> It's made more difficult because ct() action itself does L3 processing
>>> (and I think I demonstrated this).
>>>
>>>> Looking at the tree, it seems like this problem can be solved in
>>>> userspace without further kernel changes by using
>>>> OVS_ACTION_ATTR_CHECK_PKT_LEN, see commit 4d5ec89fc8d1 ("net:
>>>> openvswitch: Add a new action check_pkt_len"). It even explicitly says
>>>> "The main use case for adding this action is to solve the packet drops
>>>> because of MTU mismatch in OVN virtual networking solution.". Have you
>>>> tried using this approach?
>>>
>>> We looked and discussed it a bit.  I think the outcome boils down to
>>> check_pkt_len needs to be used on every single instance where a ct()
>>> call occurs because ct() implies we have connections to monitor, and
>>> that implies l3, so we need to do something (either push to a controller
>>> and handle it like OVN would, etc).  This has implications on older
>>> versions of OvS userspace (that don't support check_pkt_len action), and
>>> non-OVN based controllers (that might just program a flow pipeline and
>>> expect it to work).
>>>
>>> I'm not sure what the best approach is really.
>>>
>>>>> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
>>>>> index 61ae899cfc17..d4d7487833be 100644
>>>>> --- a/tools/testing/selftests/net/.gitignore
>>>>> +++ b/tools/testing/selftests/net/.gitignore
>>>>> @@ -30,3 +30,4 @@ hwtstamp_config
>>>>>  rxtimestamp
>>>>>  timestamping
>>>>>  txtimestamp
>>>>> +test_mismatched_mtu_with_conntrack
>>>>> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
>>>>> index 25f198bec0b2..dc9b556f86fd 100644
>>>>> --- a/tools/testing/selftests/net/Makefile
>>>>> +++ b/tools/testing/selftests/net/Makefile
>>>>
>>>> Neat to see some bootstrapping of in-tree OVS testing. I'd probably
>>>> put it in a separate commit but maybe that's just personal preference.
>>>
>>> I figured I should add it here because it demonstrates the issue I'm
>>> trying to solve.  But I agree, it's maybe a new functionality, so I'm
>>> okay with submitting this part + test cases with net-next instead.
>>>
>>>> I didn't look *too* closely at the tests but just one nit below:
>>>>
>>>>> +       # test a udp connection
>>>>> +       info "send udp data"
>>>>> + ip netns exec server sh -c 'cat ${ovs_dir}/fifo | nc -l -vv -u
>>>>> 8888 >${ovs_dir}/fifo 2>${ovs_dir}/s1-nc.log & echo $! >
>>>>> ${ovs_dir}/server.pid'
>>>>
>>>> There are multiple netcat implementations with different arguments
>>>> (BSD and nmap.org and maybe also Debian versions). Might be nice to
>>>> point out which netcat you're relying on here or try to detect & fail
>>>> out/skip on the wrong one. For reference, the equivalent OVS test code
>>>> detection is here:
>>>
>>> netcat's -l, -v, and -u options are universal (even to the old 'hobbit'
>>> 1.10 netcat), so I don't think we need to do detection for these
>>> options.  If a future test needs something special (like 'send-only' for
>>> nmap-ncat), then it probably makes sense to hook something up then.
>>>
>>>> https://github.com/openvswitch/ovs/blob/80e74da4fd8bfdaba92105560ce144b4b2d00e36/tests/atlocal.in#L175
>>>
>>> _______________________________________________
>>> dev mailing list
>>> dev@openvswitch.org
>>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
>>>
> 

