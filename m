Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EEE4822EB
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 10:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhLaJI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 04:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhLaJIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 04:08:44 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFE9C06173E
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:08:44 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 8so23357681pgc.10
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rinH6kV18209m1rpGyhR86RkGemg2dOxjTwm0axN2jA=;
        b=KBLbUqlWp5GA0N8RaSeM78ei2/q7kocXMpjf2AoaZaQghi1dGqeMpRN6UzK9p+gdvS
         8gFHPlFr6x/nCSJBrqeDHusUKweonMW56pgQkBGTm1DYxCkpsX+SNGB+BJHPNEhe1NtB
         qmUXCcK6nM6Y5Okx5wVFDjgXMftaaNJgttM3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rinH6kV18209m1rpGyhR86RkGemg2dOxjTwm0axN2jA=;
        b=NpG88xiU10+3m++SkMznjDu0xCf8vg+KsW9G8hrriOji3ugnQQMURH1d2pDSYlJwOZ
         tseOLpYslDrllUtMLxHvCBU9l7IKnrFDf53n8dWQ2sYQuGigiKsxIOR4GwSXxaRESIzE
         rZopGi95guYt5TlvgSIuTbhrW61Wmy5Tu0MoNE9+lZcTH6LFe9W/IUnutznkI/bo43jX
         EuE0b8FcvPcPK5y5jGDijkCUVSeucK2tR/LGjoDLYqEcrQiLyhDl3KLl5I20A77hHwO+
         Ed/Mq4TgBcAWODYi+eCYGs+X+vU/PBL7I8azyapipViwBygZxj5rwvJEP8cZ+fFgVj7K
         ReIg==
X-Gm-Message-State: AOAM532+CuF2GnpQq3gSNhf06ufYsA6XK7tI/AUJPaiW4qvA3TElwEeT
        wv5Lv7wdjwij3TKmw3X0y5RSJw==
X-Google-Smtp-Source: ABdhPJyLNCN2rN9zJhCE28T57760Jqw/cMMBlF6RtfpW5h5Y9yMX5idUxTMXAEfmaW/CgJqDzaMo1g==
X-Received: by 2002:aa7:8891:0:b0:4ba:ee8a:8cdd with SMTP id z17-20020aa78891000000b004baee8a8cddmr35049458pfe.79.1640941724187;
        Fri, 31 Dec 2021 01:08:44 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id t31sm19875192pfg.184.2021.12.31.01.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 01:08:43 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v2 7/8] net/funeth: add kTLS TX control part
