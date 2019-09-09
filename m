Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4087AD777
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 13:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390886AbfIILAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 07:00:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:49296 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390900AbfIIK76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 06:59:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 03:59:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,484,1559545200"; 
   d="scan'208";a="213883412"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 09 Sep 2019 03:59:54 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 1/2] NET: m_can: split into core library and platform adaptation
Date:   Mon,  9 Sep 2019 13:59:52 +0300
Message-Id: <20190909105953.36504-1-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A future patch will add PCI-based m_can driver. This patch makes that
a lot simpler.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/net/can/m_can/Kconfig          |  10 +
 drivers/net/can/m_can/Makefile         |   1 +
 drivers/net/can/m_can/m_can.c          | 707 ++-----------------------
 drivers/net/can/m_can/m_can.h          | 420 +++++++++++++++
 drivers/net/can/m_can/m_can_platform.c | 306 +++++++++++
 5 files changed, 778 insertions(+), 666 deletions(-)
 create mode 100644 drivers/net/can/m_can/m_can.h
 create mode 100644 drivers/net/can/m_can/m_can_platform.c

diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index ec4b2e117f66..fba73338bc38 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -4,3 +4,13 @@ config CAN_M_CAN
 	tristate "Bosch M_CAN devices"
 	---help---
 	  Say Y here if you want to support for Bosch M_CAN controller.
+
+if CAN_M_CAN
+
+config CAN_M_CAN_PLATFORM
+	tristate "Generic Platform Bus based M_CAN driver"
+	---help---
+	   Say Y here if you want to support Bosch M_CAN controller connected
+	   to the platform bus.
+
+endif
diff --git a/drivers/net/can/m_can/Makefile b/drivers/net/can/m_can/Makefile
index 599ae69cb4a1..ac568be3de98 100644
--- a/drivers/net/can/m_can/Makefile
+++ b/drivers/net/can/m_can/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_CAN_M_CAN) += m_can.o
+obj-$(CONFIG_CAN_M_CAN_PLATFORM) += m_can_platform.o
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index deb274a19ba0..eabd3777908b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -13,402 +13,19 @@
  * warranty of any kind, whether express or implied.
  */
 
-#include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/interrupt.h>
+#include <linux/device.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
-#include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/iopoll.h>
 #include <linux/can/dev.h>
