Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ADE538536
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbiE3PrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242157AbiE3PrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:47:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6C7222A04
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 08:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB9660FE4
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 15:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A412C3411C;
        Mon, 30 May 2022 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653922806;
        bh=GpyK8/Yfu8X4M5tnR6vG0wJ9aTdcB+4+BwiogudKXbU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=K0eam4/L3UiqfDx4ZaZPRhC0CXQitGxjy0pxK+UgrRcq6xPa+X4JFBoN6J8wpEqgI
         kr1STHg8rVjzRp3KfMRH6NeUjM7cWZZLaWGhbPPdMiHOrarGhNu98qcmcVfOrGsd4I
         f/Jwf4Kv9KrCPuIBhmTB9pgz6yeYZ1w/uwG8Jhq9PARVbQXQR959DwGuEF8quDMaAY
         z7jUlq3ger85lGQYWCd5wyTLL2KdTswPdTEgbTnp+eQQaNWgBqwg0s5ziLcwSHnKPS
         5El72S2VH1M+H97ObDALF+788uJK1vErDLEiD0/ZxpuY+c8k0YRmQm9AoQ3xvjhov2
         Utfwkg8puPUZg==
Message-ID: <779a783e-41ec-d0b0-d6a1-0c5668d0c844@kernel.org>
Date:   Mon, 30 May 2022 09:00:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH net V2] net: ping6: Fix ping -6 with interface name
Content-Language: en-US
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220529115033.13454-1-tariqt@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220529115033.13454-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/22 5:50 AM, Tariq Toukan wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> When passing interface parameter to ping -6:
> $ ping -6 ::11:141:84:9 -I eth2
> Results in:
> PING ::11:141:84:10(::11:141:84:10) from ::11:141:84:9 eth2: 56 data bytes
> ping: sendmsg: Invalid argument
> ping: sendmsg: Invalid argument
> 
> Initialize the fl6's outgoing interface (OIF) before triggering
> ip6_datagram_send_ctl. Don't wipe fl6 after ip6_datagram_send_ctl() as
> changes in fl6 that may happen in the function are overwritten explicitly.
> Update comment accordingly.
> 
> Fixes: 13651224c00b ("net: ping6: support setting basic SOL_IPV6 options via cmsg")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/ipv6/ping.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> V2:
> Per David Ahern's comment, moved memset before if (msg->msg_controllen),
> and updated the code comment accordingly.
> 
> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> index ff033d16549e..2a5f3337d488 100644
> --- a/net/ipv6/ping.c
> +++ b/net/ipv6/ping.c
> @@ -101,24 +101,25 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  	ipc6.sockc.tsflags = sk->sk_tsflags;
>  	ipc6.sockc.mark = sk->sk_mark;
>  
> +	memset(&fl6, 0, sizeof(fl6));
> +
>  	if (msg->msg_controllen) {
>  		struct ipv6_txoptions opt = {};
>  
>  		opt.tot_len = sizeof(opt);
>  		ipc6.opt = &opt;
> +		fl6.flowi6_oif = oif;

This should be moved up to after the memset since it is currently done
after "fl6.daddr = *daddr;" below (remove that one). That's how it is
done in rawv6_sendmsg and udpv6_sendmsg.



>  
>  		err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, &fl6, &ipc6);
>  		if (err < 0)
>  			return err;
>  
>  		/* Changes to txoptions and flow info are not implemented, yet.
> -		 * Drop the options, fl6 is wiped below.
> +		 * Drop the options.
>  		 */
>  		ipc6.opt = NULL;
>  	}
>  
> -	memset(&fl6, 0, sizeof(fl6));
> -
>  	fl6.flowi6_proto = IPPROTO_ICMPV6;
>  	fl6.saddr = np->saddr;
>  	fl6.daddr = *daddr;

