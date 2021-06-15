Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9D3A72FB
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFOAc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFOAc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:32:27 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA2FC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:23 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id l4so9988134ljg.0
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=09saV9KmEfikWFU+B3dYBUDsghoxduQoY/JmTiKZxII=;
        b=i4w8mj72DESMqzXNaWdjPtsxUAeWqEIzl8bnp5q0QVoJouR7aUg2DEd2CuweXmS/i3
         FVjGknvuUA6RFIQDt+DDk9op2c1lEOtdzV1ayM9oulB3xERIxDrvair3bFckZRO8XNVn
         xT+FwtTx3E7OVlf5Kp9YNiPEWKKTNYw1spsXKjpCP77AluLPHS9dwFsqH41w6xEB938Z
         b3cgN18i1klKoqlK4F/+2tplFusl7bXahgflKPVECNPeUs7KqFxyKsZ0ArrvTTo+shxd
         AXUQxvvnjHJM4Hj0q8Jdt+3OmnCCu0wBW80e84gIVG3WJtHdmgx+v9oN6qAr2zCLPzmc
         p4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=09saV9KmEfikWFU+B3dYBUDsghoxduQoY/JmTiKZxII=;
        b=KCUnuUqo0VsRgwsjxXwBPdDG0nMscJYSWQx4sfaAX5kFVQUmAuVissNnJHL53xa+S1
         /sQJScA3dYlNvN2UJVLPQDoqWWnHIZtmgwoMNWYVVYDgv8XlVx1znCr+BLgfPXW2GdEb
         4tGGWH2hpuAzv8Zllguz3xMT/2KVReDmzC1PlySA2ua+Uu+tbG9QkcH0v3oW16/zQF9s
         PgTjMhNZyc0D294AGvH8w31JYTZuGTQG76UQELxpNvlV2uo3nkPy8NAmHj2cpFGEJgZ1
         ufINyJzIkuLIBytNB4KMQQ8F2k+b1MmYGTrfDEC+M9hAsJS5SxJyenoqY0SfTjC7CUnG
         08FA==
X-Gm-Message-State: AOAM5330VDyMhRbTAty1lRqKbmB+Ozdt87LhnXWMhrkIGa5RN8pjV7Eo
        2SMGA+SU5VQOwRSI9EghhFk=
X-Google-Smtp-Source: ABdhPJxLK8DtO1fnEHHvLp9f1oBxz5LyOikPJmLSO+dOUo0ZmRD9oH+MuH44TgA7CYJVy60xqbnZgA==
X-Received: by 2002:a2e:8845:: with SMTP id z5mr15278394ljj.405.1623717022051;
        Mon, 14 Jun 2021 17:30:22 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:21 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 02/10] wwan: core: relocate ops registering code
Date:   Tue, 15 Jun 2021 03:30:08 +0300
Message-Id: <20210615003016.477-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210615003016.477-1-ryazanov.s.a@gmail.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
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
 drivers/net/wwan/wwan_core.c | 142 +++++++++++++++++------------------
 1 file changed, 71 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 7e728042fc41..00b514b01d91 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -781,77 +781,6 @@ static const struct file_operations wwan_port_fops = {
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
@@ -966,6 +895,77 @@ static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
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

