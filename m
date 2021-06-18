Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFF03AC931
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhFRKzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:55:14 -0400
Received: from first.geanix.com ([116.203.34.67]:53890 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230437AbhFRKym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 06:54:42 -0400
Received: from localhost (80-62-117-165-mobile.dk.customer.tdc.net [80.62.117.165])
        by first.geanix.com (Postfix) with ESMTPSA id E13034C3657;
        Fri, 18 Jun 2021 10:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1624013551; bh=AhyE6isg6VavideXUV32Ga9HpCHHdtL8iBqEJ8xAQ6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IBx7ezM/tE3xoRjX27fCXGRC6JiArooX8DWHvrAmbc5gsTw9UGnifXZ/PUnf17VS8
         LL45QuuEQM7jgugfFVuGNSrYphhFALh2z5m+CUNW9dS7fFFxiMADwNq7cjdBwtYOcO
         vA3b7VqQ9snsOZ3nqWo9OlpWBB1lGf5E4AELnxbM/BCbXNADpTv+Hh/fFF9BK86O1K
         a8Nkr4kN6tRAVoQtpRFsP+16OnqOn4rui7XFCfn7EQ0D66cDSGvaEeqJEeB0O2x/LV
         pFOl/ajZfNBseSyssqyr0/XyzyYTD4MEQpRz09wOximhLXBRZMsEID4e9ZYxOyqdA6
         wzhGIdKwl7ANg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Michael Walle <michael@walle.cc>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Wang Hai <wanghai38@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] net: ll_temac: Add memory-barriers for TX BD access
Date:   Fri, 18 Jun 2021 12:52:28 +0200
Message-Id: <ac97150d7ba16b2145edfe77e377bd5e467735ff.1624013456.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
References: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple of memory-barriers to ensure correct ordering of read/write
access to TX BDs.

In xmit_done, we should ensure that reading the additional BD fields are
only done after STS_CTRL_APP0_CMPLT bit is set.

When xmit_done marks the BD as free by setting APP0=0, we need to ensure
that the other BD fields are reset first, so we avoid racing with the xmit
path, which writes to the same fields.

Finally, making sure to read APP0 of next BD after the current BD, ensures
that we see all available buffers.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index e82f162cd80c..9797aa3221d1 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -774,12 +774,15 @@ static void temac_start_xmit_done(struct net_device *ndev)
 	stat = be32_to_cpu(cur_p->app0);
 
 	while (stat & STS_CTRL_APP0_CMPLT) {
+		/* Make sure that the other fields are read after bd is
+		 * released by dma
+		 */
+		rmb();
 		dma_unmap_single(ndev->dev.parent, be32_to_cpu(cur_p->phys),
 				 be32_to_cpu(cur_p->len), DMA_TO_DEVICE);
 		skb = (struct sk_buff *)ptr_from_txbd(cur_p);
 		if (skb)
 			dev_consume_skb_irq(skb);
-		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
 		cur_p->app3 = 0;
@@ -788,6 +791,12 @@ static void temac_start_xmit_done(struct net_device *ndev)
 		ndev->stats.tx_packets++;
 		ndev->stats.tx_bytes += be32_to_cpu(cur_p->len);
 
+		/* app0 must be visible last, as it is used to flag
+		 * availability of the bd
+		 */
+		smp_mb();
+		cur_p->app0 = 0;
+
 		lp->tx_bd_ci++;
 		if (lp->tx_bd_ci >= lp->tx_bd_num)
 			lp->tx_bd_ci = 0;
@@ -814,6 +823,9 @@ static inline int temac_check_tx_bd_space(struct temac_local *lp, int num_frag)
 		if (cur_p->app0)
 			return NETDEV_TX_BUSY;
 
+		/* Make sure to read next bd app0 after this one */
+		rmb();
+
 		tail++;
 		if (tail >= lp->tx_bd_num)
 			tail = 0;
-- 
2.32.0

