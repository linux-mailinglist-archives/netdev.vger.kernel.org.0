Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CAF69422D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjBMKAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBMKAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75CAE3A2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 02:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49346B80DA9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAA9EC4339C;
        Mon, 13 Feb 2023 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676282420;
        bh=sgGd6p0JfV6CiN7lkBqJds1vKRO/cAog3d+Ua+st3lM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L3naAZYALsqvXk8G/+cM5IxOKKKNZi8vJKLTwF6dP1ASCwY4dxkqIrKlEawVRctkj
         lEYVoSMZop2rILgZf030XuDoCPgkkadAVCuvsP6iP3gA9L9JQWISeBmkLFUZgpBJLi
         Ia+e/tNWdyWdTDu+/VstOhEy0hUoCN+oHJuxhQ18cpIHhzGrFOMzqA9dlgp9vRGHd6
         W+9V5AsuOOgbmXHv+8XvoVil+fLH5gw15xBxNzkBOpB8RzKnnysystp5kM1QgKDB2s
         4b4Px04kd4i15e+ipgN2wqTNhJHsGOejrGDmB4UuUk/6Zo8ND1j7zsoWPX3iXF1tPP
         +o/xpg9sTXBLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6336E68D39;
        Mon, 13 Feb 2023 10:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: fix error recovery in qdisc_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628242080.19101.4551130082733315908.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 10:00:20 +0000
References: <20230210152605.1852743-1-edumazet@google.com>
In-Reply-To: <20230210152605.1852743-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com,
        vladimir.oltean@nxp.com, kurt@linutronix.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 15:26:05 +0000 you wrote:
> If TCA_STAB attribute is malformed, qdisc_get_stab() returns
> an error, and we end up calling ops->destroy() while ops->init()
> has not been called yet.
> 
> While we are at it, call qdisc_put_stab() after ops->destroy().
> 
> Fixes: 1f62879e3632 ("net/sched: make stab available before ops->init() call")
> Reported-by: syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: fix error recovery in qdisc_create()
    https://git.kernel.org/netdev/net-next/c/4fab64126891

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


