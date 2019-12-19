Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0667A126038
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfLSLAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:00:10 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:52023 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLSLAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:00:09 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 30F1D1BF21D;
        Thu, 19 Dec 2019 11:00:02 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v4 01/15] net: macsec: move some definitions in a dedicated header
Date:   Thu, 19 Dec 2019 11:55:01 +0100
Message-Id: <20191219105515.78400-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219105515.78400-1-antoine.tenart@bootlin.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves some structure, type and identifier definitions into a
MACsec specific header. This patch does not modify how the MACsec code
is running and only move things around. This is a preparation for the
future MACsec hardware offloading support, which will re-use those
definitions outside macsec.c.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/macsec.c           | 163 ------------------------------
 include/net/macsec.h           | 178 +++++++++++++++++++++++++++++++++
 include/uapi/linux/if_macsec.h |   3 +-
 3 files changed, 179 insertions(+), 165 deletions(-)
 create mode 100644 include/net/macsec.h

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index afd8b2a08245..9bce52d62eb3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -19,8 +19,6 @@
 
 #include <uapi/linux/if_macsec.h>
 
-typedef u64 __bitwise sci_t;
-
 #define MACSEC_SCI_LEN 8
 
 /* SecTAG length = macsec_eth_header without the optional SCI */
@@ -58,8 +56,6 @@ struct macsec_eth_header {
 #define GCM_AES_IV_LEN 12
 #define DEFAULT_ICV_LEN 16
 
-#define MACSEC_NUM_AN 4 /* 2 bits for the association number */
-
 #define for_each_rxsc(secy, sc)				\
 	for (sc = rcu_dereference_bh(secy->rx_sc);	\
 	     sc;					\
@@ -77,49 +73,6 @@ struct gcm_iv {
 	__be32 pn;
 };
 
-/**
- * struct macsec_key - SA key
- * @id: user-provided key identifier
- * @tfm: crypto struct, key storage
- */
-struct macsec_key {
-	u8 id[MACSEC_KEYID_LEN];
-	struct crypto_aead *tfm;
-};
-
-struct macsec_rx_sc_stats {
-	__u64 InOctetsValidated;
-	__u64 InOctetsDecrypted;
-	__u64 InPktsUnchecked;
-	__u64 InPktsDelayed;
-	__u64 InPktsOK;
-	__u64 InPktsInvalid;
-	__u64 InPktsLate;
-	__u64 InPktsNotValid;
-	__u64 InPktsNotUsingSA;
-	__u64 InPktsUnusedSA;
-};
-
-struct macsec_rx_sa_stats {
-	__u32 InPktsOK;
-	__u32 InPktsInvalid;
-	__u32 InPktsNotValid;
-	__u32 InPktsNotUsingSA;
-	__u32 InPktsUnusedSA;
-};
-
-struct macsec_tx_sa_stats {
-	__u32 OutPktsProtected;
-	__u32 OutPktsEncrypted;
-};
-
-struct macsec_tx_sc_stats {
-	__u64 OutPktsProtected;
-	__u64 OutPktsEncrypted;
-	__u64 OutOctetsProtected;
-	__u64 OutOctetsEncrypted;
-};
-
 struct macsec_dev_stats {
 	__u64 OutPktsUntagged;
 	__u64 InPktsUntagged;
@@ -131,124 +84,8 @@ struct macsec_dev_stats {
 	__u64 InPktsOverrun;
 };
 
-/**
- * struct macsec_rx_sa - receive secure association
- * @active:
- * @next_pn: packet number expected for the next packet
- * @lock: protects next_pn manipulations
- * @key: key structure
- * @stats: per-SA stats
- */
-struct macsec_rx_sa {
-	struct macsec_key key;
-	spinlock_t lock;
-	u32 next_pn;
-	refcount_t refcnt;
-	bool active;
-	struct macsec_rx_sa_stats __percpu *stats;
-	struct macsec_rx_sc *sc;
-	struct rcu_head rcu;
-};
-
-struct pcpu_rx_sc_stats {
-	struct macsec_rx_sc_stats stats;
-	struct u64_stats_sync syncp;
-};
-
-/**
- * struct macsec_rx_sc - receive secure channel
- * @sci: secure channel identifier for this SC
- * @active: channel is active
- * @sa: array of secure associations
- * @stats: per-SC stats
- */
-struct macsec_rx_sc {
-	struct macsec_rx_sc __rcu *next;
-	sci_t sci;
-	bool active;
-	struct macsec_rx_sa __rcu *sa[MACSEC_NUM_AN];
-	struct pcpu_rx_sc_stats __percpu *stats;
-	refcount_t refcnt;
-	struct rcu_head rcu_head;
-};
-
-/**
- * struct macsec_tx_sa - transmit secure association
- * @active:
- * @next_pn: packet number to use for the next packet
- * @lock: protects next_pn manipulations
- * @key: key structure
- * @stats: per-SA stats
- */
-struct macsec_tx_sa {
-	struct macsec_key key;
-	spinlock_t lock;
-	u32 next_pn;
-	refcount_t refcnt;
-	bool active;
-	struct macsec_tx_sa_stats __percpu *stats;
-	struct rcu_head rcu;
-};
-
-struct pcpu_tx_sc_stats {
-	struct macsec_tx_sc_stats stats;
-	struct u64_stats_sync syncp;
-};
-
-/**
- * struct macsec_tx_sc - transmit secure channel
- * @active:
- * @encoding_sa: association number of the SA currently in use
- * @encrypt: encrypt packets on transmit, or authenticate only
- * @send_sci: always include the SCI in the SecTAG
- * @end_station:
- * @scb: single copy broadcast flag
- * @sa: array of secure associations
- * @stats: stats for this TXSC
- */
-struct macsec_tx_sc {
-	bool active;
-	u8 encoding_sa;
-	bool encrypt;
-	bool send_sci;
-	bool end_station;
-	bool scb;
-	struct macsec_tx_sa __rcu *sa[MACSEC_NUM_AN];
-	struct pcpu_tx_sc_stats __percpu *stats;
-};
-
 #define MACSEC_VALIDATE_DEFAULT MACSEC_VALIDATE_STRICT
 
-/**
- * struct macsec_secy - MACsec Security Entity
- * @netdev: netdevice for this SecY
- * @n_rx_sc: number of receive secure channels configured on this SecY
- * @sci: secure channel identifier used for tx
- * @key_len: length of keys used by the cipher suite
- * @icv_len: length of ICV used by the cipher suite
- * @validate_frames: validation mode
- * @operational: MAC_Operational flag
- * @protect_frames: enable protection for this SecY
- * @replay_protect: enable packet number checks on receive
- * @replay_window: size of the replay window
- * @tx_sc: transmit secure channel
- * @rx_sc: linked list of receive secure channels
- */
-struct macsec_secy {
-	struct net_device *netdev;
-	unsigned int n_rx_sc;
-	sci_t sci;
-	u16 key_len;
-	u16 icv_len;
-	enum macsec_validation_type validate_frames;
-	bool operational;
-	bool protect_frames;
-	bool replay_protect;
-	u32 replay_window;
-	struct macsec_tx_sc tx_sc;
-	struct macsec_rx_sc __rcu *rx_sc;
-};
-
 struct pcpu_secy_stats {
 	struct macsec_dev_stats stats;
 	struct u64_stats_sync syncp;
diff --git a/include/net/macsec.h b/include/net/macsec.h
new file mode 100644
index 000000000000..d18100ff2f57
--- /dev/null
+++ b/include/net/macsec.h
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * MACsec netdev header, used for h/w accelerated implementations.
+ *
+ * Copyright (c) 2015 Sabrina Dubroca <sd@queasysnail.net>
+ */
+#ifndef _NET_MACSEC_H_
+#define _NET_MACSEC_H_
+
+#include <linux/u64_stats_sync.h>
+#include <uapi/linux/if_link.h>
+#include <uapi/linux/if_macsec.h>
+
+typedef u64 __bitwise sci_t;
+
+#define MACSEC_NUM_AN 4 /* 2 bits for the association number */
+#define MACSEC_KEYID_LEN 16
+
+/**
+ * struct macsec_key - SA key
+ * @id: user-provided key identifier
+ * @tfm: crypto struct, key storage
+ */
+struct macsec_key {
+	u8 id[MACSEC_KEYID_LEN];
+	struct crypto_aead *tfm;
+};
+
+struct macsec_rx_sc_stats {
+	__u64 InOctetsValidated;
+	__u64 InOctetsDecrypted;
+	__u64 InPktsUnchecked;
+	__u64 InPktsDelayed;
+	__u64 InPktsOK;
+	__u64 InPktsInvalid;
+	__u64 InPktsLate;
+	__u64 InPktsNotValid;
+	__u64 InPktsNotUsingSA;
+	__u64 InPktsUnusedSA;
+};
+
+struct macsec_rx_sa_stats {
+	__u32 InPktsOK;
+	__u32 InPktsInvalid;
+	__u32 InPktsNotValid;
+	__u32 InPktsNotUsingSA;
+	__u32 InPktsUnusedSA;
+};
+
+struct macsec_tx_sa_stats {
+	__u32 OutPktsProtected;
+	__u32 OutPktsEncrypted;
+};
+
+struct macsec_tx_sc_stats {
+	__u64 OutPktsProtected;
+	__u64 OutPktsEncrypted;
+	__u64 OutOctetsProtected;
+	__u64 OutOctetsEncrypted;
+};
+
+/**
+ * struct macsec_rx_sa - receive secure association
+ * @active:
+ * @next_pn: packet number expected for the next packet
+ * @lock: protects next_pn manipulations
+ * @key: key structure
+ * @stats: per-SA stats
+ */
+struct macsec_rx_sa {
+	struct macsec_key key;
+	spinlock_t lock;
+	u32 next_pn;
+	refcount_t refcnt;
+	bool active;
+	struct macsec_rx_sa_stats __percpu *stats;
+	struct macsec_rx_sc *sc;
+	struct rcu_head rcu;
+};
+
+struct pcpu_rx_sc_stats {
+	struct macsec_rx_sc_stats stats;
+	struct u64_stats_sync syncp;
+};
+
+struct pcpu_tx_sc_stats {
+	struct macsec_tx_sc_stats stats;
+	struct u64_stats_sync syncp;
+};
+
+/**
+ * struct macsec_rx_sc - receive secure channel
+ * @sci: secure channel identifier for this SC
+ * @active: channel is active
+ * @sa: array of secure associations
+ * @stats: per-SC stats
+ */
+struct macsec_rx_sc {
+	struct macsec_rx_sc __rcu *next;
+	sci_t sci;
+	bool active;
+	struct macsec_rx_sa __rcu *sa[MACSEC_NUM_AN];
+	struct pcpu_rx_sc_stats __percpu *stats;
+	refcount_t refcnt;
+	struct rcu_head rcu_head;
+};
+
+/**
+ * struct macsec_tx_sa - transmit secure association
+ * @active:
+ * @next_pn: packet number to use for the next packet
+ * @lock: protects next_pn manipulations
+ * @key: key structure
+ * @stats: per-SA stats
+ */
+struct macsec_tx_sa {
+	struct macsec_key key;
+	spinlock_t lock;
+	u32 next_pn;
+	refcount_t refcnt;
+	bool active;
+	struct macsec_tx_sa_stats __percpu *stats;
+	struct rcu_head rcu;
+};
+
+/**
+ * struct macsec_tx_sc - transmit secure channel
+ * @active:
+ * @encoding_sa: association number of the SA currently in use
+ * @encrypt: encrypt packets on transmit, or authenticate only
+ * @send_sci: always include the SCI in the SecTAG
+ * @end_station:
+ * @scb: single copy broadcast flag
+ * @sa: array of secure associations
+ * @stats: stats for this TXSC
+ */
+struct macsec_tx_sc {
+	bool active;
+	u8 encoding_sa;
+	bool encrypt;
+	bool send_sci;
+	bool end_station;
+	bool scb;
+	struct macsec_tx_sa __rcu *sa[MACSEC_NUM_AN];
+	struct pcpu_tx_sc_stats __percpu *stats;
+};
+
+/**
+ * struct macsec_secy - MACsec Security Entity
+ * @netdev: netdevice for this SecY
+ * @n_rx_sc: number of receive secure channels configured on this SecY
+ * @sci: secure channel identifier used for tx
+ * @key_len: length of keys used by the cipher suite
+ * @icv_len: length of ICV used by the cipher suite
+ * @validate_frames: validation mode
+ * @operational: MAC_Operational flag
+ * @protect_frames: enable protection for this SecY
+ * @replay_protect: enable packet number checks on receive
+ * @replay_window: size of the replay window
+ * @tx_sc: transmit secure channel
+ * @rx_sc: linked list of receive secure channels
+ */
+struct macsec_secy {
+	struct net_device *netdev;
+	unsigned int n_rx_sc;
+	sci_t sci;
+	u16 key_len;
+	u16 icv_len;
+	enum macsec_validation_type validate_frames;
+	bool operational;
+	bool protect_frames;
+	bool replay_protect;
+	u32 replay_window;
+	struct macsec_tx_sc tx_sc;
+	struct macsec_rx_sc __rcu *rx_sc;
+};
+
+#endif /* _NET_MACSEC_H_ */
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index 98e4d5d7c45c..573208cac210 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -14,14 +14,13 @@
 #define _UAPI_MACSEC_H
 
 #include <linux/types.h>
+#include <net/macsec.h>
 
 #define MACSEC_GENL_NAME "macsec"
 #define MACSEC_GENL_VERSION 1
 
 #define MACSEC_MAX_KEY_LEN 128
 
-#define MACSEC_KEYID_LEN 16
-
 /* cipher IDs as per IEEE802.1AEbn-2011 */
 #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
 #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
-- 
2.24.1

