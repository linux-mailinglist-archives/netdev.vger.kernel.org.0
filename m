Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9353F1A88
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732167AbfKFP5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:57:01 -0500
Received: from www.os-cillation.de ([87.106.250.87]:56348 "EHLO
        www.os-cillation.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfKFP5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:57:00 -0500
Received: by www.os-cillation.de (Postfix, from userid 1030)
        id 0CB2E7FD; Wed,  6 Nov 2019 16:57:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        s17988253.onlinehome-server.info
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.5 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from core2019.osc.gmbh (p578a635d.dip0.t-ipconnect.de [87.138.99.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by www.os-cillation.de (Postfix) with ESMTPSA id 0E86B772;
        Wed,  6 Nov 2019 16:57:00 +0100 (CET)
Received: from [192.168.3.92] (hd2019.osc.gmbh [192.168.3.92])
        by core2019.osc.gmbh (Postfix) with ESMTPA id C64198E00E0;
        Wed,  6 Nov 2019 16:56:57 +0100 (CET)
Subject: Re: [Possible regression?] ip route deletion behavior change
To:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
 <9384f54f-67a0-f2dc-68f8-3216717ee63e@gmail.com>
From:   Hendrik Donner <hd@os-cillation.de>
Openpgp: preference=signencrypt
Cc:     Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Message-ID: <b7d44dcf-6382-a668-1a6a-4385f77fb0f5@os-cillation.de>
Date:   Wed, 6 Nov 2019 16:56:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9384f54f-67a0-f2dc-68f8-3216717ee63e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 9:41 PM, David Ahern wrote:
> On 10/31/19 9:44 AM, Hendrik Donner wrote:
>> Hello,
>>
>> analyzing a network issue on our embedded system product i found a change in behavior 
>> regarding the removal of routing table entries when an IP address is removed.
>>
>> On older kernel releases before commit 5a56a0b3a45dd0cc5b2f7bec6afd053a474ed9f5
>> (simplified example):
>>
>> Routing table:
>>
>> # ip r
>> default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 1024
>> 10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
>> 10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 1024
>> 10.20.0.0/14 via 10.0.2.2 dev enp0s3 src 10.20.40.100
>>
>> The last route was manually added with ip r add.
>>
>> Removing the IP 10.20.40.100 from enp0s3 also removes the last route:
>>
>> # ip r
>> default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 1024
>> 10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
>> 10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 1024
>>
>> After the mentioned commit - so since v4.10 - the route will no longer be removed. At 
>> least for my team that's a surprising change in behavior because our system relies on
>> the old behavior.
>>
>> Reverting the commit restores the old behavior.
>>
>> I'm aware that our use case is a bit odd, but according to the commit message commit 
>> 5a56a0b3a45dd0cc5b2f7bec6afd053a474ed9f5 was meant to fix VRF related behavior while
>> having the described (maybe unintended?) user visible side effect for non-VRF usage.
>>
> 
> devices not associated with a VRF table are implicitly tied to the
> default == main table.
> 
> Can you test this change:
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 0913a090b2bf..f1888c683426 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -1814,8 +1814,8 @@ int fib_sync_down_addr(struct net_device *dev,
> __be32 local)
>         int ret = 0;
>         unsigned int hash = fib_laddr_hashfn(local);
>         struct hlist_head *head = &fib_info_laddrhash[hash];
> +       int tb_id = l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
>         struct net *net = dev_net(dev);
> -       int tb_id = l3mdev_fib_table(dev);
>         struct fib_info *fi;
> 
>         if (!fib_info_laddrhash || local == 0)
> 
> [ As DaveM noted, you should cc maintainers and author(s) of suspected
> regression patches ]
> 

I've tested your patch and it restores the expected behavior.

+ Mark Tomlinson so he can have a look at it too.

And my mail server can't deliver to Shrijeet Mukherjee <shm@cumulusnetworks.com>.
Is that email address correct?
