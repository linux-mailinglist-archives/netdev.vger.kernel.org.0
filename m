Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55CE639C98
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 20:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiK0TjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 14:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiK0TjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 14:39:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE7CDF01;
        Sun, 27 Nov 2022 11:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29C5AB80B2F;
        Sun, 27 Nov 2022 19:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B1FC433D6;
        Sun, 27 Nov 2022 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669577944;
        bh=yPaWCE6V8i4bhYQI3SgB7sBQSTx+DEFIGJ44+YgM6b8=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=r8/wbQ1n4XvPIbzzS+iiJfFAkhu0+GlzQTmQ8epk0YHiqj++L3+DFT8ght0lQMO48
         YMSfVqBpHbRMzWNnFM4MicpH8hSW3U2KU+SjMDqc+T7V0vtYIQsJICjchcwDfu52pu
         2V0QT4CAPEK1gV2yFvDtzUytxoTIkrnBs1VdHbEixuKzNhFR4TApYcUuNoKcXT6/FC
         vnou81zgrKpqiSzzclxxFzNz4U40lY++3KS4LpFCBUn+bfaVoXoMsGg0jFzvCGz5Ya
         L9I9MKi2k/yDbWmJljQpzctgxvcpDDIOOgRUpxxd66YU5WhbOe9QQ3QwsBNLUBDodK
         /mzLe/zR3mp9A==
Message-ID: <d3eb1d37-fcbc-e3d7-30d4-3e97aa20696b@kernel.org>
Date:   Sun, 27 Nov 2022 12:39:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 1/2] udp_tunnel: Add checks for nla_nest_start() in
 __udp_tunnel_nic_dump_write()
Content-Language: en-US
To:     Yuan Can <yuancan@huawei.com>, johannes@sipsolutions.net,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221126100634.106887-1-yuancan@huawei.com>
 <20221126100634.106887-2-yuancan@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221126100634.106887-2-yuancan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/22 3:06 AM, Yuan Can wrote:
> As the nla_nest_start() may fail with NULL returned, the return value needs
> to be checked.
> 
> Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  net/ipv4/udp_tunnel_nic.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
> index bc3a043a5d5c..75a0caa4aebe 100644
> --- a/net/ipv4/udp_tunnel_nic.c
> +++ b/net/ipv4/udp_tunnel_nic.c
> @@ -624,6 +624,8 @@ __udp_tunnel_nic_dump_write(struct net_device *dev, unsigned int table,
>  			continue;
>  
>  		nest = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
> +		if (!nest)
> +			goto err_cancel;

no need to call nla_nest_cancel if nest_start fails.

>  
>  		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
>  				 utn->entries[table][j].port) ||

