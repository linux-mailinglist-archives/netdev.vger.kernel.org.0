Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA465BA887
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiIPIs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiIPIsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:48:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD50A830A;
        Fri, 16 Sep 2022 01:48:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 519A2B82480;
        Fri, 16 Sep 2022 08:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88401C433D7;
        Fri, 16 Sep 2022 08:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663318128;
        bh=8tc89q940ibLYEMk2eysbYWfLIggnNtafg4NSlVuf4w=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=V6SlSvaPfTpL+OVqXeXsfefFXLIrBEuprVzNTY9m7ldGMfttZe+WNmhepCeisUmkk
         FcKdd2Sv46tGR3IaGZs5AQn2qSEc9mf6FyYR9QblmE1m6A/4xGFWC7b1Wjivoc8kqM
         hHGaAhq/mPNY0l0zWvZckCfVuHbD+j+nFFuAqGAYefXm/aeivOYV21iULzi6zsGq11
         OU5En5lsqcm9kIHJjzK1r/9HvOgIKGn9Skjadm8Nsfajv4zF3WawPQPOf29OYfnrSz
         72Nx+Z2qeVs+nu98tMwGh5nQRtc9kAetxd2gNKD9naq4Vo5DRAWR/lTJG8hx27ilIS
         9VAoJDoHIhn4A==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     chunkeey@googlemail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] carl9170: use strscpy() is more robust and safer
In-Reply-To: <20220916063047.155021-1-chi.minghao@zte.com.cn> (cgel zte's
        message of "Fri, 16 Sep 2022 06:30:47 +0000")
References: <20220916063047.155021-1-chi.minghao@zte.com.cn>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 16 Sep 2022 11:48:42 +0300
Message-ID: <87k0637lhx.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Minghao Chi <chi.minghao@zte.com.cn>
>
> The implementation of strscpy() is more robust and safer.
>
> That's now the recommended way to copy NUL terminated strings.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---
>  drivers/net/wireless/ath/carl9170/fw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
> index 1ab09e1c9ec5..4c1aecd1163c 100644
> --- a/drivers/net/wireless/ath/carl9170/fw.c
> +++ b/drivers/net/wireless/ath/carl9170/fw.c
> @@ -105,7 +105,7 @@ static void carl9170_fw_info(struct ar9170 *ar)
>  			 CARL9170FW_GET_MONTH(fw_date),
>  			 CARL9170FW_GET_DAY(fw_date));
>  
> -		strlcpy(ar->hw->wiphy->fw_version, motd_desc->release,
> +		strscpy(ar->hw->wiphy->fw_version, motd_desc->release,
>  			sizeof(ar->hw->wiphy->fw_version));

Already changed in:

https://git.kernel.org/netdev/net-next/c/bf99f11df4de

Please use latest trees to avoid duplicate work.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
