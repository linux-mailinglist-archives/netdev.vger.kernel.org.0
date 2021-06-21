Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1893AF8D1
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhFUWxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhFUWxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:30 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C09C0617A6
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:14 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id k8so4395739ljk.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9x3aWVhf83fqUBCi5KA2Sw+7A91cTEb+jWWkn/WqcsM=;
        b=UcvxyrC51Mydu6OmjsD/KAIX287fHYFXQo9+xCVVAsjL2JWJthEMxaketbMCvz+LEz
         ShM9ST6Yjzi7P+Ca/9cHX6XgjCn2QUGboupAJoR+rPlsP8mWARVPyesdtpss1huCi6Xh
         oyvwn8xEnFVatTL5H73BMyaWzzL4609y2ffCvVgPlfLr7rF03t2zLUeBq5plDsxS/6NA
         +GPfdUEIvQgAwDk6CPUeNu/otx+rUlDx7ujzzoLFGEmWdqWW5VRsPaLZmXTUFHrTOt2n
         X6ZVaEheVU2+YxNilIkFu0YJLWJw8S8PdhL9Tb6XsOR320NXJl7W0+ZBN2a0a2CuBG3y
         XySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9x3aWVhf83fqUBCi5KA2Sw+7A91cTEb+jWWkn/WqcsM=;
        b=KdTZ0ztPMOIWpofFYjqpJCIotyAlIe1VUNcxXOVO1F8ikmthgsImiLWzqq3q79d5Tm
         S4chOhzWJfXCubMaZiCgbEL5VK9qVK+Sijqiyjs2BfETfDJrFVcL8F3YgIfWl1uNQiH2
         kgBu3bZyfWYlo1TXoDtgYBrbND3zO5Xw+Sdlp0vJg7n7SuZab/NnPKlmSHCx4cX0Thli
         Owdat2vtFz7iLQ9MScLowj+VtEcGal9oclwxKnEWppYTTZwFcBQLZJ8ZEfzdE+k9zQ0j
         xpO7r02Oz7ujSvvay229B+oUsW/laDfKTR5oUflXkA1yyHi6YugmkvxSMzntkIefhpLl
         wgCA==
X-Gm-Message-State: AOAM531E2TnTEiVTGjPeLznwFdcqPrnF6Yx/BRBo+rdHxE1mhu4/tH3K
        hMPoVXRO/G3mhiiScof8HuA=
X-Google-Smtp-Source: ABdhPJxrGP3nQH5yEpvmTe3Hx1LE57YRBQlOI/AV34pTX8uhdoHXK0ZFnETjnOsSEAgdIyg3pSNVFw==
X-Received: by 2002:a05:651c:543:: with SMTP id q3mr436849ljp.432.1624315872385;
        Mon, 21 Jun 2021 15:51:12 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:12 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Subject: [PATCH net-next v2 08/10] wwan: core: support default netdev creation
Date:   Tue, 22 Jun 2021 01:50:58 +0300
Message-Id: <20210621225100.21005-9-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most, if not each WWAN device driver will create a netdev for the
default data channel. Therefore, add an option for the WWAN netdev ops
registration function to create a default netdev for the WWAN device.

A WWAN device driver should pass a default data channel link id to the
ops registering function to request the creation of a default netdev, or
a special value WWAN_NO_DEFAULT_LINK to inform the WWAN core that the
default netdev should not be created.

For now, only wwan_hwsim utilize the default link creation option. Other
drivers will be reworked next.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC: M Chetan Kumar <m.chetan.kumar@intel.com>
CC: Intel Corporation <linuxwwan@intel.com>
---

v1 -> v2:
 * fix a comment style '/**' -> '/*' to avoid confusion with kernel-doc

 drivers/net/mhi/net.c                 |  3 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c |  3 +-
 drivers/net/wwan/wwan_core.c          | 75 ++++++++++++++++++++++++++-
 drivers/net/wwan/wwan_hwsim.c         |  2 +-
 include/linux/wwan.h                  |  8 ++-
 5 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index ffd1c01b3f35..f36ca5c0dfe9 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -397,7 +397,8 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	struct net_device *ndev;
 	int err;
 
-	err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev);
+	err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev,
+				WWAN_NO_DEFAULT_LINK);
 	if (err)
 		return err;
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index bee9b278223d..adb2bd40a404 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -317,7 +317,8 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 	ipc_wwan->dev = dev;
 	ipc_wwan->ipc_imem = ipc_imem;
 
-	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan)) {
+	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
+			      WWAN_NO_DEFAULT_LINK)) {
 		kfree(ipc_wwan);
 		return NULL;
 	}
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index b634a0ba1196..ef6ec641d877 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -903,17 +903,81 @@ static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
 	.policy = wwan_rtnl_policy,
 };
 
