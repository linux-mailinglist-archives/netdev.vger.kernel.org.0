Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A474B635EEC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbiKWNHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiKWNHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:07:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA36E0DD4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A131CB81F6D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50462C433B5;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207815;
        bh=hIVvg7GYixP7yKspKaOEkXYj8mxOVmo+58A6atonM9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lD/LtanuvpCylxH7IlG5W+r/VbmDNP9QjjioBEAJe1qLigSFd3bZA73W1fz1gPusn
         S8zLOHcd5TkhQHhSSqayYAdvq4MQNo7xR20EUxPwtNkqxfc4Ev7aJfGVgjNsU82nKs
         nC+/lgIr48H6zSVVOzGNdqTshVBEypW40w02OHnzWWJaQ5lngn2oGBUQErQjnL2r58
         KlPV5DNse6jaWtmh9M0gNsQJhOto2nO1eh+m6yiZzfy+tEb18eC+EeuDBohOy9qYJJ
         yHyyaqSyS0pg+ShwIOCA+e3Bs4omCJwpMl/OilQf42OqfCKuscUNQfyeF7pQkm5SkZ
         y7g63KGB8g8FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33C78E21EFD;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166920781520.7047.5118959763745270461.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 12:50:15 +0000
References: <20221121085426.21315-1-jakub@cloudflare.com>
In-Reply-To: <20221121085426.21315-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, tparkin@katalix.com,
        penguin-kernel@i-love.sakura.ne.jp,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 21 Nov 2022 09:54:26 +0100 you wrote:
> When holding a reader-writer spin lock we cannot sleep. Calling
> setup_udp_tunnel_sock() with write lock held violates this rule, because we
> end up calling percpu_down_read(), which might sleep, as syzbot reports
> [1]:
> 
>  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
>  percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
>  cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
>  static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
>  udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
>  setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
>  l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
>  pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
> 
> [...]

Here is the summary with links:
  - [net,v2] l2tp: Don't sleep and disable BH under writer-side sk_callback_lock
    https://git.kernel.org/netdev/net/c/af295e854a4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


