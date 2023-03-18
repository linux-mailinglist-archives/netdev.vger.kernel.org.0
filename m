Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590DD6BF80E
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjCRFkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCRFkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FD3233EE;
        Fri, 17 Mar 2023 22:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B179B826CF;
        Sat, 18 Mar 2023 05:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3399AC4339B;
        Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679118019;
        bh=gOxTeqwsh9Q8N0zoTLkkp+TmqCf2YsSs4985Ao1K28s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sxeoIF9oTi5wJxHvWKQhnFGyCKMVIr1mZRs0blBRnE/kSewNh39kT2iNr2kHGsPD/
         n8jDYwrd8sQWr3rWyPG6Y3Z7uqgOi376gg/5pXdcBRyu+5aPU0cJR5bej4qlN5TCNc
         2tSLGO+0c7j3CNCoZd3UZNWUYjBKCAN065dadFz1JVJIjqXp/Ql/tMriFX+TS28hjy
         Go8cQOyQXgdtZp4ZkHh0tMeRXqTig+S2ptraAiV2rRe0+CHo1KOcs2boU5Mp37eBqa
         IZh+mU48WBIq1eEG70+5C/0iZAQVElqnQgCqBAdZ0gYRHSNsd8hG7HOYglwfoXtevd
         kuoyIu7IsR/Pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19E77E21EE8;
        Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/4] net: dsa: mv88e6xxx: accelerate C45 scan
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911801910.9150.1802116889596947531.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:40:19 +0000
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
In-Reply-To: <20230315163846.3114-1-klaus.kudielka@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 17:38:42 +0100 you wrote:
> Starting with commit 1a136ca2e089 ("net: mdio: scan bus based on bus
> capabilities for C22 and C45"), mdiobus_scan_bus_c45() is being called on
> buses with MDIOBUS_NO_CAP. On a Turris Omnia (Armada 385, 88E6176 switch),
> this causes a significant increase of boot time, from 1.6 seconds, to 6.3
> seconds. The boot time stated here is until start of /init.
> 
> Further testing revealed that the C45 scan is indeed expensive (around
> 2.7 seconds, due to a huge number of bus transactions), and called twice.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ mappings from mdiobus code
    https://git.kernel.org/netdev/net-next/c/b1a2de9ccfe6
  - [net-next,v4,2/4] net: dsa: mv88e6xxx: re-order functions
    https://git.kernel.org/netdev/net-next/c/f1bee740fa82
  - [net-next,v4,3/4] net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
    https://git.kernel.org/netdev/net-next/c/2cb0658d4f88
  - [net-next,v4,4/4] net: dsa: mv88e6xxx: mask apparently non-existing phys during probing
    https://git.kernel.org/netdev/net-next/c/2c7e46edbd03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


