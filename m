Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FDF4B9731
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiBQDuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:50:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiBQDuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:50:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74C6C4280
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4954B61D34
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 03:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588A8C340E9;
        Thu, 17 Feb 2022 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645069808;
        bh=mU7ca/Po13Yz5zyEFjpJGKcc/Du9+Pth+20ktmSRQ5k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oFwijLXfQi5ST77YYHFzn6fZMdUrZeL0SkElVtZHrj7P5WiF/xc0ERQaherwvuLCI
         7pakUSpT2Fa2AwmjO1SZz0ASMZG/14NCLNWTjpWJYMWx7NytMrm31urhSUXVwoNTGG
         x1PS4uQ0vEoC8XZ58l30rY1AoWTHrwzPneadnYR/hABgBU06SWQnWIyAO2unShmd/J
         AFnHu7HUej+YPOZw5eRc8kYb5TZnfBlDMy6c5KFZWiMAfFwfSF8NX05b/i0ZV0LpTg
         PrGYX76gcj6xEVHJ5KEXNsM/1+xNoLwdqyTPqy1eoibwX2cL/URHecNm+3Okfb8RQ7
         VtP1xQXR/gjPg==
Message-ID: <4383fcc3-f7de-8eb3-6746-2f271578a9e0@kernel.org>
Date:   Wed, 16 Feb 2022 20:50:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [RFC PATCH net] vrf: fix incorrect dereferencing of skb->cb
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <1644844229-54977-1-git-send-email-alibuda@linux.alibaba.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <1644844229-54977-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/22 6:10 AM, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> There is a failed test case in vrf scenario, it can be reproduced
> with script:
> 
> ./vrf_route_leaking.sh -t ipv6_ping_frag
> 
> Which output is similar to following:
> 
> TEST: Basic IPv6 connectivity			[ OK ]
> TEST: Ping received ICMP Packet too big		[FAIL]
> 
> The direct cause of this issue is because the Packet too big in ICMPv6
> is sent by the message whose source address is IPv6 loopback address and
> is discarded dues to its input interface is not the local loopback device.
> But the root cause is there's a bug that affects the correct source
> address selection.

That is the correct problem, but your solution is not.

> 
> In the above case the calling stack is as follows:
> 
>     icmp6_send+1
>     ip6_fragment+543
>     ip6_output+98
>     vrf_ip6_local_out+78
>     vrf_xmit+424
>     dev_hard_start_xmit+221
>     __dev_queue_xmit+2792
>     ip6_finish_output2+705
>     ip6_output+98
>     ip6_forward+1464
>     ipv6_rcv+67
> 
> To be more specific:
> 
> ipv6_rcv()
> 	init skb->cb as struct inet6_skb_parm
> ...
> __dev_queue_xmit()
> 	qdisc_pkt_len_init()
> 	init skb->cb as struct qdisc_skb_cb
> ...
> vrf_xmit
> 	fill skb->cb to zero.
> ...
> ip6_fragment()
> icmp6_send()
> 	treats skb->cb as struct inet6_skb_parm.
> 
> icmp6_send() will try to use original input interface in IP6CB for
> selecting a more meaningful source address, we should keep the old IP6CB
> rather than overwrite it.

The packet is recirculated through the VRF device so the cb data should
be overwritten. The VRF driver does another route lookup within the VRF.
Address selection should only consider addresses in the domain.
Something is off in that logic for VRF route leaking. I looked into a
bit when Michael posted the tests, but never came back to it.
