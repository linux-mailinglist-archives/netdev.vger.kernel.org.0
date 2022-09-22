Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531125E6621
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiIVOrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiIVOrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:47:24 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86A6F1D6F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:47:21 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1obNTu-0000Gv-Sc; Thu, 22 Sep 2022 16:47:14 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1obNTu-0004Em-Hn; Thu, 22 Sep 2022 16:47:14 +0200
Subject: Re: [PATCH net 1/1] net: Fix return value of qdisc ingress handling
 on success
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Blakey <paulb@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <1663750248-20363-1-git-send-email-paulb@nvidia.com>
 <c322d8d6-8594-65a9-0514-3b6486d588fe@iogearbox.net>
 <20220921074854.48175d87@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2338579f-689f-4891-ec58-22ac4046dd5a@iogearbox.net>
Date:   Thu, 22 Sep 2022 16:47:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220921074854.48175d87@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26666/Thu Sep 22 09:54:12 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/22 4:48 PM, Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 11:11:03 +0200 Daniel Borkmann wrote:
>> On 9/21/22 10:50 AM, Paul Blakey wrote:
>>> Currently qdisc ingress handling (sch_handle_ingress()) doesn't
>>> set a return value and it is left to the old return value of
>>> the caller (__netif_receive_skb_core()) which is RX drop, so if
>>> the packet is consumed, caller will stop and return this value
>>> as if the packet was dropped.
>>>
>>> This causes a problem in the kernel tcp stack when having a
>>> egress tc rule forwarding to a ingress tc rule.
>>> The tcp stack sending packets on the device having the egress rule
>>> will see the packets as not successfully transmitted (although they
>>> actually were), will not advance it's internal state of sent data,
>>> and packets returning on such tcp stream will be dropped by the tcp
>>> stack with reason ack-of-unsent-data. See reproduction in [0] below.
>>>
>>> Fix that by setting the return value to RX success if
>>> the packet was handled successfully.
>>>
>>> [0] Reproduction steps:
>>>    $ ip link add veth1 type veth peer name peer1
>>>    $ ip link add veth2 type veth peer name peer2
>>>    $ ifconfig peer1 5.5.5.6/24 up
>>>    $ ip netns add ns0
>>>    $ ip link set dev peer2 netns ns0
>>>    $ ip netns exec ns0 ifconfig peer2 5.5.5.5/24 up
>>>    $ ifconfig veth2 0 up
>>>    $ ifconfig veth1 0 up
>>>
>>>    #ingress forwarding veth1 <-> veth2
>>>    $ tc qdisc add dev veth2 ingress
>>>    $ tc qdisc add dev veth1 ingress
>>>    $ tc filter add dev veth2 ingress prio 1 proto all flower \
>>>      action mirred egress redirect dev veth1
>>>    $ tc filter add dev veth1 ingress prio 1 proto all flower \
>>>      action mirred egress redirect dev veth2
>>>
>>>    #steal packet from peer1 egress to veth2 ingress, bypassing the veth pipe
>>>    $ tc qdisc add dev peer1 clsact
>>>    $ tc filter add dev peer1 egress prio 20 proto ip flower \
>>>      action mirred ingress redirect dev veth1
>>>
>>>    #run iperf and see connection not running
>>>    $ iperf3 -s&
>>>    $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1
>>>
>>>    #delete egress rule, and run again, now should work
>>>    $ tc filter del dev peer1 egress
>>>    $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1
>>>
>>> Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
>>> Signed-off-by: Paul Blakey <paulb@nvidia.com>
>>
>> Looks reasonable and aligns with sch_handle_egress() fwiw. I think your Fixes tag is wrong
>> since that commit didn't modify any of the above. This patch should also rather go to net-next
>> tree to make sure it has enough soak time to catch potential regressions from this change in
>> behavior.
> 
> I don't think we do "soak time" in networking. Perhaps we can try
> to use the "CC: stable # after 4 weeks" delay mechanism which Greg
> promised at LPC?

Isn't that implicit? If the commit has Fixes tag and lands in net-next, stable team
anyway automatically pulls it once everything lands in Linus' tree via merge win and
then does the backporting for stable.

>> Given the change under TC_ACT_REDIRECT is BPF specific, please also add a BPF selftest
>> for tc BPF program to assert the new behavior so we can run it in our BPF CI for every patch.
> 
> And it would be great to turn the commands from the commit message
> into a selftest as well :S
