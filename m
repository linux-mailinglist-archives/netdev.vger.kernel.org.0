Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0B25871BA
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbiHATuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiHATuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E178326EF;
        Mon,  1 Aug 2022 12:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FE1C6134B;
        Mon,  1 Aug 2022 19:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5114C433B5;
        Mon,  1 Aug 2022 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659383413;
        bh=8yH98xuWpRPWIrzevEWD47Sjgiur2HOH9NKL9rK9XVs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ECCcAtC98UcytzgL3/0zzZExguY7vhYuu+nOkKt10frPsr3P2DEPw5JrG1J4P4PB/
         rVShWwu2QGhBu0Uet0u+inQanbDSLb1zv2X/6T3PpjV6fAKBbwHVm2TAR5rQTgZMr9
         lvItJ7liaMxSM2hBcmHz1o8jg3qaSwyTplCk+flVs98vyJhX+9VvO2xRt0oX547Rae
         6VDU1sFjMWNGl3Cb4eREn1EkMVZ+HNmU19y+lDeo6de/lept85m/MwyeIqFkYsjKL3
         oD2vf0TTb9niACiyOZ84oDci5frgfVrug53+btxLtwMHQTPrDDR0HsPrvhm1XUAWzE
         iDUV3z15RKd/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2A5EC43144;
        Mon,  1 Aug 2022 19:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in
 the same lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165938341366.9721.17408043483330420763.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 19:50:13 +0000
References: <20220729110027.40569-1-hbh25y@gmail.com>
In-Reply-To: <20220729110027.40569-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.co.jp, joannelkoong@gmail.com,
        richard_siegfried@systemli.org, socketcan@hartkopp.net,
        ian.mcdonald@jandi.co.nz, acme@mandriva.com, gerrit@erg.abdn.ac.uk,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Jul 2022 19:00:27 +0800 you wrote:
> In the case of sk->dccps_qpolicy == DCCPQ_POLICY_PRIO, dccp_qpolicy_full
> will drop a skb when qpolicy is full. And the lock in dccp_sendmsg is
> released before sock_alloc_send_skb and then relocked after
> sock_alloc_send_skb. The following conditions may lead dccp_qpolicy_push
> to add skb to an already full sk_write_queue:
> 
> thread1--->lock
> thread1--->dccp_qpolicy_full: queue is full. drop a skb
> thread1--->unlock
> thread2--->lock
> thread2--->dccp_qpolicy_full: queue is not full. no need to drop.
> thread2--->unlock
> thread1--->lock
> thread1--->dccp_qpolicy_push: add a skb. queue is full.
> thread1--->unlock
> thread2--->lock
> thread2--->dccp_qpolicy_push: add a skb!
> thread2--->unlock
> 
> [...]

Here is the summary with links:
  - [v2] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock
    https://git.kernel.org/netdev/net/c/a41b17ff9dac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


