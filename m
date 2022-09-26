Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA15EB045
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiIZSlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiIZSl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:41:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1335036DE9
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EC12B80C75
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06B4BC4347C;
        Mon, 26 Sep 2022 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664217616;
        bh=48hMv6eb+KMdk0qP9PT65H8DfJaWRtyuVvtFzIOfVrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XVOdJAOy/ts2w7w7X7uczo7XNcwpqL9KI0zWNrxpFYn/YK53d6VE380IIPsmpMsw1
         Ju1T7XpdZ22lBmWUDSKdzTm6WmKHzRdrNxq7Kw++YAmSmywsHEQPGsP5FfWuMRA0Pq
         TYuiMo45gfnQOI2ZlAD5VXI2DTO0/YnO+0ItjrdfiHmbOFBo/f0YiDcObUJt1pjBG/
         xBy0RYkvbh0uPSq/0JYbO9u+Jvoq3goIMcyH1SKN+Q2W4cAGLQxcObq0CcAdLsas+6
         WS8B3YX2VQ7Q/rWW4CtjhuWt4O5hR3Av4ZSRJcmdCSXctKnD6eumPKLYk+vAnHnx62
         ZT7V+EAPoiaOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4F0FE21EC2;
        Mon, 26 Sep 2022 18:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: make user ports return to init_net on
 netns deletion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166421761593.17810.673618488847121611.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 18:40:15 +0000
References: <20220921185428.1767001-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220921185428.1767001-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 21 Sep 2022 21:54:28 +0300 you wrote:
> As pointed out during review, currently the following set of commands
> crashes the kernel:
> 
> $ ip netns add ns0
> $ ip link set swp0 netns ns0
> $ ip netns del ns0
> WARNING: CPU: 1 PID: 27 at net/core/dev.c:10884 unregister_netdevice_many+0xaa4/0xaec
> Workqueue: netns cleanup_net
> pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : unregister_netdevice_many+0xaa4/0xaec
> lr : unregister_netdevice_many+0x700/0xaec
> Call trace:
>  unregister_netdevice_many+0xaa4/0xaec
>  default_device_exit_batch+0x294/0x340
>  ops_exit_list+0xac/0xc4
>  cleanup_net+0x2e4/0x544
>  process_one_work+0x4ec/0xb40
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: make user ports return to init_net on netns deletion
    https://git.kernel.org/netdev/net-next/c/56378f3ccb83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


