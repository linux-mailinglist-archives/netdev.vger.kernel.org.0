Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112B660A7CE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 14:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiJXM6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 08:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiJXM5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 08:57:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B4E97D43
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 05:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ECC6612C9
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04188C433D6;
        Mon, 24 Oct 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666612215;
        bh=YIgtoT3+hcagjwMxPgwl1UZ4hx7tfXCV/RsKIoG6jOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BXjsWld/Hio4i5A4JS0BoBzZ94Jinents5Q/Wx1tGuoIuV7cc3RYmRhQR7dbB33q2
         nf9pFvia40xUJlHvx/fC1TFpc9CAQyGmpoQnrZ7eJN5Ckb+6pzFe2tjgXDXFETLj19
         Bu4rmoa60DZk9GY7szBkhe/SY/QhEsgppy9LhbJ/klSgks5PBT//vYYc/ozEF1LEux
         d8XNoYuIYecfmoj6UOLyhYEYDtg795Mm7j7bHS7/6r4/Sdp6BzKMPdJvypm4YUvECl
         9Yl8D5n6jr+z1RPKmu0oR0hSKDQUNAOu7L8sQZ3YkuGj1IRV+JiKVmkL/lYVxPIl6R
         iOkm1omTt6R7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9E57E270DD;
        Mon, 24 Oct 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fix UAF issue in nfqnl_nf_hook_drop() when
 ops_init() failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166661221488.6085.16932100870985132190.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 11:50:14 +0000
References: <20221020024213.264324-1-shaozhengchao@huawei.com>
In-Reply-To: <20221020024213.264324-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shakeelb@google.com,
        roman.gushchin@linux.dev, hmukos@yandex-team.ru, memxor@gmail.com,
        vasily.averin@linux.dev, ebiederm@xmission.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 10:42:13 +0800 you wrote:
> When the ops_init() interface is invoked to initialize the net, but
> ops->init() fails, data is released. However, the ptr pointer in
> net->gen is invalid. In this case, when nfqnl_nf_hook_drop() is invoked
> to release the net, invalid address access occurs.
> 
> The process is as follows:
> setup_net()
> 	ops_init()
> 		data = kzalloc(...)   ---> alloc "data"
> 		net_assign_generic()  ---> assign "date" to ptr in net->gen
> 		...
> 		ops->init()           ---> failed
> 		...
> 		kfree(data);          ---> ptr in net->gen is invalid
> 	...
> 	ops_exit_list()
> 		...
> 		nfqnl_nf_hook_drop()
> 			*q = nfnl_queue_pernet(net) ---> q is invalid
> 
> [...]

Here is the summary with links:
  - [net] net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed
    https://git.kernel.org/netdev/net/c/d266935ac43d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


