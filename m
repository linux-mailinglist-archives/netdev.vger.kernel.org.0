Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72436567988
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiGEVuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiGEVuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0105F2AE9;
        Tue,  5 Jul 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DF9961CF4;
        Tue,  5 Jul 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FE91C341CB;
        Tue,  5 Jul 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657057813;
        bh=L+i1nEUDeFfTV1alPccsdJXl82/LOZYPtDeD9hQnN1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LFDWrrejLl4UZuC6wY1S6+EUa/jUlLFm89X0JSu40/yrxJAtdhSLnk/THEvHXuT0U
         aWxSprZEhypegt/yo3dqSIrd52ujt6BDxzRLw0ucTRWF9m6SS+boRP6+VH/LqKOAnQ
         NC1ZyOIQ2l2iZdDdAGHOtLf0mYHj1uB2ylw6zYZevSg5j5CpvVzhXpVyWcPeCRtpTe
         5gky4x2WGUJjHhFuKGdrzJlqCfmz2jLxVK4LFECt5Tc6xLN0AvmQSUVlvp6ml4GQzv
         eUUQshoIvFFrO/EoSPG2OmKIIUVHBRhKSrA5cF1LqnWJp6/NNy8SIVMERaEiAyDgYH
         yMH8VqOG3KFBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CB1AE45BD8;
        Tue,  5 Jul 2022 21:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: core: Fix deadlock due to
 `cancel_work_sync(&hdev->power_on)` from hci_power_on_sync.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165705781323.1977.3304816866885746199.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 21:50:13 +0000
References: <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
In-Reply-To: <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
To:     Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, max.oss.09@gmail.com,
        francesco.dolcini@toradex.com, mat.jonczyk@o2.pl, kuba@kernel.org,
        marcel@holtmann.org, max.krummenacher@toradex.com,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com
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

This patch was applied to netdev/net.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Tue,  5 Jul 2022 15:59:31 +0300 you wrote:
> `cancel_work_sync(&hdev->power_on)` was moved to hci_dev_close_sync in
> commit [1] to ensure that power_on work is canceled after HCI interface
> down.
> 
> But, in certain cases power_on work function may call hci_dev_close_sync
> itself: hci_power_on -> hci_dev_do_close -> hci_dev_close_sync ->
> cancel_work_sync(&hdev->power_on), causing deadlock. In particular, this
> happens when device is rfkilled on boot. To avoid deadlock, move
> power_on work canceling out of hci_dev_do_close/hci_dev_close_sync.
> 
> [...]

Here is the summary with links:
  - Bluetooth: core: Fix deadlock due to `cancel_work_sync(&hdev->power_on)` from hci_power_on_sync.
    https://git.kernel.org/netdev/net/c/e36bea6e78ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


