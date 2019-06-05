Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B56536684
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfFEVMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:12 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42267 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFEVMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:12 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so212286qtk.9
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b47iSl8LtPRBKIkSMy71My2j2J2J5s5/pTcQ2zNYwTk=;
        b=Lg8RttMxfdb4Wpzc3hCxYwGAziRyA3os0vzYxuQqXZodOkC5bFQQSKZCv1WQgsReuy
         OGtHlNRp3G+q5zx/FqCixdrauSolAluBs8M2pMpq6E+mJZFlobnnEfVIN0l8z2YvWdxk
         6z/3kcQaKWHqL0sZr5of/5Z/ivNlqipyJFiG3YvyNQGS8tsWE4SaD3zc3xkIyncowqsC
         lOFGri0q9Lb+nOBzW/5OMdCKGgtFijFwTHRyPlq3UaEi44KSOqRh4m6mDOKslLY9Kq4u
         4Bud60DFaMgyDEr8RmW2hDkOAqy29HTAPr2E2y6A/tVUA5IkkWKoGMJmRlmWrQDtPRPz
         2Vgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b47iSl8LtPRBKIkSMy71My2j2J2J5s5/pTcQ2zNYwTk=;
        b=nXZBkbUJeuAPW9hA8qbex2RyGGs5dvvK4n1lk+q2dv646t1SqpBGHkJfgxSlqn0IA7
         eONbmM+pHLAYsCB1VoalDHIBgVNmB2CNLJHDxsIfatnfL7mm917AVaNMPqHV5luiaily
         2+VS9CDjjwc8KMuswGKa+UJCQsa20dTGkld1VvFQTbcOTMUKvMFZNq6LCX9c1TqFy0ku
         ZH3w5deFUhb59l/N11aoHcVhS28/mAOmhQOEkQgNldxJyx6A9a3d6bzS1tTYfptHph11
         +8ONC4BTMXIkArPD5QfWV5ArQ1yinCI04dKG17RvmAyfDgK2g/8p5PP/U6MDsEReXlS0
         mV0A==
X-Gm-Message-State: APjAAAWpc0gV9tNL/vX+dFrJUKs719D6KtH9Sq1JqPhZ5zIi5LDB5B96
        8UQpNg1CoeBOafTN2feGj4rJuw==
X-Google-Smtp-Source: APXvYqwhOumvQRCdU/yDfUQ9YPLl9AAmHtC05/htQLI5enBE9lWYrLuLa1srfyYB1mP0EPQ8yFRMvA==
X-Received: by 2002:aed:23ac:: with SMTP id j41mr10849838qtc.200.1559769130267;
        Wed, 05 Jun 2019 14:12:10 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:09 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 06/13] nfp: add tls init code
Date:   Wed,  5 Jun 2019 14:11:36 -0700
Message-Id: <20190605211143.29689-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add FW ABI defines and code for basic init of TLS offload.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/Kconfig        |   1 +
 drivers/net/ethernet/netronome/nfp/Makefile   |   5 +
 drivers/net/ethernet/netronome/nfp/ccm.h      |   4 +
 .../ethernet/netronome/nfp/crypto/crypto.h    |  16 +++
 .../net/ethernet/netronome/nfp/crypto/fw.h    |  82 +++++++++++
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 127 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   1 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  10 +-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   1 +
 9 files changed, 245 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/crypto.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/fw.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/tls.c

diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index 4ad5109059e0..bac5be4d4f43 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -20,6 +20,7 @@ config NFP
 	tristate "Netronome(R) NFP4000/NFP6000 NIC driver"
 	depends on PCI && PCI_MSI
 	depends on VXLAN || VXLAN=n
+	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
 	select NET_DEVLINK
 	---help---
 	  This driver supports the Netronome(R) NFP4000/NFP6000 based
diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index e40893692a8e..2805641965f3 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -35,6 +35,11 @@ nfp-objs := \
 	    nfp_shared_buf.o \
 	    nic/main.o
 
+ifeq ($(CONFIG_TLS_DEVICE),y)
+nfp-objs += \
+	    crypto/tls.o
+endif
+
 ifeq ($(CONFIG_NFP_APP_FLOWER),y)
 nfp-objs += \
 	    flower/action.o \
