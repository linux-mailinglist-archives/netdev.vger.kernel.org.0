Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ECD30B535
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBBCYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhBBCYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:24:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B22864ECB;
        Tue,  2 Feb 2021 02:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612232646;
        bh=P2K4uqWqOgM8BRdDM+SUm3etBfFucpbuBx9Lm3oMfqM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=blDv/8zvyb5jdCI1d+ltgsGLoFDNoPlQBRaYXa26cEEUEVzBce+VeXccjaabLM1eo
         dOkuOh1mjBQpNW3xEwDdgpWSnXiVWslRkAWmktXdJNVxwU3ETUZUuNeqhCJeDJHQih
         dU+J89a4oro+qW2Lol7g9m8uK7GQq8GkqbucFMJdJQU4SIziKZuyTK8z07eBnJ0m9k
         593QDTezXBshZkcdrhTWVSpUb72JgQPTDZAMVSYYQkoGJlOAO3HYifbgq1pupeqR4i
         jzwf6FwYxlRxEn5Undi3xaSnm1eyusoKCsALgJjZzD49r6XMJu7NPkLEBaySA+knaa
         aGYTnN7Tjfkmw==
Date:   Mon, 1 Feb 2021 18:24:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
Message-ID: <20210201182404.4ac54542@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129002136.70865-1-weiwan@google.com>
References: <20210129002136.70865-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 16:21:36 -0800 Wei Wang wrote:
> With the implementation of napi-tx in virtio driver, we clean tx
> descriptors from rx napi handler, for the purpose of reducing tx
> complete interrupts. But this could introduce a race where tx complete
> interrupt has been raised, but the handler found there is no work to do
> because we have done the work in the previous rx interrupt handler.
> This could lead to the following warning msg:
> [ 3588.010778] irq 38: nobody cared (try booting with the
> "irqpoll" option)
> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> 5.3.0-19-generic #20~18.04.2-Ubuntu
> [ 3588.017940] Call Trace:
> [ 3588.017942]  <IRQ>
> [ 3588.017951]  dump_stack+0x63/0x85
> [ 3588.017953]  __report_bad_irq+0x35/0xc0
> [ 3588.017955]  note_interrupt+0x24b/0x2a0
> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> [ 3588.017957]  handle_irq_event+0x3b/0x60
> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> [ 3588.017961]  handle_irq+0x20/0x30
> [ 3588.017964]  do_IRQ+0x50/0xe0
> [ 3588.017966]  common_interrupt+0xf/0xf
> [ 3588.017966]  </IRQ>
> [ 3588.017989] handlers:
> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> [ 3588.025099] Disabling IRQ #38
> 
> This patch adds a new param to struct vring_virtqueue, and we set it for
> tx virtqueues if napi-tx is enabled, to suppress the warning in such
> case.
> 
> Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> Reported-by: Rick Jones <jonesrick@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Michael, Jason, does this one look okay to you?
