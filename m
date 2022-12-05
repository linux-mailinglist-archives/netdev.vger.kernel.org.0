Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7BE6421BE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 04:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiLEDAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 22:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiLEDAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 22:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7B910FF4;
        Sun,  4 Dec 2022 19:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C50260F58;
        Mon,  5 Dec 2022 03:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72F7FC433D6;
        Mon,  5 Dec 2022 03:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670209215;
        bh=1OfbOLGGbUDZppu1Hn+ZXHMAyYCp14mQCqYYAC9x3HM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R/j2Yq4OeyGi/pv+PN62/JoZ+JmpALM/oLvXz28dOfCwvoZpB0d+5t4wImSZKrHl2
         ceyLNdRVvQY7TbiIujXIRDTTIW+Y0NJ0xQr+lmXsr62IiDHZnPFHRwHylzXMeZPnqi
         znyeGlqHhxSjAz+TizHBH1qnJ1w3SdrdPnaQgsw7G1EI/pLAAVUSVpukwk1WstQ0bE
         goNrHAGhUg4cKiWZKrzZuSf+wdBuRCadg3K5AQTRaMnuyqjQEu5lgCVfu8Q0JBL0Km
         jltNtUp/eo3hUuoe3+hdl71KChRBc9+GSlxIj5qY4vLjsIchiufKh/wd2Ay9p6rIlu
         4HBE5y18zrEKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AA70E49BBF;
        Mon,  5 Dec 2022 03:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf: Add dummy type reference to nf_conn___init to fix
 type deduplication
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167020921530.5137.9042058313238429858.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 03:00:15 +0000
References: <20221201123939.696558-1-toke@redhat.com>
In-Reply-To: <20221201123939.696558-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, lorenzo@kernel.org,
        memxor@gmail.com, jbenc@redhat.com, edumazet@google.com,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu,  1 Dec 2022 13:39:39 +0100 you wrote:
> The bpf_ct_set_nat_info() kfunc is defined in the nf_nat.ko module, and
> takes as a parameter the nf_conn___init struct, which is allocated through
> the bpf_xdp_ct_alloc() helper defined in the nf_conntrack.ko module.
> However, because kernel modules can't deduplicate BTF types between each
> other, and the nf_conn___init struct is not referenced anywhere in vmlinux
> BTF, this leads to two distinct BTF IDs for the same type (one in each
> module). This confuses the verifier, as described here:
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf: Add dummy type reference to nf_conn___init to fix type deduplication
    https://git.kernel.org/bpf/bpf-next/c/578ce69ffda4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


