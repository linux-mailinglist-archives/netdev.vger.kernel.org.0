Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0553AF8CB
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhFUWx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbhFUWxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD4CC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:08 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j2so32808166lfg.9
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XeTcl+ojXRGqwK0cxD8Tw9oSI94jFHk2blsIQcbVeRE=;
        b=pjvpSapXx2sPE4Z2N7TQaEcOzrxkckEwzPCE7LnEaeTdxFOtrQdIa+1XI+nVf8SjiL
         F5kkNIfoM0qq7WzN1C50ihT+ZOQoHaIJ8qzGneFsY8F2xh0IFh7Ymk4J0jXx5IEWB77p
         CWbOeEWVPBqnuE9TJMarZ8qeRLlqOk9l812L8td7993UcUqUKl22q8OaDXRFnM3rp5m5
         YwCW6uLMfuN1LzVzEedFo+gsoReokQzn9NHE09HnSL7/YC2laV5vRShcQfDanzwdHv+U
         i6Eu+GX6x8A7dw0FQQBwoWvVdFU+dVS4fJDVpWcpbFEhZrMGksinF36SCNj7h9f+JtTl
         PBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XeTcl+ojXRGqwK0cxD8Tw9oSI94jFHk2blsIQcbVeRE=;
        b=PC4kscnEioKxq/n7YK5FejkLWMOg+OoUn3JLnk8T3ravdfqIerzkhFEDsAXO8dydk8
         BosD4KMjJSArXmQ5s3QXALoYPfUnvKF7qc4r4vWADMRk7KpVYL4eNtMvfC4Ro59pxWX6
         /Eoo7m697iO2W3GciOzVDTBDjWX83zOOncl3EW2Dx6TMKkkQ+CYFn+GgXTqHme0L5g/0
         9XHWSXBk6lfIO3pmW5kjscf+DIqbSbLNNuFm5wxEMdIYVXRZgWiKnX7ofVEjEBgXvXg0
         o3Rok9f6EdwyyjKBLkv2qPa0E6qiy934Bxi3lvYZX9iQUyb9Ra9TOOZJ4uImkhg/aiK4
         Pfzw==
X-Gm-Message-State: AOAM532npFtNK6AeLqScbHAj0tk+2pxLqKdXBpp02r085BWniwUWAaW/
        JvwED7CXuDtztgmX9WGg2mA=
X-Google-Smtp-Source: ABdhPJzinRAruyfRrXHCww1WHMLaSM6IV9SwJ0hwSa/CmqoGRUQUPANScPGReagLMGjJT4yFRJK9GQ==
X-Received: by 2002:a19:7d04:: with SMTP id y4mr418858lfc.201.1624315866479;
        Mon, 21 Jun 2021 15:51:06 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:06 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 02/10] wwan: core: relocate ops registering code
Date:   Tue, 22 Jun 2021 01:50:52 +0300
Message-Id: <20210621225100.21005-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is unlikely that RTNL callbacks will call WWAN ops (un-)register
functions, but it is highly likely that the ops (un-)register functions
will use RTNL link create/destroy handlers. So move the WWAN network
interface ops (un-)register functions below the RTNL callbacks to be
able to call them without forward declarations.

No functional changes, just code relocation.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---

v1 -> v2:
 * no changes

 drivers/net/wwan/wwan_core.c | 142 +++++++++++++++++------------------
 1 file changed, 71 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 165afec1dbd1..688a7278a396 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -789,77 +789,6 @@ static const struct file_operations wwan_port_fops = {
 	.llseek = noop_llseek,
 };
 
