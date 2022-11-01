Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDFD6146E1
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiKAJiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiKAJiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:38:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E17F1B1DB;
        Tue,  1 Nov 2022 02:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4D0961552;
        Tue,  1 Nov 2022 09:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D667C43470;
        Tue,  1 Nov 2022 09:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667295382;
        bh=g33U7xA0K22xKmt+wrUahIeZScTw24v+60/5Vp+UUpA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MtlZH/biXGj9c2yyviamR6q25nQqoOp+Uew5Me+Zg43zO+UQm7z7ohQexO5Kz9lt1
         WOo4ayIvTG/niq+rtN9RtAkdKcUl/BhPAvyZBVfeilFO8GETmGY+mKTWxAvvvw1qwu
         qjHS3U2tbBGyeRtTg6arXLA1b6rqjs/CsgY7MRq//+ZUXfmQ2CBSqUYNWUcfyI7Apt
         wIFJwdg0W6UzBsEkzZjUvp1gLNRkqZMXJVf4k6aGhVDXq1K5vZDDwFXVjvN2MRK9UQ
         opHB+3Y1LQyzNrjCspg1vvcrLNQ0rQ1lO+vJBviqXeuK7OxMqsHhY96ofZO5Wd9AYd
         SXP0DPpoRFxdA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/6] hostap: Avoid clashing function prototypes
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <8388b5ed9e729eb9dadec875a7576219e6d61223.1666894751.git.gustavoars@kernel.org>
References: <8388b5ed9e729eb9dadec875a7576219e6d61223.1666894751.git.gustavoars@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jouni Malinen <j@w1.fi>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166729537521.21401.10713096825251730903.kvalo@kernel.org>
Date:   Tue,  1 Nov 2022 09:36:19 +0000 (UTC)
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Fix a total of 42 warnings like these:
> 
> ../drivers/net/wireless/intersil/hostap/hostap_ioctl.c:3868:2: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, char *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
>         (iw_handler) prism2_get_name,                   /* SIOCGIWNAME */
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The hostap Wireless Extension handler callbacks (iw_handler) use a
> union for the data argument. Actually use the union and perform explicit
> member selection in the function body instead of having a function
> prototype mismatch. There are no resulting binary differences
> before/after changes.
> 
> Link: https://github.com/KSPP/linux/issues/235
> Link: https://reviews.llvm.org/D134831 [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Please add "wifi: " to all wireless patches, for example this one should be:

wifi: hostap: Avoid clashing function prototypes

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/8388b5ed9e729eb9dadec875a7576219e6d61223.1666894751.git.gustavoars@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

