Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B260F117948
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfLIW0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:26:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfLIW0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:26:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B885154925CD;
        Mon,  9 Dec 2019 14:26:53 -0800 (PST)
Date:   Mon, 09 Dec 2019 14:26:53 -0800 (PST)
Message-Id: <20191209.142653.1925547187942224188.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, ivan.khoronzhuk@linaro.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: davinci_cpdma: fix warning "device
 driver frees DMA memory with different size"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209111924.22555-1-grygorii.strashko@ti.com>
References: <20191209111924.22555-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 14:26:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Mon, 9 Dec 2019 13:19:24 +0200

> The TI CPSW(s) driver produces warning with DMA API debug options enabled:
> 
> WARNING: CPU: 0 PID: 1033 at kernel/dma/debug.c:1025 check_unmap+0x4a8/0x968
> DMA-API: cpsw 48484000.ethernet: device driver frees DMA memory with different size
>  [device address=0x00000000abc6aa02] [map size=64 bytes] [unmap size=42 bytes]
> CPU: 0 PID: 1033 Comm: ping Not tainted 5.3.0-dirty #41
> Hardware name: Generic DRA72X (Flattened Device Tree)
> [<c0112c60>] (unwind_backtrace) from [<c010d270>] (show_stack+0x10/0x14)
> [<c010d270>] (show_stack) from [<c09bc564>] (dump_stack+0xd8/0x110)
> [<c09bc564>] (dump_stack) from [<c013b93c>] (__warn+0xe0/0x10c)
> [<c013b93c>] (__warn) from [<c013b9ac>] (warn_slowpath_fmt+0x44/0x6c)
> [<c013b9ac>] (warn_slowpath_fmt) from [<c01e0368>] (check_unmap+0x4a8/0x968)
> [<c01e0368>] (check_unmap) from [<c01e08a8>] (debug_dma_unmap_page+0x80/0x90)
> [<c01e08a8>] (debug_dma_unmap_page) from [<c0752414>] (__cpdma_chan_free+0x114/0x16c)
> [<c0752414>] (__cpdma_chan_free) from [<c07525c4>] (__cpdma_chan_process+0x158/0x17c)
> [<c07525c4>] (__cpdma_chan_process) from [<c0753690>] (cpdma_chan_process+0x3c/0x5c)
> [<c0753690>] (cpdma_chan_process) from [<c0758660>] (cpsw_tx_mq_poll+0x48/0x94)
> [<c0758660>] (cpsw_tx_mq_poll) from [<c0803018>] (net_rx_action+0x108/0x4e4)
> [<c0803018>] (net_rx_action) from [<c010230c>] (__do_softirq+0xec/0x598)
> [<c010230c>] (__do_softirq) from [<c0143914>] (do_softirq.part.4+0x68/0x74)
> [<c0143914>] (do_softirq.part.4) from [<c0143a44>] (__local_bh_enable_ip+0x124/0x17c)
> [<c0143a44>] (__local_bh_enable_ip) from [<c0871590>] (ip_finish_output2+0x294/0xb7c)
> [<c0871590>] (ip_finish_output2) from [<c0875440>] (ip_output+0x210/0x364)
> [<c0875440>] (ip_output) from [<c0875e2c>] (ip_send_skb+0x1c/0xf8)
> [<c0875e2c>] (ip_send_skb) from [<c08a7fd4>] (raw_sendmsg+0x9a8/0xc74)
> [<c08a7fd4>] (raw_sendmsg) from [<c07d6b90>] (sock_sendmsg+0x14/0x24)
> [<c07d6b90>] (sock_sendmsg) from [<c07d8260>] (__sys_sendto+0xbc/0x100)
> [<c07d8260>] (__sys_sendto) from [<c01011ac>] (__sys_trace_return+0x0/0x14)
> Exception stack(0xea9a7fa8 to 0xea9a7ff0)
> ...
> 
> The reason is that cpdma_chan_submit_si() now stores original buffer length
> (sw_len) in CPDMA descriptor instead of adjusted buffer length (hw_len)
> used to map the buffer.
> 
> Hence, fix an issue by passing correct buffer length in CPDMA descriptor.
> 
> Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> Fixes: 6670acacd59e ("net: ethernet: ti: davinci_cpdma: add dma mapped submit")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> changes in v3:
>  - removed swlen local var

Applied and queued up for -stable, thanks.
