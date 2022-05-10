Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE6521F26
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345945AbiEJPmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346524AbiEJPlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:41:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A5D1E3268;
        Tue, 10 May 2022 08:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3BAC6118C;
        Tue, 10 May 2022 15:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5D6C385C2;
        Tue, 10 May 2022 15:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197019;
        bh=xOvOmO4LHzDhTL1j0y0XP3wn2GNGaiwfVWhzZ9JGiS0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lBQPOBGi4cXhelaxU9z63kS/K4UheW9ikuiHI8yNsj485ecd034VXk7R6lnWXgMbb
         WlwXbeTIBFLSacERGvFC3Msn8N+KsDgIb2lfD73RJCkcEIlO3jYrQIDgI162nWdHhU
         rx/V65Ch1v1jSdDlGIefuQ4Ua/zmuYMAwKU3+mErYjCxHyNFQbwQLGjDUMPRfnkvux
         +zMe0BghH3lVSyBRiW+qSrYdAKOBl194LQd/Jv2XBefpxLvW7DqMeoeLhnJ0i9VmIM
         L/VFOQrGkeiz8QrH39q8Esfup+qH41wWyOlhKO6oOTneTlxOrmeqeh2mBlDF6H6vyw
         VE5vLIDj/HKCw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: rtlwifi: Use pr_warn_once instead of WARN_ONCE
In-Reply-To: <20220510092503.1546698-1-dzm91@hust.edu.cn> (Dongliang Mu's
        message of "Tue, 10 May 2022 17:25:03 +0800")
References: <20220510092503.1546698-1-dzm91@hust.edu.cn>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Tue, 10 May 2022 18:36:51 +0300
Message-ID: <87ee118kmk.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dongliang Mu <dzm91@hust.edu.cn> writes:

> From: Dongliang Mu <mudongliangabcd@gmail.com>
>
> This memory allocation failure can be triggered by fault injection or
> high pressure testing, resulting a WARN.
>
> Fix this by replacing WARN with pr_warn_once.
>
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
> index 86a236873254..acb0c15e9748 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
> @@ -1014,7 +1014,7 @@ int rtl_usb_probe(struct usb_interface *intf,
>  	hw = ieee80211_alloc_hw(sizeof(struct rtl_priv) +
>  				sizeof(struct rtl_usb_priv), &rtl_ops);
>  	if (!hw) {
> -		WARN_ONCE(true, "rtl_usb: ieee80211 alloc failed\n");
> +		pr_warn_once("rtl_usb: ieee80211 alloc failed\n");
>  		return -ENOMEM;
>  	}
>  	rtlpriv = hw->priv;

I think we should warn every time ieee80211_alloc_hw() fails, it's
called only once per device initialisation, so pr_warn() is more
approriate.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
