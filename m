Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1355A57FE80
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 13:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiGYLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 07:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiGYLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 07:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496AC2197
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 04:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D36C6B80E79
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F0D6C341C8;
        Mon, 25 Jul 2022 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658749213;
        bh=jxc+c8tgDsmI5QTetqIn0AFF4yZJU6C59yh4t80rvrw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q60MliFmTH5oOdtxByllElq1vRsUEKQufzlSDkHEmfSYysm3DvG20qJNmhiIIMcCJ
         lnvstUCtKY3qM2SqSw8y1ypfDomMT/miAu9fz/XHzJa+Jby9idSjcdheQKelNvSgF6
         KaX4w0oRGTXyaPnGGgQChWr63id7HGh6LvXpsk3mNj3+N3RgCpst1P7020HDs0kAQN
         wvcO6mt0Pz0iulNOnD8Zh4pLMPMCz5LcPTmCkJesHvYSMerk5QsN0HSKUq/b9cTG+j
         WT4/AokshksgkfCOgu1yzWgbxW6vLTqX6PXSpQV77MACg9ATfKMNEQjgODf/lbaYaw
         yaX0oMRkivp+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6337BE450B4;
        Mon, 25 Jul 2022 11:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: mld: fix reference count leak in mld_{query |
 report}_work()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165874921340.25231.17481959950698631240.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 11:40:13 +0000
References: <20220722170635.14847-1-ap420073@gmail.com>
In-Reply-To: <20220722170635.14847-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, liuhangbin@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 22 Jul 2022 17:06:35 +0000 you wrote:
> mld_{query | report}_work() processes queued events.
> If there are too many events in the queue, it re-queue a work.
> And then, it returns without in6_dev_put().
> But if queuing is failed, it should call in6_dev_put(), but it doesn't.
> So, a reference count leak would occur.
> 
> THREAD0				THREAD1
> mld_report_work()
> 				spin_lock_bh()
> 				if (!mod_delayed_work())
> 					in6_dev_hold();
> 				spin_unlock_bh()
> 	spin_lock_bh()
> 	schedule_delayed_work()
> 	spin_unlock_bh()
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mld: fix reference count leak in mld_{query | report}_work()
    https://git.kernel.org/netdev/net/c/3e7d18b9dca3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


