Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF27F57A474
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiGSRAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 13:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGSRAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 13:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5C62A72D;
        Tue, 19 Jul 2022 10:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34F2C60AC9;
        Tue, 19 Jul 2022 17:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43825C341CE;
        Tue, 19 Jul 2022 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658250014;
        bh=XGBxAjl/31+vmFzw9+HbFNyJva2edC2j2mtdWCSg8p0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P+chmJupQCBVUjRilZkRMGMjyq0iObvrvyAOFOYLIcHLczxEEHLdSevcruoYrRoG1
         yj0zwB+ooyvVk4A3203fcg4gFC1p7XJhoOI+7NQ7jtPnTTgOtIAS5yB+4Fyh1eexUD
         BOllY1uTpFzh7cnD9JwYMgZqduikHOf4NtPXWabE2u1/q8WxHpqysVFMCTKV844+p1
         tzeufFq12+75MyVeXZQby70PLd966XHbEmgEmL1FO4tCb/ajL++YkOWKxOxZcfAfO9
         q0DcUs1S1xZrqmstv1vAg3m/zbmDOkN4b78OZi6VbWTjxW530z1VeTS4ftUxA3stbs
         qJVw67Mo9zm9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2412CE451BB;
        Tue, 19 Jul 2022 17:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4,bpf-next] bpf: Don't redirect packets with invalid pkt_len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165825001414.21239.5976197980941265711.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 17:00:14 +0000
References: <20220715115559.139691-1-shaozhengchao@huawei.com>
In-Reply-To: <20220715115559.139691-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        hawk@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, bigeasy@linutronix.de, imagedong@tencent.com,
        petrm@nvidia.com, arnd@arndb.de, dsahern@kernel.org,
        talalahmad@google.com, keescook@chromium.org, haoluo@google.com,
        jolsa@kernel.org, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 15 Jul 2022 19:55:59 +0800 you wrote:
> Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
> skbs, that is, the flow->head is null.
> The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
> run a bpf prog which redirects empty skbs.
> So we should determine whether the length of the packet modified by bpf
> prog or others like bpf_prog_test is valid before forwarding it directly.
> 
> [...]

Here is the summary with links:
  - [v4,bpf-next] bpf: Don't redirect packets with invalid pkt_len
    https://git.kernel.org/bpf/bpf-next/c/fd1894224407

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


