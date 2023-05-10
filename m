Return-Path: <netdev+bounces-1465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D006FDD5E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 215E72813A0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719D712B6B;
	Wed, 10 May 2023 12:02:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05298C18
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A2CC433D2;
	Wed, 10 May 2023 12:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683720142;
	bh=2ILLQ6Iy+EQzWADwWGcsm6vbdNQ9DyBgRr+4GFanAbk=;
	h=From:Date:Subject:To:Cc:From;
	b=HpMhmafbOlDyWZIxveCigP0xuhFOy8HViQyON8PLi3HjEfZABji4ECqMYVFjnH2n2
	 n7/hpNRN+9Co4yRNWsmI7sMnKSmz/rYhz1Z/yYQpm/Xfl2ms2XamoAuiKZAz1Lhb/r
	 0YsBRFNDw6a0PUqv+3Os6lI6JkW+QTZDXSehvrxyNp0Od71hp1UpgR8KNjuoClogT+
	 LQQDgDuF1PB8ftZJ9cbxkf4K2Q+WVJ0OyuRZWJBzEvl0wrxHf74T3rdo67NPWYWKMV
	 +OmsRvhyDDlKpKRy27m8Zi49uvtiEeCbhDX714psCe3hZm6FYFukPfZKlTDOzNrzYv
	 K42z9izut8sEA==
From: Simon Horman <horms@kernel.org>
Date: Wed, 10 May 2023 14:02:09 +0200
Subject: [PATCH RFC net-next] net: stmmac: dwmac-mediatek: Use integer
 values with FIELD_PREP
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230510-dwmac-mediatek-field_prep-v1-1-51c1f9291908@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMCHW2QC/x2NwQrCMBBEfyXs2YW0tdZ6LfgBXkUkTbZ2MV1LE
 rVQ+u8Gj2+YN7NCpMAU4aRWCPThyC/JUOwU2NHIg5BdZih1Wem60Oi+k7E4kWOT6IkDk3f3OdC
 MrWtsU++PpmoPkP3eRMI+GLFjXpC39znMzYGX/+EVLudOCSUUWhLctu0HR+QilY4AAAA=
To: Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Jose Abreu <joabreu@synopsys.com>, 
 Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
X-Mailer: b4 0.12.2

FIELD_PREP() takes two arguments, a mask and a value, both of
which are unsigned integers.

The dwmac-mediatek driver calls for filling in single bit enable fields
based on an wider integer value being 0 or non-zero.

Prior to this patch this is achieved using !!.  Sparse feels this is
dubious and I tend to agree because ! is a logical operator while
FIELD_PREP() deals with integers.

Address this by explicitly passing the integer values 0 and 1 to
FIELD_PREP. And as this is a bit repetitive, create a macro to help out.

Reported by sparse as follows:
 .../dwmac-mediatek.c:201:30: warning: dubious: x & !y
 .../dwmac-mediatek.c:205:30: warning: dubious: x & !y
 .../dwmac-mediatek.c:216:38: warning: dubious: x & !y
 .../dwmac-mediatek.c:220:38: warning: dubious: x & !y
 .../dwmac-mediatek.c:235:46: warning: dubious: x & !y
 .../dwmac-mediatek.c:243:46: warning: dubious: x & !y
 .../dwmac-mediatek.c:261:30: warning: dubious: x & !y
 .../dwmac-mediatek.c:265:30: warning: dubious: x & !y
 .../dwmac-mediatek.c:352:30: warning: dubious: x & !y
 .../dwmac-mediatek.c:356:30: warning: dubious: x & !y
 .../dwmac-mediatek.c:367:43: warning: dubious: x & !y
 .../dwmac-mediatek.c:374:43: warning: dubious: x & !y
 .../dwmac-mediatek.c:392:46: warning: dubious: x & !y
 .../dwmac-mediatek.c:403:46: warning: dubious: x & !y
 .../dwmac-mediatek.c:416:35: warning: dubious: x & !y
 .../dwmac-mediatek.c:420:30: warning: dubious: x & !y

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   | 54 ++++++++++++++--------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 73c1dfa7ecb1..a691abd52388 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -66,6 +66,8 @@
 #define MT8195_DLY_RMII_TXC_ENABLE	BIT(5)
 #define MT8195_DLY_RMII_TXC_STAGES	GENMASK(4, 0)
 