-/**
- * wwan_register_ops - register WWAN device ops
- * @parent: Device to use as parent and shared by all WWAN ports and
- *	created netdevs
- * @ops: operations to register
- * @ctxt: context to pass to operations
- *
- * Returns: 0 on success, a negative error code on failure
- */
-int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
-		      void *ctxt)
-{
-	struct wwan_device *wwandev;
-
-	if (WARN_ON(!parent || !ops))
-		return -EINVAL;
-
-	wwandev = wwan_create_dev(parent);
-	if (!wwandev)
-		return -ENOMEM;
-
-	if (WARN_ON(wwandev->ops)) {
-		wwan_remove_dev(wwandev);
-		return -EBUSY;
-	}
-
-	if (!try_module_get(ops->owner)) {
-		wwan_remove_dev(wwandev);
-		return -ENODEV;
-	}
-
-	wwandev->ops = ops;
-	wwandev->ops_ctxt = ctxt;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(wwan_register_ops);
-
-/**
- * wwan_unregister_ops - remove WWAN device ops
- * @parent: Device to use as parent and shared by all WWAN ports and
- *	created netdevs
- */
-void wwan_unregister_ops(struct device *parent)
-{
-	struct wwan_device *wwandev = wwan_dev_get_by_parent(parent);
-	bool has_ops;
-
-	if (WARN_ON(IS_ERR(wwandev)))
-		return;
-
-	has_ops = wwandev->ops;
-
-	/* put the reference obtained by wwan_dev_get_by_parent(),
-	 * we should still have one (that the owner is giving back
-	 * now) due to the ops being assigned, check that below
-	 * and return if not.
-	 */
-	put_device(&wwandev->dev);
-
-	if (WARN_ON(!has_ops))
-		return;
-
-	module_put(wwandev->ops->owner);
-
-	wwandev->ops = NULL;
-	wwandev->ops_ctxt = NULL;
-	wwan_remove_dev(wwandev);
-}
-EXPORT_SYMBOL_GPL(wwan_unregister_ops);
-
 static int wwan_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
 			      struct netlink_ext_ack *extack)
 {
@@ -974,6 +903,77 @@ static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
 	.policy = wwan_rtnl_policy,
 };
 
+/**
+ * wwan_register_ops - register WWAN device ops
+ * @parent: Device to use as parent and shared by all WWAN ports and
+ *	created netdevs
+ * @ops: operations to register
+ * @ctxt: context to pass to operations
+ *
+ * Returns: 0 on success, a negative error code on failure
+ */
+int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
+		      void *ctxt)
+{
+	struct wwan_device *wwandev;
+
+	if (WARN_ON(!parent || !ops))
+		return -EINVAL;
+
+	wwandev = wwan_create_dev(parent);
+	if (!wwandev)
+		return -ENOMEM;
+
+	if (WARN_ON(wwandev->ops)) {
+		wwan_remove_dev(wwandev);
+		return -EBUSY;
+	}
+
+	if (!try_module_get(ops->owner)) {
+		wwan_remove_dev(wwandev);
+		return -ENODEV;
+	}
+
+	wwandev->ops = ops;
+	wwandev->ops_ctxt = ctxt;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wwan_register_ops);
+
+/**
+ * wwan_unregister_ops - remove WWAN device ops
+ * @parent: Device to use as parent and shared by all WWAN ports and
+ *	created netdevs
+ */
+void wwan_unregister_ops(struct device *parent)
+{
+	struct wwan_device *wwandev = wwan_dev_get_by_parent(parent);
+	bool has_ops;
+
+	if (WARN_ON(IS_ERR(wwandev)))
+		return;
+
+	has_ops = wwandev->ops;
+
+	/* put the reference obtained by wwan_dev_get_by_parent(),
+	 * we should still have one (that the owner is giving back
+	 * now) due to the ops being assigned, check that below
+	 * and return if not.
+	 */
+	put_device(&wwandev->dev);
+
+	if (WARN_ON(!has_ops))
+		return;
+
+	module_put(wwandev->ops->owner);
+
+	wwandev->ops = NULL;
+	wwandev->ops_ctxt = NULL;
+	wwan_remove_dev(wwandev);
+}
+EXPORT_SYMBOL_GPL(wwan_unregister_ops);
+
 static int __init wwan_init(void)
 {
 	int err;
-- 
2.26.3

