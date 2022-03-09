Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A6A4D2E20
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiCILeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiCILeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:34:25 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2544B1D2;
        Wed,  9 Mar 2022 03:33:23 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1646825602; bh=uhNr4TnutaVzv7hPR3sNvY7ptu+XNXJq03aDr0UTAEg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Sm/0YRBjqegVVoYdpertNJC6D92VOE7N88kkkSppqinLU4+uFwkmJkyLPqaou9EQ5
         OcM2bU7M4dd0K+ryIULBsfP4504OQlMvjJlslQTHmVM0MwTrQD29KlclflbE9a6MKl
         CN0h9bitj0+SKBoqG3e/22NZ+MVVwsU8j7yc3Ma46f56vpG5PlVPQYSqISw268oZtU
         J6t/NyuDutjmOFhic0X1TROn940G14I4S23bdR+qz+O2M37ltyC26cDDWj5y7Nycsm
         l3WVC3WXUSoIWJFQ9U+7kCxnQFOn/mO5NkNfXWS9Uj+62NxMY7sOcKPUjhFFqKqyPG
         NDTPeIitPeWeg==
To:     cgel.zte@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] ath9k: Use platform_get_irq() to get the interrupt
In-Reply-To: <20220309053521.2081129-1-chi.minghao@zte.com.cn>
References: <20220309053521.2081129-1-chi.minghao@zte.com.cn>
Date:   Wed, 09 Mar 2022 12:33:21 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <874k47webi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
>  drivers/net/wireless/ath/ath9k/ahb.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
> index cdefb8e2daf1..9cd12b20b18d 100644
> --- a/drivers/net/wireless/ath/ath9k/ahb.c
> +++ b/drivers/net/wireless/ath/ath9k/ahb.c
> @@ -98,13 +98,9 @@ static int ath_ahb_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	if (res == NULL) {
> -		dev_err(&pdev->dev, "no IRQ resource found\n");

Hmm, I think we should retain this dev_err() call on failure...

-Toke
