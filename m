Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7E55C66E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbiF1HkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242793AbiF1HkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65832A413;
        Tue, 28 Jun 2022 00:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8757FB81D11;
        Tue, 28 Jun 2022 07:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 465DBC341CD;
        Tue, 28 Jun 2022 07:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656402013;
        bh=v2OzFWbDv6KcXFLLbY3So5B3U7J0LbFxzEq1Td1EZJA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QW1XWGfac/CTTnaDZ+rYCVpLlt8JNV3YRGO74xIqIrVc1abIlcR2g0hNNJIanuVam
         lkXGhFojP5aO0DanEPbzLsZplR//v3qDbA6sUTws/1gcqPT9gf7lHsFzHXg6BEU8lW
         MkmVGQsW5e7+Jsm763psnzZnCeV3w7WpzoYi1vc0GHdbUB6rj8DsPKsGRkKrtSZeOo
         KZ/VQBZ3sjrmuTetR5jmwqvZ0pUc4j4b/eZQ4QLAmvpeWqd5tUnVpegHI8JPUJ7utH
         k5JUH0Aw+uSLm6e02dlvIZdXfvqNmNWkzLK57uFkdXaV4ZgIxs7GxKmDW1uKVEO/+t
         Zl4+if9yc2DkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 278E9E49F65;
        Tue, 28 Jun 2022 07:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: sockmap calling sleepable function in teardown
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165640201315.9025.13424648170851367214.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 07:40:13 +0000
References: <20220628035803.317876-1-john.fastabend@gmail.com>
In-Reply-To: <20220628035803.317876-1-john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com, bpf@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 27 Jun 2022 20:58:03 -0700 you wrote:
> syzbot reproduced the BUG,
> 
>  BUG: sleeping function called from invalid context at kernel/workqueue.c:3010
> 
> with the following stack trace fragment
> 
>  start_flush_work kernel/workqueue.c:3010 [inline]
>  __flush_work+0x109/0xb10 kernel/workqueue.c:3074
>  __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3162
>  sk_psock_stop+0x4cb/0x630 net/core/skmsg.c:802
>  sock_map_destroy+0x333/0x760 net/core/sock_map.c:1581
>  inet_csk_destroy_sock+0x196/0x440 net/ipv4/inet_connection_sock.c:1130
>  __tcp_close+0xd5b/0x12b0 net/ipv4/tcp.c:2897
>  tcp_close+0x29/0xc0 net/ipv4/tcp.c:2909
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: sockmap calling sleepable function in teardown path
    https://git.kernel.org/bpf/bpf-next/c/697fb80a5364

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


