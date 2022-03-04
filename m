Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052514CCCA6
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbiCDEny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiCDEnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:43:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D304344CE
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 20:43:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31B4CB82755
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 04:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14035C340E9;
        Fri,  4 Mar 2022 04:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646368982;
        bh=Aj4iOLIH2HveaGTQZtQjC6E9tZe/nTCo6ygjBAvfhwU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kBVUM9eoPQyv7VFSlGS5YvnJAE1i3AXxzP/jOMdN6OXCaBdaWrf8DVNADwwP3INBr
         e3OQssUVmfwJj6zjLaV7CQrGxXuZIFGGtYxcbb4hgy+1plxedMTf4+iUgDFTteyR6j
         bbcSOh9ZHndARu5VyL1TDl+MPQo10QtpeOdoM4uO495mvJjE1FcASJyEtsSoFr9m/g
         8yT76U4GcNtsgLN5ZfffsQlWApVY7hb4gsPEKLqmHCYgFmHg5BU/+8fC3Q2igGhRGt
         ZffHXUBNV3t6VAOp/17Rw1DQZNkMoEyukL1VG0mmXXZTPvHDZzYZRqO4MI/acSs8M3
         qDnhcGHLz6uog==
Message-ID: <c9f5c261-c263-a6b4-7e00-17dfefd36a7a@kernel.org>
Date:   Thu, 3 Mar 2022 21:42:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 net-next 14/14] mlx5: support BIG TCP packets
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-15-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220303181607.1094358-15-eric.dumazet@gmail.com>
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

On 3/3/22 11:16 AM, Eric Dumazet wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index b2ed2f6d4a9208aebfd17fd0c503cd1e37c39ee1..1e51ce1d74486392a26568852c5068fe9047296d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4910,6 +4910,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>  
>  	netdev->priv_flags       |= IFF_UNICAST_FLT;
>  
> +	netif_set_tso_ipv6_max_size(netdev, 512 * 1024);


How does the ConnectX hardware handle fairness for such large packet
sizes? For 1500 MTU this means a single large TSO can cause the H/W to
generate 349 MTU sized packets. Even a 4k MTU means 128 packets. This
has an effect on the rate of packets hitting the next hop switch for
example.
