Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13476052FE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiJSWY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiJSWY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:24:26 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAD7B2646;
        Wed, 19 Oct 2022 15:24:22 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 7059A20FE892; Wed, 19 Oct 2022 15:24:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7059A20FE892
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1666218262;
        bh=rwVxEsxu7JjwiZgZjI9rnYUFS4A1egO/GwxRV1e+7jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=Ah/kYEzWBNfekdtbd3hkpOPxBmvF/cfZmNAnMzYGwFFaHSS6+bBZ0X+eOWVyxC9uP
         td5aJkmZ7ljDLK/f0DWQVAop5vj1wnQtsYplolXzMaEpMNFXKWpDZokcqQX7Ry7IFp
         NLGe4vBIOYRDZnBT/QFs6PCd2ok08IHCiKFqncNA=
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
Subject: [Patch v8 01/12] net: mana: Add support for auxiliary device
Date:   Wed, 19 Oct 2022 15:24:01 -0700
Message-Id: <1666218252-32191-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

In preparation for supporting MANA RDMA driver, add support for auxiliary
device in the Ethernet driver. The RDMA device is modeled as an auxiliary
device to the Ethernet device.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Change log:
v3: define mana_adev_idx_alloc and mana_adev_idx_free as static
v7: fix a bug that may assign a negative value to adev->id

 drivers/net/ethernet/microsoft/Kconfig        |  1 +
 drivers/net/ethernet/microsoft/mana/gdma.h    |  2 +
 .../ethernet/microsoft/mana/mana_auxiliary.h  | 10 +++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 83 ++++++++++++++++++-
 4 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_auxiliary.h

diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
index fe4e7a7d9c0b..090e6b983243 100644
--- a/drivers/net/ethernet/microsoft/Kconfig
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -19,6 +19,7 @@ config MICROSOFT_MANA
 	tristate "Microsoft Azure Network Adapter (MANA) support"
 	depends on PCI_MSI && X86_64
 	depends on PCI_HYPERV
+	select AUXILIARY_BUS
 	help
 	  This driver supports Microsoft Azure Network Adapter (MANA).
 	  So far, the driver is only supported on X86_64.
diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 4a6efe6ada08..f321a2616d03 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -204,6 +204,8 @@ struct gdma_dev {
 
 	/* GDMA driver specific pointer */
 	void *driver_data;
+
+	struct auxiliary_device *adev;
 };
 
 #define MINIMUM_SUPPORTED_PAGE_SIZE PAGE_SIZE
diff --git a/drivers/net/ethernet/microsoft/mana/mana_auxiliary.h b/drivers/net/ethernet/microsoft/mana/mana_auxiliary.h
new file mode 100644
index 000000000000..373d59756846
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/mana_auxiliary.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022, Microsoft Corporation. */
+
+#include "mana.h"
+#include <linux/auxiliary_bus.h>
+
+struct mana_adev {
+	struct auxiliary_device adev;
+	struct gdma_dev *mdev;
+};
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9259a74eca40..8751e475d1ba 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -13,6 +13,19 @@
 #include <net/ip6_checksum.h>
 
 #include "mana.h"
+#include "mana_auxiliary.h"
+
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
 
 /* Microsoft Azure Network Adapter (MANA) functions */
 
@@ -2106,6 +2119,69 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
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
+	struct auxiliary_device *adev;
+	struct mana_adev *madev;
+	int ret;
+
+	madev = kzalloc(sizeof(*madev), GFP_KERNEL);
+	if (!madev)
+		return -ENOMEM;
+
+	adev = &madev->adev;
+	ret = mana_adev_idx_alloc();
+	if (ret < 0)
+		goto idx_fail;
+	adev->id = ret;
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
@@ -2173,6 +2249,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 				break;
 		}
 	}
+
+	err = add_adev(gd);
 out:
 	if (err)
 		mana_remove(gd, false);
@@ -2189,6 +2267,10 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	int err;
 	int i;
 
+	/* adev currently doesn't support suspending, always remove it */
+	if (gd->adev)
+		remove_adev(gd);
+
 	for (i = 0; i < ac->num_ports; i++) {
 		ndev = ac->ports[i];
 		if (!ndev) {
@@ -2221,7 +2303,6 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	}
 
 	mana_destroy_eq(ac);
-
 out:
 	mana_gd_deregister_device(gd);
 
-- 
2.17.1

