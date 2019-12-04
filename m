Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6FC113041
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 17:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfLDQug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 11:50:36 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45716 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDQug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 11:50:36 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4GoWR6091288;
        Wed, 4 Dec 2019 10:50:32 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575478232;
        bh=Fsq/sOp9KxxrreLSU1uAKOD6Ws/kWQRUU7rs0e7O1Bo=;
        h=From:To:CC:Subject:Date;
        b=Vrj2vo2Wt5iBs7dHFyOKFXF945VyQsaQIbLcJq/GHeEgC+RhsoC5NtspRH0zPNfZr
         9zhpTathXj2IHuY+KvFjHMiB8tv3klK5JOLDxXin8j6kjdUIhIOwDt9uSKVyOxXKsN
         2LsxfeWzftkirh/mvaokktXA5bBVCAY1G+CTqDB4=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4GoWDC036211;
        Wed, 4 Dec 2019 10:50:32 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 10:50:32 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 10:50:32 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4GoV8Q046172;
        Wed, 4 Dec 2019 10:50:32 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2] net: ethernet: ti: davinci_cpdma: fix warning "device driver frees DMA memory with different size"
Date:   Wed, 4 Dec 2019 18:50:29 +0200
Message-ID: <20191204165029.9264-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 37ba708ac781..f30a9b9c78a7 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -1018,7 +1018,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 	struct cpdma_chan		*chan = si->chan;
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
 	int				len = si->len;
-	int				swlen = len;
+	int				swlen;
 	struct cpdma_desc __iomem	*desc;
 	dma_addr_t			buffer;
 	u32				mode;
@@ -1040,6 +1040,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 		chan->stats.runt_transmit_buff++;
 	}
 
+	swlen = len;
 	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
 	cpdma_desc_to_port(chan, mode, si->directed);
 
-- 
2.17.1

