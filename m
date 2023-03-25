Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304776C8A24
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjCYCKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjCYCKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E80E15577;
        Fri, 24 Mar 2023 19:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09089B82661;
        Sat, 25 Mar 2023 02:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0F2DC433EF;
        Sat, 25 Mar 2023 02:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679710217;
        bh=LuNYj1EqVPg7MtM0L5VBp1l9g/DSZFniixqdUVZdXbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X0WRsZBQfomA8fsx2D+pKRb+ubhfiBE1Z2bwMbQ7s9QeGsd/NfrjQhbHkjZeEkCB1
         yv4Tb1Ne5PT7CNNkEkzX7q7StIISlp5slhwlQJCvF0VqmNwsiTb1wY+qMhEDK+URiw
         o+RImi5mfLg2enEnlvIhqi/PCz5m1U4+cd1Oj4KZ7MQ3QCsb6DnOD0wpywGByQaM0W
         iB/CZBsZ/P5oG6i9LF4gCvzQQCVAyQicMns7rzFLs/6UIdpQ6p2Cr50xdDzmNowFtj
         U1mcz2l8NyU+DKAjv01lBSwMqrH+JqkrbB0vH2c35Ge4bEayj0yyBZRiMXI2j4bHrp
         0m4GjiTVxRrsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A23B0C41612;
        Sat, 25 Mar 2023 02:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: dsa: realtek: fix out-of-bounds access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167971021766.17146.5805572858718496946.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Mar 2023 02:10:17 +0000
References: <20230323103735.2331786-1-a.fatoum@pengutronix.de>
In-Reply-To: <20230323103735.2331786-1-a.fatoum@pengutronix.de>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com, luizluca@gmail.com,
        davem@davemloft.net, kernel@pengutronix.de, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 11:37:35 +0100 you wrote:
> The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
> with the expectation that priv has enough trailing space.
> 
> However, only realtek-smi actually allocated this chip_data space.
> Do likewise in realtek-mdio to fix out-of-bounds accesses.
> 
> These accesses likely went unnoticed so far, because of an (unused)
> buf[4096] member in struct realtek_priv, which caused kmalloc to
> round up the allocated buffer to a big enough size, so nothing of
> value was overwritten. With a different allocator (like in the barebox
> bootloader port of the driver) or with KASAN, the memory corruption
> becomes quickly apparent.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: realtek: fix out-of-bounds access
    https://git.kernel.org/netdev/net/c/b93eb5648693

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


