Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8945F39AC32
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhFCVBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhFCVBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B6D5613E4;
        Thu,  3 Jun 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622754004;
        bh=2lE0Sc5EJ/jVT8FN9y3qThe0QydcNInYrfUlen1Kufs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S0j9skKJjyLPitCzxxHh5/MMe0/dnr3kwhqHjMenbiZIs2/+zgIFcZvc6b7jx66Th
         Mvc1x88WSuuedqc4SXFj6xHakl/DNe+Ae5BFldSReqvwVFwXvN16HlNt5XdSioIr5Q
         HwdUAhEyc3S2kkpZ83cgsU8NeKuCbfYsUvs3k8dYUstBztQ/bi/hIbJL27Msw6JSxy
         OxS3TCVbHY1d4Nyeb0+sV/hrab/zk48A8APac4aSm/F+zWKH3CcA/Qe0NDuKBq/iyI
         we6RpA21roruV4cxLnIx1RUMyNXfmjlFmFZCXbSwUa1Rpp0dLmlHvslAe1E9ljjfn9
         oPjlDYnDs2uiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8937260BFB;
        Thu,  3 Jun 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nft_ct: skip expectations for confirmed
 conntrack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275400455.32659.4499816404978112391.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:00:04 +0000
References: <20210602124430.10863-2-pablo@netfilter.org>
In-Reply-To: <20210602124430.10863-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed,  2 Jun 2021 14:44:29 +0200 you wrote:
> nft_ct_expect_obj_eval() calls nf_ct_ext_add() for a confirmed
> conntrack entry. However, nf_ct_ext_add() can only be called for
> !nf_ct_is_confirmed().
> 
> [ 1825.349056] WARNING: CPU: 0 PID: 1279 at net/netfilter/nf_conntrack_extend.c:48 nf_ct_xt_add+0x18e/0x1a0 [nf_conntrack]
> [ 1825.351391] RIP: 0010:nf_ct_ext_add+0x18e/0x1a0 [nf_conntrack]
> [ 1825.351493] Code: 41 5c 41 5d 41 5e 41 5f c3 41 bc 0a 00 00 00 e9 15 ff ff ff ba 09 00 00 00 31 f6 4c 89 ff e8 69 6c 3d e9 eb 96 45 31 ed eb cd <0f> 0b e9 b1 fe ff ff e8 86 79 14 e9 eb bf 0f 1f 40 00 0f 1f 44 00
> [ 1825.351721] RSP: 0018:ffffc90002e1f1e8 EFLAGS: 00010202
> [ 1825.351790] RAX: 000000000000000e RBX: ffff88814f5783c0 RCX: ffffffffc0e4f887
> [ 1825.351881] RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff88814f578440
> [ 1825.351971] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88814f578447
> [ 1825.352060] R10: ffffed1029eaf088 R11: 0000000000000001 R12: ffff88814f578440
> [ 1825.352150] R13: ffff8882053f3a00 R14: 0000000000000000 R15: 0000000000000a20
> [ 1825.352240] FS:  00007f992261c900(0000) GS:ffff889faec00000(0000) knlGS:0000000000000000
> [ 1825.352343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1825.352417] CR2: 000056070a4d1158 CR3: 000000015efe0000 CR4: 0000000000350ee0
> [ 1825.352508] Call Trace:
> [ 1825.352544]  nf_ct_helper_ext_add+0x10/0x60 [nf_conntrack]
> [ 1825.352641]  nft_ct_expect_obj_eval+0x1b8/0x1e0 [nft_ct]
> [ 1825.352716]  nft_do_chain+0x232/0x850 [nf_tables]
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nft_ct: skip expectations for confirmed conntrack
    https://git.kernel.org/netdev/net/c/1710eb913bdc
  - [net,2/2] netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches
    https://git.kernel.org/netdev/net/c/8971ee8b0877

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