-#include <linux/pinctrl/consumer.h>
-
-/* napi related */
-#define M_CAN_NAPI_WEIGHT	64
-
-/* message ram configuration data length */
-#define MRAM_CFG_LEN	8
-
-/* registers definition */
-enum m_can_reg {
-	M_CAN_CREL	= 0x0,
-	M_CAN_ENDN	= 0x4,
-	M_CAN_CUST	= 0x8,
-	M_CAN_DBTP	= 0xc,
-	M_CAN_TEST	= 0x10,
-	M_CAN_RWD	= 0x14,
-	M_CAN_CCCR	= 0x18,
-	M_CAN_NBTP	= 0x1c,
-	M_CAN_TSCC	= 0x20,
-	M_CAN_TSCV	= 0x24,
-	M_CAN_TOCC	= 0x28,
-	M_CAN_TOCV	= 0x2c,
-	M_CAN_ECR	= 0x40,
-	M_CAN_PSR	= 0x44,
-/* TDCR Register only available for version >=3.1.x */
-	M_CAN_TDCR	= 0x48,
-	M_CAN_IR	= 0x50,
-	M_CAN_IE	= 0x54,
-	M_CAN_ILS	= 0x58,
-	M_CAN_ILE	= 0x5c,
-	M_CAN_GFC	= 0x80,
-	M_CAN_SIDFC	= 0x84,
-	M_CAN_XIDFC	= 0x88,
-	M_CAN_XIDAM	= 0x90,
-	M_CAN_HPMS	= 0x94,
-	M_CAN_NDAT1	= 0x98,
-	M_CAN_NDAT2	= 0x9c,
-	M_CAN_RXF0C	= 0xa0,
-	M_CAN_RXF0S	= 0xa4,
-	M_CAN_RXF0A	= 0xa8,
-	M_CAN_RXBC	= 0xac,
-	M_CAN_RXF1C	= 0xb0,
-	M_CAN_RXF1S	= 0xb4,
-	M_CAN_RXF1A	= 0xb8,
-	M_CAN_RXESC	= 0xbc,
-	M_CAN_TXBC	= 0xc0,
-	M_CAN_TXFQS	= 0xc4,
-	M_CAN_TXESC	= 0xc8,
-	M_CAN_TXBRP	= 0xcc,
-	M_CAN_TXBAR	= 0xd0,
-	M_CAN_TXBCR	= 0xd4,
-	M_CAN_TXBTO	= 0xd8,
-	M_CAN_TXBCF	= 0xdc,
-	M_CAN_TXBTIE	= 0xe0,
-	M_CAN_TXBCIE	= 0xe4,
-	M_CAN_TXEFC	= 0xf0,
-	M_CAN_TXEFS	= 0xf4,
-	M_CAN_TXEFA	= 0xf8,
-};
-
-/* m_can lec values */
-enum m_can_lec_type {
-	LEC_NO_ERROR = 0,
-	LEC_STUFF_ERROR,
-	LEC_FORM_ERROR,
-	LEC_ACK_ERROR,
-	LEC_BIT1_ERROR,
-	LEC_BIT0_ERROR,
-	LEC_CRC_ERROR,
-	LEC_UNUSED,
-};
-
-enum m_can_mram_cfg {
-	MRAM_SIDF = 0,
-	MRAM_XIDF,
-	MRAM_RXF0,
-	MRAM_RXF1,
-	MRAM_RXB,
-	MRAM_TXE,
-	MRAM_TXB,
-	MRAM_CFG_NUM,
-};
-
-/* Core Release Register (CREL) */
-#define CREL_REL_SHIFT		28
-#define CREL_REL_MASK		(0xF << CREL_REL_SHIFT)
-#define CREL_STEP_SHIFT		24
-#define CREL_STEP_MASK		(0xF << CREL_STEP_SHIFT)
-#define CREL_SUBSTEP_SHIFT	20
-#define CREL_SUBSTEP_MASK	(0xF << CREL_SUBSTEP_SHIFT)
-
-/* Data Bit Timing & Prescaler Register (DBTP) */
-#define DBTP_TDC		BIT(23)
-#define DBTP_DBRP_SHIFT		16
-#define DBTP_DBRP_MASK		(0x1f << DBTP_DBRP_SHIFT)
-#define DBTP_DTSEG1_SHIFT	8
-#define DBTP_DTSEG1_MASK	(0x1f << DBTP_DTSEG1_SHIFT)
-#define DBTP_DTSEG2_SHIFT	4
-#define DBTP_DTSEG2_MASK	(0xf << DBTP_DTSEG2_SHIFT)
-#define DBTP_DSJW_SHIFT		0
-#define DBTP_DSJW_MASK		(0xf << DBTP_DSJW_SHIFT)
-
-/* Transmitter Delay Compensation Register (TDCR) */
-#define TDCR_TDCO_SHIFT		8
-#define TDCR_TDCO_MASK		(0x7F << TDCR_TDCO_SHIFT)
-#define TDCR_TDCF_SHIFT		0
-#define TDCR_TDCF_MASK		(0x7F << TDCR_TDCF_SHIFT)
-
-/* Test Register (TEST) */
-#define TEST_LBCK		BIT(4)
-
-/* CC Control Register(CCCR) */
-#define CCCR_CMR_MASK		0x3
-#define CCCR_CMR_SHIFT		10
-#define CCCR_CMR_CANFD		0x1
-#define CCCR_CMR_CANFD_BRS	0x2
-#define CCCR_CMR_CAN		0x3
-#define CCCR_CME_MASK		0x3
-#define CCCR_CME_SHIFT		8
-#define CCCR_CME_CAN		0
-#define CCCR_CME_CANFD		0x1
-#define CCCR_CME_CANFD_BRS	0x2
-#define CCCR_TXP		BIT(14)
-#define CCCR_TEST		BIT(7)
-#define CCCR_MON		BIT(5)
-#define CCCR_CSR		BIT(4)
-#define CCCR_CSA		BIT(3)
-#define CCCR_ASM		BIT(2)
-#define CCCR_CCE		BIT(1)
-#define CCCR_INIT		BIT(0)
-#define CCCR_CANFD		0x10
-/* for version >=3.1.x */
-#define CCCR_EFBI		BIT(13)
-#define CCCR_PXHD		BIT(12)
-#define CCCR_BRSE		BIT(9)
-#define CCCR_FDOE		BIT(8)
-/* only for version >=3.2.x */
-#define CCCR_NISO		BIT(15)
-
-/* Nominal Bit Timing & Prescaler Register (NBTP) */
-#define NBTP_NSJW_SHIFT		25
-#define NBTP_NSJW_MASK		(0x7f << NBTP_NSJW_SHIFT)
-#define NBTP_NBRP_SHIFT		16
-#define NBTP_NBRP_MASK		(0x1ff << NBTP_NBRP_SHIFT)
-#define NBTP_NTSEG1_SHIFT	8
-#define NBTP_NTSEG1_MASK	(0xff << NBTP_NTSEG1_SHIFT)
-#define NBTP_NTSEG2_SHIFT	0
-#define NBTP_NTSEG2_MASK	(0x7f << NBTP_NTSEG2_SHIFT)
-
-/* Error Counter Register(ECR) */
-#define ECR_RP			BIT(15)
-#define ECR_REC_SHIFT		8
-#define ECR_REC_MASK		(0x7f << ECR_REC_SHIFT)
-#define ECR_TEC_SHIFT		0
-#define ECR_TEC_MASK		0xff
-
-/* Protocol Status Register(PSR) */
-#define PSR_BO		BIT(7)
-#define PSR_EW		BIT(6)
-#define PSR_EP		BIT(5)
-#define PSR_LEC_MASK	0x7
-
-/* Interrupt Register(IR) */
-#define IR_ALL_INT	0xffffffff
-
-/* Renamed bits for versions > 3.1.x */
-#define IR_ARA		BIT(29)
-#define IR_PED		BIT(28)
-#define IR_PEA		BIT(27)
-
-/* Bits for version 3.0.x */
-#define IR_STE		BIT(31)
-#define IR_FOE		BIT(30)
-#define IR_ACKE		BIT(29)
-#define IR_BE		BIT(28)
-#define IR_CRCE		BIT(27)
-#define IR_WDI		BIT(26)
-#define IR_BO		BIT(25)
-#define IR_EW		BIT(24)
-#define IR_EP		BIT(23)
-#define IR_ELO		BIT(22)
-#define IR_BEU		BIT(21)
-#define IR_BEC		BIT(20)
-#define IR_DRX		BIT(19)
-#define IR_TOO		BIT(18)
-#define IR_MRAF		BIT(17)
-#define IR_TSW		BIT(16)
-#define IR_TEFL		BIT(15)
-#define IR_TEFF		BIT(14)
-#define IR_TEFW		BIT(13)
-#define IR_TEFN		BIT(12)
-#define IR_TFE		BIT(11)
-#define IR_TCF		BIT(10)
-#define IR_TC		BIT(9)
-#define IR_HPM		BIT(8)
-#define IR_RF1L		BIT(7)
-#define IR_RF1F		BIT(6)
-#define IR_RF1W		BIT(5)
-#define IR_RF1N		BIT(4)
-#define IR_RF0L		BIT(3)
-#define IR_RF0F		BIT(2)
-#define IR_RF0W		BIT(1)
-#define IR_RF0N		BIT(0)
-#define IR_ERR_STATE	(IR_BO | IR_EW | IR_EP)
-
-/* Interrupts for version 3.0.x */
-#define IR_ERR_LEC_30X	(IR_STE	| IR_FOE | IR_ACKE | IR_BE | IR_CRCE)
-#define IR_ERR_BUS_30X	(IR_ERR_LEC_30X | IR_WDI | IR_ELO | IR_BEU | \
-			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
-			 IR_RF1L | IR_RF0L)
-#define IR_ERR_ALL_30X	(IR_ERR_STATE | IR_ERR_BUS_30X)
-/* Interrupts for version >= 3.1.x */
-#define IR_ERR_LEC_31X	(IR_PED | IR_PEA)
-#define IR_ERR_BUS_31X      (IR_ERR_LEC_31X | IR_WDI | IR_ELO | IR_BEU | \
-			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
-			 IR_RF1L | IR_RF0L)
-#define IR_ERR_ALL_31X	(IR_ERR_STATE | IR_ERR_BUS_31X)
-
-/* Interrupt Line Select (ILS) */
-#define ILS_ALL_INT0	0x0
-#define ILS_ALL_INT1	0xFFFFFFFF
-
-/* Interrupt Line Enable (ILE) */
-#define ILE_EINT1	BIT(1)
-#define ILE_EINT0	BIT(0)
-
-/* Rx FIFO 0/1 Configuration (RXF0C/RXF1C) */
-#define RXFC_FWM_SHIFT	24
-#define RXFC_FWM_MASK	(0x7f << RXFC_FWM_SHIFT)
-#define RXFC_FS_SHIFT	16
-#define RXFC_FS_MASK	(0x7f << RXFC_FS_SHIFT)
-
-/* Rx FIFO 0/1 Status (RXF0S/RXF1S) */
-#define RXFS_RFL	BIT(25)
-#define RXFS_FF		BIT(24)
-#define RXFS_FPI_SHIFT	16
-#define RXFS_FPI_MASK	0x3f0000
-#define RXFS_FGI_SHIFT	8
-#define RXFS_FGI_MASK	0x3f00
-#define RXFS_FFL_MASK	0x7f
-
-/* Rx Buffer / FIFO Element Size Configuration (RXESC) */
-#define M_CAN_RXESC_8BYTES	0x0
-#define M_CAN_RXESC_64BYTES	0x777
-
-/* Tx Buffer Configuration(TXBC) */
-#define TXBC_NDTB_SHIFT		16
-#define TXBC_NDTB_MASK		(0x3f << TXBC_NDTB_SHIFT)
-#define TXBC_TFQS_SHIFT		24
-#define TXBC_TFQS_MASK		(0x3f << TXBC_TFQS_SHIFT)
-
-/* Tx FIFO/Queue Status (TXFQS) */
-#define TXFQS_TFQF		BIT(21)
-#define TXFQS_TFQPI_SHIFT	16
-#define TXFQS_TFQPI_MASK	(0x1f << TXFQS_TFQPI_SHIFT)
-#define TXFQS_TFGI_SHIFT	8
-#define TXFQS_TFGI_MASK		(0x1f << TXFQS_TFGI_SHIFT)
-#define TXFQS_TFFL_SHIFT	0
-#define TXFQS_TFFL_MASK		(0x3f << TXFQS_TFFL_SHIFT)
-
-/* Tx Buffer Element Size Configuration(TXESC) */
-#define TXESC_TBDS_8BYTES	0x0
-#define TXESC_TBDS_64BYTES	0x7
-
-/* Tx Event FIFO Configuration (TXEFC) */
-#define TXEFC_EFS_SHIFT		16
-#define TXEFC_EFS_MASK		(0x3f << TXEFC_EFS_SHIFT)
-
-/* Tx Event FIFO Status (TXEFS) */
-#define TXEFS_TEFL		BIT(25)
-#define TXEFS_EFF		BIT(24)
-#define TXEFS_EFGI_SHIFT	8
-#define	TXEFS_EFGI_MASK		(0x1f << TXEFS_EFGI_SHIFT)
-#define TXEFS_EFFL_SHIFT	0
-#define TXEFS_EFFL_MASK		(0x3f << TXEFS_EFFL_SHIFT)
-
-/* Tx Event FIFO Acknowledge (TXEFA) */
-#define TXEFA_EFAI_SHIFT	0
-#define TXEFA_EFAI_MASK		(0x1f << TXEFA_EFAI_SHIFT)
-
-/* Message RAM Configuration (in bytes) */
-#define SIDF_ELEMENT_SIZE	4
-#define XIDF_ELEMENT_SIZE	8
-#define RXF0_ELEMENT_SIZE	72
-#define RXF1_ELEMENT_SIZE	72
-#define RXB_ELEMENT_SIZE	72
-#define TXE_ELEMENT_SIZE	8
-#define TXB_ELEMENT_SIZE	72
-
-/* Message RAM Elements */
-#define M_CAN_FIFO_ID		0x0
-#define M_CAN_FIFO_DLC		0x4
-#define M_CAN_FIFO_DATA(n)	(0x8 + ((n) << 2))
-
-/* Rx Buffer Element */
-/* R0 */
-#define RX_BUF_ESI		BIT(31)
-#define RX_BUF_XTD		BIT(30)
-#define RX_BUF_RTR		BIT(29)
-/* R1 */
-#define RX_BUF_ANMF		BIT(31)
-#define RX_BUF_FDF		BIT(21)
-#define RX_BUF_BRS		BIT(20)
-
-/* Tx Buffer Element */
-/* T0 */
-#define TX_BUF_ESI		BIT(31)
-#define TX_BUF_XTD		BIT(30)
-#define TX_BUF_RTR		BIT(29)
-/* T1 */
-#define TX_BUF_EFC		BIT(23)
-#define TX_BUF_FDF		BIT(21)
-#define TX_BUF_BRS		BIT(20)
-#define TX_BUF_MM_SHIFT		24
-#define TX_BUF_MM_MASK		(0xff << TX_BUF_MM_SHIFT)
-
-/* Tx event FIFO Element */
-/* E1 */
-#define TX_EVENT_MM_SHIFT	TX_BUF_MM_SHIFT
-#define TX_EVENT_MM_MASK	(0xff << TX_EVENT_MM_SHIFT)
-
-/* address offset and element number for each FIFO/Buffer in the Message RAM */
-struct mram_cfg {
-	u16 off;
-	u8  num;
-};
-
-/* m_can private data structure */
-struct m_can_priv {
-	struct can_priv can;	/* must be the first member */
-	struct napi_struct napi;
-	struct net_device *dev;
-	struct device *device;
-	struct clk *hclk;
-	struct clk *cclk;
-	void __iomem *base;
-	u32 irqstatus;
-	int version;
-
-	/* message ram configuration */
-	void __iomem *mram_base;
-	struct mram_cfg mcfg[MRAM_CFG_NUM];
-};
-
-static inline u32 m_can_read(const struct m_can_priv *priv, enum m_can_reg reg)
-{
-	return readl(priv->base + reg);
-}
-
-static inline void m_can_write(const struct m_can_priv *priv,
-			       enum m_can_reg reg, u32 val)
-{
-	writel(val, priv->base + reg);
-}
 
