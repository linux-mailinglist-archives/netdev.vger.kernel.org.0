Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A880369B38
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbhDWUUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232573AbhDWUUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 16:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 248D5613D8;
        Fri, 23 Apr 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619209209;
        bh=KwpXWDR6RptZH5/aOZxZIkSEc3jGxMZvt+O46FNQknU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PgdIOH2NPa1xDWUTqhwpFfQn2sutyJ7+Y8/GdORyNt4nzQPMbumHIBz2K5wgwU3FS
         5Cru6igETvQEGLTEjdWBUeun0T90IOxc2TcJIJ1lE6Yn6eIPQUd6el8/50cMx127+j
         dLGKfGAdx4pgniyAol2gXJgfYdnsHt42sDkTNmpHbNgtgOvl49zz/0ODHLIQbPbt3A
         S+cwHlwzIyBspKJidvgPxwpScvL4viKEGMBbWm5QwXVp0xtaveEAKEpsTlUGVeWbnH
         YSHLQCaA61MfNVg7vcxStXqNJzVeiIRzuM+51px4PLc+Sd2TfneQ3HzB5zFPC7rKZo
         DAdp9GR7+PRAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1770560976;
        Fri, 23 Apr 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in skb_gro_receive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161920920909.3258.367904620770720568.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 20:20:09 +0000
References: <20210422151620.58204-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210422151620.58204-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 23:16:20 +0800 you wrote:
> When "headroom" > 0, the actual allocated memory space is the entire
> page, so the address of the page should be used when passing it to
> build_skb().
> 
> BUG: KASAN: use-after-free in skb_gro_receive (net/core/skbuff.c:4260)
> Write of size 16 at addr ffff88811619fffc by task kworker/u9:0/534
> CPU: 2 PID: 534 Comm: kworker/u9:0 Not tainted 5.12.0-rc7-custom-16372-gb150be05b806 #3382
> Hardware name: QEMU MSN2700, BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> Workqueue: xprtiod xs_stream_data_receive_workfn [sunrpc]
> Call Trace:
>  <IRQ>
> dump_stack (lib/dump_stack.c:122)
> print_address_description.constprop.0 (mm/kasan/report.c:233)
> kasan_report.cold (mm/kasan/report.c:400 mm/kasan/report.c:416)
> skb_gro_receive (net/core/skbuff.c:4260)
> tcp_gro_receive (net/ipv4/tcp_offload.c:266 (discriminator 1))
> tcp4_gro_receive (net/ipv4/tcp_offload.c:316)
> inet_gro_receive (net/ipv4/af_inet.c:1545 (discriminator 2))
> dev_gro_receive (net/core/dev.c:6075)
> napi_gro_receive (net/core/dev.c:6168 net/core/dev.c:6198)
> receive_buf (drivers/net/virtio_net.c:1151) virtio_net
> virtnet_poll (drivers/net/virtio_net.c:1415 drivers/net/virtio_net.c:1519) virtio_net
> __napi_poll (net/core/dev.c:6964)
> net_rx_action (net/core/dev.c:7033 net/core/dev.c:7118)
> __do_softirq (./arch/x86/include/asm/jump_label.h:25 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:346)
> irq_exit_rcu (kernel/softirq.c:221 kernel/softirq.c:422 kernel/softirq.c:434)
> common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 14))
> </IRQ>
> 
> [...]

Here is the summary with links:
  - [net-next] virtio-net: fix use-after-free in skb_gro_receive
    https://git.kernel.org/netdev/net-next/c/f80bd740cb7c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


