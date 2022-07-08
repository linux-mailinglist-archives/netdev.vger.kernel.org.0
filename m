Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81CB56B8F7
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238028AbiGHLuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiGHLuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482C4951E5;
        Fri,  8 Jul 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A896257A;
        Fri,  8 Jul 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D8A4C341CE;
        Fri,  8 Jul 2022 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657281016;
        bh=t7s6ZZjOAsKc3zrk/Tqh5VGlKgGyBf3FzczzUzgjL1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V2B7OoMm53sCCJvhLVkSVIunqCbe0fuAUmAw3+I3FCOPLSsbh4+OQ2gPJ6l2S1hCi
         NlmjVGYsE7aoFQPi5yMAdlabr5lQlipBLL/z1ZEFjI6vN0EEDkhcG62aMAflbj3cDw
         szKZE/BGPhrLVyVxOkce1XiFpFvG8Yit7VGBA+UR1yYpGDKfSOWp0qlAvi0WLb3jgA
         WLEQTS715yY8+SxJXosRLOhTR2SMvJUBOZgiLw/UyOOJLS9Gy+Lqmu54BH1NFd4edO
         VcJUZyWRiCpscfmLUpf3xNgVpruL9vAJREbAALDtN79vQatPpm59YOmUmxzfWl8eOn
         kzcqN/2k9pUEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2282BE45BDB;
        Fri,  8 Jul 2022 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] l2tp: l2tp_debugfs: fix Clang -Wformat warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165728101613.21070.5807408911077077330.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 11:50:16 +0000
References: <20220707221456.1782048-1-justinstitt@google.com>
In-Reply-To: <20220707221456.1782048-1-justinstitt@google.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, tparkin@katalix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Jul 2022 15:14:56 -0700 you wrote:
> When building with Clang we encounter the following warnings:
> | net/l2tp/l2tp_debugfs.c:187:40: error: format specifies type 'unsigned
> | short' but the argument has type 'u32' (aka 'unsigned int')
> | [-Werror,-Wformat] seq_printf(m, "   nr %hu, ns %hu\n", session->nr,
> | session->ns);
> -
> | net/l2tp/l2tp_debugfs.c:196:32: error: format specifies type 'unsigned
> | short' but the argument has type 'int' [-Werror,-Wformat]
> | session->l2specific_type, l2tp_get_l2specific_len(session));
> -
> | net/l2tp/l2tp_debugfs.c:219:6: error: format specifies type 'unsigned
> | short' but the argument has type 'u32' (aka 'unsigned int')
> | [-Werror,-Wformat] session->nr, session->ns,
> 
> [...]

Here is the summary with links:
  - l2tp: l2tp_debugfs: fix Clang -Wformat warnings
    https://git.kernel.org/netdev/net-next/c/9d899dbe2301

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


