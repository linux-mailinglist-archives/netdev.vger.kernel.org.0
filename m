Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BF12657C2
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 05:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgIKD6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 23:58:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11811 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725283AbgIKD6Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 23:58:25 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 98578750294870E6A356;
        Fri, 11 Sep 2020 11:58:23 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Sep 2020
 11:58:17 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: stmmac: set get_rx_header_len() as void for it didn't have any error code to return
Date:   Fri, 11 Sep 2020 11:55:58 +0800
Message-ID: <1599796558-45818-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found the following warning when using W=1 to build kernel:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3634:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
int ret, coe = priv->hw->rx_csum;

When digging stmmac_get_rx_header_len(), dwmac4_get_rx_header_len() and
dwxgmac2_get_rx_header_len() return 0 only, without any error code to
report. Therefore, it's better to define get_rx_header_len() as void.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c   | 3 +--
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 +--
 drivers/net/ethernet/stmicro/stmmac/hwif.h           | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    | 4 ++--
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index eff8206..c6540b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -494,10 +494,9 @@ static void dwmac4_set_vlan(struct dma_desc *p, u32 type)
 	p->des2 |= cpu_to_le32(type & TDES2_VLAN_TAG_MASK);
 }
 
-static int dwmac4_get_rx_header_len(struct dma_desc *p, unsigned int *len)
+static void dwmac4_get_rx_header_len(struct dma_desc *p, unsigned int *len)
 {
 	*len = le32_to_cpu(p->des2) & RDES2_HL;
-	return 0;
 }
 
 static void dwmac4_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index c3d654c..0aaf19a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -286,11 +286,10 @@ static int dwxgmac2_get_rx_hash(struct dma_desc *p, u32 *hash,
 	return -EINVAL;
 }
 
-static int dwxgmac2_get_rx_header_len(struct dma_desc *p, unsigned int *len)
+static void dwxgmac2_get_rx_header_len(struct dma_desc *p, unsigned int *len)
 {
 	if (le32_to_cpu(p->des3) & XGMAC_RDES3_L34T)
 		*len = le32_to_cpu(p->des2) & XGMAC_RDES2_HL;
-	return 0;
 }
 
 static void dwxgmac2_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index ffe2d63..e2dca9b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -90,7 +90,7 @@ struct stmmac_desc_ops {
 	/* RSS */
 	int (*get_rx_hash)(struct dma_desc *p, u32 *hash,
 			   enum pkt_hash_types *type);
-	int (*get_rx_header_len)(struct dma_desc *p, unsigned int *len);
+	void (*get_rx_header_len)(struct dma_desc *p, unsigned int *len);
 	void (*set_sec_addr)(struct dma_desc *p, dma_addr_t addr);
 	void (*set_sarc)(struct dma_desc *p, u32 sarc_type);
 	void (*set_vlan_tag)(struct dma_desc *p, u16 tag, u16 inner_tag,
@@ -150,7 +150,7 @@ struct stmmac_desc_ops {
 #define stmmac_get_rx_hash(__priv, __args...) \
 	stmmac_do_callback(__priv, desc, get_rx_hash, __args)
 #define stmmac_get_rx_header_len(__priv, __args...) \
-	stmmac_do_callback(__priv, desc, get_rx_header_len, __args)
+	stmmac_do_void_callback(__priv, desc, get_rx_header_len, __args)
 #define stmmac_set_desc_sec_addr(__priv, __args...) \
 	stmmac_do_void_callback(__priv, desc, set_sec_addr, __args)
 #define stmmac_set_desc_sarc(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89b2b34..7e95412 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3631,15 +3631,15 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 				       struct dma_desc *p,
 				       int status, unsigned int len)
 {
-	int ret, coe = priv->hw->rx_csum;
 	unsigned int plen = 0, hlen = 0;
+	int coe = priv->hw->rx_csum;
 
 	/* Not first descriptor, buffer is always zero */
 	if (priv->sph && len)
 		return 0;
 
 	/* First descriptor, get split header length */
-	ret = stmmac_get_rx_header_len(priv, p, &hlen);
+	stmmac_get_rx_header_len(priv, p, &hlen);
 	if (priv->sph && hlen) {
 		priv->xstats.rx_split_hdr_pkt_n++;
 		return hlen;
-- 
2.7.4

