Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A33A0613
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhFHVfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbhFHVfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:35:36 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656C8C061574;
        Tue,  8 Jun 2021 14:33:43 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4G03QB4MylzQk73;
        Tue,  8 Jun 2021 23:33:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1623188016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fSz0m9sPraTKMTobrCNgkrd/L6fxdcYg957KRk67d7E=;
        b=OPlIvgtJPoNGUNB+gv9VjjjPHWnzOKNOQB0M+ydjt6mcLVSPDz5jvS6JnTM6uKZv7ADMZX
        GXa/dj9WLC9sS0memtYy6VlMrAWQ2+AiUcTEE7XkyvdXBf3m3H1za4untJTnrvv8g8z7Z1
        uE5O1PGp3vg56hZF/dzMEZ8/lt/94H4rRgiobb5JmD48m1f+3LgvYwzg6tKbdHXU/eIE7s
        DD+hKK/2oGjrcMDhZHpt36YXfJMEW4uIfeWiqhX+L9VLfB0LMmwhiuP6CcNYvQ7JrLQgAN
        EypAWT744ewduY8JgQSWy5DIP1i6ewugimbsfRkFQdqDZoHJxxdHp4p/ZjQFfQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id W8K3dG3pOehM; Tue,  8 Jun 2021 23:33:35 +0200 (CEST)
Subject: Re: [PATCH net] net: lantiq: disable interrupt before sheduling NAPI
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210608212107.222690-1-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <c951fd28-443e-9445-0be3-b134c888f4dc@hauke-m.de>
Date:   Tue, 8 Jun 2021 23:33:34 +0200
MIME-Version: 1.0
In-Reply-To: <20210608212107.222690-1-olek2@wp.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 8F21B1857
X-Rspamd-UID: 9c61b0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/21 11:21 PM, Aleksander Jan Bajkowski wrote:
> This patch fixes TX hangs with threaded NAPI enabled. The scheduled
> NAPI seems to be executed in parallel with the interrupt on second
> thread. Sometimes it happens that ltq_dma_disable_irq() is executed
> after xrx200_tx_housekeeping(). The symptom is that TX interrupts
> are disabled in the DMA controller. As a result, the TX hangs after
> a few seconds of the iperf test. Scheduling NAPI after disabling
> interrupts fixes this issue.
> 
> Tested on Lantiq xRX200 (BT Home Hub 5A).
> 
> Fixes: 9423361da523 ("net: lantiq: Disable IRQs only if NAPI gets scheduled ")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>   drivers/net/ethernet/lantiq_xrx200.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index 36dc3e5f6218..0e10d8aeffe1 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -352,8 +352,8 @@ static irqreturn_t xrx200_dma_irq(int irq, void *ptr)
>   	struct xrx200_chan *ch = ptr;
>   
>   	if (napi_schedule_prep(&ch->napi)) {
> -		__napi_schedule(&ch->napi);
>   		ltq_dma_disable_irq(&ch->dma);
> +		__napi_schedule(&ch->napi);
>   	}
>   
>   	ltq_dma_ack_irq(&ch->dma);
> 

