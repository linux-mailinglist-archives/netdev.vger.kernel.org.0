Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9990A5F0268
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 03:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiI3Bu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 21:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiI3BuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 21:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E350EFADB9;
        Thu, 29 Sep 2022 18:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F94062209;
        Fri, 30 Sep 2022 01:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA323C433D6;
        Fri, 30 Sep 2022 01:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664502614;
        bh=U/wl4sfOCbRmnbRe8Qdj9wn6w23xnk8ijjxkRXD1rvs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DytHIQjq7M7MQq1AAM0pvvoqGiynchRzt5mXZorP9D7gLRbq0TxD5z34vdqaXUxoF
         5qZNxgkz7VdGAAwV9v3LNHs6Hxvj0nid/aE+vKftVw4vCBYIH4VdXEdJbIOKoH1ZZt
         nKEVlEt56HsJ9JFvgCMZwslcw7MH8AvUbPlUvI14lgHX0xfU7JN/MnqU5kDUY2Vb1J
         zyG3aBCj9R3AIZk1ytQEAXcJNG+ECVTcdWInXlEXShd+ZUdKWv4J34/JY6pegdp7Tw
         quBDWGW8k8DJdI9xdscmkMCAASb7XGUCdK8eueTQMX29Yy39WSbTXAzn7Osps68Ne5
         /EG83Z+zxlrMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9496C395DA;
        Fri, 30 Sep 2022 01:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450261468.15562.8337973902056212950.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 01:50:14 +0000
References: <20220928064538.667678-1-uekawa@chromium.org>
In-Reply-To: <20220928064538.667678-1-uekawa@chromium.org>
To:     =?utf-8?b?SnVuaWNoaSBVZWthd2EgKOS4iuW3nee0lOS4gCkgPHVla2F3YUBjaHJvbWl1bS5v?=@ci.codeaurora.org,
        =?utf-8?b?cmc+?=@ci.codeaurora.org
Cc:     stefanha@redhat.com, sgarzare@redhat.com, jasowang@redhat.com,
        edumazet@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, mst@redhat.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 28 Sep 2022 15:45:38 +0900 you wrote:
> When copying a large file over sftp over vsock, data size is usually 32kB,
> and kmalloc seems to fail to try to allocate 32 32kB regions.
> 
>  Call Trace:
>   [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
>   [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
>   [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
>   [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
>   [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
>   [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
>   [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
>   [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
>   [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
>   [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
>   [<ffffffffb683ddce>] kthread+0xfd/0x105
>   [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
>   [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
>   [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
>   [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> 
> [...]

Here is the summary with links:
  - vhost/vsock: Use kvmalloc/kvfree for larger packets.
    https://git.kernel.org/netdev/net/c/0e3f72931fc4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