+#define MT8195_FIELD_ENABLE(_mask, _val) FIELD_PREP(_mask, _val ? 1UL : 0UL)
+
 struct mac_delay_struct {
 	u32 tx_delay;
 	u32 rx_delay;
@@ -198,11 +200,13 @@ static int mt2712_set_delay(struct mediatek_dwmac_plat_data *plat)
 
 	switch (plat->phy_mode) {
 	case PHY_INTERFACE_MODE_MII:
-		delay_val |= FIELD_PREP(ETH_DLY_TXC_ENABLE, !!mac_delay->tx_delay);
+		delay_val |= MT8195_FIELD_ENABLE(ETH_DLY_TXC_ENABLE,
+						 mac_delay->tx_delay);
 		delay_val |= FIELD_PREP(ETH_DLY_TXC_STAGES, mac_delay->tx_delay);
 		delay_val |= FIELD_PREP(ETH_DLY_TXC_INV, mac_delay->tx_inv);
 
-		delay_val |= FIELD_PREP(ETH_DLY_RXC_ENABLE, !!mac_delay->rx_delay);
+		delay_val |= MT8195_FIELD_ENABLE(ETH_DLY_RXC_ENABLE,
+						 mac_delay->rx_delay);
 		delay_val |= FIELD_PREP(ETH_DLY_RXC_STAGES, mac_delay->rx_delay);
 		delay_val |= FIELD_PREP(ETH_DLY_RXC_INV, mac_delay->rx_inv);
 		break;
@@ -213,11 +217,13 @@ static int mt2712_set_delay(struct mediatek_dwmac_plat_data *plat)
 			 * The egress timing can be adjusted by GTXC delay macro circuit.
 			 * The ingress timing can be adjusted by TXC delay macro circuit.
 			 */
-			delay_val |= FIELD_PREP(ETH_DLY_TXC_ENABLE, !!mac_delay->rx_delay);
+			delay_val |= MT8195_FIELD_ENABLE(ETH_DLY_TXC_ENABLE,
+							 mac_delay->rx_delay);
 			delay_val |= FIELD_PREP(ETH_DLY_TXC_STAGES, mac_delay->rx_delay);
 			delay_val |= FIELD_PREP(ETH_DLY_TXC_INV, mac_delay->rx_inv);
 
-			delay_val |= FIELD_PREP(ETH_DLY_GTXC_ENABLE, !!mac_delay->tx_delay);
+			delay_val |= MT8195_FIELD_ENABLE(ETH_DLY_GTXC_ENABLE,
+							 mac_delay->tx_delay);
 			delay_val |= FIELD_PREP(ETH_DLY_GTXC_STAGES, mac_delay->tx_delay);
 			delay_val |= FIELD_PREP(ETH_DLY_GTXC_INV, mac_delay->tx_inv);
 		} else {
@@ -232,7 +238,8 @@ static int mt2712_set_delay(struct mediatek_dwmac_plat_data *plat)
 				 * to RXC pin, the reference clock will be adjusted
 				 * by RXC delay macro circuit.
 				 */
-				delay_val |= FIELD_PREP(ETH_DLY_RXC_ENABLE, !!mac_delay->rx_delay);
+				delay_val |= FIELD_PREP(ETH_DLY_RXC_ENABLE,
+							mac_delay->rx_delay ? 1 : 0);
 				delay_val |= FIELD_PREP(ETH_DLY_RXC_STAGES, mac_delay->rx_delay);
 				delay_val |= FIELD_PREP(ETH_DLY_RXC_INV, mac_delay->rx_inv);
 			} else {
@@ -240,7 +247,8 @@ static int mt2712_set_delay(struct mediatek_dwmac_plat_data *plat)
 				 * to TXC pin, the reference clock will be adjusted
 				 * by TXC delay macro circuit.
 				 */
-				delay_val |= FIELD_PREP(ETH_DLY_TXC_ENABLE, !!mac_delay->rx_delay);
+				delay_val |= MT8195_FIELD_ENABLE(ETH_DLY_TXC_ENABLE,
+								 mac_delay->rx_delay);
 				delay_val |= FIELD_PREP(ETH_DLY_TXC_STAGES, mac_delay->rx_delay);
 				delay_val |= FIELD_PREP(ETH_DLY_TXC_INV, mac_delay->rx_inv);
 			}
@@ -258,11 +266,13 @@ static int mt2712_set_delay(struct mediatek_dwmac_plat_data *plat)
 	case PHY_INTERFACE_MODE_RGMII_ID:
 		fine_val = ETH_FINE_DLY_GTXC | ETH_FINE_DLY_RXC;
 
-		delay_val |= FIELD_PREP(ETH_DLY_GTXC_ENABLE, !!mac_delay->tx_delay);
+		delay_val |= MT8195_FIELD_ENABLE(ETH_DLY_GTXC_ENABLE,
+						 mac_delay->tx_delay);
 		delay_val |= FIELD_PREP(ETH_DLY_GTXC_STAGES, mac_delay->tx_delay);
 		delay_val |= FIELD_PREP(ETH_DLY_GTXC_INV, mac_delay->tx_inv);
 
-		delay_val |= FIELD_PREP(ETH_DLY_RXC_ENABLE, !!mac_delay->rx_delay);
+		delay_val |= MT8195_FIELD_ENABLE(ETH_DLY_RXC_ENABLE,
+						 mac_delay->rx_delay);
 		delay_val |= FIELD_PREP(ETH_DLY_RXC_STAGES, mac_delay->rx_delay);
 		delay_val |= FIELD_PREP(ETH_DLY_RXC_INV, mac_delay->rx_inv);
 		break;
@@ -349,11 +359,13 @@ static int mt8195_set_delay(struct mediatek_dwmac_plat_data *plat)
 
 	switch (plat->phy_mode) {
 	case PHY_INTERFACE_MODE_MII:
-		delay_val |= FIELD_PREP(MT8195_DLY_TXC_ENABLE, !!mac_delay->tx_delay);
+		delay_val |= MT8195_FIELD_ENABLE(MT8195_DLY_TXC_ENABLE,
+						 mac_delay->tx_delay);
 		delay_val |= FIELD_PREP(MT8195_DLY_TXC_STAGES, mac_delay->tx_delay);
 		delay_val |= FIELD_PREP(MT8195_DLY_TXC_INV, mac_delay->tx_inv);
 
-		delay_val |= FIELD_PREP(MT8195_DLY_RXC_ENABLE, !!mac_delay->rx_delay);
+		delay_val |= MT8195_FIELD_ENABLE(MT8195_DLY_RXC_ENABLE,
+						 mac_delay->rx_delay);
 		delay_val |= FIELD_PREP(MT8195_DLY_RXC_STAGES, mac_delay->rx_delay);
 		delay_val |= FIELD_PREP(MT8195_DLY_RXC_INV, mac_delay->rx_inv);
 		break;
@@ -364,15 +376,15 @@ static int mt8195_set_delay(struct mediatek_dwmac_plat_data *plat)
 			 * The egress timing can be adjusted by RMII_TXC delay macro circuit.
 			 * The ingress timing can be adjusted by RMII_RXC delay macro circuit.
 			 */
-			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_TXC_ENABLE,
-						     !!mac_delay->tx_delay);
+			rmii_delay_val |= MT8195_FIELD_ENABLE(MT8195_DLY_RMII_TXC_ENABLE,
+							      mac_delay->tx_delay);
 			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_TXC_STAGES,
 						     mac_delay->tx_delay);
 			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_TXC_INV,
 						     mac_delay->tx_inv);
 
