Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E2217D74F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 01:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgCIA2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 20:28:35 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:35265 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726354AbgCIA2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 20:28:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583713714; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Da5JPQ8waNhHJz7M7/xg0nq00tT0BWhg583a40BWJA0=;
 b=XqH8rQHIpn9zdyWlwHDdBbHS5UUZu5YuZ3ZNIX8TpVyYO8JK0C7cIjlfG/xW5eAHlmMHK3Jv
 9ne+I2VUQ0dyxOT4eee2afhtEjBRqISPZ9paqeRlgUWyjOfw+PVEsFexVx+EM4j+EQC/RI4S
 /xJYK8YKT2+ADTO/I/SPRz8CdTw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e658d9c.7f7bcf394a40-smtp-out-n05;
 Mon, 09 Mar 2020 00:28:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AF033C432C2; Mon,  9 Mar 2020 00:28:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3D9F8C433D2;
        Mon,  9 Mar 2020 00:28:11 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 08 Mar 2020 18:28:11 -0600
From:   subashab@codeaurora.org
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: rmnet: set NETIF_F_LLTX flag
In-Reply-To: <20200308134706.18727-1-ap420073@gmail.com>
References: <20200308134706.18727-1-ap420073@gmail.com>
Message-ID: <c3ae604f1bd130b3c753578aa89087cb@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-08 07:47, Taehee Yoo wrote:
> The rmnet_vnd_setup(), which is the callback of ->ndo_start_xmit() is
> allowed to call concurrently because it uses RCU protected data.
> So, it doesn't need tx lock.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> index d7c52e398e4a..d58b51d277f1 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> @@ -212,6 +212,8 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
>  	rmnet_dev->needs_free_netdev = true;
>  	rmnet_dev->ethtool_ops = &rmnet_ethtool_ops;
> 
> +	rmnet_dev->features |= NETIF_F_LLTX;
> +
>  	/* This perm addr will be used as interface identifier by IPv6 */
>  	rmnet_dev->addr_assign_type = NET_ADDR_RANDOM;
>  	eth_random_addr(rmnet_dev->perm_addr);

Hi Taehee

It seems the flag is deprecated per documentation.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/networking/netdevices.txt#n73
