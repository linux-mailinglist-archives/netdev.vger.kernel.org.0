Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113095F5076
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 09:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiJEHvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 03:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiJEHvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 03:51:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAF35D11F;
        Wed,  5 Oct 2022 00:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 404A5B81B49;
        Wed,  5 Oct 2022 07:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14AAC433C1;
        Wed,  5 Oct 2022 07:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664956270;
        bh=aE9etRiOEVxYZXgsGYS0VimxiIbgJuJ/6jugX8sMxWU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DqV1X5GB+NH9fM/qMl7lhz2eeHtCoZETQS9jk092yvCkqxgMeVfIg/2EdYx+4ZHvJ
         lpbZZbs8LiR1VkWbqWSimeWK1tvqJdaEx8TMUoAC/DKJ17CQWjw5SWPWGR0JbpwRKp
         sP1UwPsvInN+I1cC9SfdfJW+Vp9vSqEzUQoXuLB3WyST/s+eiDnqxM6VftliIDX8Nl
         sGNFS47PiCFW4AicE8/GBti8Mk4m7o182b+0HIzqBTmEcj9VwuMYtbAMq8u4AihFJp
         k6esy8BbH+2bpSIeLeQM19pyOPGQYicfWZJRUyp2DgtNyPKFBSBQIVGZZx2H3R6bm8
         CXoSAcHGu+hUA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: atmel: Avoid clashing function prototypes
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221002032428.4091540-1-keescook@chromium.org>
References: <20221002032428.4091540-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Simon Kelley <simon@thekelleys.org.uk>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166495626187.5945.10399695218838618829.kvalo@kernel.org>
Date:   Wed,  5 Oct 2022 07:51:06 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> When built with Control Flow Integrity, function prototypes between
> caller and function declaration must match. These mismatches are visible
> at compile time with the new -Wcast-function-type-strict in Clang[1].
> 
> Of the 1549 warnings found, 188 come from the atmel driver. For example:
> 
> drivers/net/wireless/atmel/atmel.c:2518:2: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, void *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
>         (iw_handler) atmel_config_commit,       /* SIOCSIWCOMMIT */
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The atmel Wireless Extension handler callbacks (iw_handler) use a union
> for the data argument. Actually use the union and perform explicit
> member selection in the function body instead of having a function
> prototype mismatch. There are no resulting binary differences.
> 
> This patch is a cleanup based on Brad Spengler/PaX Team's modifications
> to the atmel driver in their last public patch of grsecurity/PaX based
> on my understanding of the code. Changes or omissions from the original
> code are mine and don't reflect the original grsecurity/PaX code.
> 
> [1] https://reviews.llvm.org/D134831
> 
> Cc: Simon Kelley <simon@thekelleys.org.uk>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

8af9d4068e86 wifi: atmel: Avoid clashing function prototypes

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221002032428.4091540-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

