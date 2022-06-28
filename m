Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B1355F215
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 01:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiF1XtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 19:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiF1XtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 19:49:09 -0400
Received: from mail.yonan.net (mail.yonan.net [54.244.116.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6535A387B9
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 16:49:09 -0700 (PDT)
Received: from [10.10.0.40] (unknown [76.130.91.106])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.yonan.net (Postfix) with ESMTPSA id C554F3E947;
        Tue, 28 Jun 2022 23:49:08 +0000 (UTC)
Message-ID: <5ceef56b-9f7b-df36-17e4-1542d3306267@openvpn.net>
Date:   Tue, 28 Jun 2022 17:49:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v2] rfs: added /proc/sys/net/core/rps_allow_ooo
 flag to tweak flow alg
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, therbert@google.com,
        stephen@networkplumber.org
References: <20220624100536.4bbc1156@hermes.local>
 <20220628051754.365238-1-james@openvpn.net>
 <20220628100126.5a906259@kicinski-fedora-PC1C0HJN>
From:   James Yonan <james@openvpn.net>
In-Reply-To: <20220628100126.5a906259@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/22 11:03, Jakub Kicinski wrote:
> On Mon, 27 Jun 2022 23:17:54 -0600 James Yonan wrote:
>> rps_allow_ooo (0|1, default=0) -- if set to 1, allow RFS (receive flow
>> steering) to move a flow to a new CPU even if the old CPU queue has
>> pending packets.  Note that this can result in packets being delivered
>> out-of-order.  If set to 0 (the default), the previous behavior is
>> retained, where flows will not be moved as long as pending packets remain.
>>
>> The motivation for this patch is that while it's good to prevent
>> out-of-order packets, the current RFS logic requires that all previous
>> packets for the flow have been dequeued before an RFS CPU switch is made,
>> so as to preserve in-order delivery.  In some cases, on links with heavy
>> VPN traffic, we have observed that this requirement is too onerous, and
>> that it prevents an RFS CPU switch from occurring within a reasonable time
>> frame if heavy traffic causes the old CPU queue to never fully drain.
>>
>> So rps_allow_ooo allows the user to select the tradeoff between a more
>> aggressive RFS steering policy that may reorder packets on a CPU switch
>> event (rps_allow_ooo=1) vs. one that prioritizes in-order delivery
>> (rps_allow_ooo=0).
> Can you give a practical example where someone would enable this?
> What is the traffic being served here that does not care about getting
> severely chopped up? Also why are you using RPS, it's 2022, don't all
> devices of note have multi-queue support?

So the problem with VPN transport is that you have encryption overhead 
that can be CPU intensive.  Suppose I can get 10 Gbps throughput per 
core.  Now suppose I have 4 different 10 Gbps sessions on my 4 core 
machine.  In a perfect world, each of those sessions would migrate to a 
different core and you would achieve the full parallelism of your 
hardware.  RFS helps to make this work, but the existing RFS algorithm 
sometimes gets stuck with multiple sessions on one core, while other 
cores are idle.  I found that this often occurs because RFS puts a high 
priority on maintaining in-order delivery, so once the queues are 
operating at full speed, it's very difficult to find an opportunity to 
switch CPUs without some packet reordering.  But the cost of being 
strict about packet reordering is that you end up with multiple sessions 
stuck on the same core, alongside idle cores.  This is solved by setting 
rps_allow_ooo to 1.  You might get a few reordered packets on the CPU 
switch event, but once the queues stabilize, you get significantly 
higher throughput because you can actively load balance the sessions 
across CPUs.

Re: why are we still using RPS/RFS in 2022?  It's very useful for load 
balancing L4 sessions across multiple CPUs (not only across multiple net 
device queues).

James


