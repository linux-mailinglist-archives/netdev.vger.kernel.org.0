Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF07C12B892
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfL0R43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727700AbfL0RmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF8F22525;
        Fri, 27 Dec 2019 17:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468520;
        bh=H/c2RXbV3YqiPEXgtVF8jWTUDngMsg0srTo73SONCKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwuCskXeHvYC5TmOZrfjM0S/XQotgTb8p4A3MIOiUozpe0yJVqcwxurLhasYEvUzz
         c9oHzamhmAEkIYz2s5uUU/71bhnzggOmGOHFlaCR9n4Tu+MF+9s5uMaHO7R39le2Ud
         xIAkGuoR4f0zTDH9QZaliI6JXpHN70uLv7bMfXcw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 052/187] net: ethernet: ti: davinci_cpdma: fix warning "device driver frees DMA memory with different size"
Date:   Fri, 27 Dec 2019 12:38:40 -0500
Message-Id: <20191227174055.4923-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 8a2b22203f8596729c54eba221b4044351bfe167 ]

The TI CPSW(s) driver produces warning with DMA API debug options enabled:

WARNING: CPU: 0 PID: 1033 at kernel/dma/debug.c:1025 check_unmap+0x4a8/0x968
DMA-API: cpsw 48484000.ethernet: device driver frees DMA memory with different size
 [device address=0x00000000abc6aa02] [map size=64 bytes] [unmap size=42 bytes]
CPU: 0 PID: 1033 Comm: ping Not tainted 5.3.0-dirty #41
Hardware name: Generic DRA72X (Flattened Device Tree)
[<c0112c60>] (unwind_backtrace) from [<c010d270>] (show_stack+0x10/0x14)
[<c010d270>] (show_stack) from [<c09bc564>] (dump_stack+0xd8/0x110)
[<c09bc564>] (dump_stack) from [<c013b93c>] (__warn+0xe0/0x10c)
[<c013b93c>] (__warn) from [<c013b9ac>] (warn_slowpath_fmt+0x44/0x6c)
[<c013b9ac>] (warn_slowpath_fmt) from [<c01e0368>] (check_unmap+0x4a8/0x968)
[<c01e0368>] (check_unmap) from [<c01e08a8>] (debug_dma_unmap_page+0x80/0x90)
[<c01e08a8>] (debug_dma_unmap_page) from [<c0752414>] (__cpdma_chan_free+0x114/0x16c)
[<c0752414>] (__cpdma_chan_free) from [<c07525c4>] (__cpdma_chan_process+0x158/0x17c)
[<c07525c4>] (__cpdma_chan_process) from [<c0753690>] (cpdma_chan_process+0x3c/0x5c)
[<c0753690>] (cpdma_chan_process) from [<c0758660>] (cpsw_tx_mq_poll+0x48/0x94)
[<c0758660>] (cpsw_tx_mq_poll) from [<c0803018>] (net_rx_action+0x108/0x4e4)
[<c0803018>] (net_rx_action) from [<c010230c>] (__do_softirq+0xec/0x598)
[<c010230c>] (__do_softirq) from [<c0143914>] (do_softirq.part.4+0x68/0x74)
[<c0143914>] (do_softirq.part.4) from [<c0143a44>] (__local_bh_enable_ip+0x124/0x17c)
[<c0143a44>] (__local_bh_enable_ip) from [<c0871590>] (ip_finish_output2+0x294/0xb7c)
[<c0871590>] (ip_finish_output2) from [<c0875440>] (ip_output+0x210/0x364)
[<c0875440>] (ip_output) from [<c0875e2c>] (ip_send_skb+0x1c/0xf8)
[<c0875e2c>] (ip_send_skb) from [<c08a7fd4>] (raw_sendmsg+0x9a8/0xc74)
[<c08a7fd4>] (raw_sendmsg) from [<c07d6b90>] (sock_sendmsg+0x14/0x24)
[<c07d6b90>] (sock_sendmsg) from [<c07d8260>] (__sys_sendto+0xbc/0x100)
[<c07d8260>] (__sys_sendto) from [<c01011ac>] (__sys_trace_return+0x0/0x14)
Exception stack(0xea9a7fa8 to 0xea9a7ff0)
...

The reason is that cpdma_chan_submit_si() now stores original buffer length
(sw_len) in CPDMA descriptor instead of adjusted buffer length (hw_len)
used to map the buffer.

Hence, fix an issue by passing correct buffer length in CPDMA descriptor.

Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Fixes: 6670acacd59e ("net: ethernet: ti: davinci_cpdma: add dma mapped submit")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 37ba708ac781..6614fa3089b2 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -1018,7 +1018,6 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 	struct cpdma_chan		*chan = si->chan;
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
 	int				len = si->len;
-	int				swlen = len;
 	struct cpdma_desc __iomem	*desc;
 	dma_addr_t			buffer;
 	u32				mode;
@@ -1046,7 +1045,6 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 	if (si->data_dma) {
 		buffer = si->data_dma;
 		dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);
-		swlen |= CPDMA_DMA_EXT_MAP;
 	} else {
 		buffer = dma_map_single(ctlr->dev, si->data_virt, len, chan->dir);
 		ret = dma_mapping_error(ctlr->dev, buffer);
@@ -1065,7 +1063,8 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 	writel_relaxed(mode | len, &desc->hw_mode);
 	writel_relaxed((uintptr_t)si->token, &desc->sw_token);
 	writel_relaxed(buffer, &desc->sw_buffer);
-	writel_relaxed(swlen, &desc->sw_len);
+	writel_relaxed(si->data_dma ? len | CPDMA_DMA_EXT_MAP : len,
+		       &desc->sw_len);
 	desc_read(desc, sw_len);
 
 	__cpdma_chan_submit(chan, desc);
-- 
2.20.1

