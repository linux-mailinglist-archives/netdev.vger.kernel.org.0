Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF1834D159
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhC2Ng7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:36:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:45673 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231571AbhC2Ng1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 09:36:27 -0400
IronPort-SDR: 9u1ZPvYnGTYfOj67oW/8BHx6bFs0SUZqqFlqQtcri3Twpu8s4WYhkI9jzNbGD9uI3XjGegIvIq
 Of4VFa3H37hA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="191578695"
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="191578695"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 06:36:27 -0700
IronPort-SDR: +l9e/G6tHjwa1KuU/ooNwJpc6WXAW1rN2dalrWNZudQesddftnUyZxNu4rbH9wawqVDBTu4sbQ
 ugaEgoWhgP0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="411079330"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga008.fm.intel.com with ESMTP; 29 Mar 2021 06:36:22 -0700
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
Subject: [PATCH net-next 1/6] stmmac: intel: set IRQ affinity hint for multi MSI vectors
Date:   Mon, 29 Mar 2021 21:40:08 +0800
Message-Id: <20210329134013.9516-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210329134013.9516-1-boon.leong.ong@intel.com>
References: <20210329134013.9516-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel mGBE has independent hardware IRQ resources for TX and RX DMA
operation. In preparation to support XDP TX, we add IRQ affinity hint
to group both RX and TX queue of the same queue ID to the same CPU.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 08b4852eed4c..53a24932a192 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -810,6 +810,7 @@ static int stmmac_config_multi_msi(struct pci_dev *pdev,
 				   struct plat_stmmacenet_data *plat,
 				   struct stmmac_resources *res)
 {
+	cpumask_t cpu_mask;
 	int ret;
 	int i;
 
@@ -832,12 +833,18 @@ static int stmmac_config_multi_msi(struct pci_dev *pdev,
 	for (i = 0; i < plat->rx_queues_to_use; i++) {
 		res->rx_irq[i] = pci_irq_vector(pdev,
 						plat->msi_rx_base_vec + i * 2);
+		cpumask_clear(&cpu_mask);
+		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
+		irq_set_affinity_hint(res->rx_irq[i], &cpu_mask);
 	}
 
 	/* For TX MSI */
 	for (i = 0; i < plat->tx_queues_to_use; i++) {
 		res->tx_irq[i] = pci_irq_vector(pdev,
 						plat->msi_tx_base_vec + i * 2);
+		cpumask_clear(&cpu_mask);
+		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
+		irq_set_affinity_hint(res->tx_irq[i], &cpu_mask);
 	}
 
 	if (plat->msi_mac_vec < STMMAC_MSI_VEC_MAX)
-- 
2.25.1

