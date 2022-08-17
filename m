Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0391059781D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242069AbiHQUk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238164AbiHQUkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FD7255AD;
        Wed, 17 Aug 2022 13:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BA65B81F48;
        Wed, 17 Aug 2022 20:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F36EC433D7;
        Wed, 17 Aug 2022 20:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660768815;
        bh=jmkHjzQKnXnTZXAiNqy62Ks6t6cAs0u1vIR2cUnl5kE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d/nginzkE8gHggIIDCFrhKkPRF+S3kEQRuqOixwmNNP5suwDm8CAq1i5VF258rQef
         qC+YGmqdvtFksEXz97YCI1jAO8H6Vu1BAtDz7DsFVfVKm+31vPpxyuNd1Iqp3b34xw
         nO/AxejgwlUrOjNO1xlKt3OcFf2cMEQJvIvxfJcfOItIm9olDyG0o9nK6fhfE7aw3/
         UjAfk93Sr+FDCdzFQvvzaMWXf+5agxN2X+dO/Ix0fUEvARTnQ0IRoFiP94GRSKKF85
         MF5KflzLme/+eyNNVbvoUlDG8BqGWQ0d9GBxNuoKciw5yTYuJ3yfvDIvLDXH6VTf5h
         vr4PMZZbjBEBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1ADAE2A053;
        Wed, 17 Aug 2022 20:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] skmsg: Fix wrong last sg check in
 sk_msg_recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166076881492.14069.1219004956913012192.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 20:40:14 +0000
References: <20220809094915.150391-1-liujian56@huawei.com>
In-Reply-To: <20220809094915.150391-1-liujian56@huawei.com>
To:     liujian (CE) <liujian56@huawei.com>
Cc:     john.fastabend@gmail.com, jakub@cloudflare.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 9 Aug 2022 17:49:15 +0800 you wrote:
> Fix one kernel NULL pointer dereference as below:
> 
> [  224.462334] Call Trace:
> [  224.462394]  __tcp_bpf_recvmsg+0xd3/0x380
> [  224.462441]  ? sock_has_perm+0x78/0xa0
> [  224.462463]  tcp_bpf_recvmsg+0x12e/0x220
> [  224.462494]  inet_recvmsg+0x5b/0xd0
> [  224.462534]  __sys_recvfrom+0xc8/0x130
> [  224.462574]  ? syscall_trace_enter+0x1df/0x2e0
> [  224.462606]  ? __do_page_fault+0x2de/0x500
> [  224.462635]  __x64_sys_recvfrom+0x24/0x30
> [  224.462660]  do_syscall_64+0x5d/0x1d0
> [  224.462709]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] skmsg: Fix wrong last sg check in sk_msg_recvmsg()
    https://git.kernel.org/bpf/bpf/c/583585e48d96

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