+static void wwan_create_default_link(struct wwan_device *wwandev,
+				     u32 def_link_id)
+{
+	struct nlattr *tb[IFLA_MAX + 1], *linkinfo[IFLA_INFO_MAX + 1];
+	struct nlattr *data[IFLA_WWAN_MAX + 1];
+	struct net_device *dev;
+	struct nlmsghdr *nlh;
+	struct sk_buff *msg;
+
+	/* Forge attributes required to create a WWAN netdev. We first
+	 * build a netlink message and then parse it. This looks
+	 * odd, but such approach is less error prone.
+	 */
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (WARN_ON(!msg))
+		return;
+	nlh = nlmsg_put(msg, 0, 0, RTM_NEWLINK, 0, 0);
+	if (WARN_ON(!nlh))
+		goto free_attrs;
+
+	if (nla_put_string(msg, IFLA_PARENT_DEV_NAME, dev_name(&wwandev->dev)))
+		goto free_attrs;
+	tb[IFLA_LINKINFO] = nla_nest_start(msg, IFLA_LINKINFO);
+	if (!tb[IFLA_LINKINFO])
+		goto free_attrs;
+	linkinfo[IFLA_INFO_DATA] = nla_nest_start(msg, IFLA_INFO_DATA);
+	if (!linkinfo[IFLA_INFO_DATA])
+		goto free_attrs;
+	if (nla_put_u32(msg, IFLA_WWAN_LINK_ID, def_link_id))
+		goto free_attrs;
+	nla_nest_end(msg, linkinfo[IFLA_INFO_DATA]);
+	nla_nest_end(msg, tb[IFLA_LINKINFO]);
+
+	nlmsg_end(msg, nlh);
+
+	/* The next three parsing calls can not fail */
+	nlmsg_parse_deprecated(nlh, 0, tb, IFLA_MAX, NULL, NULL);
+	nla_parse_nested_deprecated(linkinfo, IFLA_INFO_MAX, tb[IFLA_LINKINFO],
+				    NULL, NULL);
+	nla_parse_nested_deprecated(data, IFLA_WWAN_MAX,
+				    linkinfo[IFLA_INFO_DATA], NULL, NULL);
+
+	rtnl_lock();
+
+	dev = rtnl_create_link(&init_net, "wwan%d", NET_NAME_ENUM,
+			       &wwan_rtnl_link_ops, tb, NULL);
+	if (WARN_ON(IS_ERR(dev)))
+		goto unlock;
+
+	if (WARN_ON(wwan_rtnl_newlink(&init_net, dev, tb, data, NULL))) {
+		free_netdev(dev);
+		goto unlock;
+	}
+
+unlock:
+	rtnl_unlock();
+
+free_attrs:
+	nlmsg_free(msg);
+}
+
 /**
  * wwan_register_ops - register WWAN device ops
  * @parent: Device to use as parent and shared by all WWAN ports and
  *	created netdevs
  * @ops: operations to register
  * @ctxt: context to pass to operations
+ * @def_link_id: id of the default link that will be automatically created by
+ *	the WWAN core for the WWAN device. The default link will not be created
+ *	if the passed value is WWAN_NO_DEFAULT_LINK.
  *
  * Returns: 0 on success, a negative error code on failure
  */
 int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
-		      void *ctxt)
+		      void *ctxt, u32 def_link_id)
 {
 	struct wwan_device *wwandev;
 
@@ -932,6 +996,15 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 	wwandev->ops = ops;
 	wwandev->ops_ctxt = ctxt;
 
+	/* NB: we do not abort ops registration in case of default link
+	 * creation failure. Link ops is the management interface, while the
+	 * default link creation is a service option. And we should not prevent
+	 * a user from manually creating a link latter if service option failed
+	 * now.
+	 */
+	if (def_link_id != WWAN_NO_DEFAULT_LINK)
+		wwan_create_default_link(wwandev, def_link_id);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wwan_register_ops);
diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index a8582a58a385..5b62cf3b3c42 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -288,7 +288,7 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 
 	INIT_WORK(&dev->del_work, wwan_hwsim_dev_del_work);
 
-	err = wwan_register_ops(&dev->dev, &wwan_hwsim_wwan_rtnl_ops, dev);
+	err = wwan_register_ops(&dev->dev, &wwan_hwsim_wwan_rtnl_ops, dev, 1);
 	if (err)
 		goto err_unreg_dev;
 
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index e1981ea3a2fd..91590db70a12 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -126,6 +126,12 @@ void wwan_port_txon(struct wwan_port *port);
  */
 void *wwan_port_get_drvdata(struct wwan_port *port);
 
+/*
+ * Used to indicate that the WWAN core should not create a default network
+ * link.
+ */
+#define WWAN_NO_DEFAULT_LINK		U32_MAX
+
 /**
  * struct wwan_ops - WWAN device ops
  * @priv_size: size of private netdev data area
@@ -143,7 +149,7 @@ struct wwan_ops {
 };
 
 int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
-		      void *ctxt);
+		      void *ctxt, u32 def_link_id);
 
 void wwan_unregister_ops(struct device *parent);
 
-- 
2.26.3

