Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F38E60775E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJUMza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiJUMz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:55:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8940210DE70;
        Fri, 21 Oct 2022 05:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC766B82B4C;
        Fri, 21 Oct 2022 12:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458E9C433C1;
        Fri, 21 Oct 2022 12:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666356924;
        bh=MI0KyCnRQ27+RGF2HuHJ1TVh1JIv76zKh0XFtp71vEw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IhD0yQCV5q+IYm1pzsYRX9vdRw4ppRnRjaDwZYzqQNyh4v1uGNrmJ5dHUAkDwZ90D
         ThCB0TPRNuwNwWBesx3QO37PbkdpAy/CzEL36IG0NjbC4NZyRrJ2dOOW1zga26uITM
         sJhWWBIJeVuLOT+XC7bD4DFJzw+35XnVSX5oU9BdIICHsU2tV8pGhSjyxf6aSXRKw4
         mQkysZ8oEcTjf9WWzkRFqUtVw9gQY7psYOYxrGg3bWQsZb76V3nqw+vROqekmxv6Ho
         dOjBfwfdyWCZZlusuOpmISl2XtM1pyCT+SVJcsNrtRB5kKZmOHYXDwVNyx1A3CcrQu
         +TG6vk16nHZag==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wifi: rtl8xxxu: Fix reads of uninitialized
 variables
 hw_ctrl_s1, sw_ctrl_s1
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221020135709.1549086-1-colin.i.king@gmail.com>
References: <20221020135709.1549086-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166635691805.25811.8540312447323133705.kvalo@kernel.org>
Date:   Fri, 21 Oct 2022 12:55:22 +0000 (UTC)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

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
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>

Patch applied to wireless-next.git, thanks.

80e5acb6dd72 wifi: rtl8xxxu: Fix reads of uninitialized variables hw_ctrl_s1, sw_ctrl_s1

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221020135709.1549086-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

