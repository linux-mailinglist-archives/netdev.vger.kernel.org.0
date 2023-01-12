Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD7C666ABF
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbjALFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbjALFUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2AE485B2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AF83B81DD2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 067E0C433F1;
        Thu, 12 Jan 2023 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673500817;
        bh=oThfUK8Q7Plbg6tMmhzTwLyQlx96EKOEqVFXXwL0hCk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XcOjOFdbJF1ZT2l9plEQARxQurcU//V6Ix16UjnIgxa6K00nn0wdIL4IuERraVdUO
         UqYbKHXTjDe3tQTP51sv2etspQ8prTWBLvIQRZlXVAyl/rBD5e5xJRCY1w5MVKJgrs
         dAIvsJentCF0mFGCkQhfc1iPyWNCvzEmfMp7VW1l4USRjIlR4z0qGWUUCssEJ4vNCN
         963vh7dEk6IoiU59J0YT/6yM4Iqtm9JxoWUYU933vipfbCNkJygYLwTFA6pk0z+aES
         I2UttVsftwkHvWnGQeB1gDuqKUf3AC3Y+9emtKJtzIt20MYeTvaGma5mNkFKBr0KLl
         6XAPmHHsiwRPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2479C395D9;
        Thu, 12 Jan 2023 05:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: ethernet: mtk_wed: get rid of queue lock for
 rx queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167350081692.21073.12325913693099285748.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 05:20:16 +0000
References: <36ec3b729542ea60898471d890796f745479ba32.1673342990.git.lorenzo@kernel.org>
In-Reply-To: <36ec3b729542ea60898471d890796f745479ba32.1673342990.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org, alexanderduyck@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 Jan 2023 10:31:26 +0100 you wrote:
> Queue spinlock is currently held in mtk_wed_wo_queue_rx_clean and
> mtk_wed_wo_queue_refill routines for MTK Wireless Ethernet Dispatcher
> MCU rx queue. mtk_wed_wo_queue_refill() is running during initialization
> and in rx tasklet while mtk_wed_wo_queue_rx_clean() is running in
> mtk_wed_wo_hw_deinit() during hw de-init phase after rx tasklet has been
> disabled. Since mtk_wed_wo_queue_rx_clean and mtk_wed_wo_queue_refill
> routines can't run concurrently get rid of spinlock for mcu rx queue.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: ethernet: mtk_wed: get rid of queue lock for rx queue
    https://git.kernel.org/netdev/net-next/c/d4f12a8271fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


