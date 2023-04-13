Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C1C6E083B
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 09:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjDMHup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 03:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjDMHun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 03:50:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9B093F1;
        Thu, 13 Apr 2023 00:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C0AF63C2D;
        Thu, 13 Apr 2023 07:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C61F1C4339B;
        Thu, 13 Apr 2023 07:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681372217;
        bh=JAjWavrA+ZgB3agBM3DMPabBKzWaDvz6pU3/S9q4AvU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d1QGG74Cl7IIFfZFPuf9qGcllPP88cjKSVjsnJ3ZgBF7Mg+uAAoqiEAosE4iI3PIo
         aC+Q35xdLko7SpFXrkLxvS/oi1Les9TD3YlUKp+kQ/tUGpBz0JXBBvraAPTx5K28aJ
         NQ8HBYelltV0kzDULWRHv8AVDkiC08onfAqq1szBOQOYWwMqDjKTIE0paCGYRkMr9j
         GdIIU7lmRIQwrmntOv5VfbECcZp7KYmGvxmS786jxcn0EHyMtOZ1hcRGPJeCIxf5S6
         09ip1xu+AnuLlWK8H+oLp39TJycTSJVCuWqyS8pJtYSe+aQD6yvaYx578unLk0Gf6Y
         KTt7KMsOdomxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A62A2C395C5;
        Thu, 13 Apr 2023 07:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: qrtr: Fix an uninit variable access bug in
 qrtr_tx_resume()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168137221767.12270.4741360777654214045.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 07:50:17 +0000
References: <20230410012352.3997823-1-william.xuanziyang@huawei.com>
In-Reply-To: <20230410012352.3997823-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan (William) <william.xuanziyang@huawei.com>
Cc:     mani@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 10 Apr 2023 09:23:52 +0800 you wrote:
> Syzbot reported a bug as following:
> 
> =====================================================
> BUG: KMSAN: uninit-value in qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
>  qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
>  qrtr_endpoint_post+0xf85/0x11b0 net/qrtr/af_qrtr.c:519
>  qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
>  call_write_iter include/linux/fs.h:2189 [inline]
>  aio_write+0x63a/0x950 fs/aio.c:1600
>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>  __do_sys_io_submit fs/aio.c:2078 [inline]
>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [net,v2] net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()
    https://git.kernel.org/netdev/net/c/6417070918de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


