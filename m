Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED6A666497
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbjAKUKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjAKUKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D3BCC;
        Wed, 11 Jan 2023 12:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF58861D9E;
        Wed, 11 Jan 2023 20:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 203C0C433F0;
        Wed, 11 Jan 2023 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673467817;
        bh=IqUrYkAjm4CwMRnnIvaM2uflzYQogPf66FSQYPlF+7I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZbGuZXtI/BqFEze9TAwX6kmMqCpkQJCR/p41+5rcb72RzkpFsFvaeHEslA0Q1R48w
         VCJhmuakQF82BWrINEcsdwReJ+Cv048YDYm7/FdIknUUopdK4Zxj5nh0Ng/3roH6UG
         61vlpQWuOzb0bHNQbAek12ULy2ImpoFdL47lT7ATkEgB+GRngNvZDXZj9abxX8BEH/
         jnCFxRu5bfThbFcdMdc4vLN5saDEm0WEit/ZRdIGp0RMYpjSbBrhKKrPWJOFQJCsRA
         GW3JXRceFFdV08DGd4wrDlImyoMIIX/p3NHaKmzi4kuPgJWra7MH+4RW1vc1V3JbDt
         G53Puri+iE0Ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1902E270F6;
        Wed, 11 Jan 2023 20:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167346781697.28484.18153858601113924457.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 20:10:16 +0000
References: <20230111031540.v3.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
In-Reply-To: <20230111031540.v3.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
To:     Ying Hsu <yinghsu@chromium.org>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        leon@kernel.org, luiz.dentz@gmail.com,
        chromeos-bluetooth-upstreaming@chromium.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, johan.hedberg@gmail.com,
        pabeni@redhat.com, tedd.an@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 11 Jan 2023 03:16:14 +0000 you wrote:
> syzbot reports a possible deadlock in rfcomm_sk_state_change [1].
> While rfcomm_sock_connect acquires the sk lock and waits for
> the rfcomm lock, rfcomm_sock_release could have the rfcomm
> lock and hit a deadlock for acquiring the sk lock.
> Here's a simplified flow:
> 
> rfcomm_sock_connect:
>   lock_sock(sk)
>   rfcomm_dlc_open:
>     rfcomm_lock()
> 
> [...]

Here is the summary with links:
  - [v3] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
    https://git.kernel.org/bluetooth/bluetooth-next/c/7ed38304a633

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


