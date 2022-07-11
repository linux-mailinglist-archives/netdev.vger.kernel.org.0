Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5C157085F
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiGKQaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiGKQaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E12B21813;
        Mon, 11 Jul 2022 09:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA14EB810D5;
        Mon, 11 Jul 2022 16:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D61FC341CA;
        Mon, 11 Jul 2022 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657557014;
        bh=aNQ+BDXMXzM+Tqs2QOCZqwZwwv67alTyO9wJS8ENrQY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XqJ/1pKSU9P6u1P/Gc+91mtL4bmNvZpJzwsAz9OqN/iLu4k06LTrg5+Sf7D629OaG
         Tp6qioOZJzLj7/I/s1EImArY9gX5jZyvv09wUlt2LxuOFlyFUT0p75tDB4XZ7iiur9
         ORqo8ADovTvFpDKHsqb1Ai278ktMYB008Lp5P+joVcU/txIcV9+Cr0LnqVesg1ycVq
         u/7ij7WVPQ8BAeDZ2lkNpTVILgeAsxC8iGeH4jjF/C3NKIR4umgAG3E/ywpt0qvBGA
         13RNSACw6SkZP5QSD+Tl2gFQwXxQ/XCXNQ1rubXXzAvPYRtZjMgVUw+ESL295+6GGF
         jxB6f9nmbcfLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AD89E45223;
        Mon, 11 Jul 2022 16:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] skmsg: Fix invalid last sg check in sk_msg_recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165755701430.14376.9886144012475004579.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jul 2022 16:30:14 +0000
References: <20220628123616.186950-1-liujian56@huawei.com>
In-Reply-To: <20220628123616.186950-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     john.fastabend@gmail.com, jakub@cloudflare.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 28 Jun 2022 20:36:16 +0800 you wrote:
> In sk_psock_skb_ingress_enqueue function, if the linear area + nr_frags +
> frag_list of the SKB has NR_MSG_FRAG_IDS blocks in total, skb_to_sgvec
> will return NR_MSG_FRAG_IDS, then msg->sg.end will be set to
> NR_MSG_FRAG_IDS, and in addition, (NR_MSG_FRAG_IDS - 1) is set to the last
> SG of msg. Recv the msg in sk_msg_recvmsg, when i is (NR_MSG_FRAG_IDS - 1),
> the sk_msg_iter_var_next(i) will change i to 0 (not NR_MSG_FRAG_IDS), the
> judgment condition "msg_rx->sg.start==msg_rx->sg.end" and
> "i != msg_rx->sg.end" can not work.
> 
> [...]

Here is the summary with links:
  - [bpf] skmsg: Fix invalid last sg check in sk_msg_recvmsg()
    https://git.kernel.org/bpf/bpf-next/c/9974d37ea75f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


