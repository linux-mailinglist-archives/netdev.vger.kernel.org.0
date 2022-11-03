Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7F617535
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiKCDuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKCDuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E2F1573A;
        Wed,  2 Nov 2022 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6894E61D24;
        Thu,  3 Nov 2022 03:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD7F6C433C1;
        Thu,  3 Nov 2022 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447416;
        bh=meTwYXASJuCUJQoFrRar/pHDoiFT1xzFnZQzg2tg+c0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bJe77gwAu4c1jrj1HEoDhaxypOOXlsn8CWcgDTbIqEY4een6TagjWmsRCLWmUpN2s
         za5XLyR6kxmTc+bEMJwZEvrAFmC38p/cadjp4gRJM38QcXd8F2+MaZfMNIv7/fuyHk
         NiXf9rpdSHHdaeIBsw3dzsbMTTfTM6YNXjV6s89Qxzfz0I1NKslavhz3Uxata3aSMJ
         i9haajZqbWbpVCXG3B4zYHPXzSQBGmkey8Rgihb/fVRdxFC5H6mhlwOD/ndYv5Tasn
         BSRBwSKE+T6Aqh9Ald+3b3Ze/3ghPQsvw63/JZjsPakF23swg7MVrTBM27aSxQF2kp
         DMpZakNqq67aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87577E270D3;
        Thu,  3 Nov 2022 03:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net, neigh: Fix null-ptr-deref in neigh_table_clear()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744741655.12191.13515055087737354526.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:50:16 +0000
References: <20221101121552.21890-1-chenzhongjin@huawei.com>
In-Reply-To: <20221101121552.21890-1-chenzhongjin@huawei.com>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, daniel@iogearbox.net,
        yangyingliang@huawei.com, stephen@networkplumber.org,
        wangyuweihx@gmail.com, alexander.mikhalitsyn@virtuozzo.com,
        den@openvz.org, xu.xin16@zte.com.cn
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 1 Nov 2022 20:15:52 +0800 you wrote:
> When IPv6 module gets initialized but hits an error in the middle,
> kenel panic with:
> 
> KASAN: null-ptr-deref in range [0x0000000000000598-0x000000000000059f]
> CPU: 1 PID: 361 Comm: insmod
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
> RIP: 0010:__neigh_ifdown.isra.0+0x24b/0x370
> RSP: 0018:ffff888012677908 EFLAGS: 00000202
> ...
> Call Trace:
>  <TASK>
>  neigh_table_clear+0x94/0x2d0
>  ndisc_cleanup+0x27/0x40 [ipv6]
>  inet6_init+0x21c/0x2cb [ipv6]
>  do_one_initcall+0xd3/0x4d0
>  do_init_module+0x1ae/0x670
> ...
> Kernel panic - not syncing: Fatal exception
> 
> [...]

Here is the summary with links:
  - [net] net, neigh: Fix null-ptr-deref in neigh_table_clear()
    https://git.kernel.org/netdev/net/c/f8017317cb0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


