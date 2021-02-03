Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A45130D090
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhBCA5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:57:41 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:13301 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232238AbhBCA5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 19:57:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612313833; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=tkAMhePMIBfSciTVX2iHxu9d+dvo6x/40klzGYc4UHE=;
 b=acyiz4ddF4BJ+8iKHUJaHsA0jdmXmHLW1FdhdSr/h1Ca6CuYIGe6Yksmatzb9GK/MPNQAvkR
 xjU0POlW68EB+qvL5Qey5f5wXgAvDdiqdvF9nzgDHS0JVF6BRVMTJnMw15CX2b6z2gOdECZO
 tr+22ALEfpMXya1MEVVPHCyHq6E=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6019f4e87a21b36a9d924ec1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Feb 2021 00:57:12
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 179C9C43462; Wed,  3 Feb 2021 00:57:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5088BC433CA;
        Wed,  3 Feb 2021 00:57:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Feb 2021 17:57:10 -0700
From:   subashab@codeaurora.org
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org
Subject: Re: [PATCH net-next v2 2/2] net: qualcomm: rmnet: Fix rx_handler for
 non-linear skbs
In-Reply-To: <1612282568-14094-2-git-send-email-loic.poulain@linaro.org>
References: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org>
 <1612282568-14094-2-git-send-email-loic.poulain@linaro.org>
Message-ID: <f6d99c2c648337be7a00dbafb66fe6cd@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-02 09:16, Loic Poulain wrote:
> There is no guarantee that rmnet rx_handler is only fed with linear
> skbs, but current rmnet implementation does not check that, leading
> to crash in case of non linear skbs processed as linear ones.
> 
> Fix that by ensuring skb linearization before processing.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: Add this patch to the series to prevent crash
> 
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> index 3d7d3ab..2776c32 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -180,7 +180,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff
> **pskb)
>  	struct rmnet_port *port;
>  	struct net_device *dev;
> 
> -	if (!skb)
> +	if (!skb || skb_linearize(skb))
>  		goto done;
> 
>  	if (skb->pkt_type == PACKET_LOOPBACK)

Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
