Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FA35477B8
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 23:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiFKVkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 17:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiFKVkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 17:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93746B0AD;
        Sat, 11 Jun 2022 14:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53C47612B3;
        Sat, 11 Jun 2022 21:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A58F0C3411C;
        Sat, 11 Jun 2022 21:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654983613;
        bh=6RRA9QNgaXVnE/UIBBzd6rblPf5Yo595VngXDmM1I5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iVYLaQIyE4q+wjSvuTjF9kcjWR7sdcFRvOZ/bIJTJNR1EWJZrOxq+zRvZq6bYNX5v
         I0eglXvTEv5ZqXgtW8bZs8U4F0DPMd0dVl23Gjjm6ffxdSPoUTrroGrHag6UCOWgQn
         tWn2MyrbRmQ1jW7gfeP6gdqI19MWc606X7k7ymKPAav8WdyIc9I0Yo5AiLLXTdoofu
         ACnfHncJStp8PXUj8JEzRoFTRHFTJtyQ/pG0P++QsRzIhGtFFpD7TMlnNFzDR3/Ezx
         RhCoRAf3jBAp4WsaAI1CT7MPnJy5gDz733pHedOybhYNSZGHMKwUzWMDrrTejQHL5e
         /r1kK83scn1/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88F4DE737F4;
        Sat, 11 Jun 2022 21:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 0/2] Optimize performance of update hash-map when free is
 zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165498361355.20267.7962671859794283090.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Jun 2022 21:40:13 +0000
References: <20220610023308.93798-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220610023308.93798-1-zhoufeng.zf@bytedance.com>
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 10 Jun 2022 10:33:06 +0800 you wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> We encountered bad case on big system with 96 CPUs that
> alloc_htab_elem() would last for 1ms. The reason is that after the
> prealloc hashtab has no free elems, when trying to update, it will still
> grab spin_locks of all cpus. If there are multiple update users, the
> competition is very serious.
> 
> [...]

Here is the summary with links:
  - [v6,1/2] bpf: avoid grabbing spin_locks of all cpus when no free elems
    https://git.kernel.org/bpf/bpf-next/c/54a9c3a42d92
  - [v6,2/2] selftest/bpf/benchs: Add bpf_map benchmark
    https://git.kernel.org/bpf/bpf-next/c/89eda98428ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


