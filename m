Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D506E8382
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 23:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjDSVVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 17:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbjDSVVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 17:21:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26097AD35;
        Wed, 19 Apr 2023 14:21:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 867056306A;
        Wed, 19 Apr 2023 21:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3A8BC433D2;
        Wed, 19 Apr 2023 21:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681939218;
        bh=IZje+2r+GnRqX9Nu6Qa+XAyYOT6tBOuoqnWCr7UOMjE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r4LfYUKvfz9Z9fUzoVZtkNVrrxHe793IfAF2rgPvPdg1qc/V7N2EDPzCarj7gglQ8
         POimW8R3ACtXXIbILzlGRHxJ0ddXvApX7s5lWPXfOl/CZfXW5VF9Vj0o8ORNB7wf58
         KMrYn8wS7P6hAhhdQJSWcKROZHUhl9kDqU2UPt4oKr4Nwotp/6AxeAszdWR5PwIm2N
         rSn1yLANPmIR2WONurP693MHh00CF8C2nYzV0eADrruXvq89VDtZ5Bb/kCMlEky2lz
         J3zAqTdNC7yQxPKK42N88efOWtMQSpMXEgX64788fPSCraGWdwbHPMLkPzTR/NgrP8
         2mElmz372vHfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C61F3E4D033;
        Wed, 19 Apr 2023 21:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: microchip: ksz8795: Correctly handle huge frame
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168193921880.10989.3291332705872506866.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 21:20:18 +0000
References: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arun.ramadoss@microchip.com,
        linux@rempel-privat.de, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Apr 2023 20:19:33 +0200 you wrote:
> Because of the logic in place, SW_HUGE_PACKET can never be set.
> (If the first condition is true, then the 2nd one is also true, but is not
> executed)
> 
> Change the logic and update each bit individually.
> 
> Fixes: 29d1e85f45e0 ("net: dsa: microchip: ksz8: add MTU configuration support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: microchip: ksz8795: Correctly handle huge frame configuration
    https://git.kernel.org/netdev/net/c/3d2f8f1f184c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


