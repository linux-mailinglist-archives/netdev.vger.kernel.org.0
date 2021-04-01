Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA40350C53
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 04:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhDACIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 22:08:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:60202 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232763AbhDACHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 22:07:40 -0400
IronPort-SDR: JI0WbZMMaT8qjAHFVCxm0w2NjIfhfDfnQjOmKR6voDQM+8Gao5tK/Fc37ZMuId5M7lQaIVhKYD
 fmU+m1KfQq1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="212379990"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="212379990"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 19:07:40 -0700
IronPort-SDR: crsTts9aLDE4bskpm+aZ6m/kptAmCNFNvl5HOc6p3fhGMKCM6OGoygriVMZHQGhsmz0ZCg5y59
 IiBH9hQjmTvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="528004198"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga004.jf.intel.com with ESMTP; 31 Mar 2021 19:07:35 -0700
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
Subject: [PATCH net-next v4 1/6] net: stmmac: set IRQ affinity hint for multi MSI vectors
Date:   Thu,  1 Apr 2021 10:11:12 +0800
Message-Id: <20210401021117.13360-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401021117.13360-1-boon.leong.ong@intel.com>
References: <20210401021117.13360-1-boon.leong.ong@intel.com>
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

