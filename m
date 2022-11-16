Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BDF62B691
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiKPJcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiKPJcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:32:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062E212AA7;
        Wed, 16 Nov 2022 01:32:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDA74B81C56;
        Wed, 16 Nov 2022 09:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B2EC433D7;
        Wed, 16 Nov 2022 09:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668591134;
        bh=gTs3K9d/PdhPyra4juo+80Yt54DsbmGjg8a5VaaNvbQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YuOZEXxK4NdTpbnxVCqSw6gEPxF0wD86605uSrIsXL1v/gaJnTEfq5JmCqG1ziR03
         cbjL+i3Of/KqFIaHnEfgiA7CIab7kuRyFXUrQuqdYvSzhZ2QmwHcFhxAV3o/UvGkOj
         RhoyqLr6MeDOVHTp8/mjDsUo7eoeRKYkdOG5WR9DrXJww0zs+9h5EmMFXJUG063CYQ
         ylz/KhlhSzZWo9PIVvn/y20Tc9kP5rQBycp+yivCdzrRbyEF96Hm085epEyOANraOu
         WGPKeAJbPa/M1vCfNTzOjQA4dkrXYn2RHHRBpQnigxIPXXoEb3VkfN3Wbsaz/8KuWb
         VBqpwe3/r3Zmw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/7] wifi: orinoco: Avoid clashing function prototypes
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <e564003608a1f2ad86283370ef816805c92b30f6.1667934775.git.gustavoars@kernel.org>
References: <e564003608a1f2ad86283370ef816805c92b30f6.1667934775.git.gustavoars@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166859113003.16887.7125863875259889843.kvalo@kernel.org>
Date:   Wed, 16 Nov 2022 09:32:11 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> When built with Control Flow Integrity, function prototypes between
> caller and function declaration must match. These mismatches are visible
> at compile time with the new -Wcast-function-type-strict in Clang[1].
> 
> Fix a total of 43 warnings like these:
> 
> drivers/net/wireless/intersil/orinoco/wext.c:1379:27: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, struct iw_param *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
>         IW_HANDLER(SIOCGIWPOWER,        (iw_handler)orinoco_ioctl_getpower),
>                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The orinoco Wireless Extension handler callbacks (iw_handler) use a
> union for the data argument. Actually use the union and perform explicit
> member selection in the function body instead of having a function
> prototype mismatch. No significant binary differences were seen
> before/after changes.
> 
> These changes were made partly manually and partly with the help of
> Coccinelle.
> 
> Link: https://github.com/KSPP/linux/issues/234
> Link: https://reviews.llvm.org/D134831 [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

5 patches applied to wireless-next.git, thanks.

2c0e077db65a wifi: orinoco: Avoid clashing function prototypes
02ae6a7034d7 wifi: cfg80211: Avoid clashing function prototypes
fd7ef879a983 wifi: hostap: Avoid clashing function prototypes
ff7efc66b7ea wifi: zd1201: Avoid clashing function prototypes
89e706459848 wifi: airo: Avoid clashing function prototypes

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/e564003608a1f2ad86283370ef816805c92b30f6.1667934775.git.gustavoars@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

