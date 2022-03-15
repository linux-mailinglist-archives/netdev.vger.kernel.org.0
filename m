Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7A44D9F23
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 16:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349754AbiCOPvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 11:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240957AbiCOPvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 11:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4213CA65;
        Tue, 15 Mar 2022 08:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68107612BB;
        Tue, 15 Mar 2022 15:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B354EC340EE;
        Tue, 15 Mar 2022 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647359411;
        bh=rdp3AbFl+8EeHhRXu+vBPp50liGlttGFRGiVRdwOGdQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oKMPjaozWPUOEaYgl/YdTOv59FYn4eUk7cFP6zPCZjE6Pu4Nl4JUxRBc9EwBLHqs6
         4ZLFwgvBaxWbRAFuHBolzLNR5glxubnMUsadIagoCH3CaBBLZUR+B3SDhR+b2uT01x
         bD1PLbxgdxsj9RL2lkP7Xyd6Kkj/YJECx06+8GwdBD8LIUkbYZXbgXEE15V8ru26jn
         RCbeCU3hJQuEX3PN7SL6xDeM/9J5eRpNv7rdqtMDCoFmkpm/A4A6kvARbXFNf8M9Fa
         3T1edJZmxUQObDOYywaTCo4ju2lmZX3SCmieUKG4Zvyrnb2WbC959u8yte6FVlQX+8
         GgmxAAvbcc67w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D88CE6BBCA;
        Tue, 15 Mar 2022 15:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/4] bpf,
 sockmap: Fix memleaks and issues of mem charge/uncharge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164735941157.4881.17090692944812757596.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 15:50:11 +0000
References: <20220304081145.2037182-1-wangyufen@huawei.com>
In-Reply-To: <20220304081145.2037182-1-wangyufen@huawei.com>
To:     wangyufen <wangyufen@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        bpf@vger.kernel.org, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 4 Mar 2022 16:11:41 +0800 you wrote:
> This patchset fixes memleaks and incorrect charge/uncharge memory, these
> issues cause the following info:
> 
> WARNING: CPU: 0 PID: 9202 at net/core/stream.c:205 sk_stream_kill_queues+0xc8/0xe0
> Call Trace:
>  <IRQ>
>  inet_csk_destroy_sock+0x55/0x110
>  tcp_rcv_state_process+0xe5f/0xe90
>  ? sk_filter_trim_cap+0x10d/0x230
>  ? tcp_v4_do_rcv+0x161/0x250
>  tcp_v4_do_rcv+0x161/0x250
>  tcp_v4_rcv+0xc3a/0xce0
>  ip_protocol_deliver_rcu+0x3d/0x230
>  ip_local_deliver_finish+0x54/0x60
>  ip_local_deliver+0xfd/0x110
>  ? ip_protocol_deliver_rcu+0x230/0x230
>  ip_rcv+0xd6/0x100
>  ? ip_local_deliver+0x110/0x110
>  __netif_receive_skb_one_core+0x85/0xa0
>  process_backlog+0xa4/0x160
>  __napi_poll+0x29/0x1b0
>  net_rx_action+0x287/0x300
>  __do_softirq+0xff/0x2fc
>  do_softirq+0x79/0x90
>  </IRQ>
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/4] bpf, sockmap: Fix memleak in sk_psock_queue_msg
    https://git.kernel.org/bpf/bpf-next/c/938d3480b92f
  - [bpf-next,v3,2/4] bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
    https://git.kernel.org/bpf/bpf-next/c/9c34e38c4a87
  - [bpf-next,v3,3/4] bpf, sockmap: Fix more uncharged while msg has more_data
    https://git.kernel.org/bpf/bpf-next/c/84472b436e76
  - [bpf-next,v3,4/4] bpf, sockmap: Fix double uncharge the mem of sk_msg
    https://git.kernel.org/bpf/bpf-next/c/2486ab434b2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


