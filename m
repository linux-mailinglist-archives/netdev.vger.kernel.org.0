Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A339547C55
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiFLVPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiFLVPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:15:09 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BDCF13CCA;
        Sun, 12 Jun 2022 14:15:08 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 6D5B820C14C5; Sun, 12 Jun 2022 14:15:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6D5B820C14C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655068508;
        bh=EClUPTjymD22GzOVOedSKpBiLTxVWxxsjCAzhUYzNpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=Khuw0dilVJgYcc/sZjmXLiN6hBBb4BBCWbBtA3DePdcWbAkzGKGpv/Yaq4EVMXCe1
         SzdglWxlkqeITFZwuPT5kRUxRkGG8gpqOOuc943KsTDHilKj9bN7Lif29ekDBnfaTr
         puLkqpLfVQzbh4Lhxb/MCG3YLcxpdzVfkACABJgg=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [Patch v3 01/12] net: mana: Add support for auxiliary device
Date:   Sun, 12 Jun 2022 14:14:43 -0700
Message-Id: <1655068494-16440-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
References: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

In preparation for supporting MANA RDMA driver, add support for auxiliary
device in the Ethernet driver. The RDMA device is modeled as an auxiliary
device to the Ethernet device.

Signed-off-by: Long Li <longli@microsoft.com>
---
Change log:
v3: define mana_adev_idx_alloc and mana_adev_idx_free as static

 drivers/net/ethernet/microsoft/mana/gdma.h    |  2 +
 drivers/net/ethernet/microsoft/mana/mana.h    |  6 ++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 83 ++++++++++++++++++-
 3 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 41ecd156e95f..d815d323be87 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -204,6 +204,8 @@ struct gdma_dev {
 
 	/* GDMA driver specific pointer */
 	void *driver_data;
+
+	struct auxiliary_device *adev;
 };
 
 #define MINIMUM_SUPPORTED_PAGE_SIZE PAGE_SIZE
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index d36405af9432..51bff91b63ee 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -6,6 +6,7 @@
 
 #include "gdma.h"
 #include "hw_channel.h"
+#include <linux/auxiliary_bus.h>
 
 /* Microsoft Azure Network Adapter (MANA)'s definitions
  *
@@ -561,4 +562,9 @@ struct mana_tx_package {
 	struct gdma_posted_wqe_info wqe_info;
 };
 
+struct mana_adev {
+	struct auxiliary_device adev;
+	struct gdma_dev *mdev;
+};
+
 #endif /* _MANA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index b7d3ba1b4d17..745a9783dd70 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -13,6 +13,18 @@
 
 #include "mana.h"
 
+static DEFINE_IDA(mana_adev_ida);
+
+static int mana_adev_idx_alloc(void)
+{
+	return ida_alloc(&mana_adev_ida, GFP_KERNEL);
+}
+
+static void mana_adev_idx_free(int idx)
+{
+	ida_free(&mana_adev_ida, idx);
+}
+
 /* Microsoft Azure Network Adapter (MANA) functions */
 
 static int mana_open(struct net_device *ndev)
@@ -1960,6 +1972,70 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	return err;
 }
 
+static void adev_release(struct device *dev)
+{
+	struct mana_adev *madev = container_of(dev, struct mana_adev, adev.dev);
+
+	kfree(madev);
+}
+
+static void remove_adev(struct gdma_dev *gd)
+{
+	struct auxiliary_device *adev = gd->adev;
+	int id = adev->id;
+
+	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
+
+	mana_adev_idx_free(id);
+	gd->adev = NULL;
+}
+
+static int add_adev(struct gdma_dev *gd)
+{
+	int ret = 0;
+	struct mana_adev *madev;
+	struct auxiliary_device *adev;
+
+	madev = kzalloc(sizeof(*madev), GFP_KERNEL);
+	if (!madev)
+		return -ENOMEM;
+
+	adev = &madev->adev;
+	adev->id = mana_adev_idx_alloc();
+	if (adev->id < 0) {
+		ret = adev->id;
+		goto idx_fail;
+	}
+
+	adev->name = "rdma";
+	adev->dev.parent = gd->gdma_context->dev;
+	adev->dev.release = adev_release;
+	madev->mdev = gd;
+
+	ret = auxiliary_device_init(adev);
+	if (ret)
+		goto init_fail;
+
+	ret = auxiliary_device_add(adev);
+	if (ret)
+		goto add_fail;
+
+	gd->adev = adev;
+	return 0;
+
+add_fail:
+	auxiliary_device_uninit(adev);
+
+init_fail:
+	mana_adev_idx_free(adev->id);
+
+idx_fail:
+	kfree(madev);
+
+	return ret;
+}
+
 int mana_probe(struct gdma_dev *gd, bool resuming)
 {
 	struct gdma_context *gc = gd->gdma_context;
@@ -2027,6 +2103,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 				break;
 		}
 	}
+
+	err = add_adev(gd);
 out:
 	if (err)
 		mana_remove(gd, false);
@@ -2043,6 +2121,10 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	int err;
 	int i;
 
+	/* adev currently doesn't support suspending, always remove it */
+	if (gd->adev)
+		remove_adev(gd);
+
 	for (i = 0; i < ac->num_ports; i++) {
 		ndev = ac->ports[i];
 		if (!ndev) {
@@ -2075,7 +2157,6 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	}
 
 	mana_destroy_eq(ac);
-
 out:
 	mana_gd_deregister_device(gd);
 
-- 
2.17.1

