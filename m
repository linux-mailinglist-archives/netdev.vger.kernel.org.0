Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFEA606F2C
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJUFJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJUFJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:09:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE5C3A4B3;
        Thu, 20 Oct 2022 22:09:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D55FCE2800;
        Fri, 21 Oct 2022 05:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1AAC433C1;
        Fri, 21 Oct 2022 05:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666328975;
        bh=IMGy1JEt2HVE4gKYtafGewyM6r1bYKdalhrSjASTyfo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=g0DDgEeQjnRi75qQiQYcmWrXptukGgIdf8FsEjJD84v6n6uPIqP90eYBHMlBWVh83
         7/8B7tvWbwkvV74AdWaplGbH2AjcQpA7+HQlRMUJeRtVk1grfPJNQzX9lvpdO1KZ6n
         djScNp5+0erm4MR7a6RRKovc95TttUhgyaPoSMyqGfsVxLcXfORfuSOwTOTq4SHPFl
         Y3C4dFbf+/NlI0Pf6w4RPi3VSzKrEq8LBai8CjTIKAC7qRhrLJ8UFEBSpxu/yNuK99
         mRsyKX51FueCsaT3nlydvDRPYH5s6tagdiaGPxLoFC+AsdyEPm4TsYNZBJYqni3UEA
         w4JSbDiTHQKlw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] wifi: rtl8xxxu: Fix reads of uninitialized variables hw_ctrl_s1, sw_ctrl_s1
References: <20221020135709.1549086-1-colin.i.king@gmail.com>
Date:   Fri, 21 Oct 2022 08:09:27 +0300
In-Reply-To: <20221020135709.1549086-1-colin.i.king@gmail.com> (Colin Ian
        King's message of "Thu, 20 Oct 2022 14:57:09 +0100")
Message-ID: <87ilkdlq48.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> writes:

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

I'll queue this to v6.1.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
