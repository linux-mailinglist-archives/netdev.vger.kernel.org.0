Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC11356B8F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 13:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbhDGLxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 07:53:49 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:39317 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238613AbhDGLxl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 07:53:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617796412; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ftOQviE1FSzzRGWmikfFzO6yxTTkoqf8WYw+BHbHQdY=; b=xBN4vUrabMc9cTlEyGWRhE8Q5XKyYRY70P1Ks0CD7j8P7QZ2j/ZxhWWUcr/yFtrUFJU+YARu
 n79jA21eEjUolDtDSCfalt3nYwTQay4xtD1dOgRf4hjZNp/2M1HtZ/0Ral3ssTA27BVQ1Xrs
 whj5AUPiBpME4m95MEe9eeJ5Hq8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 606d9d3187ce1fbb56dc0491 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 07 Apr 2021 11:53:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB861C43465; Wed,  7 Apr 2021 11:53:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12D51C433C6;
        Wed,  7 Apr 2021 11:53:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 12D51C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Jouni Malinen <j@w1.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hostap: Fix memleak in prism2_config
References: <20210329085246.24586-1-dinghao.liu@zju.edu.cn>
Date:   Wed, 07 Apr 2021 14:53:15 +0300
In-Reply-To: <20210329085246.24586-1-dinghao.liu@zju.edu.cn> (Dinghao Liu's
        message of "Mon, 29 Mar 2021 16:52:43 +0800")
Message-ID: <87tuoimhuc.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dinghao Liu <dinghao.liu@zju.edu.cn> writes:

> When prism2_hw_config() fails, we just return an error code
> without any resource release, which may lead to memleak.
>
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/net/wireless/intersil/hostap/hostap_cs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/intersil/hostap/hostap_cs.c b/drivers/net/wireless/intersil/hostap/hostap_cs.c
> index ec7db2badc40..7dc16ab50ad6 100644
> --- a/drivers/net/wireless/intersil/hostap/hostap_cs.c
> +++ b/drivers/net/wireless/intersil/hostap/hostap_cs.c
> @@ -536,10 +536,10 @@ static int prism2_config(struct pcmcia_device *link)
>  	sandisk_enable_wireless(dev);
>  
>  	ret = prism2_hw_config(dev, 1);
> -	if (!ret)
> -		ret = hostap_hw_ready(dev);
> +	if (ret)
> +		goto failed;
>  
> -	return ret;
> +	return hostap_hw_ready(dev);;

Two semicolons.

But I'm not sure about this, can someone provide a Reviewed-by tag?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
