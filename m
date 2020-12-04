Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB7A2CF670
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgLDV4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:56:50 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:43825 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbgLDV4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 16:56:50 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607118985; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=I5SlKBv0SkNfskI9GrrnMZNG4079rgC/Hn+iDRemQhI=;
 b=d6cu0LVJMx6YgVSApQYgvtpXinUvWXmZhBWYr5DB1RWJeFNpEt7wQF0d5k3RSruQOAMOBEr8
 LUWE2YxEfW1HRbAMUdzR4IQqlGvndrcj+B94BZq/HYuBQNJuFLuxbh9BmISVoEKneh27EZst
 E5bt0ls4y156F/hyynuFjxTp560=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fcab08708086a3dc7e9f268 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Dec 2020 21:56:23
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 27BEAC43462; Fri,  4 Dec 2020 21:56:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6C33CC433CA;
        Fri,  4 Dec 2020 21:56:22 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 04 Dec 2020 14:56:22 -0700
From:   subashab@codeaurora.org
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     stranche@codeaurora.org, netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH] net: rmnet: Adjust virtual device MTU on real device
 capability
In-Reply-To: <1607017240-10582-1-git-send-email-loic.poulain@linaro.org>
References: <1607017240-10582-1-git-send-email-loic.poulain@linaro.org>
Message-ID: <3a2ca2c269911de71df6dca2e981f7fe@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-03 10:40, Loic Poulain wrote:
> A submitted qmap/rmnet packet size can not be larger than the linked
> interface (real_dev) MTU. This patch ensures that the rmnet virtual
> iface MTU is configured according real device capability.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> index d58b51d..d1d7328 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> @@ -60,9 +60,14 @@ static netdev_tx_t rmnet_vnd_start_xmit(struct 
> sk_buff
> *skb,
> 
>  static int rmnet_vnd_change_mtu(struct net_device *rmnet_dev, int
> new_mtu)
>  {
> +	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
> +
>  	if (new_mtu < 0 || new_mtu > RMNET_MAX_PACKET_SIZE)
>  		return -EINVAL;
> 
> +	if (priv->real_dev && (new_mtu + RMNET_NEEDED_HEADROOM) >
> priv->real_dev->mtu)
> +		return -EINVAL;
> +
>  	rmnet_dev->mtu = new_mtu;
>  	return 0;
>  }
> @@ -242,6 +247,9 @@ int rmnet_vnd_newlink(u8 id, struct net_device
> *rmnet_dev,
> 
>  	priv->real_dev = real_dev;
> 
> +	/* Align default MTU with real_dev MTU */
> +	rmnet_vnd_change_mtu(rmnet_dev, real_dev->mtu -
> RMNET_NEEDED_HEADROOM);
> +
>  	rc = register_netdevice(rmnet_dev);
>  	if (!rc) {
>  		ep->egress_dev = rmnet_dev;

This would need similar checks in the NETDEV_PRECHANGEMTU
netdev notifier.
