Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C4F5ABD04
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiICEaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiICEaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE0F402CA
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 21:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26EFCB82E4F
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 04:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5ABDC433D7;
        Sat,  3 Sep 2022 04:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662179418;
        bh=znfy1MwVQ4oR5OwBIjFWY47tTDWxcGU1Su14/E6QAa8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ee4n6CbzyMbUwurvOr0RwG6+hFesOqZn5Xley+hfwUpIw6txI3JKJ0lNJie2+bgWG
         10izchi7QTlovWQu9cQcOf5AGxLiD6QZlWSVDoIUDnVsofiI9HkUHgj18xly++95t7
         coqQboJP9nRRkHZ6991KIZHQzUldyTk2P2QefuhvSJPVa0oCkI8j8pkoDfBXJE49sa
         F8VKU9PmJCik3pTKfncEVb45CCzBXpPqAoltTP9uB7pPZtZbuO1ijACbZpVpOca7E5
         k7R2oJKeXzgyR900yjgwNLKd1pr5AHEs33mOtaCSrlvBb/LNaImx+sCMlt8eorBkIb
         n/QkLL4R5QWuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9864E924D9;
        Sat,  3 Sep 2022 04:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217941868.8630.12397808960218340130.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 04:30:18 +0000
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
In-Reply-To: <20220901140402.64804-1-csokas.bence@prolan.hu>
To:     =?utf-8?b?Q3PDs2vDoXMgQmVuY2UgPGNzb2thcy5iZW5jZUBwcm9sYW4uaHU+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        francesco.dolcini@toradex.com, andrew@lunn.ch,
        kernel@pengutronix.de, mkl@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 1 Sep 2022 16:04:03 +0200 you wrote:
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `tmreg_lock` fixes this.
> 
> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> 
> [...]

Here is the summary with links:
  - [v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
    https://git.kernel.org/netdev/net/c/b353b241f1eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