-static inline u32 m_can_fifo_read(const struct m_can_priv *priv,
-				  u32 fgi, unsigned int offset)
-{
-	return readl(priv->mram_base + priv->mcfg[MRAM_RXF0].off +
-		     fgi * RXF0_ELEMENT_SIZE + offset);
-}
+#include "m_can.h"
 
-static inline void m_can_fifo_write(const struct m_can_priv *priv,
-				    u32 fpi, unsigned int offset, u32 val)
-{
-	writel(val, priv->mram_base + priv->mcfg[MRAM_TXB].off +
-	       fpi * TXB_ELEMENT_SIZE + offset);
-}
-
-static inline u32 m_can_txe_fifo_read(const struct m_can_priv *priv,
-				      u32 fgi,
-				      u32 offset) {
-	return readl(priv->mram_base + priv->mcfg[MRAM_TXE].off +
-			fgi * TXE_ELEMENT_SIZE + offset);
-}
-
-static inline bool m_can_tx_fifo_full(const struct m_can_priv *priv)
-{
-		return !!(m_can_read(priv, M_CAN_TXFQS) & TXFQS_TFQF);
-}
-
-static inline void m_can_config_endisable(const struct m_can_priv *priv,
-					  bool enable)
+void m_can_config_endisable(const struct m_can_priv *priv, bool enable)
 {
 	u32 cccr = m_can_read(priv, M_CAN_CCCR);
 	u32 timeout = 10;
@@ -437,17 +54,20 @@ static inline void m_can_config_endisable(const struct m_can_priv *priv,
 		udelay(1);
 	}
 }
+EXPORT_SYMBOL_GPL(m_can_config_endisable);
 
-static inline void m_can_enable_all_interrupts(const struct m_can_priv *priv)
+void m_can_enable_all_interrupts(const struct m_can_priv *priv)
 {
 	/* Only interrupt line 0 is used in this driver */
 	m_can_write(priv, M_CAN_ILE, ILE_EINT0);
 }
+EXPORT_SYMBOL_GPL(m_can_enable_all_interrupts);
 
-static inline void m_can_disable_all_interrupts(const struct m_can_priv *priv)
+void m_can_disable_all_interrupts(const struct m_can_priv *priv)
 {
 	m_can_write(priv, M_CAN_ILE, 0x0);
 }
