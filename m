Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E815917E0
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiHMAuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 20:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiHMAuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 20:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCDEC5B
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 17:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ECB1B8255C
        for <netdev@vger.kernel.org>; Sat, 13 Aug 2022 00:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4738C433D7;
        Sat, 13 Aug 2022 00:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660351813;
        bh=EBh8Dd1WfQ+AJQz2z6joC6IlHdkMqZxU0ta26Tyd4AQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eWyu8pH7PHPNcSm8STmZp97H0xxR0G2Ynq2su9wHT/Ueiuud3xPcnTb1BClhthb8/
         0/352BrG3R/slHbDYsdGx0siz9DJ6BlktBhZlbGEhQlxdJl3vB5ncWf9eLf2I96HAa
         OLzjBF7zjbByW22kf1QhjusMqeEtAu5qCyv6Elnc5ktdo03um35r8xXY0YGVfY3+RB
         SEzBxejEtDwILG5mgDvXaVMfh75XliQqbUfH2aMlB0D2/VgaT+7Yf4Zimnb5wlACC6
         Umj0QGV0b47o4HT7cZMDFgpu35h4RT6K/siB+83Jsfl2sG2gpaqZeMSuW/IK7qDPN6
         9g3s0FGWjM9jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CCA25C43142;
        Sat, 13 Aug 2022 00:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: mv88e6060: prevent crash on an unused port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166035181383.28473.10389431989705713321.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Aug 2022 00:50:13 +0000
References: <20220811070939.1717146-1-saproj@gmail.com>
In-Reply-To: <20220811070939.1717146-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@savoirfairelinux.com,
        f.fainelli@gmail.com, davem@davemloft.net, olteanv@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 11 Aug 2022 10:09:39 +0300 you wrote:
> If the port isn't a CPU port nor a user port, 'cpu_dp'
> is a null pointer and a crash happened on dereferencing
> it in mv88e6060_setup_port():
> 
> [    9.575872] Unable to handle kernel NULL pointer dereference at virtual address 00000014
> ...
> [    9.942216]  mv88e6060_setup from dsa_register_switch+0x814/0xe84
> [    9.948616]  dsa_register_switch from mdio_probe+0x2c/0x54
> [    9.954433]  mdio_probe from really_probe.part.0+0x98/0x2a0
> [    9.960375]  really_probe.part.0 from driver_probe_device+0x30/0x10c
> [    9.967029]  driver_probe_device from __device_attach_driver+0xb8/0x13c
> [    9.973946]  __device_attach_driver from bus_for_each_drv+0x90/0xe0
> [    9.980509]  bus_for_each_drv from __device_attach+0x110/0x184
> [    9.986632]  __device_attach from bus_probe_device+0x8c/0x94
> [    9.992577]  bus_probe_device from deferred_probe_work_func+0x78/0xa8
> [    9.999311]  deferred_probe_work_func from process_one_work+0x290/0x73c
> [   10.006292]  process_one_work from worker_thread+0x30/0x4b8
> [   10.012155]  worker_thread from kthread+0xd4/0x10c
> [   10.017238]  kthread from ret_from_fork+0x14/0x3c
> 
> [...]

Here is the summary with links:
  - net: dsa: mv88e6060: prevent crash on an unused port
    https://git.kernel.org/netdev/net/c/246bbf2f977e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


