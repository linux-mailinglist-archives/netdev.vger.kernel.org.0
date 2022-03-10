Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496A84D4013
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbiCJEBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239396AbiCJEBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:01:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6A412CC08
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D9B5B8246A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20712C340EB;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646884811;
        bh=eUKJwtEOAt6EKpxBA66lHN0tr0huTyyOia6f4u8VFJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kl+cyyhU7LPotzcoe4vyqDNqGPNr5ODLEswvOE6/7zfHg7JkGtxoEhxBzXG5GU/cO
         1KdnH1Uc+Zo9kqkqyMWwwU3fmOJxwPcQKt817FAG1LObeZWPGwqCmwCUhNkYCpUNVC
         n8eAO0qx3MJgpFtp9ng3053IFJ8vu58cWFDutvwnXFUC3NrhOVLs4m8m5moiPitka/
         vo+UQVkZ1ILzDgN7aQWvKMbD6awKQbZcdI6CD75zgWFSrJTxhYCVSUC6WF4hJ2bgNh
         cGG2Od/sWSvQU+gxOrj/ZErT7Jn4brZWbuR4Zwkjrq8T/HHYJXfw89CRjOc1nVsp6U
         wuv3SRt1AGcdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07C0DEAC095;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] e1000e: Print PHY register address when MDI
 read/write fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688481102.32652.748801945728142151.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:00:11 +0000
References: <20220308172030.451566-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220308172030.451566-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yu.c.chen@intel.com,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, pmenzel@molgen.mpg.de,
        todd.e.brandt@intel.com, naamax.meir@linux.intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Mar 2022 09:20:30 -0800 you wrote:
> From: Chen Yu <yu.c.chen@intel.com>
> 
> There is occasional suspend error from e1000e which blocks the
> system from further suspending. And the issue was found on
> a WhiskeyLake-U platform with I219-V:
> 
> [   20.078957] PM: pci_pm_suspend(): e1000e_pm_suspend+0x0/0x780 [e1000e] returns -2
> [   20.078970] PM: dpm_run_callback(): pci_pm_suspend+0x0/0x170 returns -2
> [   20.078974] e1000e 0000:00:1f.6: PM: pci_pm_suspend+0x0/0x170 returned -2 after 371012 usecs
> [   20.078978] e1000e 0000:00:1f.6: PM: failed to suspend async: error -2
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] e1000e: Print PHY register address when MDI read/write fails
    https://git.kernel.org/netdev/net-next/c/91ec77924714

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


