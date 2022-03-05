Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AFE4CE5F5
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiCEQhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCEQhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:37:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1808321CD36
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 08:36:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95142B80B12
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 16:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D8FC004E1;
        Sat,  5 Mar 2022 16:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646498213;
        bh=uTW06DySGEZz0/Z8Bdyd0/9xsu4LZtsXTuGTvFjeiE4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KjIPeVsDXYmhVJ9FJ8vqFzcHUbtOvwwnKGbeUc6azg4nDDmAg3yPtZEmIDusQUEfL
         V1sK2uYgHnFvrRqENYfBtPP0Jsu10L2mMzPjSOS/059cie5iBQsB7mdDbOjoFrtuHZ
         LEYUqX14iw2ioiKNWBQmfbzN2zIh9AyzieFLNHzZl5JiM/L+22GRiSx0wCo6lkctYy
         SeJX5bDTIQ7QT7e0EizstPMmdZqZ9GuRXmcIABqCU+Dn30XkfzGcTQp/si62ozHmK4
         NmLZE8uRhpQroBXp/8Q5c/n9eCu84TI3Wtcp7WsDboXM8LGMQE8OeLrvZxQ+zsUGIy
         vdj/zfSWD+ocg==
Message-ID: <66ea9048-3287-c0d5-6edc-bd4b7ec4bd70@kernel.org>
Date:   Sat, 5 Mar 2022 09:36:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 net-next 14/14] mlx5: support BIG TCP packets
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-15-eric.dumazet@gmail.com>
 <c9f5c261-c263-a6b4-7e00-17dfefd36a7a@kernel.org>
 <CANn89iJKEV6Y+2mY1Gs_zJTrnm+TTXOHoW_D3AWYE0ELijrm+w@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89iJKEV6Y+2mY1Gs_zJTrnm+TTXOHoW_D3AWYE0ELijrm+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/22 10:14 AM, Eric Dumazet wrote:
> On Thu, Mar 3, 2022 at 8:43 PM David Ahern <dsahern@kernel.org> wrote:
>>
>> On 3/3/22 11:16 AM, Eric Dumazet wrote:
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> index b2ed2f6d4a9208aebfd17fd0c503cd1e37c39ee1..1e51ce1d74486392a26568852c5068fe9047296d 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> @@ -4910,6 +4910,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>>>
>>>       netdev->priv_flags       |= IFF_UNICAST_FLT;
>>>
>>> +     netif_set_tso_ipv6_max_size(netdev, 512 * 1024);
>>
>>
>> How does the ConnectX hardware handle fairness for such large packet
>> sizes? For 1500 MTU this means a single large TSO can cause the H/W to
>> generate 349 MTU sized packets. Even a 4k MTU means 128 packets. This
>> has an effect on the rate of packets hitting the next hop switch for
>> example.
> 
> I think ConnectX cards interleave packets from all TX queues, at least
> old CX3 have a parameter to control that.
> 
> Given that we already can send at line rate, from a single TX queue, I
> do not see why presenting larger TSO packets
> would change anything on the wire ?
> 
> Do you think ConnectX adds an extra gap on the wire at the end of a TSO train ?

It's not about 1 queue, my question was along several lines. e.g,
1. the inter-packet gap for TSO generated packets. With 512kB packets
the burst is 8x from what it is today.

2. the fairness within hardware as 1 queue has potentially many 512kB
packets and the impact on other queues (e.g., higher latency?) since it
will take longer to split the larger packets into MTU sized packets.

It is really about understanding the change this new default size is
going to have on users.