Date:   Fri, 31 Dec 2021 01:08:32 -0800
Message-Id: <20211231090833.98977-8-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211231090833.98977-1-dmichail@fungible.com>
References: <20211231090833.98977-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides the control pieces for kTLS Tx offload, implementinng the
offload operations.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../ethernet/fungible/funeth/funeth_ktls.c    | 181 ++++++++++++++++++
 .../ethernet/fungible/funeth/funeth_ktls.h    |  33 ++++
 2 files changed, 214 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.h

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ktls.c b/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
new file mode 100644
index 000000000000..bdcf3365bb16
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include "funeth.h"
+#include "funeth_ktls.h"
+
+static int fun_admin_ktls_create(struct funeth_priv *fp, unsigned int id)
+{
+	struct fun_admin_ktls_create_req req = {
+		.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_KTLS,
+						     sizeof(req)),
+		.subop = FUN_ADMIN_SUBOP_CREATE,
+		.id = cpu_to_be32(id),
+	};
+
+	return fun_submit_admin_sync_cmd(fp->fdev, &req.common, NULL, 0, 0);
+}
+
+static int fun_ktls_add(struct net_device *netdev, struct sock *sk,
+			enum tls_offload_ctx_dir direction,
+			struct tls_crypto_info *crypto_info,
+			u32 start_offload_tcp_sn)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	struct fun_admin_ktls_modify_req req = {
+		.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_KTLS,
+						     sizeof(req)),
+		.subop = FUN_ADMIN_SUBOP_MODIFY,
+		.id = cpu_to_be32(fp->ktls_id),
+		.tcp_seq = cpu_to_be32(start_offload_tcp_sn),
+	};
+	struct fun_admin_ktls_modify_rsp rsp;
+	struct fun_ktls_tx_ctx *tx_ctx;
+	int rc;
+
+	if (direction != TLS_OFFLOAD_CTX_DIR_TX)
+		return -EOPNOTSUPP;
+
+	if (crypto_info->version == TLS_1_2_VERSION)
+		req.version = FUN_KTLS_TLSV2;
+	else if (crypto_info->version == TLS_1_3_VERSION)
+		req.version = FUN_KTLS_TLSV3;
+	else
+		return -EOPNOTSUPP;
+
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *c = (void *)crypto_info;
+
+		req.cipher = FUN_KTLS_CIPHER_AES_GCM_128;
+		memcpy(req.key, c->key, sizeof(c->key));
+		memcpy(req.iv, c->iv, sizeof(c->iv));
+		memcpy(req.salt, c->salt, sizeof(c->salt));
+		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
+		break;
+	}
+
+	case TLS_CIPHER_AES_GCM_256: {
+		struct tls12_crypto_info_aes_gcm_256 *c = (void *)crypto_info;
+
+		req.cipher = FUN_KTLS_CIPHER_AES_GCM_256;
+		memcpy(req.key, c->key, sizeof(c->key));
+		memcpy(req.iv, c->iv, sizeof(c->iv));
+		memcpy(req.salt, c->salt, sizeof(c->salt));
+		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
+		break;
+	}
+
+	case TLS_CIPHER_CHACHA20_POLY1305: {
+		struct tls12_crypto_info_chacha20_poly1305 *c;
+
+		c = (void *)crypto_info;
+		req.cipher = FUN_KTLS_CIPHER_CHACHA20_POLY1305;
+		memcpy(req.key, c->key, sizeof(c->key));
+		memcpy(req.iv, c->iv, sizeof(c->iv));
+		memcpy(req.salt, c->salt, sizeof(c->salt));
+		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
+		break;
+	}
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	rc = fun_submit_admin_sync_cmd(fp->fdev, &req.common, &rsp,
+				       sizeof(rsp), 0);
+	memzero_explicit(&req, sizeof(req));
+	if (rc)
+		return rc;
+
+	tx_ctx = tls_driver_ctx(sk, direction);
+	tx_ctx->tlsid = rsp.tlsid;
+	tx_ctx->next_seq = start_offload_tcp_sn;
+	atomic64_inc(&fp->tx_tls_add);
+	return 0;
+}
+
+static void fun_ktls_del(struct net_device *netdev,
+			 struct tls_context *tls_ctx,
+			 enum tls_offload_ctx_dir direction)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	struct fun_admin_ktls_modify_req req;
+	struct fun_ktls_tx_ctx *tx_ctx;
+
+	if (direction != TLS_OFFLOAD_CTX_DIR_TX)
+		return;
+
+	tx_ctx = __tls_driver_ctx(tls_ctx, direction);
+
+	req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_KTLS,
+			offsetof(struct fun_admin_ktls_modify_req, tcp_seq));
+	req.subop = FUN_ADMIN_SUBOP_MODIFY;
+	req.flags = cpu_to_be16(FUN_KTLS_MODIFY_REMOVE);
+	req.id = cpu_to_be32(fp->ktls_id);
+	req.tlsid = tx_ctx->tlsid;
+
+	fun_submit_admin_sync_cmd(fp->fdev, &req.common, NULL, 0, 0);
+	atomic64_inc(&fp->tx_tls_del);
+}
+
+static int fun_ktls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
+			   u8 *rcd_sn, enum tls_offload_ctx_dir direction)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	struct fun_admin_ktls_modify_req req;
+	struct fun_ktls_tx_ctx *tx_ctx;
+	int rc;
+
+	if (direction != TLS_OFFLOAD_CTX_DIR_TX)
+		return -EOPNOTSUPP;
+
+	tx_ctx = tls_driver_ctx(sk, direction);
+
+	req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_KTLS,
+			offsetof(struct fun_admin_ktls_modify_req, key));
+	req.subop = FUN_ADMIN_SUBOP_MODIFY;
+	req.flags = 0;
+	req.id = cpu_to_be32(fp->ktls_id);
+	req.tlsid = tx_ctx->tlsid;
+	req.tcp_seq = cpu_to_be32(seq);
+	req.version = 0;
+	req.cipher = 0;
+	memcpy(req.record_seq, rcd_sn, sizeof(req.record_seq));
+
+	atomic64_inc(&fp->tx_tls_resync);
+	rc = fun_submit_admin_sync_cmd(fp->fdev, &req.common, NULL, 0, 0);
+	if (!rc)
+		tx_ctx->next_seq = seq;
+	return rc;
+}
+
+static const struct tlsdev_ops fun_ktls_ops = {
+	.tls_dev_add = fun_ktls_add,
+	.tls_dev_del = fun_ktls_del,
+	.tls_dev_resync = fun_ktls_resync,
+};
+
+int fun_ktls_init(struct net_device *netdev)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	int rc;
+
+	rc = fun_admin_ktls_create(fp, netdev->dev_port);
+	if (rc)
+		return rc;
+
+	fp->ktls_id = netdev->dev_port;
+	netdev->tlsdev_ops = &fun_ktls_ops;
+	netdev->hw_features |= NETIF_F_HW_TLS_TX;
+	netdev->features |= NETIF_F_HW_TLS_TX;
+	return 0;
+}
+
+void fun_ktls_cleanup(struct funeth_priv *fp)
+{
+	if (fp->ktls_id == FUN_HCI_ID_INVALID)
+		return;
+
+	fun_res_destroy(fp->fdev, FUN_ADMIN_OP_KTLS, 0, fp->ktls_id);
+	fp->ktls_id = FUN_HCI_ID_INVALID;
+}
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ktls.h b/drivers/net/ethernet/fungible/funeth/funeth_ktls.h
new file mode 100644
index 000000000000..1b433ac8cd7b
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ktls.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef _FUN_KTLS_H
+#define _FUN_KTLS_H
+
+struct net_device;
+struct funeth_priv;
+
+#ifdef CONFIG_TLS_DEVICE
+#include <net/tls.h>
+
+struct fun_ktls_tx_ctx {
+	__be64 tlsid;
+	u32 next_seq;
+};
+
+int fun_ktls_init(struct net_device *netdev);
+void fun_ktls_cleanup(struct funeth_priv *fp);
+
+#else
+#include <linux/errno.h>
+
+static inline int fun_ktls_init(struct net_device *netdev)
+{
+	return -ENOTSUPP;
+}
+
+static inline void fun_ktls_cleanup(struct funeth_priv *fp)
+{
+}
+#endif
+
+#endif /* _FUN_KTLS_H */
-- 
2.25.1