-			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_RXC_ENABLE,
-						     !!mac_delay->rx_delay);
+			rmii_delay_val |= MT8195_FIELD_ENABLE(MT8195_DLY_RMII_RXC_ENABLE,
+							      mac_delay->rx_delay);
 			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_RXC_STAGES,
 						     mac_delay->rx_delay);
 			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_RXC_INV,
@@ -389,8 +401,8 @@ static int mt8195_set_delay(struct mediatek_dwmac_plat_data *plat)
 				 * to RXC pin, the reference clock will be adjusted
 				 * by RXC delay macro circuit.
 				 */
-				delay_val |= FIELD_PREP(MT8195_DLY_RXC_ENABLE,
-							!!mac_delay->rx_delay);
+				delay_val |= MT8195_FIELD_ENABLE(MT8195_DLY_RXC_ENABLE,
+								 mac_delay->rx_delay);
 				delay_val |= FIELD_PREP(MT8195_DLY_RXC_STAGES,
 							mac_delay->rx_delay);
 				delay_val |= FIELD_PREP(MT8195_DLY_RXC_INV,
@@ -400,8 +412,8 @@ static int mt8195_set_delay(struct mediatek_dwmac_plat_data *plat)
 				 * to TXC pin, the reference clock will be adjusted
 				 * by TXC delay macro circuit.
 				 */
-				delay_val |= FIELD_PREP(MT8195_DLY_TXC_ENABLE,
-							!!mac_delay->rx_delay);
+				delay_val |= MT8195_FIELD_ENABLE(MT8195_DLY_TXC_ENABLE,
+								 mac_delay->rx_delay);
 				delay_val |= FIELD_PREP(MT8195_DLY_TXC_STAGES,
 							mac_delay->rx_delay);
 				delay_val |= FIELD_PREP(MT8195_DLY_TXC_INV,
@@ -413,11 +425,13 @@ static int mt8195_set_delay(struct mediatek_dwmac_plat_data *plat)
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_ID:
-		gtxc_delay_val |= FIELD_PREP(MT8195_DLY_GTXC_ENABLE, !!mac_delay->tx_delay);
+		gtxc_delay_val |= MT8195_FIELD_ENABLE(MT8195_DLY_GTXC_ENABLE,
+						      mac_delay->tx_delay);
 		gtxc_delay_val |= FIELD_PREP(MT8195_DLY_GTXC_STAGES, mac_delay->tx_delay);
 		gtxc_delay_val |= FIELD_PREP(MT8195_DLY_GTXC_INV, mac_delay->tx_inv);
 
-		delay_val |= FIELD_PREP(MT8195_DLY_RXC_ENABLE, !!mac_delay->rx_delay);
+		delay_val |= MT8195_FIELD_ENABLE(MT8195_DLY_RXC_ENABLE,
+						 mac_delay->rx_delay);
 		delay_val |= FIELD_PREP(MT8195_DLY_RXC_STAGES, mac_delay->rx_delay);
 		delay_val |= FIELD_PREP(MT8195_DLY_RXC_INV, mac_delay->rx_inv);
 


