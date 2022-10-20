Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07A46063E8
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJTPLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJTPLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:11:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BE51A045D;
        Thu, 20 Oct 2022 08:11:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A00F561BDF;
        Thu, 20 Oct 2022 15:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59ECCC433C1;
        Thu, 20 Oct 2022 15:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666278675;
        bh=9tJciRsKBhYoViFTQp4Jzyo6krWJs9KAQXG4IOS7utk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aibgDG8H1jmvy/0hGWGi9jBcH831JbtU5ipO+SdQWABxiVnWt70Or5gaA9y1XuFKq
         HyXxvJjo8poBaZd2GZv+K3o+dvvHpgoRtf6Yg1tgf5+qDRjdN7CDuj1dQXYxqX4Dsa
         5EX4SdCNEfQFny8EFXKVsSYW/UIuNN5uvuLAUNz10vgp9zaVW4YAsldw4yzp3wnUZK
         dxbTs22eCRnmzbn78ye4IH9agTOSh0OvWArwRogj7ozQMGxKZH9k2VuW2wkarABKxx
         ESlouU94E1riDmXadO1iPCHBUqiYVkMUxXeslfo3kAViGKokhdk8nQtcKukOmcd8jl
         khRV9DVqIsiAw==
Date:   Thu, 20 Oct 2022 08:11:12 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] wifi: rtl8xxxu: Fix reads of uninitialized
 variables hw_ctrl_s1, sw_ctrl_s1
Message-ID: <Y1FlEABysKCjobzu@thelio-3990X>
References: <20221020135709.1549086-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020135709.1549086-1-colin.i.king@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 02:57:09PM +0100, Colin Ian King wrote:
> Variables hw_ctrl_s1 and sw_ctrl_s1 are not being initialized and
> potentially can contain any garbage value. Currently there is an if
> statement that sets one or the other of these variables, followed
> by an if statement that checks if any of these variables have been
> set to a non-zero value. In the case where they may contain
> uninitialized non-zero values, the latter if statement may be
> taken as true when it was not expected to.
> 
> Fix this by ensuring hw_ctrl_s1 and sw_ctrl_s1 are initialized.
> 
> Cleans up clang warning:
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:7: warning:
> variable 'hw_ctrl_s1' is used uninitialized whenever 'if' condition is
> false [-Wsometimes-uninitialized]
>                 if (hw_ctrl) {
>                     ^~~~~~~
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:440:7: note: uninitialized
> use occurs here
>                 if (hw_ctrl_s1 || sw_ctrl_s1) {
>                     ^~~~~~~~~~
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:3: note: remove the 'if'
> if its condition is always true
>                 if (hw_ctrl) {
>                 ^~~~~~~~~~~~~
> 
> Fixes: c888183b21f3 ("wifi: rtl8xxxu: Support new chip RTL8188FU")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

I was getting ready to send a similar patch.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
> index 99610bb2afd5..0025bb32538d 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
> @@ -412,7 +412,7 @@ static void rtl8188f_spur_calibration(struct rtl8xxxu_priv *priv, u8 channel)
>  	};
>  
>  	const u8 threshold = 0x16;
> -	bool do_notch, hw_ctrl, sw_ctrl, hw_ctrl_s1, sw_ctrl_s1;
> +	bool do_notch, hw_ctrl, sw_ctrl, hw_ctrl_s1 = 0, sw_ctrl_s1 = 0;
>  	u32 val32, initial_gain, reg948;
>  
>  	val32 = rtl8xxxu_read32(priv, REG_OFDM0_RX_D_SYNC_PATH);
> -- 
> 2.37.3
> 
> 