diff --git a/drivers/net/ethernet/netronome/nfp/ccm.h b/drivers/net/ethernet/netronome/nfp/ccm.h
index c84be54abb4c..01efa779ab31 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm.h
+++ b/drivers/net/ethernet/netronome/nfp/ccm.h
@@ -22,6 +22,10 @@ enum nfp_ccm_type {
 	NFP_CCM_TYPE_BPF_MAP_GETNEXT	= 6,
 	NFP_CCM_TYPE_BPF_MAP_GETFIRST	= 7,
 	NFP_CCM_TYPE_BPF_BPF_EVENT	= 8,
+	NFP_CCM_TYPE_CRYPTO_RESET	= 9,
+	NFP_CCM_TYPE_CRYPTO_ADD		= 10,
+	NFP_CCM_TYPE_CRYPTO_DEL		= 11,
+	NFP_CCM_TYPE_CRYPTO_UPDATE	= 12,
 	__NFP_CCM_TYPE_MAX,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
new file mode 100644
index 000000000000..43aed51a8769
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#ifndef NFP_CRYPTO_H
+#define NFP_CRYPTO_H 1
+
+#ifdef CONFIG_TLS_DEVICE
+int nfp_net_tls_init(struct nfp_net *nn);
+#else
+static inline int nfp_net_tls_init(struct nfp_net *nn)
+{
+	return 0;
+}
+#endif
+
+#endif
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/fw.h b/drivers/net/ethernet/netronome/nfp/crypto/fw.h
new file mode 100644
index 000000000000..192ba907d91b
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/crypto/fw.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#ifndef NFP_CRYPTO_FW_H
+#define NFP_CRYPTO_FW_H 1
+
+#include "../ccm.h"
+
+#define NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC	0
+#define NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_DEC	1
+
+struct nfp_crypto_reply_simple {
+	struct nfp_ccm_hdr hdr;
+	__be32 error;
+};
+
+struct nfp_crypto_req_reset {
+	struct nfp_ccm_hdr hdr;
+	__be32 ep_id;
+};
+
+#define NFP_NET_TLS_IPVER		GENMASK(15, 12)
+#define NFP_NET_TLS_VLAN		GENMASK(11, 0)
+#define NFP_NET_TLS_VLAN_UNUSED			4095
+
+struct nfp_crypto_req_add_front {
+	struct nfp_ccm_hdr hdr;
+	__be32 ep_id;
+	u8 resv[3];
+	u8 opcode;
+	u8 key_len;
+	__be16 ipver_vlan __packed;
+	u8 l4_proto;
+};
+
+struct nfp_crypto_req_add_back {
+	__be16 src_port;
+	__be16 dst_port;
+	__be32 key[8];
+	__be32 salt;
+	__be32 iv[2];
+	__be32 counter;
+	__be32 rec_no[2];
+	__be32 tcp_seq;
+};
+
+struct nfp_crypto_req_add_v4 {
+	struct nfp_crypto_req_add_front front;
+	__be32 src_ip;
+	__be32 dst_ip;
+	struct nfp_crypto_req_add_back back;
+};
+
+struct nfp_crypto_req_add_v6 {
+	struct nfp_crypto_req_add_front front;
+	__be32 src_ip[4];
+	__be32 dst_ip[4];
+	struct nfp_crypto_req_add_back back;
+};
+
+struct nfp_crypto_reply_add {
+	struct nfp_ccm_hdr hdr;
+	__be32 error;
+	__be32 handle[2];
+};
+
+struct nfp_crypto_req_del {
+	struct nfp_ccm_hdr hdr;
+	__be32 ep_id;
+	__be32 handle[2];
+};
+
+struct nfp_crypto_req_update {
+	struct nfp_ccm_hdr hdr;
+	__be32 ep_id;
+	u8 resv[3];
+	u8 opcode;
+	__be32 handle[2];
+	__be32 rec_no[2];
+	__be32 tcp_seq;
+};
+#endif
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
new file mode 100644
index 000000000000..c5909f069ee8
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <linux/skbuff.h>
+#include <net/tls.h>
+
+#include "../ccm.h"
+#include "../nfp_net.h"
+#include "crypto.h"
+#include "fw.h"
+
+#define NFP_NET_TLS_CCM_MBOX_OPS_MASK		\
+	(BIT(NFP_CCM_TYPE_CRYPTO_RESET) |	\
+	 BIT(NFP_CCM_TYPE_CRYPTO_ADD) |		\
+	 BIT(NFP_CCM_TYPE_CRYPTO_DEL) |		\
+	 BIT(NFP_CCM_TYPE_CRYPTO_UPDATE))
+
+#define NFP_NET_TLS_OPCODE_MASK_RX			\
+	BIT(NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_DEC)
+
+#define NFP_NET_TLS_OPCODE_MASK_TX			\
+	BIT(NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC)
+
+#define NFP_NET_TLS_OPCODE_MASK						\
+	(NFP_NET_TLS_OPCODE_MASK_RX | NFP_NET_TLS_OPCODE_MASK_TX)
+
+static struct sk_buff *
+nfp_net_tls_alloc_simple(struct nfp_net *nn, size_t req_sz, gfp_t flags)
+{
+	return nfp_ccm_mbox_alloc(nn, req_sz,
+				  sizeof(struct nfp_crypto_reply_simple),
+				  flags);
+}
+
+static int
+nfp_net_tls_communicate_simple(struct nfp_net *nn, struct sk_buff *skb,
+			       const char *name, enum nfp_ccm_type type)
+{
+	struct nfp_crypto_reply_simple *reply;
+	int err;
+
+	err = nfp_ccm_mbox_communicate(nn, skb, type,
+				       sizeof(*reply), sizeof(*reply));
+	if (err) {
+		nn_dp_warn(&nn->dp, "failed to %s TLS: %d\n", name, err);
+		return err;
+	}
+
+	reply = (void *)skb->data;
+	err = -be32_to_cpu(reply->error);
+	if (err)
+		nn_dp_warn(&nn->dp, "failed to %s TLS, fw replied: %d\n",
+			   name, err);
+	dev_consume_skb_any(skb);
+
+	return err;
+}
+
+static int
+nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
+		enum tls_offload_ctx_dir direction,
+		struct tls_crypto_info *crypto_info,
+		u32 start_offload_tcp_sn)
+{
+	return -EOPNOTSUPP;
+}
+
+static void
+nfp_net_tls_del(struct net_device *netdev, struct tls_context *tls_ctx,
+		enum tls_offload_ctx_dir direction)
+{
+}
+
+static const struct tlsdev_ops nfp_net_tls_ops = {
+	.tls_dev_add = nfp_net_tls_add,
+	.tls_dev_del = nfp_net_tls_del,
+};
+
+static int nfp_net_tls_reset(struct nfp_net *nn)
+{
+	struct nfp_crypto_req_reset *req;
+	struct sk_buff *skb;
+
+	skb = nfp_net_tls_alloc_simple(nn, sizeof(*req), GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	req = (void *)skb->data;
+	req->ep_id = 0;
+
+	return nfp_net_tls_communicate_simple(nn, skb, "reset",
+					      NFP_CCM_TYPE_CRYPTO_RESET);
+}
+
+int nfp_net_tls_init(struct nfp_net *nn)
+{
+	struct net_device *netdev = nn->dp.netdev;
+	int err;
+
+	if (!(nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK))
+		return 0;
+
+	if ((nn->tlv_caps.mbox_cmsg_types & NFP_NET_TLS_CCM_MBOX_OPS_MASK) !=
+	    NFP_NET_TLS_CCM_MBOX_OPS_MASK)
+		return 0;
+
+	if (!nfp_ccm_mbox_fits(nn, sizeof(struct nfp_crypto_req_add_v6))) {
+		nn_warn(nn, "disabling TLS offload - mbox too small: %d\n",
+			nn->tlv_caps.mbox_len);
+		return 0;
+	}
+
+	err = nfp_net_tls_reset(nn);
+	if (err)
+		return err;
+
+	nn_ctrl_bar_lock(nn);
+	nn_writel(nn, nn->tlv_caps.crypto_enable_off, 0);
+	err = __nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_CRYPTO);
+	nn_ctrl_bar_unlock(nn);
+	if (err)
+		return err;
+
+	netdev->tlsdev_ops = &nfp_net_tls_ops;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 134d2709cd70..7010c9f1e676 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -894,6 +894,7 @@ void nfp_ctrl_close(struct nfp_net *nn);
 
 void nfp_net_set_ethtool_ops(struct net_device *netdev);
 void nfp_net_info(struct nfp_net *nn);
+int __nfp_net_reconfig(struct nfp_net *nn, u32 update);
 int nfp_net_reconfig(struct nfp_net *nn, u32 update);
 unsigned int nfp_net_rss_key_sz(struct nfp_net *nn);
 void nfp_net_rss_write_itbl(struct nfp_net *nn);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0ccc5206340b..ac6ea6d3557b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -44,6 +44,7 @@
 #include "nfp_net.h"
 #include "nfp_net_sriov.h"
 #include "nfp_port.h"
+#include "crypto/crypto.h"
 
 /**
  * nfp_net_get_fw_version() - Read and parse the FW version
@@ -270,7 +271,7 @@ static void nfp_net_reconfig_wait_posted(struct nfp_net *nn)
  *
  * Return: Negative errno on error, 0 on success
  */
-static int __nfp_net_reconfig(struct nfp_net *nn, u32 update)
+int __nfp_net_reconfig(struct nfp_net *nn, u32 update)
 {
 	int ret;
 
@@ -4005,9 +4006,14 @@ int nfp_net_init(struct nfp_net *nn)
 	if (err)
 		return err;
 
-	if (nn->dp.netdev)
+	if (nn->dp.netdev) {
 		nfp_net_netdev_init(nn);
 
+		err = nfp_net_tls_init(nn);
+		if (err)
+			return err;
+	}
+
 	nfp_net_vecs_init(nn);
 
 	if (!nn->dp.netdev)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index bd4e2194dda5..b570c90fa96c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -135,6 +135,7 @@
 #define   NFP_NET_CFG_UPDATE_MACADDR	  (0x1 << 11) /* MAC address change */
 #define   NFP_NET_CFG_UPDATE_MBOX	  (0x1 << 12) /* Mailbox update */
 #define   NFP_NET_CFG_UPDATE_VF		  (0x1 << 13) /* VF settings change */
+#define   NFP_NET_CFG_UPDATE_CRYPTO	  (0x1 << 14) /* Crypto on/off */
 #define   NFP_NET_CFG_UPDATE_ERR	  (0x1 << 31) /* A error occurred */
 #define NFP_NET_CFG_TXRS_ENABLE		0x0008
 #define NFP_NET_CFG_RXRS_ENABLE		0x0010
-- 
2.21.0

