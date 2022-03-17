Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31004DCC78
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 18:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiCQRba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiCQRba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 13:31:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CE7215444;
        Thu, 17 Mar 2022 10:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01008B81F12;
        Thu, 17 Mar 2022 17:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EE8BC340EF;
        Thu, 17 Mar 2022 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647538210;
        bh=96us3Vh/tsNMsCASX/xc99i/hu4THmpwg7JXOE7T2wA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QQ7HIwqoeeaFxGaqcHo2+3DWH6XcB527Rho039o3vg+al77VBDhGTCvqHo5gwLqhy
         iAWBlyfqPtAcjCYnzGtaSvl74cv1RUhpXQ0l3REP075lTcdsTTPEugL8CciY7Yh5k/
         M/g0gU5WNcC9ArRGxJJMMAjpKrxeamw64p2BDNpPz/Qm/+CfcMM0QMPOMy0IEROIk5
         zfedF6qkbkPJA1hEXUfA/LZDC3Pas0N5D9besUFHvoQbH+4NfYhi1rLHOAQjBzRXjs
         FiJhTWWf6gx0mc6WAgI9G6y8N5R1yulEeJz81VBbBTcn8CUKLAHV3LILuKlEH8oHrL
         ytZSYAUesPeMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6575FF03841;
        Thu, 17 Mar 2022 17:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] iavf: Fix hang during reboot/shutdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164753821041.18148.18371834724218825935.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 17:30:10 +0000
References: <20220317104524.2802848-1-ivecera@redhat.com>
In-Reply-To: <20220317104524.2802848-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, poros@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        slawomirx.laba@intel.com, mateusz.palczewski@intel.com,
        jacob.e.keller@intel.com, phani.r.burra@intel.com,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Mar 2022 11:45:24 +0100 you wrote:
> Recent commit 974578017fc1 ("iavf: Add waiting so the port is
> initialized in remove") adds a wait-loop at the beginning of
> iavf_remove() to ensure that port initialization is finished
> prior unregistering net device. This causes a regression
> in reboot/shutdown scenario because in this case callback
> iavf_shutdown() is called and this callback detaches the device,
> makes it down if it is running and sets its state to __IAVF_REMOVE.
> Later shutdown callback of associated PF driver (e.g. ice_shutdown)
> is called. That callback calls among other things sriov_disable()
> that calls indirectly iavf_remove() (see stack trace below).
> As the adapter state is already __IAVF_REMOVE then the mentioned
> loop is end-less and shutdown process hangs.
> 
> [...]

Here is the summary with links:
  - iavf: Fix hang during reboot/shutdown
    https://git.kernel.org/netdev/net/c/b04683ff8f08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


