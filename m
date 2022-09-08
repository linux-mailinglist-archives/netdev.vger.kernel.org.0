Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462475B1873
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiIHJVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiIHJUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DB5D2B20;
        Thu,  8 Sep 2022 02:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F7AC61C0D;
        Thu,  8 Sep 2022 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D90D6C433D7;
        Thu,  8 Sep 2022 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662628817;
        bh=FUvuGhqZtmaM2z20lSw7K2UwexslQelsC6q//ijWWVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MBi9LL0eCxKQDfD4wK2GuZz3o8nYgCHQPaEuKM6z+NzY3mOMJXDqtm3H+pw1Nqkz6
         X6qwa0CKOQNGIxs9ac7W9+qnotSlvROc4Mp+g95WwUCRe5nQf0erFI2iBCDQhWOiEZ
         meibrtXUre+pox3t2YvqRwSzn7+tI6pF5xn/QF46sgs5UJFDtgPTf6n4kaGS///dOv
         wFAGFZ4MRPOnSt06WcBko5Nwyga6l5LnisX0P/Qnj7Gi0rzKxQ0QUFfkKPf2Qr3YPx
         jJLeuf83Ht/LHXg/+tBPyA3oVobvKz5YCRsRuunmMiNgGr9QKY2nfqQrC41FIigNcY
         FYJ1lMujhzVhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE471C73FED;
        Thu,  8 Sep 2022 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v2] net: phy: lan87xx: change interrupt src of link_up to
 comm_ready
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166262881770.11432.13226560643030582200.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Sep 2022 09:20:17 +0000
References: <20220905152750.5079-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220905152750.5079-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        prasanna.vengateshan@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 5 Sep 2022 20:57:50 +0530 you wrote:
> Currently phy link up/down interrupt is enabled using the
> LAN87xx_INTERRUPT_MASK register. In the lan87xx_read_status function,
> phy link is determined using the T1_MODE_STAT_REG register comm_ready bit.
> comm_ready bit is set using the loc_rcvr_status & rem_rcvr_status.
> Whenever the phy link is up, LAN87xx_INTERRUPT_SOURCE link_up bit is set
> first but comm_ready bit takes some time to set based on local and
> remote receiver status.
> As per the current implementation, interrupt is triggered using link_up
> but the comm_ready bit is still cleared in the read_status function. So,
> link is always down.  Initially tested with the shared interrupt
> mechanism with switch and internal phy which is working, but after
> implementing interrupt controller it is not working.
> It can fixed either by updating the read_status function to read from
> LAN87XX_INTERRUPT_SOURCE register or enable the interrupt mask for
> comm_ready bit. But the validation team recommends the use of comm_ready
> for link detection.
> This patch fixes by enabling the comm_ready bit for link_up in the
> LAN87XX_INTERRUPT_MASK_2 register (MISC Bank) and link_down in
> LAN87xx_INTERRUPT_MASK register.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: phy: lan87xx: change interrupt src of link_up to comm_ready
    https://git.kernel.org/netdev/net/c/5382033a3522

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


