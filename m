Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BEB4D7AD3
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 07:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiCNGdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 02:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiCNGdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 02:33:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8661AD92;
        Sun, 13 Mar 2022 23:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D340B80D31;
        Mon, 14 Mar 2022 06:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FEFC340E9;
        Mon, 14 Mar 2022 06:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647239530;
        bh=uL2ISkbwNCyUtkHUNIck8aCPqkfUen/EsbzZstPNXaQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gbphCcZh0BddFZhU/5ZsOlHfQIzg7Tf551saRQDO2myvCkleQXf07pe/suNzTzdBg
         kKJD0wr9X5jSTCgAW2ym6DrGEy5870ihXtAqr4KJEPL6+upYBBv7V/cLC5WL6zlg4U
         2RuceMZllpZiXYD3NjvFD/XZe32ArOQmUtzziEk+VAJ1JnGdWK2kVtJz9ZgZVAy5ZX
         YAGlcelB2lf0J10guyynrMjNdn1ty1WCqYmAXkG/6v5zHAo2wCOhEM3WFjVvRVZeky
         3eoh2sWF5c89gxNpXn/Ztnp0nTK/KJRAhas6OMXT/73M7RrXsJdnjmOd819KktLppJ
         JzmR0RCj/Fknw==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     toke@toke.dk, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH V2] ath9k: Use platform_get_irq() to get the interrupt
References: <20220314062635.2113747-1-chi.minghao@zte.com.cn>
Date:   Mon, 14 Mar 2022 08:32:05 +0200
In-Reply-To: <20220314062635.2113747-1-chi.minghao@zte.com.cn> (cgel zte's
        message of "Mon, 14 Mar 2022 06:26:35 +0000")
Message-ID: <877d8xqc2i.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Minghao Chi <chi.minghao@zte.com.cn>
>
> It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
> for requesting IRQ's resources any more, as they can be not ready yet in
> case of DT-booting.
>
> platform_get_irq() instead is a recommended way for getting IRQ even if
> it was not retrieved earlier.
>
> It also makes code simpler because we're getting "int" value right away
> and no conversion from resource to int is required.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---
> v1->v2:
>   - Retain dev_err() call on failure
>
>  drivers/net/wireless/ath/ath9k/ahb.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
> index cdefb8e2daf1..28c45002c115 100644
> --- a/drivers/net/wireless/ath/ath9k/ahb.c
> +++ b/drivers/net/wireless/ath/ath9k/ahb.c
> @@ -98,14 +98,12 @@ static int ath_ahb_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	if (res == NULL) {
> +	irq = platform_get_resource(pdev, 0);

Is this really correct? Should it be platform_get_irq()?

Do you compile test your patches? That's mandatory.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
