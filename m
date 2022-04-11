Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776874FC114
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347792AbiDKPnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348087AbiDKPm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:42:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF2C3A727;
        Mon, 11 Apr 2022 08:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF721B816CA;
        Mon, 11 Apr 2022 15:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3B0EC385A9;
        Mon, 11 Apr 2022 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649691611;
        bh=Mkh/B/5SXLGGgAFR0YNa7a5GGLbPnoBLOjMVGrCsnoc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vdl+qTVGxtIlcpNRWrWvPxu5LomBpUiPA9fR/5oyBHyOqddcBNwnPtI63welELIXG
         HizMMIdD0S49wmRDntg7hhhils3/rRiJHtoICjSJHEjB+S+DDNm0YWr40auBgH2Wlv
         c71lYGuoIvyJS1EnlOPEvB/Co2kSzbTPzDZtcUKXvc7AUwzf1eq3I9K/a0bReNyXcw
         5VsfCSjCaUdDWYXDMGN7Ph9IXcPgiGf1Gl1vQkaxge7XmQXqaoo87vGLzWVSMVQDmY
         VQbOYEhoVhvpwLsNaF5bs5lv70jcydfjHjkBChX/5/lUwJSB/BXWjfETiO7ZoKnvRq
         0xa9HLTRe128w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79BFAE8DBD1;
        Mon, 11 Apr 2022 15:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: Fix release of page_pool in BPF_PROG_RUN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164969161149.11703.4623538236808431401.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 15:40:11 +0000
References: <20220409213053.3117305-1-toke@redhat.com>
In-Reply-To: <20220409213053.3117305-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, freysteinn.alfredsson@kau.se,
        pabeni@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Sat,  9 Apr 2022 23:30:53 +0200 you wrote:
> The live packet mode in BPF_PROG_RUN allocates a page_pool instance for
> each test run instance and uses it for the packet data. On setup it creates
> the page_pool, and calls xdp_reg_mem_model() to allow pages to be returned
> properly from the XDP data path. However, xdp_reg_mem_model() also raises
> the reference count of the page_pool itself, so the single
> page_pool_destroy() count on teardown was not enough to actually release
> the pool. To fix this, add an additional xdp_unreg_mem_model() call on
> teardown.
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: Fix release of page_pool in BPF_PROG_RUN
    https://git.kernel.org/bpf/bpf/c/425d239379db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


