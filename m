Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4668234DEA2
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhC3CqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:46:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:37058 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231144AbhC3Cpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 22:45:51 -0400
IronPort-SDR: jjX9tyj0WzMRNlpPbn9BRWYFBcN/0SIo+Lst8Qmnwb7qO31S3CfqZBT3i9YIgtBVqkKgvFcR5w
 +WJTB+PmAoCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179213530"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="179213530"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 19:45:50 -0700
IronPort-SDR: WwtgGCGjHhhxsLy+blmwUzPGTu8DQcCYTgJ6SoIxHddvSmAqBG3G0z/NyLOEIRDgcjgDWMlpCP
 wZ2UsbzG534g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="606598458"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2021 19:45:46 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 1/6] net: stmmac: set IRQ affinity hint for multi MSI vectors
Date:   Tue, 30 Mar 2021 10:49:44 +0800
Message-Id: <20210330024949.14010-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330024949.14010-1-boon.leong.ong@intel.com>
References: <20210330024949.14010-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain platform likes Intel mGBE has independent hardware IRQ resources
for TX and RX DMA operation. In preparation to support XDP TX, we add IRQ
affinity hint to group both RX and TX queue of the same queue ID to the
same CPU.

Changes in v2:
 - IRQ affinity hint need to set to null before IRQ is released.
   Thanks to issue reported by Song, Yoong Siang.

Reported-by: Song, Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d34388b1ffcc..9d63e8c365ae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3005,15 +3005,19 @@ static void stmmac_free_irq(struct net_device *dev,
 		fallthrough;
 	case REQ_IRQ_ERR_TX:
 		for (j = irq_idx - 1; j >= 0; j--) {
-			if (priv->tx_irq[j] > 0)
+			if (priv->tx_irq[j] > 0) {
+				irq_set_affinity_hint(priv->tx_irq[j], NULL);
 				free_irq(priv->tx_irq[j], &priv->tx_queue[j]);
+			}
 		}
 		irq_idx = priv->plat->rx_queues_to_use;
 		fallthrough;
 	case REQ_IRQ_ERR_RX:
 		for (j = irq_idx - 1; j >= 0; j--) {
-			if (priv->rx_irq[j] > 0)
+			if (priv->rx_irq[j] > 0) {
+				irq_set_affinity_hint(priv->rx_irq[j], NULL);
 				free_irq(priv->rx_irq[j], &priv->rx_queue[j]);
+			}
 		}
 
 		if (priv->sfty_ue_irq > 0 && priv->sfty_ue_irq != dev->irq)
@@ -3045,6 +3049,7 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 {
 	enum request_irq_err irq_err = REQ_IRQ_ERR_NO;
 	struct stmmac_priv *priv = netdev_priv(dev);
+	cpumask_t cpu_mask;
 	int irq_idx = 0;
 	char *int_name;
 	int ret;
@@ -3153,6 +3158,9 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 			irq_idx = i;
 			goto irq_error;
 		}
+		cpumask_clear(&cpu_mask);
+		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
+		irq_set_affinity_hint(priv->rx_irq[i], &cpu_mask);
 	}
 
 	/* Request Tx MSI irq */
@@ -3173,6 +3181,9 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 			irq_idx = i;
 			goto irq_error;
 		}
+		cpumask_clear(&cpu_mask);
+		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
+		irq_set_affinity_hint(priv->tx_irq[i], &cpu_mask);
 	}
 
 	return 0;
-- 
2.25.1

