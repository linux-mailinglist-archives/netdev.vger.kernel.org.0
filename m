Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22024A10A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgHSOCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:02:54 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:19668 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgHSOCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:02:13 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07JE1bcP027304;
        Wed, 19 Aug 2020 07:01:47 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 1/2] chelsio/chtls: separate chelsio tls driver from crypto driver
Date:   Wed, 19 Aug 2020 19:31:20 +0530
Message-Id: <20200819140121.20175-2-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200819140121.20175-1-vinay.yadav@chelsio.com>
References: <20200819140121.20175-1-vinay.yadav@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

chelsio inline tls driver(chtls) is mostly overlaps with NIC drivers
but currenty it is part of crypto driver, so move it out to appropriate
directory for better maintenance.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 MAINTAINERS                                   |  9 ++
 drivers/crypto/chelsio/Kconfig                | 11 ---
 drivers/crypto/chelsio/Makefile               |  1 -
 drivers/crypto/chelsio/chcr_algo.h            | 33 -------
 drivers/crypto/chelsio/chcr_core.h            | 53 -----------
 drivers/net/ethernet/chelsio/Kconfig          |  2 +
 drivers/net/ethernet/chelsio/Makefile         |  1 +
 .../ethernet/chelsio/inline_crypto/Kconfig    | 26 ++++++
 .../ethernet/chelsio/inline_crypto/Makefile   |  2 +
 .../chelsio/inline_crypto}/chtls/Makefile     |  0
 .../chelsio/inline_crypto}/chtls/chtls.h      | 88 +++++++++++++++++++
 .../chelsio/inline_crypto}/chtls/chtls_cm.c   |  0
 .../chelsio/inline_crypto}/chtls/chtls_cm.h   |  0
 .../chelsio/inline_crypto}/chtls/chtls_hw.c   |  0
 .../chelsio/inline_crypto}/chtls/chtls_io.c   |  0
 .../chelsio/inline_crypto}/chtls/chtls_main.c |  2 +-
 16 files changed, 129 insertions(+), 99 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/Kconfig
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/Makefile
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/Makefile (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls.h (81%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_cm.c (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_cm.h (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_hw.c (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_io.c (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_main.c (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index deaafb617361..57afa6532824 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4692,6 +4692,15 @@ S:	Supported
 W:	http://www.chelsio.com
 F:	drivers/crypto/chelsio
 
+CXGB4 INLINE CRYPTO DRIVER
+M:	Ayush Sawal <ayush.sawal@chelsio.com>
+M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
+M:	Rohit Maheshwari <rohitm@chelsio.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+W:	http://www.chelsio.com
+F:	drivers/net/ethernet/chelsio/inline_crypto/
+
 CXGB4 ETHERNET DRIVER (CXGB4)
 M:	Vishal Kulkarni <vishal@chelsio.com>
 L:	netdev@vger.kernel.org
diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 2984fdf51e85..89e1d030aada 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -32,17 +32,6 @@ config CHELSIO_IPSEC_INLINE
 	help
 	  Enable support for IPSec Tx Inline.
 
-config CRYPTO_DEV_CHELSIO_TLS
-	tristate "Chelsio Crypto Inline TLS Driver"
-	depends on CHELSIO_T4
-	depends on TLS_TOE
-	select CRYPTO_DEV_CHELSIO
-	help
-	  Support Chelsio Inline TLS with Chelsio crypto accelerator.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called chtls.
-
 config CHELSIO_TLS_DEVICE
 	bool "Chelsio Inline KTLS Offload"
 	depends on CHELSIO_T4
diff --git a/drivers/crypto/chelsio/Makefile b/drivers/crypto/chelsio/Makefile
index 0e9d035927e9..8aeffde4bcde 100644
--- a/drivers/crypto/chelsio/Makefile
+++ b/drivers/crypto/chelsio/Makefile
@@ -7,4 +7,3 @@ chcr-objs :=  chcr_core.o chcr_algo.o
 chcr-objs += chcr_ktls.o
 #endif
 chcr-$(CONFIG_CHELSIO_IPSEC_INLINE) += chcr_ipsec.o
-obj-$(CONFIG_CRYPTO_DEV_CHELSIO_TLS) += chtls/
diff --git a/drivers/crypto/chelsio/chcr_algo.h b/drivers/crypto/chelsio/chcr_algo.h
index d4f6e010dc79..507aafe93f21 100644
--- a/drivers/crypto/chelsio/chcr_algo.h
+++ b/drivers/crypto/chelsio/chcr_algo.h
@@ -86,39 +86,6 @@
 	 KEY_CONTEXT_OPAD_PRESENT_M)
 #define KEY_CONTEXT_OPAD_PRESENT_F      KEY_CONTEXT_OPAD_PRESENT_V(1U)
 
-#define TLS_KEYCTX_RXFLIT_CNT_S 24
-#define TLS_KEYCTX_RXFLIT_CNT_V(x) ((x) << TLS_KEYCTX_RXFLIT_CNT_S)
-
-#define TLS_KEYCTX_RXPROT_VER_S 20
-#define TLS_KEYCTX_RXPROT_VER_M 0xf
-#define TLS_KEYCTX_RXPROT_VER_V(x) ((x) << TLS_KEYCTX_RXPROT_VER_S)
-
-#define TLS_KEYCTX_RXCIPH_MODE_S 16
-#define TLS_KEYCTX_RXCIPH_MODE_M 0xf
-#define TLS_KEYCTX_RXCIPH_MODE_V(x) ((x) << TLS_KEYCTX_RXCIPH_MODE_S)
-
-#define TLS_KEYCTX_RXAUTH_MODE_S 12
-#define TLS_KEYCTX_RXAUTH_MODE_M 0xf
-#define TLS_KEYCTX_RXAUTH_MODE_V(x) ((x) << TLS_KEYCTX_RXAUTH_MODE_S)
-
-#define TLS_KEYCTX_RXCIAU_CTRL_S 11
-#define TLS_KEYCTX_RXCIAU_CTRL_V(x) ((x) << TLS_KEYCTX_RXCIAU_CTRL_S)
-
-#define TLS_KEYCTX_RX_SEQCTR_S 9
-#define TLS_KEYCTX_RX_SEQCTR_M 0x3
-#define TLS_KEYCTX_RX_SEQCTR_V(x) ((x) << TLS_KEYCTX_RX_SEQCTR_S)
-
-#define TLS_KEYCTX_RX_VALID_S 8
-#define TLS_KEYCTX_RX_VALID_V(x) ((x) << TLS_KEYCTX_RX_VALID_S)
-
-#define TLS_KEYCTX_RXCK_SIZE_S 3
-#define TLS_KEYCTX_RXCK_SIZE_M 0x7
-#define TLS_KEYCTX_RXCK_SIZE_V(x) ((x) << TLS_KEYCTX_RXCK_SIZE_S)
-
-#define TLS_KEYCTX_RXMK_SIZE_S 0
-#define TLS_KEYCTX_RXMK_SIZE_M 0x7
-#define TLS_KEYCTX_RXMK_SIZE_V(x) ((x) << TLS_KEYCTX_RXMK_SIZE_S)
-
 #define CHCR_HASH_MAX_DIGEST_SIZE 64
 #define CHCR_MAX_SHA_DIGEST_SIZE 64
 
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index 67d77abd6775..73239aa3fc5f 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -72,54 +72,6 @@ struct _key_ctx {
 	unsigned char key[];
 };
 
-#define KEYCTX_TX_WR_IV_S  55
-#define KEYCTX_TX_WR_IV_M  0x1ffULL
-#define KEYCTX_TX_WR_IV_V(x) ((x) << KEYCTX_TX_WR_IV_S)
-#define KEYCTX_TX_WR_IV_G(x) \
-	(((x) >> KEYCTX_TX_WR_IV_S) & KEYCTX_TX_WR_IV_M)
-
-#define KEYCTX_TX_WR_AAD_S 47
-#define KEYCTX_TX_WR_AAD_M 0xffULL
-#define KEYCTX_TX_WR_AAD_V(x) ((x) << KEYCTX_TX_WR_AAD_S)
-#define KEYCTX_TX_WR_AAD_G(x) (((x) >> KEYCTX_TX_WR_AAD_S) & \
-				KEYCTX_TX_WR_AAD_M)
-
-#define KEYCTX_TX_WR_AADST_S 39
-#define KEYCTX_TX_WR_AADST_M 0xffULL
-#define KEYCTX_TX_WR_AADST_V(x) ((x) << KEYCTX_TX_WR_AADST_S)
-#define KEYCTX_TX_WR_AADST_G(x) \
-	(((x) >> KEYCTX_TX_WR_AADST_S) & KEYCTX_TX_WR_AADST_M)
-
-#define KEYCTX_TX_WR_CIPHER_S 30
-#define KEYCTX_TX_WR_CIPHER_M 0x1ffULL
-#define KEYCTX_TX_WR_CIPHER_V(x) ((x) << KEYCTX_TX_WR_CIPHER_S)
-#define KEYCTX_TX_WR_CIPHER_G(x) \
-	(((x) >> KEYCTX_TX_WR_CIPHER_S) & KEYCTX_TX_WR_CIPHER_M)
-
-#define KEYCTX_TX_WR_CIPHERST_S 23
-#define KEYCTX_TX_WR_CIPHERST_M 0x7f
-#define KEYCTX_TX_WR_CIPHERST_V(x) ((x) << KEYCTX_TX_WR_CIPHERST_S)
-#define KEYCTX_TX_WR_CIPHERST_G(x) \
-	(((x) >> KEYCTX_TX_WR_CIPHERST_S) & KEYCTX_TX_WR_CIPHERST_M)
-
-#define KEYCTX_TX_WR_AUTH_S 14
-#define KEYCTX_TX_WR_AUTH_M 0x1ff
-#define KEYCTX_TX_WR_AUTH_V(x) ((x) << KEYCTX_TX_WR_AUTH_S)
-#define KEYCTX_TX_WR_AUTH_G(x) \
-	(((x) >> KEYCTX_TX_WR_AUTH_S) & KEYCTX_TX_WR_AUTH_M)
-
-#define KEYCTX_TX_WR_AUTHST_S 7
-#define KEYCTX_TX_WR_AUTHST_M 0x7f
-#define KEYCTX_TX_WR_AUTHST_V(x) ((x) << KEYCTX_TX_WR_AUTHST_S)
-#define KEYCTX_TX_WR_AUTHST_G(x) \
-	(((x) >> KEYCTX_TX_WR_AUTHST_S) & KEYCTX_TX_WR_AUTHST_M)
-
-#define KEYCTX_TX_WR_AUTHIN_S 0
-#define KEYCTX_TX_WR_AUTHIN_M 0x7f
-#define KEYCTX_TX_WR_AUTHIN_V(x) ((x) << KEYCTX_TX_WR_AUTHIN_S)
-#define KEYCTX_TX_WR_AUTHIN_G(x) \
-	(((x) >> KEYCTX_TX_WR_AUTHIN_S) & KEYCTX_TX_WR_AUTHIN_M)
-
 #define WQ_RETRY	5
 struct chcr_driver_data {
 	struct list_head act_dev;
@@ -157,11 +109,6 @@ struct uld_ctx {
 	struct chcr_dev dev;
 };
 
-struct sge_opaque_hdr {
-	void *dev;
-	dma_addr_t addr[MAX_SKB_FRAGS + 1];
-};
-
 struct chcr_ipsec_req {
 	struct ulp_txpkt ulptx;
 	struct ulptx_idata sc_imm;
diff --git a/drivers/net/ethernet/chelsio/Kconfig b/drivers/net/ethernet/chelsio/Kconfig
index f6f3ef9a93cf..87cc0ef68b31 100644
--- a/drivers/net/ethernet/chelsio/Kconfig
+++ b/drivers/net/ethernet/chelsio/Kconfig
@@ -134,4 +134,6 @@ config CHELSIO_LIB
 	help
 	Common library for Chelsio drivers.
 
+source "drivers/net/ethernet/chelsio/inline_crypto/Kconfig"
+
 endif # NET_VENDOR_CHELSIO
diff --git a/drivers/net/ethernet/chelsio/Makefile b/drivers/net/ethernet/chelsio/Makefile
index c0f978d2e8a7..1a6fd8b2bb7d 100644
--- a/drivers/net/ethernet/chelsio/Makefile
+++ b/drivers/net/ethernet/chelsio/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_CHELSIO_T3) += cxgb3/
 obj-$(CONFIG_CHELSIO_T4) += cxgb4/
 obj-$(CONFIG_CHELSIO_T4VF) += cxgb4vf/
 obj-$(CONFIG_CHELSIO_LIB) += libcxgb/
+obj-$(CONFIG_CHELSIO_INLINE_CRYPTO) += inline_crypto/
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
new file mode 100644
index 000000000000..cbe9f1b69e3f
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
@@ -0,0 +1,26 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Chelsio inline crypto configuration
+#
+
+config CHELSIO_INLINE_CRYPTO
+	bool "Chelsio Inline Crypto support"
+	default y
+	help
+	  Enable support for inline crypto.
+	  Allows enable/disable from list of inline crypto drivers.
+
+if CHELSIO_INLINE_CRYPTO
+
+config CRYPTO_DEV_CHELSIO_TLS
+	tristate "Chelsio Crypto Inline TLS Driver"
+	depends on CHELSIO_T4
+	depends on TLS_TOE
+	help
+	  Support Chelsio Inline TLS with Chelsio crypto accelerator.
+	  Enable inline TLS support for Tx and Rx.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called chtls.
+
+endif # CHELSIO_INLINE_CRYPTO
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/Makefile b/drivers/net/ethernet/chelsio/inline_crypto/Makefile
new file mode 100644
index 000000000000..8c1fb2cc9835
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/inline_crypto/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_CHELSIO_TLS) += chtls/
diff --git a/drivers/crypto/chelsio/chtls/Makefile b/drivers/net/ethernet/chelsio/inline_crypto/chtls/Makefile
similarity index 100%
rename from drivers/crypto/chelsio/chtls/Makefile
rename to drivers/net/ethernet/chelsio/inline_crypto/chtls/Makefile
diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
similarity index 81%
rename from drivers/crypto/chelsio/chtls/chtls.h
rename to drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
index 459442704eb1..2d3dfdd2a716 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -32,6 +32,94 @@
 #include "chcr_core.h"
 #include "chcr_crypto.h"
 
+#define CHTLS_DRV_VERSION "1.0.0.0-ko"
+
+#define TLS_KEYCTX_RXFLIT_CNT_S 24
+#define TLS_KEYCTX_RXFLIT_CNT_V(x) ((x) << TLS_KEYCTX_RXFLIT_CNT_S)
+
+#define TLS_KEYCTX_RXPROT_VER_S 20
+#define TLS_KEYCTX_RXPROT_VER_M 0xf
+#define TLS_KEYCTX_RXPROT_VER_V(x) ((x) << TLS_KEYCTX_RXPROT_VER_S)
+
+#define TLS_KEYCTX_RXCIPH_MODE_S 16
+#define TLS_KEYCTX_RXCIPH_MODE_M 0xf
+#define TLS_KEYCTX_RXCIPH_MODE_V(x) ((x) << TLS_KEYCTX_RXCIPH_MODE_S)
+
+#define TLS_KEYCTX_RXAUTH_MODE_S 12
+#define TLS_KEYCTX_RXAUTH_MODE_M 0xf
+#define TLS_KEYCTX_RXAUTH_MODE_V(x) ((x) << TLS_KEYCTX_RXAUTH_MODE_S)
+
+#define TLS_KEYCTX_RXCIAU_CTRL_S 11
+#define TLS_KEYCTX_RXCIAU_CTRL_V(x) ((x) << TLS_KEYCTX_RXCIAU_CTRL_S)
+
+#define TLS_KEYCTX_RX_SEQCTR_S 9
+#define TLS_KEYCTX_RX_SEQCTR_M 0x3
+#define TLS_KEYCTX_RX_SEQCTR_V(x) ((x) << TLS_KEYCTX_RX_SEQCTR_S)
+
+#define TLS_KEYCTX_RX_VALID_S 8
+#define TLS_KEYCTX_RX_VALID_V(x) ((x) << TLS_KEYCTX_RX_VALID_S)
+
+#define TLS_KEYCTX_RXCK_SIZE_S 3
+#define TLS_KEYCTX_RXCK_SIZE_M 0x7
+#define TLS_KEYCTX_RXCK_SIZE_V(x) ((x) << TLS_KEYCTX_RXCK_SIZE_S)
+
+#define TLS_KEYCTX_RXMK_SIZE_S 0
+#define TLS_KEYCTX_RXMK_SIZE_M 0x7
+#define TLS_KEYCTX_RXMK_SIZE_V(x) ((x) << TLS_KEYCTX_RXMK_SIZE_S)
+
+#define KEYCTX_TX_WR_IV_S  55
+#define KEYCTX_TX_WR_IV_M  0x1ffULL
+#define KEYCTX_TX_WR_IV_V(x) ((x) << KEYCTX_TX_WR_IV_S)
+#define KEYCTX_TX_WR_IV_G(x) \
+	(((x) >> KEYCTX_TX_WR_IV_S) & KEYCTX_TX_WR_IV_M)
+
+#define KEYCTX_TX_WR_AAD_S 47
+#define KEYCTX_TX_WR_AAD_M 0xffULL
+#define KEYCTX_TX_WR_AAD_V(x) ((x) << KEYCTX_TX_WR_AAD_S)
+#define KEYCTX_TX_WR_AAD_G(x) (((x) >> KEYCTX_TX_WR_AAD_S) & \
+				KEYCTX_TX_WR_AAD_M)
+
+#define KEYCTX_TX_WR_AADST_S 39
+#define KEYCTX_TX_WR_AADST_M 0xffULL
+#define KEYCTX_TX_WR_AADST_V(x) ((x) << KEYCTX_TX_WR_AADST_S)
+#define KEYCTX_TX_WR_AADST_G(x) \
+	(((x) >> KEYCTX_TX_WR_AADST_S) & KEYCTX_TX_WR_AADST_M)
+
+#define KEYCTX_TX_WR_CIPHER_S 30
+#define KEYCTX_TX_WR_CIPHER_M 0x1ffULL
+#define KEYCTX_TX_WR_CIPHER_V(x) ((x) << KEYCTX_TX_WR_CIPHER_S)
+#define KEYCTX_TX_WR_CIPHER_G(x) \
+	(((x) >> KEYCTX_TX_WR_CIPHER_S) & KEYCTX_TX_WR_CIPHER_M)
+
+#define KEYCTX_TX_WR_CIPHERST_S 23
+#define KEYCTX_TX_WR_CIPHERST_M 0x7f
+#define KEYCTX_TX_WR_CIPHERST_V(x) ((x) << KEYCTX_TX_WR_CIPHERST_S)
+#define KEYCTX_TX_WR_CIPHERST_G(x) \
+	(((x) >> KEYCTX_TX_WR_CIPHERST_S) & KEYCTX_TX_WR_CIPHERST_M)
+
+#define KEYCTX_TX_WR_AUTH_S 14
+#define KEYCTX_TX_WR_AUTH_M 0x1ff
+#define KEYCTX_TX_WR_AUTH_V(x) ((x) << KEYCTX_TX_WR_AUTH_S)
+#define KEYCTX_TX_WR_AUTH_G(x) \
+	(((x) >> KEYCTX_TX_WR_AUTH_S) & KEYCTX_TX_WR_AUTH_M)
+
+#define KEYCTX_TX_WR_AUTHST_S 7
+#define KEYCTX_TX_WR_AUTHST_M 0x7f
+#define KEYCTX_TX_WR_AUTHST_V(x) ((x) << KEYCTX_TX_WR_AUTHST_S)
+#define KEYCTX_TX_WR_AUTHST_G(x) \
+	(((x) >> KEYCTX_TX_WR_AUTHST_S) & KEYCTX_TX_WR_AUTHST_M)
+
+#define KEYCTX_TX_WR_AUTHIN_S 0
+#define KEYCTX_TX_WR_AUTHIN_M 0x7f
+#define KEYCTX_TX_WR_AUTHIN_V(x) ((x) << KEYCTX_TX_WR_AUTHIN_S)
+#define KEYCTX_TX_WR_AUTHIN_G(x) \
+	(((x) >> KEYCTX_TX_WR_AUTHIN_S) & KEYCTX_TX_WR_AUTHIN_M)
+
+struct sge_opaque_hdr {
+	void *dev;
+	dma_addr_t addr[MAX_SKB_FRAGS + 1];
+};
+
 #define MAX_IVS_PAGE			256
 #define TLS_KEY_CONTEXT_SZ		64
 #define CIPHER_BLOCK_SIZE		16
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
similarity index 100%
rename from drivers/crypto/chelsio/chtls/chtls_cm.c
rename to drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
similarity index 100%
rename from drivers/crypto/chelsio/chtls/chtls_cm.h
rename to drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
similarity index 100%
rename from drivers/crypto/chelsio/chtls/chtls_hw.c
rename to drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
similarity index 100%
rename from drivers/crypto/chelsio/chtls/chtls_io.c
rename to drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
similarity index 99%
rename from drivers/crypto/chelsio/chtls/chtls_main.c
rename to drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index 66d247efd561..9098b3eed4da 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -638,4 +638,4 @@ module_exit(chtls_unregister);
 MODULE_DESCRIPTION("Chelsio TLS Inline driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Chelsio Communications");
-MODULE_VERSION(DRV_VERSION);
+MODULE_VERSION(CHTLS_DRV_VERSION);
-- 
2.18.1

