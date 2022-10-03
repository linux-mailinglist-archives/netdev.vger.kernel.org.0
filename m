Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8EC5F28E4
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 09:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJCHAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 03:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJCHAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 03:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27037DF1C;
        Mon,  3 Oct 2022 00:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE95160F80;
        Mon,  3 Oct 2022 07:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54FAAC433B5;
        Mon,  3 Oct 2022 07:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664780415;
        bh=qZ17h429eDqUgwv/aGG3SQHS7BjHvVN6jcPIWDLcYAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R53ANWsdp78RakxCBEjxbBu1d5cN6J48MgxmDE/iK5QUj/X4qGB2fLCM/UXKPaRHU
         1Qde8nkVZv+xI6+Y3DaGz0AM7EWIOHSbvqAuCPVAt44V5RvLM4QvcXElj4iH25O5IP
         1U+DKS2r/pDjeb6vJUfZI7zOuuyWL9V4nc8fEechn0gXF5XbdYyh9W0a0cdE2UTjaw
         juVY0DIKYpo8woIBDKwJJlAIoz3hHlYFrcepz0m9Cyvp/VcoxeDWGwQNGLIBE/vOnJ
         BmXfdQv/bbEsQ+jaGAC7VNeUBFH88K+OMVMFIjuWSqJ21zXjphrP/zqkPwa1QdLY69
         765M3f1KacwPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3AF5AE49FA7;
        Mon,  3 Oct 2022 07:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: rds: don't hold sock lock when cancelling work from
 rds_tcp_reset_callbacks()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166478041523.16664.6828494970350493146.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 07:00:15 +0000
References: <3de97b2d-1c15-5dda-4fe2-78311a91d861@I-love.SAKURA.ne.jp>
In-Reply-To: <3de97b2d-1c15-5dda-4fe2-78311a91d861@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        sowmini.varadhan@oracle.com, hdanton@sina.com,
        syzkaller-bugs@googlegroups.com,
        syzbot+78c55c7bc6f66e53dce2@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
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

On Thu, 29 Sep 2022 00:25:37 +0900 you wrote:
> syzbot is reporting lockdep warning at rds_tcp_reset_callbacks() [1], for
> commit ac3615e7f3cffe2a ("RDS: TCP: Reduce code duplication in
> rds_tcp_reset_callbacks()") added cancel_delayed_work_sync() into a section
> protected by lock_sock() without realizing that rds_send_xmit() might call
> lock_sock().
> 
> We don't need to protect cancel_delayed_work_sync() using lock_sock(), for
> even if rds_{send,recv}_worker() re-queued this work while __flush_work()
>  from cancel_delayed_work_sync() was waiting for this work to complete,
> retried rds_{send,recv}_worker() is no-op due to the absence of RDS_CONN_UP
> bit.
> 
> [...]

Here is the summary with links:
  - net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()
    https://git.kernel.org/netdev/net/c/a91b750fd662

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


