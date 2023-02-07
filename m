Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5388168CB02
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 01:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBGAVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 19:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBGAVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 19:21:00 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C19A2F793
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 16:20:58 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 641D360003;
        Tue,  7 Feb 2023 00:20:53 +0000 (UTC)
Message-ID: <35e2378f-1a9b-9b32-796d-cb1c8c777118@ovn.org>
Date:   Tue, 7 Feb 2023 01:20:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Cc:     i.maximets@ovn.org, Oz Shlomo <ozsh@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Marcelo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware miss
 to tc action
Content-Language: en-US
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20230205154934.22040-1-paulb@nvidia.com>
 <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
 <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com>
From:   Ilya Maximets <i.maximets@ovn.org>
In-Reply-To: <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/23 18:14, Paul Blakey wrote:
> 
> 
> On 06/02/2023 14:34, Ilya Maximets wrote:
>> On 2/5/23 16:49, Paul Blakey wrote:
>>> Hi,
>>>
>>> This series adds support for hardware miss to instruct tc to continue execution
>>> in a specific tc action instance on a filter's action list. The mlx5 driver patch
>>> (besides the refactors) shows its usage instead of using just chain restore.
>>>
>>> Currently a filter's action list must be executed all together or
>>> not at all as driver are only able to tell tc to continue executing from a
>>> specific tc chain, and not a specific filter/action.
>>>
>>> This is troublesome with regards to action CT, where new connections should
>>> be sent to software (via tc chain restore), and established connections can
>>> be handled in hardware.
>>>
>>> Checking for new connections is done when executing the ct action in hardware
>>> (by checking the packet's tuple against known established tuples).
>>> But if there is a packet modification (pedit) action before action CT and the
>>> checked tuple is a new connection, hardware will need to revert the previous
>>> packet modifications before sending it back to software so it can
>>> re-match the same tc filter in software and re-execute its CT action.
>>>
>>> The following is an example configuration of stateless nat
>>> on mlx5 driver that isn't supported before this patchet:
>>>
>>>   #Setup corrosponding mlx5 VFs in namespaces
>>>   $ ip netns add ns0
>>>   $ ip netns add ns1
>>>   $ ip link set dev enp8s0f0v0 netns ns0
>>>   $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
>>>   $ ip link set dev enp8s0f0v1 netns ns1
>>>   $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
>>>
>>>   #Setup tc arp and ct rules on mxl5 VF representors
>>>   $ tc qdisc add dev enp8s0f0_0 ingress
>>>   $ tc qdisc add dev enp8s0f0_1 ingress
>>>   $ ifconfig enp8s0f0_0 up
>>>   $ ifconfig enp8s0f0_1 up
>>>
>>>   #Original side
>>>   $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
>>>      ct_state -trk ip_proto tcp dst_port 8888 \
>>>        action pedit ex munge tcp dport set 5001 pipe \
>>>        action csum ip tcp pipe \
>>>        action ct pipe \
>>>        action goto chain 1
>>>   $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>>      ct_state +trk+est \
>>>        action mirred egress redirect dev enp8s0f0_1
>>>   $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>>      ct_state +trk+new \
>>>        action ct commit pipe \
>>>        action mirred egress redirect dev enp8s0f0_1
>>>   $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
>>>        action mirred egress redirect dev enp8s0f0_1
>>>
>>>   #Reply side
>>>   $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
>>>        action mirred egress redirect dev enp8s0f0_0
>>>   $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
>>>      ct_state -trk ip_proto tcp \
>>>        action ct pipe \
>>>        action pedit ex munge tcp sport set 8888 pipe \
>>>        action csum ip tcp pipe \
>>>        action mirred egress redirect dev enp8s0f0_0
>>>
>>>   #Run traffic
>>>   $ ip netns exec ns1 iperf -s -p 5001&
>>>   $ sleep 2 #wait for iperf to fully open
>>>   $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
>>>
>>>   #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
>>>   $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
>>>          Sent hardware 9310116832 bytes 6149672 pkt
>>>          Sent hardware 9310116832 bytes 6149672 pkt
>>>          Sent hardware 9310116832 bytes 6149672 pkt
>>>
>>> A new connection executing the first filter in hardware will first rewrite
>>> the dst port to the new port, and then the ct action is executed,
>>> because this is a new connection, hardware will need to be send this back
>>> to software, on chain 0, to execute the first filter again in software.
>>> The dst port needs to be reverted otherwise it won't re-match the old
>>> dst port in the first filter. Because of that, currently mlx5 driver will
>>> reject offloading the above action ct rule.
>>>
>>> This series adds supports partial offload of a filter's action list,
>>> and letting tc software continue processing in the specific action instance
>>> where hardware left off (in the above case after the "action pedit ex munge tcp
>>> dport... of the first rule") allowing support for scenarios such as the above.
>>
>>
>> Hi, Paul.  Not sure if this was discussed before, but don't we also need
>> a new TCA_CLS_FLAGS_IN_HW_PARTIAL flag or something like this?
>>
>> Currently the in_hw/not_in_hw flags are reported per filter, i.e. these
>> flags are not per-action.  This may cause confusion among users, if flows
>> are reported as in_hw, while they are actually partially or even mostly
>> processed in SW.
>>
>> What do you think?
>>
>> Best regards, Ilya Maximets.
> 
> I think its a good idea, and I'm fine with proposing something like this in a
> different series, as this isn't a new problem from this series and existed before
> it, at least with CT rules.

Hmm, I didn't realize the issue already exists.

> 
> So how about I'll propose it in a different series and we continue with this first?

Sounds fine to me.  Thanks!

Best regards, Ilya Maximets.