+EXPORT_SYMBOL_GPL(m_can_disable_all_interrupts);
 
 static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 {
@@ -629,7 +249,7 @@ static int __m_can_get_berr_counter(const struct net_device *dev,
 	return 0;
 }
 
-static int m_can_clk_start(struct m_can_priv *priv)
+int m_can_clk_start(struct m_can_priv *priv)
 {
 	int err;
 
@@ -641,11 +261,13 @@ static int m_can_clk_start(struct m_can_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(m_can_clk_start);
 
-static void m_can_clk_stop(struct m_can_priv *priv)
+void m_can_clk_stop(struct m_can_priv *priv)
 {
 	pm_runtime_put_sync(priv->device);
 }
+EXPORT_SYMBOL_GPL(m_can_clk_stop);
 
 static int m_can_get_berr_counter(const struct net_device *dev,
 				  struct can_berr_counter *bec)
@@ -1178,7 +800,7 @@ static void m_can_chip_config(struct net_device *dev)
 	m_can_config_endisable(priv, false);
 }
 
-static void m_can_start(struct net_device *dev)
+void m_can_start(struct net_device *dev)
 {
 	struct m_can_priv *priv = netdev_priv(dev);
 
@@ -1189,6 +811,7 @@ static void m_can_start(struct net_device *dev)
 
 	m_can_enable_all_interrupts(priv);
 }
+EXPORT_SYMBOL_GPL(m_can_start);
 
 static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
 {
@@ -1263,7 +886,7 @@ static bool m_can_niso_supported(const struct m_can_priv *priv)
 	return !niso_timeout;
 }
 
-static int m_can_dev_setup(struct platform_device *pdev, struct net_device *dev,
+int m_can_dev_setup(struct device *dev, struct net_device *net,
 			   void __iomem *addr)
 {
 	struct m_can_priv *priv;
@@ -1272,17 +895,17 @@ static int m_can_dev_setup(struct platform_device *pdev, struct net_device *dev,
 	m_can_version = m_can_check_core_release(addr);
 	/* return if unsupported version */
 	if (!m_can_version) {
-		dev_err(&pdev->dev, "Unsupported version number: %2d",
+		dev_err(dev, "Unsupported version number: %2d",
 			m_can_version);
 		return -EINVAL;
 	}
 
-	priv = netdev_priv(dev);
-	netif_napi_add(dev, &priv->napi, m_can_poll, M_CAN_NAPI_WEIGHT);
+	priv = netdev_priv(net);
+	netif_napi_add(net, &priv->napi, m_can_poll, M_CAN_NAPI_WEIGHT);
 
 	/* Shared properties of all M_CAN versions */
 	priv->version = m_can_version;
-	priv->dev = dev;
+	priv->dev = net;
 	priv->base = addr;
 	priv->can.do_set_mode = m_can_set_mode;
 	priv->can.do_get_berr_counter = m_can_get_berr_counter;
@@ -1297,14 +920,14 @@ static int m_can_dev_setup(struct platform_device *pdev, struct net_device *dev,
 	switch (priv->version) {
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
-		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		can_set_static_ctrlmode(net, CAN_CTRLMODE_FD_NON_ISO);
 		priv->can.bittiming_const = &m_can_bittiming_const_30X;
 		priv->can.data_bittiming_const =
 				&m_can_data_bittiming_const_30X;
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
-		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		can_set_static_ctrlmode(net, CAN_CTRLMODE_FD_NON_ISO);
 		priv->can.bittiming_const = &m_can_bittiming_const_31X;
 		priv->can.data_bittiming_const =
 				&m_can_data_bittiming_const_31X;
@@ -1318,13 +941,14 @@ static int m_can_dev_setup(struct platform_device *pdev, struct net_device *dev,
 						: 0);
 		break;
 	default:
-		dev_err(&pdev->dev, "Unsupported version number: %2d",
+		dev_err(dev, "Unsupported version number: %2d",
 			priv->version);
 		return -EINVAL;
 	}
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(m_can_dev_setup);
 
 static int m_can_open(struct net_device *dev)
 {
@@ -1366,7 +990,7 @@ static int m_can_open(struct net_device *dev)
 	return err;
 }
 
-static void m_can_stop(struct net_device *dev)
+void m_can_stop(struct net_device *dev)
 {
 	struct m_can_priv *priv = netdev_priv(dev);
 
@@ -1376,6 +1000,7 @@ static void m_can_stop(struct net_device *dev)
 	/* set the state as STOPPED */
 	priv->can.state = CAN_STATE_STOPPED;
 }
+EXPORT_SYMBOL_GPL(m_can_stop);
 
 static int m_can_close(struct net_device *dev)
 {
@@ -1528,15 +1153,16 @@ static const struct net_device_ops m_can_netdev_ops = {
 	.ndo_change_mtu = can_change_mtu,
 };
 
-static int register_m_can_dev(struct net_device *dev)
+int register_m_can_dev(struct net_device *dev)
 {
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &m_can_netdev_ops;
 
 	return register_candev(dev);
 }
+EXPORT_SYMBOL_GPL(register_m_can_dev);
 
-static void m_can_init_ram(struct m_can_priv *priv)
+void m_can_init_ram(struct m_can_priv *priv)
 {
 	int end, i, start;
 
@@ -1549,283 +1175,32 @@ static void m_can_init_ram(struct m_can_priv *priv)
 	for (i = start; i < end; i += 4)
 		writel(0x0, priv->mram_base + i);
 }
+EXPORT_SYMBOL_GPL(m_can_init_ram);
 
-static void m_can_of_parse_mram(struct m_can_priv *priv,
-				const u32 *mram_config_vals)
+void unregister_m_can_dev(struct net_device *dev)
 {
-	priv->mcfg[MRAM_SIDF].off = mram_config_vals[0];
-	priv->mcfg[MRAM_SIDF].num = mram_config_vals[1];
-	priv->mcfg[MRAM_XIDF].off = priv->mcfg[MRAM_SIDF].off +
-			priv->mcfg[MRAM_SIDF].num * SIDF_ELEMENT_SIZE;
-	priv->mcfg[MRAM_XIDF].num = mram_config_vals[2];
-	priv->mcfg[MRAM_RXF0].off = priv->mcfg[MRAM_XIDF].off +
-			priv->mcfg[MRAM_XIDF].num * XIDF_ELEMENT_SIZE;
-	priv->mcfg[MRAM_RXF0].num = mram_config_vals[3] &
-			(RXFC_FS_MASK >> RXFC_FS_SHIFT);
-	priv->mcfg[MRAM_RXF1].off = priv->mcfg[MRAM_RXF0].off +
-			priv->mcfg[MRAM_RXF0].num * RXF0_ELEMENT_SIZE;
-	priv->mcfg[MRAM_RXF1].num = mram_config_vals[4] &
-			(RXFC_FS_MASK >> RXFC_FS_SHIFT);
-	priv->mcfg[MRAM_RXB].off = priv->mcfg[MRAM_RXF1].off +
-			priv->mcfg[MRAM_RXF1].num * RXF1_ELEMENT_SIZE;
-	priv->mcfg[MRAM_RXB].num = mram_config_vals[5];
-	priv->mcfg[MRAM_TXE].off = priv->mcfg[MRAM_RXB].off +
-			priv->mcfg[MRAM_RXB].num * RXB_ELEMENT_SIZE;
-	priv->mcfg[MRAM_TXE].num = mram_config_vals[6];
-	priv->mcfg[MRAM_TXB].off = priv->mcfg[MRAM_TXE].off +
-			priv->mcfg[MRAM_TXE].num * TXE_ELEMENT_SIZE;
-	priv->mcfg[MRAM_TXB].num = mram_config_vals[7] &
-			(TXBC_NDTB_MASK >> TXBC_NDTB_SHIFT);
-
-	dev_dbg(priv->device,
-		"mram_base %p sidf 0x%x %d xidf 0x%x %d rxf0 0x%x %d rxf1 0x%x %d rxb 0x%x %d txe 0x%x %d txb 0x%x %d\n",
-		priv->mram_base,
-		priv->mcfg[MRAM_SIDF].off, priv->mcfg[MRAM_SIDF].num,
-		priv->mcfg[MRAM_XIDF].off, priv->mcfg[MRAM_XIDF].num,
-		priv->mcfg[MRAM_RXF0].off, priv->mcfg[MRAM_RXF0].num,
-		priv->mcfg[MRAM_RXF1].off, priv->mcfg[MRAM_RXF1].num,
-		priv->mcfg[MRAM_RXB].off, priv->mcfg[MRAM_RXB].num,
-		priv->mcfg[MRAM_TXE].off, priv->mcfg[MRAM_TXE].num,
-		priv->mcfg[MRAM_TXB].off, priv->mcfg[MRAM_TXB].num);
-
-	m_can_init_ram(priv);
+	unregister_candev(dev);
 }
+EXPORT_SYMBOL_GPL(unregister_m_can_dev);
 
-static int m_can_plat_probe(struct platform_device *pdev)
+struct net_device *alloc_m_can_dev(u32 tx_fifo_size)
 {
-	struct net_device *dev;
+	struct net_device *net;
 	struct m_can_priv *priv;
-	struct resource *res;
-	void __iomem *addr;
-	void __iomem *mram_addr;
-	struct clk *hclk, *cclk;
-	int irq, ret;
-	struct device_node *np;
-	u32 mram_config_vals[MRAM_CFG_LEN];
-	u32 tx_fifo_size;
-
-	np = pdev->dev.of_node;
-
-	hclk = devm_clk_get(&pdev->dev, "hclk");
-	cclk = devm_clk_get(&pdev->dev, "cclk");
-
-	if (IS_ERR(hclk) || IS_ERR(cclk)) {
-		dev_err(&pdev->dev, "no clock found\n");
-		ret = -ENODEV;
-		goto failed_ret;
-	}
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "m_can");
-	addr = devm_ioremap_resource(&pdev->dev, res);
-	irq = platform_get_irq_byname(pdev, "int0");
-
-	if (IS_ERR(addr) || irq < 0) {
-		ret = -EINVAL;
-		goto failed_ret;
-	}
-
-	/* message ram could be shared */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
-	if (!res) {
-		ret = -ENODEV;
-		goto failed_ret;
-	}
-
-	mram_addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!mram_addr) {
-		ret = -ENOMEM;
-		goto failed_ret;
-	}
-
-	/* get message ram configuration */
-	ret = of_property_read_u32_array(np, "bosch,mram-cfg",
-					 mram_config_vals,
-					 sizeof(mram_config_vals) / 4);
-	if (ret) {
-		dev_err(&pdev->dev, "Could not get Message RAM configuration.");
-		goto failed_ret;
-	}
-
-	/* Get TX FIFO size
-	 * Defines the total amount of echo buffers for loopback
-	 */
-	tx_fifo_size = mram_config_vals[7];
-
-	/* allocate the m_can device */
-	dev = alloc_candev(sizeof(*priv), tx_fifo_size);
-	if (!dev) {
-		ret = -ENOMEM;
-		goto failed_ret;
-	}
-
-	priv = netdev_priv(dev);
-	dev->irq = irq;
-	priv->device = &pdev->dev;
-	priv->hclk = hclk;
-	priv->cclk = cclk;
-	priv->can.clock.freq = clk_get_rate(cclk);
-	priv->mram_base = mram_addr;
-
-	platform_set_drvdata(pdev, dev);
-	SET_NETDEV_DEV(dev, &pdev->dev);
-
-	/* Enable clocks. Necessary to read Core Release in order to determine
-	 * M_CAN version
-	 */
-	pm_runtime_enable(&pdev->dev);
-	ret = m_can_clk_start(priv);
-	if (ret)
-		goto pm_runtime_fail;
-
-	ret = m_can_dev_setup(pdev, dev, addr);
-	if (ret)
-		goto clk_disable;
-
-	ret = register_m_can_dev(dev);
-	if (ret) {
-		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
-			KBUILD_MODNAME, ret);
-		goto clk_disable;
-	}
-
-	m_can_of_parse_mram(priv, mram_config_vals);
-
-	devm_can_led_init(dev);
-
-	of_can_transceiver(dev);
-
-	dev_info(&pdev->dev, "%s device registered (irq=%d, version=%d)\n",
-		 KBUILD_MODNAME, dev->irq, priv->version);
-
-	/* Probe finished
-	 * Stop clocks. They will be reactivated once the M_CAN device is opened
-	 */
-clk_disable:
-	m_can_clk_stop(priv);
-pm_runtime_fail:
-	if (ret) {
-		pm_runtime_disable(&pdev->dev);
-		free_candev(dev);
-	}
-failed_ret:
-	return ret;
-}
-
-static __maybe_unused int m_can_suspend(struct device *dev)
-{
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *priv = netdev_priv(ndev);
-
-	if (netif_running(ndev)) {
-		netif_stop_queue(ndev);
-		netif_device_detach(ndev);
-		m_can_stop(ndev);
-		m_can_clk_stop(priv);
-	}
-
-	pinctrl_pm_select_sleep_state(dev);
-
-	priv->can.state = CAN_STATE_SLEEPING;
-
-	return 0;
-}
-
-static __maybe_unused int m_can_resume(struct device *dev)
-{
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *priv = netdev_priv(ndev);
-
-	pinctrl_pm_select_default_state(dev);
 
-	priv->can.state = CAN_STATE_ERROR_ACTIVE;
-
-	if (netif_running(ndev)) {
-		int ret;
+	net = alloc_candev(sizeof(*priv), tx_fifo_size);
+	if (!net)
+		return NULL;
 
-		ret = m_can_clk_start(priv);
-		if (ret)
-			return ret;
-
-		m_can_init_ram(priv);
-		m_can_start(ndev);
-		netif_device_attach(ndev);
-		netif_start_queue(ndev);
-	}
-
-	return 0;
+	return net;
 }
+EXPORT_SYMBOL_GPL(alloc_m_can_dev);
 
-static void unregister_m_can_dev(struct net_device *dev)
+void free_m_can_dev(struct net_device *dev)
 {
-	unregister_candev(dev);
-}
-
-static int m_can_plat_remove(struct platform_device *pdev)
-{
-	struct net_device *dev = platform_get_drvdata(pdev);
-
-	unregister_m_can_dev(dev);
-
-	pm_runtime_disable(&pdev->dev);
-
-	platform_set_drvdata(pdev, NULL);
-
 	free_candev(dev);
-
-	return 0;
-}
-
-static int __maybe_unused m_can_runtime_suspend(struct device *dev)
-{
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *priv = netdev_priv(ndev);
-
-	clk_disable_unprepare(priv->cclk);
-	clk_disable_unprepare(priv->hclk);
-
-	return 0;
-}
-
-static int __maybe_unused m_can_runtime_resume(struct device *dev)
-{
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *priv = netdev_priv(ndev);
-	int err;
-
-	err = clk_prepare_enable(priv->hclk);
-	if (err)
-		return err;
-
-	err = clk_prepare_enable(priv->cclk);
-	if (err)
-		clk_disable_unprepare(priv->hclk);
-
-	return err;
 }
-
-static const struct dev_pm_ops m_can_pmops = {
-	SET_RUNTIME_PM_OPS(m_can_runtime_suspend,
-			   m_can_runtime_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(m_can_suspend, m_can_resume)
-};
-
-static const struct of_device_id m_can_of_table[] = {
-	{ .compatible = "bosch,m_can", .data = NULL },
-	{ /* sentinel */ },
-};
-MODULE_DEVICE_TABLE(of, m_can_of_table);
-
-static struct platform_driver m_can_plat_driver = {
-	.driver = {
-		.name = KBUILD_MODNAME,
-		.of_match_table = m_can_of_table,
-		.pm     = &m_can_pmops,
-	},
-	.probe = m_can_plat_probe,
-	.remove = m_can_plat_remove,
-};
-
-module_platform_driver(m_can_plat_driver);
+EXPORT_SYMBOL_GPL(free_m_can_dev);
 
 MODULE_AUTHOR("Dong Aisheng <b29396@freescale.com>");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
new file mode 100644
index 000000000000..e40ff64ac819
--- /dev/null
+++ b/drivers/net/can/m_can/m_can.h
@@ -0,0 +1,420 @@
+/*
+ * CAN bus driver for Bosch M_CAN controller
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ *	Dong Aisheng <b29396@freescale.com>
+ *
+ * Bosch M_CAN user manual can be obtained from:
+ * http://www.bosch-semiconductors.de/media/pdf_1/ipmodules_1/m_can/
+ * mcan_users_manual_v302.pdf
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __M_CAN_H
+#define __M_CAN_H
+
+#include <linux/can/dev.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+
+/* napi related */
+#define M_CAN_NAPI_WEIGHT	64
+
+/* message ram configuration data length */
+#define MRAM_CFG_LEN	8
+
+/* registers definition */
+enum m_can_reg {
+	M_CAN_CREL	= 0x0,
+	M_CAN_ENDN	= 0x4,
+	M_CAN_CUST	= 0x8,
+	M_CAN_DBTP	= 0xc,
+	M_CAN_TEST	= 0x10,
+	M_CAN_RWD	= 0x14,
+	M_CAN_CCCR	= 0x18,
+	M_CAN_NBTP	= 0x1c,
+	M_CAN_TSCC	= 0x20,
+	M_CAN_TSCV	= 0x24,
+	M_CAN_TOCC	= 0x28,
+	M_CAN_TOCV	= 0x2c,
+	M_CAN_ECR	= 0x40,
+	M_CAN_PSR	= 0x44,
+/* TDCR Register only available for version >=3.1.x */
+	M_CAN_TDCR	= 0x48,
+	M_CAN_IR	= 0x50,
+	M_CAN_IE	= 0x54,
+	M_CAN_ILS	= 0x58,
+	M_CAN_ILE	= 0x5c,
+	M_CAN_GFC	= 0x80,
+	M_CAN_SIDFC	= 0x84,
+	M_CAN_XIDFC	= 0x88,
+	M_CAN_XIDAM	= 0x90,
+	M_CAN_HPMS	= 0x94,
+	M_CAN_NDAT1	= 0x98,
+	M_CAN_NDAT2	= 0x9c,
+	M_CAN_RXF0C	= 0xa0,
+	M_CAN_RXF0S	= 0xa4,
+	M_CAN_RXF0A	= 0xa8,
+	M_CAN_RXBC	= 0xac,
+	M_CAN_RXF1C	= 0xb0,
+	M_CAN_RXF1S	= 0xb4,
+	M_CAN_RXF1A	= 0xb8,
+	M_CAN_RXESC	= 0xbc,
+	M_CAN_TXBC	= 0xc0,
+	M_CAN_TXFQS	= 0xc4,
+	M_CAN_TXESC	= 0xc8,
+	M_CAN_TXBRP	= 0xcc,
+	M_CAN_TXBAR	= 0xd0,
+	M_CAN_TXBCR	= 0xd4,
+	M_CAN_TXBTO	= 0xd8,
+	M_CAN_TXBCF	= 0xdc,
+	M_CAN_TXBTIE	= 0xe0,
+	M_CAN_TXBCIE	= 0xe4,
+	M_CAN_TXEFC	= 0xf0,
+	M_CAN_TXEFS	= 0xf4,
+	M_CAN_TXEFA	= 0xf8,
+};
+
+/* m_can lec values */
+enum m_can_lec_type {
+	LEC_NO_ERROR = 0,
+	LEC_STUFF_ERROR,
+	LEC_FORM_ERROR,
+	LEC_ACK_ERROR,
+	LEC_BIT1_ERROR,
+	LEC_BIT0_ERROR,
+	LEC_CRC_ERROR,
+	LEC_UNUSED,
+};
+
+enum m_can_mram_cfg {
+	MRAM_SIDF = 0,
+	MRAM_XIDF,
+	MRAM_RXF0,
+	MRAM_RXF1,
+	MRAM_RXB,
+	MRAM_TXE,
+	MRAM_TXB,
+	MRAM_CFG_NUM,
+};
+
+/* Core Release Register (CREL) */
+#define CREL_REL_SHIFT		28
+#define CREL_REL_MASK		(0xF << CREL_REL_SHIFT)
+#define CREL_STEP_SHIFT		24
+#define CREL_STEP_MASK		(0xF << CREL_STEP_SHIFT)
+#define CREL_SUBSTEP_SHIFT	20
+#define CREL_SUBSTEP_MASK	(0xF << CREL_SUBSTEP_SHIFT)
+
+/* Data Bit Timing & Prescaler Register (DBTP) */
+#define DBTP_TDC		BIT(23)
+#define DBTP_DBRP_SHIFT		16
+#define DBTP_DBRP_MASK		(0x1f << DBTP_DBRP_SHIFT)
+#define DBTP_DTSEG1_SHIFT	8
+#define DBTP_DTSEG1_MASK	(0x1f << DBTP_DTSEG1_SHIFT)
+#define DBTP_DTSEG2_SHIFT	4
+#define DBTP_DTSEG2_MASK	(0xf << DBTP_DTSEG2_SHIFT)
+#define DBTP_DSJW_SHIFT		0
+#define DBTP_DSJW_MASK		(0xf << DBTP_DSJW_SHIFT)
+
+/* Transmitter Delay Compensation Register (TDCR) */
+#define TDCR_TDCO_SHIFT		8
+#define TDCR_TDCO_MASK		(0x7F << TDCR_TDCO_SHIFT)
+#define TDCR_TDCF_SHIFT		0
+#define TDCR_TDCF_MASK		(0x7F << TDCR_TDCF_SHIFT)
+
+/* Test Register (TEST) */
+#define TEST_LBCK		BIT(4)
+
+/* CC Control Register(CCCR) */
+#define CCCR_CMR_MASK		0x3
+#define CCCR_CMR_SHIFT		10
+#define CCCR_CMR_CANFD		0x1
+#define CCCR_CMR_CANFD_BRS	0x2
+#define CCCR_CMR_CAN		0x3
+#define CCCR_CME_MASK		0x3
+#define CCCR_CME_SHIFT		8
+#define CCCR_CME_CAN		0
+#define CCCR_CME_CANFD		0x1
+#define CCCR_CME_CANFD_BRS	0x2
+#define CCCR_TXP		BIT(14)
+#define CCCR_TEST		BIT(7)
+#define CCCR_MON		BIT(5)
+#define CCCR_CSR		BIT(4)
+#define CCCR_CSA		BIT(3)
+#define CCCR_ASM		BIT(2)
+#define CCCR_CCE		BIT(1)
+#define CCCR_INIT		BIT(0)
+#define CCCR_CANFD		0x10
+/* for version >=3.1.x */
+#define CCCR_EFBI		BIT(13)
+#define CCCR_PXHD		BIT(12)
+#define CCCR_BRSE		BIT(9)
+#define CCCR_FDOE		BIT(8)
+/* only for version >=3.2.x */
+#define CCCR_NISO		BIT(15)
+
+/* Nominal Bit Timing & Prescaler Register (NBTP) */
+#define NBTP_NSJW_SHIFT		25
+#define NBTP_NSJW_MASK		(0x7f << NBTP_NSJW_SHIFT)
+#define NBTP_NBRP_SHIFT		16
+#define NBTP_NBRP_MASK		(0x1ff << NBTP_NBRP_SHIFT)
+#define NBTP_NTSEG1_SHIFT	8
+#define NBTP_NTSEG1_MASK	(0xff << NBTP_NTSEG1_SHIFT)
+#define NBTP_NTSEG2_SHIFT	0
+#define NBTP_NTSEG2_MASK	(0x7f << NBTP_NTSEG2_SHIFT)
+
+/* Error Counter Register(ECR) */
+#define ECR_RP			BIT(15)
+#define ECR_REC_SHIFT		8
+#define ECR_REC_MASK		(0x7f << ECR_REC_SHIFT)
+#define ECR_TEC_SHIFT		0
+#define ECR_TEC_MASK		0xff
+
+/* Protocol Status Register(PSR) */
+#define PSR_BO		BIT(7)
+#define PSR_EW		BIT(6)
+#define PSR_EP		BIT(5)
+#define PSR_LEC_MASK	0x7
+
+/* Interrupt Register(IR) */
+#define IR_ALL_INT	0xffffffff
+
+/* Renamed bits for versions > 3.1.x */
+#define IR_ARA		BIT(29)
+#define IR_PED		BIT(28)
+#define IR_PEA		BIT(27)
+
+/* Bits for version 3.0.x */
+#define IR_STE		BIT(31)
+#define IR_FOE		BIT(30)
+#define IR_ACKE		BIT(29)
+#define IR_BE		BIT(28)
+#define IR_CRCE		BIT(27)
+#define IR_WDI		BIT(26)
+#define IR_BO		BIT(25)
+#define IR_EW		BIT(24)
+#define IR_EP		BIT(23)
+#define IR_ELO		BIT(22)
+#define IR_BEU		BIT(21)
+#define IR_BEC		BIT(20)
+#define IR_DRX		BIT(19)
+#define IR_TOO		BIT(18)
+#define IR_MRAF		BIT(17)
+#define IR_TSW		BIT(16)
+#define IR_TEFL		BIT(15)
+#define IR_TEFF		BIT(14)
+#define IR_TEFW		BIT(13)
+#define IR_TEFN		BIT(12)
+#define IR_TFE		BIT(11)
+#define IR_TCF		BIT(10)
+#define IR_TC		BIT(9)
+#define IR_HPM		BIT(8)
+#define IR_RF1L		BIT(7)
+#define IR_RF1F		BIT(6)
+#define IR_RF1W		BIT(5)
+#define IR_RF1N		BIT(4)
+#define IR_RF0L		BIT(3)
+#define IR_RF0F		BIT(2)
+#define IR_RF0W		BIT(1)
+#define IR_RF0N		BIT(0)
+#define IR_ERR_STATE	(IR_BO | IR_EW | IR_EP)
+
+/* Interrupts for version 3.0.x */
+#define IR_ERR_LEC_30X	(IR_STE	| IR_FOE | IR_ACKE | IR_BE | IR_CRCE)
+#define IR_ERR_BUS_30X	(IR_ERR_LEC_30X | IR_WDI | IR_ELO | IR_BEU | \
+			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
+			 IR_RF1L | IR_RF0L)
+#define IR_ERR_ALL_30X	(IR_ERR_STATE | IR_ERR_BUS_30X)
+/* Interrupts for version >= 3.1.x */
+#define IR_ERR_LEC_31X	(IR_PED | IR_PEA)
+#define IR_ERR_BUS_31X      (IR_ERR_LEC_31X | IR_WDI | IR_ELO | IR_BEU | \
+			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
+			 IR_RF1L | IR_RF0L)
+#define IR_ERR_ALL_31X	(IR_ERR_STATE | IR_ERR_BUS_31X)
+
+/* Interrupt Line Select (ILS) */
+#define ILS_ALL_INT0	0x0
+#define ILS_ALL_INT1	0xFFFFFFFF
+
+/* Interrupt Line Enable (ILE) */
+#define ILE_EINT1	BIT(1)
+#define ILE_EINT0	BIT(0)
+
+/* Rx FIFO 0/1 Configuration (RXF0C/RXF1C) */
+#define RXFC_FWM_SHIFT	24
+#define RXFC_FWM_MASK	(0x7f << RXFC_FWM_SHIFT)
+#define RXFC_FS_SHIFT	16
+#define RXFC_FS_MASK	(0x7f << RXFC_FS_SHIFT)
+
+/* Rx FIFO 0/1 Status (RXF0S/RXF1S) */
+#define RXFS_RFL	BIT(25)
+#define RXFS_FF		BIT(24)
+#define RXFS_FPI_SHIFT	16
+#define RXFS_FPI_MASK	0x3f0000
+#define RXFS_FGI_SHIFT	8
+#define RXFS_FGI_MASK	0x3f00
+#define RXFS_FFL_MASK	0x7f
+
+/* Rx Buffer / FIFO Element Size Configuration (RXESC) */
+#define M_CAN_RXESC_8BYTES	0x0
+#define M_CAN_RXESC_64BYTES	0x777
+
+/* Tx Buffer Configuration(TXBC) */
+#define TXBC_NDTB_SHIFT		16
+#define TXBC_NDTB_MASK		(0x3f << TXBC_NDTB_SHIFT)
+#define TXBC_TFQS_SHIFT		24
+#define TXBC_TFQS_MASK		(0x3f << TXBC_TFQS_SHIFT)
+
+/* Tx FIFO/Queue Status (TXFQS) */
+#define TXFQS_TFQF		BIT(21)
+#define TXFQS_TFQPI_SHIFT	16
+#define TXFQS_TFQPI_MASK	(0x1f << TXFQS_TFQPI_SHIFT)
+#define TXFQS_TFGI_SHIFT	8
+#define TXFQS_TFGI_MASK		(0x1f << TXFQS_TFGI_SHIFT)
+#define TXFQS_TFFL_SHIFT	0
+#define TXFQS_TFFL_MASK		(0x3f << TXFQS_TFFL_SHIFT)
+
+/* Tx Buffer Element Size Configuration(TXESC) */
+#define TXESC_TBDS_8BYTES	0x0
+#define TXESC_TBDS_64BYTES	0x7
+
+/* Tx Event FIFO Configuration (TXEFC) */
+#define TXEFC_EFS_SHIFT		16
+#define TXEFC_EFS_MASK		(0x3f << TXEFC_EFS_SHIFT)
+
+/* Tx Event FIFO Status (TXEFS) */
+#define TXEFS_TEFL		BIT(25)
+#define TXEFS_EFF		BIT(24)
+#define TXEFS_EFGI_SHIFT	8
+#define	TXEFS_EFGI_MASK		(0x1f << TXEFS_EFGI_SHIFT)
+#define TXEFS_EFFL_SHIFT	0
+#define TXEFS_EFFL_MASK		(0x3f << TXEFS_EFFL_SHIFT)
+
+/* Tx Event FIFO Acknowledge (TXEFA) */
+#define TXEFA_EFAI_SHIFT	0
+#define TXEFA_EFAI_MASK		(0x1f << TXEFA_EFAI_SHIFT)
+
+/* Message RAM Configuration (in bytes) */
+#define SIDF_ELEMENT_SIZE	4
+#define XIDF_ELEMENT_SIZE	8
+#define RXF0_ELEMENT_SIZE	72
+#define RXF1_ELEMENT_SIZE	72
+#define RXB_ELEMENT_SIZE	72
+#define TXE_ELEMENT_SIZE	8
+#define TXB_ELEMENT_SIZE	72
+
+/* Message RAM Elements */
+#define M_CAN_FIFO_ID		0x0
+#define M_CAN_FIFO_DLC		0x4
+#define M_CAN_FIFO_DATA(n)	(0x8 + ((n) << 2))
+
+/* Rx Buffer Element */
+/* R0 */
+#define RX_BUF_ESI		BIT(31)
+#define RX_BUF_XTD		BIT(30)
+#define RX_BUF_RTR		BIT(29)
+/* R1 */
+#define RX_BUF_ANMF		BIT(31)
+#define RX_BUF_FDF		BIT(21)
+#define RX_BUF_BRS		BIT(20)
+
+/* Tx Buffer Element */
+/* T0 */
+#define TX_BUF_ESI		BIT(31)
+#define TX_BUF_XTD		BIT(30)
+#define TX_BUF_RTR		BIT(29)
+/* T1 */
+#define TX_BUF_EFC		BIT(23)
+#define TX_BUF_FDF		BIT(21)
+#define TX_BUF_BRS		BIT(20)
+#define TX_BUF_MM_SHIFT		24
+#define TX_BUF_MM_MASK		(0xff << TX_BUF_MM_SHIFT)
+
+/* Tx event FIFO Element */
+/* E1 */
+#define TX_EVENT_MM_SHIFT	TX_BUF_MM_SHIFT
+#define TX_EVENT_MM_MASK	(0xff << TX_EVENT_MM_SHIFT)
+
+/* address offset and element number for each FIFO/Buffer in the Message RAM */
+struct mram_cfg {
+	u16 off;
+	u8  num;
+};
+
+/* m_can private data structure */
+struct m_can_priv {
+	struct can_priv can;	/* must be the first member */
+	struct napi_struct napi;
+	struct net_device *dev;
+	struct device *device;
+	struct clk *hclk;
+	struct clk *cclk;
+	void __iomem *base;
+	u32 irqstatus;
+	int version;
+
+	/* message ram configuration */
+	void __iomem *mram_base;
+	struct mram_cfg mcfg[MRAM_CFG_NUM];
+};
+
+static inline u32 m_can_read(const struct m_can_priv *priv, enum m_can_reg reg)
+{
+	return readl(priv->base + reg);
+}
+
+static inline void m_can_write(const struct m_can_priv *priv,
+			       enum m_can_reg reg, u32 val)
+{
+	writel(val, priv->base + reg);
+}
+
+static inline u32 m_can_fifo_read(const struct m_can_priv *priv,
+				  u32 fgi, unsigned int offset)
+{
+	return readl(priv->mram_base + priv->mcfg[MRAM_RXF0].off +
+		     fgi * RXF0_ELEMENT_SIZE + offset);
+}
+
+static inline void m_can_fifo_write(const struct m_can_priv *priv,
+				    u32 fpi, unsigned int offset, u32 val)
+{
+	writel(val, priv->mram_base + priv->mcfg[MRAM_TXB].off +
+	       fpi * TXB_ELEMENT_SIZE + offset);
+}
+
+static inline u32 m_can_txe_fifo_read(const struct m_can_priv *priv,
+				      u32 fgi,
+				      u32 offset) {
+	return readl(priv->mram_base + priv->mcfg[MRAM_TXE].off +
+			fgi * TXE_ELEMENT_SIZE + offset);
+}
+
+static inline bool m_can_tx_fifo_full(const struct m_can_priv *priv)
+{
+	return !!(m_can_read(priv, M_CAN_TXFQS) & TXFQS_TFQF);
+}
+
+extern int register_m_can_dev(struct net_device *dev);
+extern void unregister_m_can_dev(struct net_device *dev);
+extern void m_can_config_endisable(const struct m_can_priv *priv, bool enable);
+extern void m_can_enable_all_interrupts(const struct m_can_priv *priv);
+extern void m_can_disable_all_interrupts(const struct m_can_priv *priv);
+extern struct net_device *alloc_m_can_dev(u32 tx_fifo_size);
+extern void free_m_can_dev(struct net_device *dev);
+extern int m_can_clk_start(struct m_can_priv *priv);
+extern void m_can_clk_stop(struct m_can_priv *priv);
+extern int m_can_dev_setup(struct device *dev, struct net_device *net,
+		void __iomem *addr);
+extern void m_can_start(struct net_device *dev);
+extern void m_can_stop(struct net_device *dev);
+extern void m_can_init_ram(struct m_can_priv *priv);
+
+#endif
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
new file mode 100644
index 000000000000..f69f502c9265
--- /dev/null
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -0,0 +1,306 @@
+/*
+ * CAN bus driver for Bosch M_CAN controller
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ *	Dong Aisheng <b29396@freescale.com>
+ *
+ * Bosch M_CAN user manual can be obtained from:
+ * http://www.bosch-semiconductors.de/media/pdf_1/ipmodules_1/m_can/
+ * mcan_users_manual_v302.pdf
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/iopoll.h>
+#include <linux/can/dev.h>
+#include <linux/pinctrl/consumer.h>
+
+#include "m_can.h"
+
+static void m_can_of_parse_mram(struct m_can_priv *priv, const u32 *mram_config_vals)
+{
+	priv->mcfg[MRAM_SIDF].off = mram_config_vals[0];
+	priv->mcfg[MRAM_SIDF].num = mram_config_vals[1];
+	priv->mcfg[MRAM_XIDF].off = priv->mcfg[MRAM_SIDF].off +
+			priv->mcfg[MRAM_SIDF].num * SIDF_ELEMENT_SIZE;
+	priv->mcfg[MRAM_XIDF].num = mram_config_vals[2];
+	priv->mcfg[MRAM_RXF0].off = priv->mcfg[MRAM_XIDF].off +
+			priv->mcfg[MRAM_XIDF].num * XIDF_ELEMENT_SIZE;
+	priv->mcfg[MRAM_RXF0].num = mram_config_vals[3] &
+			(RXFC_FS_MASK >> RXFC_FS_SHIFT);
+	priv->mcfg[MRAM_RXF1].off = priv->mcfg[MRAM_RXF0].off +
+			priv->mcfg[MRAM_RXF0].num * RXF0_ELEMENT_SIZE;
+	priv->mcfg[MRAM_RXF1].num = mram_config_vals[4] &
+			(RXFC_FS_MASK >> RXFC_FS_SHIFT);
+	priv->mcfg[MRAM_RXB].off = priv->mcfg[MRAM_RXF1].off +
+			priv->mcfg[MRAM_RXF1].num * RXF1_ELEMENT_SIZE;
+	priv->mcfg[MRAM_RXB].num = mram_config_vals[5];
+	priv->mcfg[MRAM_TXE].off = priv->mcfg[MRAM_RXB].off +
+			priv->mcfg[MRAM_RXB].num * RXB_ELEMENT_SIZE;
+	priv->mcfg[MRAM_TXE].num = mram_config_vals[6];
+	priv->mcfg[MRAM_TXB].off = priv->mcfg[MRAM_TXE].off +
+			priv->mcfg[MRAM_TXE].num * TXE_ELEMENT_SIZE;
+	priv->mcfg[MRAM_TXB].num = mram_config_vals[7] &
+			(TXBC_NDTB_MASK >> TXBC_NDTB_SHIFT);
+
+	dev_dbg(priv->device,
+		"mram_base %p sidf 0x%x %d xidf 0x%x %d rxf0 0x%x %d rxf1 0x%x %d rxb 0x%x %d txe 0x%x %d txb 0x%x %d\n",
+		priv->mram_base,
+		priv->mcfg[MRAM_SIDF].off, priv->mcfg[MRAM_SIDF].num,
+		priv->mcfg[MRAM_XIDF].off, priv->mcfg[MRAM_XIDF].num,
+		priv->mcfg[MRAM_RXF0].off, priv->mcfg[MRAM_RXF0].num,
+		priv->mcfg[MRAM_RXF1].off, priv->mcfg[MRAM_RXF1].num,
+		priv->mcfg[MRAM_RXB].off, priv->mcfg[MRAM_RXB].num,
+		priv->mcfg[MRAM_TXE].off, priv->mcfg[MRAM_TXE].num,
+		priv->mcfg[MRAM_TXB].off, priv->mcfg[MRAM_TXB].num);
+
+	m_can_init_ram(priv);
+}
+
+static int m_can_plat_probe(struct platform_device *pdev)
+{
+	struct net_device *dev;
+	struct m_can_priv *priv;
+	struct resource *res;
+	void __iomem *addr;
+	void __iomem *mram_addr;
+	struct clk *hclk, *cclk;
+	int irq, ret;
+	struct device_node *np;
+	u32 mram_config_vals[MRAM_CFG_LEN];
+	u32 tx_fifo_size;
+
+	np = pdev->dev.of_node;
+
+	hclk = devm_clk_get(&pdev->dev, "hclk");
+	cclk = devm_clk_get(&pdev->dev, "cclk");
+
+	if (IS_ERR(hclk) || IS_ERR(cclk)) {
+		dev_err(&pdev->dev, "no clock found\n");
+		ret = -ENODEV;
+		goto failed_ret;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "m_can");
+	addr = devm_ioremap_resource(&pdev->dev, res);
+	irq = platform_get_irq_byname(pdev, "int0");
+
+	if (IS_ERR(addr) || irq < 0) {
+		ret = -EINVAL;
+		goto failed_ret;
+	}
+
+	/* message ram could be shared */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
+	if (!res) {
+		ret = -ENODEV;
+		goto failed_ret;
+	}
+
+	mram_addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!mram_addr) {
+		ret = -ENOMEM;
+		goto failed_ret;
+	}
+
+	/* get message ram configuration */
+	ret = of_property_read_u32_array(np, "bosch,mram-cfg",
+					 mram_config_vals,
+					 sizeof(mram_config_vals) / 4);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not get Message RAM configuration.");
+		goto failed_ret;
+	}
+
+	/* Get TX FIFO size
+	 * Defines the total amount of echo buffers for loopback
+	 */
+	tx_fifo_size = mram_config_vals[7];
+
+	/* allocate the m_can device */
+	dev = alloc_m_can_dev(tx_fifo_size);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto failed_ret;
+	}
+
+	priv = netdev_priv(dev);
+	dev->irq = irq;
+	priv->device = &pdev->dev;
+	priv->hclk = hclk;
+	priv->cclk = cclk;
+	priv->can.clock.freq = clk_get_rate(cclk);
+	priv->mram_base = mram_addr;
+
+	platform_set_drvdata(pdev, dev);
+	SET_NETDEV_DEV(dev, &pdev->dev);
+
+	/* Enable clocks. Necessary to read Core Release in order to determine
+	 * M_CAN version
+	 */
+	pm_runtime_enable(&pdev->dev);
+	ret = m_can_clk_start(priv);
+	if (ret)
+		goto pm_runtime_fail;
+
+	ret = m_can_dev_setup(&pdev->dev, dev, addr);
+	if (ret)
+		goto clk_disable;
+
+	ret = register_m_can_dev(dev);
+	if (ret) {
+		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
+			KBUILD_MODNAME, ret);
+		goto clk_disable;
+	}
+
+	m_can_of_parse_mram(priv, mram_config_vals);
+
+	devm_can_led_init(dev);
+
+	of_can_transceiver(dev);
+
+	dev_info(&pdev->dev, "%s device registered (irq=%d, version=%d)\n",
+		 KBUILD_MODNAME, dev->irq, priv->version);
+
+	/* Probe finished
+	 * Stop clocks. They will be reactivated once the M_CAN device is opened
+	 */
+clk_disable:
+	m_can_clk_stop(priv);
+pm_runtime_fail:
+	if (ret) {
+		pm_runtime_disable(&pdev->dev);
+		free_m_can_dev(dev);
+	}
+failed_ret:
+	return ret;
+}
+
+static __maybe_unused int m_can_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct m_can_priv *priv = netdev_priv(ndev);
+
+	if (netif_running(ndev)) {
+		netif_stop_queue(ndev);
+		netif_device_detach(ndev);
+		m_can_stop(ndev);
+		m_can_clk_stop(priv);
+	}
+
+	pinctrl_pm_select_sleep_state(dev);
+
+	priv->can.state = CAN_STATE_SLEEPING;
+
+	return 0;
+}
+
+static __maybe_unused int m_can_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct m_can_priv *priv = netdev_priv(ndev);
+
+	pinctrl_pm_select_default_state(dev);
+
+	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+
+	if (netif_running(ndev)) {
+		int ret;
+
+		ret = m_can_clk_start(priv);
+		if (ret)
+			return ret;
+
+		m_can_init_ram(priv);
+		m_can_start(ndev);
+		netif_device_attach(ndev);
+		netif_start_queue(ndev);
+	}
+
+	return 0;
+}
+
+static int m_can_plat_remove(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+
+	unregister_m_can_dev(dev);
+
+	pm_runtime_disable(&pdev->dev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	free_m_can_dev(dev);
+
+	return 0;
+}
+
+static int __maybe_unused m_can_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct m_can_priv *priv = netdev_priv(ndev);
+
+	clk_disable_unprepare(priv->cclk);
+	clk_disable_unprepare(priv->hclk);
+
+	return 0;
+}
+
+static int __maybe_unused m_can_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct m_can_priv *priv = netdev_priv(ndev);
+	int err;
+
+	err = clk_prepare_enable(priv->hclk);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(priv->cclk);
+	if (err)
+		clk_disable_unprepare(priv->hclk);
+
+	return err;
+}
+
+static const struct dev_pm_ops m_can_pmops = {
+	SET_RUNTIME_PM_OPS(m_can_runtime_suspend,
+			   m_can_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(m_can_suspend, m_can_resume)
+};
+
+static const struct of_device_id m_can_of_table[] = {
+	{ .compatible = "bosch,m_can", .data = NULL },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, m_can_of_table);
+
+static struct platform_driver m_can_plat_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.of_match_table = m_can_of_table,
+		.pm     = &m_can_pmops,
+	},
+	.probe = m_can_plat_probe,
+	.remove = m_can_plat_remove,
+};
+
+module_platform_driver(m_can_plat_driver);
+
+MODULE_AUTHOR("Dong Aisheng <b29396@freescale.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CAN bus driver for Bosch M_CAN controller");
-- 
2.23.0

