Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB35B4C3C17
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 04:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbiBYDAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 22:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbiBYC7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 21:59:48 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BC11EC255
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:59:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d15so309780pjg.1
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rtUbSSQ7CdcCSJCuKtEPcOqykTnLJzDKxf7oTKII0hg=;
        b=bFw+brn6Er9pvsQGegOvUZomQ9aH1+bk3YITl/yAKxAU1Hr/o7MLct8G8FSMprO2gg
         RgcfbY9RAz8iOI2HV9mSRO3J5rat4IvjtJraOZy7+7umAsLHQqoLkxKKZlvW9IdrRRLG
         ErlMNPlKFXALS9fvSCRUnntmD9LIb7tm42da8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rtUbSSQ7CdcCSJCuKtEPcOqykTnLJzDKxf7oTKII0hg=;
        b=hJMzAPE4iw11981hJsyWt8aojlBm91gdcNRvR3ILHEI5cPz2fVGS93xDQZQKWgUN+K
         VtEh8ZLDZm+dx0Vm1k2sPnkN/IcC/dsKxNdJsmwusepaS1rrqLjsGSLqYMQ+FrqdGpT2
         otTVG3VPmm8s5VtY0noEbl4oxgce6fhCsjHezCdfcKoxK5fU6O7+pJ8KZmQWxIhMbR8P
         M7qQr82hcjLzIjIozXH3wDkp4s9Xt58B6Flnnwq+qjhM5o68AtJ7V3Hwg/kX49IOXA54
         +nvsZ3X5t5sFlOPz0AGNTCIeknQEJT5VrzkWhacusRLPMYXlh3GpEAz0+g/9iUKhEfWj
         c7Xw==
X-Gm-Message-State: AOAM533px7ZQsfYQqTRAg1LutTToxCZyrIEluwjtC+iZ9EQ7qNNcNEIO
        VkNKfo92OrFh3cEYAMOopvrWxQ==
X-Google-Smtp-Source: ABdhPJxlDAODaPkTxgglnA+ZXmbAW8Y29Sp4O1giOjWCnbZAgXUcePr5UY9BfciNSUUcQETzq0sRSg==
X-Received: by 2002:a17:90a:24f:b0:1bc:ba37:ae4 with SMTP id t15-20020a17090a024f00b001bcba370ae4mr1118965pje.30.1645757955351;
        Thu, 24 Feb 2022 18:59:15 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id q93-20020a17090a4fe600b001b9ba2a1dc3sm7397526pjh.25.2022.02.24.18.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:59:14 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v8 7/8] net/funeth: add kTLS TX control part
Date:   Thu, 24 Feb 2022 18:59:01 -0800
Message-Id: <20220225025902.40167-8-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225025902.40167-1-dmichail@fungible.com>
References: <20220225025902.40167-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides the control pieces for kTLS Tx offload, implementinng the
offload operations.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../ethernet/fungible/funeth/funeth_ktls.c    | 155 ++++++++++++++++++
 .../ethernet/fungible/funeth/funeth_ktls.h    |  31 ++++
 2 files changed, 186 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.h

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ktls.c b/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
new file mode 100644
index 000000000000..f871def70d70
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
@@ -0,0 +1,155 @@
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
index 000000000000..1b21cccf1278
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ktls.h
@@ -0,0 +1,31 @@
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
+
+static inline void fun_ktls_init(struct net_device *netdev)
+{
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

