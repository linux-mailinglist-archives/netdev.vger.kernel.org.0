Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0D5607558
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 12:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJUKs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 06:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJUKsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 06:48:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173F525F1F4;
        Fri, 21 Oct 2022 03:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B35AB82B95;
        Fri, 21 Oct 2022 10:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7943C433B5;
        Fri, 21 Oct 2022 10:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666349301;
        bh=Yl3qRQQpWdMPUbGxJERyNc/a/LusWFS2QJF+ezf+FSQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TgA9vbS6vmkee+djXhez8XsX6q6q1k2rY96M7LgzmPrdDZPi5mQ6jF/HZBcaB7ySU
         j8m64Y7onysoEui/gN8yxtcBzMLgXCrmYn6oRiTicigWyuHey2t6Auz21mRvYeqpS5
         fpN/oagLoQJJi25vqOB90BmrTDzvB8MJl+/zuRLSdckp2f1e+iemccjiKzuDF9/ylz
         rLREgmw9skT4GXZwRZSS3HUvqxq59RRVIjQGYf/7aEycG3OCnepfg1pF2lwqEkR/sO
         fKbdssWhwxeVuoQ/Ge0+keJL7SqL0oMs9a+yj0bntYMeqVElqeHoOz+zaOoD888Khx
         6QW13DEahU5hw==
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
        <87ilkdlq48.fsf@kernel.org>
Date:   Fri, 21 Oct 2022 13:48:11 +0300
In-Reply-To: <87ilkdlq48.fsf@kernel.org> (Kalle Valo's message of "Fri, 21 Oct
        2022 08:09:27 +0300")
Message-ID: <87bkq51mhg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Colin Ian King <colin.i.king@gmail.com> writes:
>
>> Variables hw_ctrl_s1 and sw_ctrl_s1 are not being initialized and
>> potentially can contain any garbage value. Currently there is an if
>> statement that sets one or the other of these variables, followed
>> by an if statement that checks if any of these variables have been
>> set to a non-zero value. In the case where they may contain
>> uninitialized non-zero values, the latter if statement may be
>> taken as true when it was not expected to.
>>
>> Fix this by ensuring hw_ctrl_s1 and sw_ctrl_s1 are initialized.
>>
>> Cleans up clang warning:
>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:7: warning:
>> variable 'hw_ctrl_s1' is used uninitialized whenever 'if' condition is
>> false [-Wsometimes-uninitialized]
>>                 if (hw_ctrl) {
>>                     ^~~~~~~
>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:440:7: note: uninitialized
>> use occurs here
>>                 if (hw_ctrl_s1 || sw_ctrl_s1) {
>>                     ^~~~~~~~~~
>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:3: note: remove the 'if'
>> if its condition is always true
>>                 if (hw_ctrl) {
>>                 ^~~~~~~~~~~~~
>>
>> Fixes: c888183b21f3 ("wifi: rtl8xxxu: Support new chip RTL8188FU")
>> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
>
> I'll queue this to v6.1.

Actually commit c888183b21f3 is in wireless-next so this patch should go
to wireless-next, for v6.2.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
