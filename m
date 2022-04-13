Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF8F4FF837
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiDMNxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiDMNwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE9E255BF;
        Wed, 13 Apr 2022 06:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 421F461A8B;
        Wed, 13 Apr 2022 13:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4507C385A3;
        Wed, 13 Apr 2022 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649857811;
        bh=BNlKKpCCAjEzk4KRbTjOnJCG5l1RHP2diT/TEyqCk7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fjy7J1J9KpEmvBf1PYzFbhJEGVhHpVu3iQMu6Y0DgqOSPH4q4UtmGFOZlsOONX/8x
         a2SxQ40mNI+6EA71c1QT8JEYuLqXkPSwOnYr4S9cNfeXokJwoPQidzuYMj3ttss/Ck
         TuBJ+DgcXrI5OGA0aXEnVSmvGt5xzKG4WCVotDnt+3ATCvoIZAxhka9dG97S8GSUol
         PcnMNmFPWroJzGvvi7mWBoCwI852oVkdV0U/lZOkX1nxrcmo6UJPEPf/yAqi7D9+I9
         rqbf0OWnGwCpYGNkUjKL/5DAKlV6jEZImF2Jd/CdhzG3Lg+WgxVItIS4z4FhbCeNjm
         jtlCLAU6H8IMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 868C3E8DD5E;
        Wed, 13 Apr 2022 13:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v0] nfc: nci: add flush_workqueue to prevent uaf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985781154.18805.3482291136799298171.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 13:50:11 +0000
References: <20220412160430.11581-1-linma@zju.edu.cn>
In-Reply-To: <20220412160430.11581-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     krzk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mudongliangabcd@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 00:04:30 +0800 you wrote:
> Our detector found a concurrent use-after-free bug when detaching an
> NCI device. The main reason for this bug is the unexpected scheduling
> between the used delayed mechanism (timer and workqueue).
> 
> The race can be demonstrated below:
> 
> Thread-1                           Thread-2
>                                  | nci_dev_up()
>                                  |   nci_open_device()
>                                  |     __nci_request(nci_reset_req)
>                                  |       nci_send_cmd
>                                  |         queue_work(cmd_work)
> nci_unregister_device()          |
>   nci_close_device()             | ...
>     del_timer_sync(cmd_timer)[1] |
> ...                              | Worker
> nci_free_device()                | nci_cmd_work()
>   kfree(ndev)[3]                 |   mod_timer(cmd_timer)[2]
> 
> [...]

Here is the summary with links:
  - [v0] nfc: nci: add flush_workqueue to prevent uaf
    https://git.kernel.org/netdev/net/c/ef27324e2cb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


