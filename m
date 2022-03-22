Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A634E3888
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 06:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbiCVFll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 01:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbiCVFlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 01:41:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F6FE0F9
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 22:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C183B81B8D
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 05:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B52ABC340ED;
        Tue, 22 Mar 2022 05:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647927610;
        bh=/JrV1MxHkiG3NoPhOJ9kpCncsozk0n7wWnFq/VztL8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C8ZRxrQeZEdKRKrwHuMPXJZsN/88S1llWxJ22FuHtQaQu9x4zN0UdVZXjhvE52m+K
         cDBFMYah+z+VPTIfsr3wCD9Y+6e2mHBjZmQ4YdMAhpMKYGGQdKtniJbal0vt+Ftgjt
         kkW49aidrl2th9Nv5i0KutRUIfkaVpnLJ6PxFYI/LTr9sdmfqN/P+y0E7m248gkjcm
         73YHHDu+yVgaDb3+YxbKM3au4/fLwp2R00BFNgXXi3Tah0dOqLSfwrSxUrah3vlJYT
         98MMWrx1FwqorYn3o6ciQ1Py+uCipXweVA3nQMNjPB3wgvHArvlFYDEuaX6g4Q7wq6
         MvHh+FHu6l0Mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9668CF03845;
        Tue, 22 Mar 2022 05:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: fix panic on shutdown if multi-chip tree failed
 to probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164792761061.20534.3890178737734792230.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 05:40:10 +0000
References: <20220318195443.275026-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220318195443.275026-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Mar 2022 21:54:43 +0200 you wrote:
> DSA probing is atypical because a tree of devices must probe all at
> once, so out of N switches which call dsa_tree_setup_routing_table()
> during probe, for (N - 1) of them, "complete" will return false and they
> will exit probing early. The Nth switch will set up the whole tree on
> their behalf.
> 
> The implication is that for (N - 1) switches, the driver binds to the
> device successfully, without doing anything. When the driver is bound,
> the ->shutdown() method may run. But if the Nth switch has failed to
> initialize the tree, there is nothing to do for the (N - 1) driver
> instances, since the slave devices have not been created, etc. Moreover,
> dsa_switch_shutdown() expects that the calling @ds has been in fact
> initialized, so it jumps at dereferencing the various data structures,
> which is incorrect.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: fix panic on shutdown if multi-chip tree failed to probe
    https://git.kernel.org/netdev/net/c/8fd36358ce82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


