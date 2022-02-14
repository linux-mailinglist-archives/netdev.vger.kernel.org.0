Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7074B427B
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 08:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiBNHHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 02:07:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241242AbiBNHHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 02:07:47 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B9B57B3D
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 23:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644822459; x=1676358459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4fQ5AqI/mm8qssZmVts1W66hjv3QYQyfAYacXYFWGSU=;
  b=FAcoWNvtaM3nx85n2zuDoaOpRLqBpM/RGANG84th1C8NsoIiwgasBWC0
   pJIjICd80uZ3Oi2l6Xetm8tnManjpmvaAg7V+Jd46t1VIsjFFydrzPUCn
   Tg1uHbn5wLqKTVuV3IYV3Qp4ACJJS/H7FHG/PJnMnG9fv3kYer8N8PXvh
   ovNE2fqSrGrMxDD3r1Iv7lbarYLsdnUlIL1ucsxjk/p8M9nLyCW9mXT8E
   4s0XdyrQNntg/LvpZAwKgfuEfRHpZ6p3jevdS3YfclGq2JIpAlzwHeu7S
   tVQvagUUsu60gmnIDwiG+AgFBFzAUCyYqiLAMehPmP73385cnc9l8t0fy
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="248862568"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="248862568"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 23:07:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="680286218"
Received: from ccgwwan-desktop15.iind.intel.com (HELO BSWCG005.iind.intel.com) ([10.224.174.19])
  by fmsmga001.fm.intel.com with ESMTP; 13 Feb 2022 23:07:36 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net-next 1/2] net: wwan: debugfs obtained dev reference not dropped
Date:   Mon, 14 Feb 2022 12:46:52 +0530
Message-Id: <20220214071653.813010-2-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214071653.813010-1-m.chetan.kumar@linux.intel.com>
References: <20220214071653.813010-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WWAN driver call's wwan_get_debugfs_dir() to obtain
WWAN debugfs dir entry. As part of this procedure it
returns a reference to a found device.

Since there is no debugfs interface available at WWAN
subsystem, it is not possible to drop dev reference post
debugfs use. This leads to side effects like post wwan
driver load and reload the wwan instance gets increment
from wwanX to wwanX+1.

A new debugfs interface is added in wwan subsystem so that
wwan driver can drop the obtained dev reference post debugfs
use.

void wwan_put_debugfs_dir(struct dentry *dir)

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/wwan_core.c | 35 +++++++++++++++++++++++++++++++++++
 include/linux/wwan.h         |  2 ++
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 1508dc2a497b..147b88464cbd 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -160,6 +160,42 @@ struct dentry *wwan_get_debugfs_dir(struct device *parent)
 	return wwandev->debugfs_dir;
 }
 EXPORT_SYMBOL_GPL(wwan_get_debugfs_dir);
+
+static int wwan_dev_debugfs_match(struct device *dev, const void *dir)
+{
+	struct wwan_device *wwandev;
+
+	if (dev->type != &wwan_dev_type)
+		return 0;
+
+	wwandev = to_wwan_dev(dev);
+
+	return wwandev->debugfs_dir == dir;
+}
+
+static struct wwan_device *wwan_dev_get_by_debugfs(struct dentry *dir)
+{
+	struct device *dev;
+
+	dev = class_find_device(wwan_class, NULL, dir, wwan_dev_debugfs_match);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	return to_wwan_dev(dev);
+}
+
+void wwan_put_debugfs_dir(struct dentry *dir)
+{
+	struct wwan_device *wwandev = wwan_dev_get_by_debugfs(dir);
+
+	if (WARN_ON(IS_ERR(wwandev)))
+		return;
+
+	/* wwan_dev_get_by_debugfs() also got a reference */
+	put_device(&wwandev->dev);
+	put_device(&wwandev->dev);
+}
+EXPORT_SYMBOL_GPL(wwan_put_debugfs_dir);
 #endif
 
 /* This function allocates and registers a new WWAN device OR if a WWAN device
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index afb3334ec8c5..5ce2acf444fb 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -174,11 +174,13 @@ void wwan_unregister_ops(struct device *parent);
 
 #ifdef CONFIG_WWAN_DEBUGFS
 struct dentry *wwan_get_debugfs_dir(struct device *parent);
+void wwan_put_debugfs_dir(struct dentry *dir);
 #else
 static inline struct dentry *wwan_get_debugfs_dir(struct device *parent)
 {
 	return ERR_PTR(-ENODEV);
 }
+static inline void wwan_put_debugfs_dir(struct dentry *dir) {}
 #endif
 
 #endif /* __WWAN_H */
-- 
2.25.1

