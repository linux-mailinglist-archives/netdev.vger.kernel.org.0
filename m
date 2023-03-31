Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED33F6D19AB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjCaIU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjCaIUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:20:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036E6AF3B;
        Fri, 31 Mar 2023 01:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 965F7B82CF3;
        Fri, 31 Mar 2023 08:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 422FBC4339B;
        Fri, 31 Mar 2023 08:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680250817;
        bh=V+bfnvlS+kOmBBeElvXS7vrBIjidlHmWIetDz9gZ2Fc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p8rQfzc1uGsVvHTd7Ewy0ywh0zOHBOm99RCtK/jO3kJ/EvUhnFAJmCWVCqT+LB7gZ
         oMAhL68de6QogCqVcdPAB+tSFznhNcqn/mSAI+xyzrhsVvKR75jLEO299cURmoU1YZ
         C6MTqVRHuWmyFffrxcKxgJZW/olvqcHQ5x4y1K9t66D6+v/nKXPl2F2MExvloG58pr
         5+LKbiTQ7KDciS0m/l2L3fwTKWD6giOfwKRttZNiYdRvuHH73cU9Kw48gnhCqBz0Zi
         HN5OyaB5+Y1LC/JRH20UjFZrxx/XXB6lBz2i/4NrIFGhC11d76RrUnq+sfELgWJhBm
         uOB76fvNDi/LQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F8E8C0C40E;
        Fri, 31 Mar 2023 08:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: qrtr: Fix a refcount bug in qrtr_recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168025081712.23963.16327516163139075912.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:20:17 +0000
References: <20230330012532.1065159-1-william.xuanziyang@huawei.com>
In-Reply-To: <20230330012532.1065159-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     mani@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, andersson@kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Mar 2023 09:25:32 +0800 you wrote:
> Syzbot reported a bug as following:
> 
> refcount_t: addition on 0; use-after-free.
> ...
> RIP: 0010:refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
> ...
> Call Trace:
>  <TASK>
>  __refcount_add include/linux/refcount.h:199 [inline]
>  __refcount_inc include/linux/refcount.h:250 [inline]
>  refcount_inc include/linux/refcount.h:267 [inline]
>  kref_get include/linux/kref.h:45 [inline]
>  qrtr_node_acquire net/qrtr/af_qrtr.c:202 [inline]
>  qrtr_node_lookup net/qrtr/af_qrtr.c:398 [inline]
>  qrtr_send_resume_tx net/qrtr/af_qrtr.c:1003 [inline]
>  qrtr_recvmsg+0x85f/0x990 net/qrtr/af_qrtr.c:1070
>  sock_recvmsg_nosec net/socket.c:1017 [inline]
>  sock_recvmsg+0xe2/0x160 net/socket.c:1038
>  qrtr_ns_worker+0x170/0x1700 net/qrtr/ns.c:688
>  process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2537
> 
> [...]

Here is the summary with links:
  - [net] net: qrtr: Fix a refcount bug in qrtr_recvmsg()
    https://git.kernel.org/netdev/net/c/44d807320000

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


