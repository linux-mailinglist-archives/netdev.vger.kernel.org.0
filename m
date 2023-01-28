Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E83167F3F6
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 03:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjA1CY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 21:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjA1CYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 21:24:55 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1DF241EF;
        Fri, 27 Jan 2023 18:24:54 -0800 (PST)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4P3dX0039Pz16NNs;
        Sat, 28 Jan 2023 10:22:55 +0800 (CST)
Received: from huawei.com (10.175.113.32) by kwepemm600003.china.huawei.com
 (7.193.23.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sat, 28 Jan
 2023 10:24:51 +0800
From:   Nanyong Sun <sunnanyong@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <mst@redhat.com>, <jasowang@redhat.com>
CC:     <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <wangrong68@huawei.com>,
        <sunnanyong@huawei.com>
Subject: [PATCH] vhost/vdpa: Add MSI translation tables to iommu for software-managed MSI
Date:   Sat, 28 Jan 2023 11:17:40 +0800
Message-ID: <20230128031740.166743-1-sunnanyong@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rong Wang <wangrong68@huawei.com>

Once enable iommu domain for one device, the MSI
translation tables have to be there for software-managed MSI.
Otherwise, platform with software-managed MSI without an
irq bypass function, can not get a correct memory write event
from pcie, will not get irqs.
The solution is to obtain the MSI phy base address from
iommu reserved region, and set it to iommu MSI cookie,
then translation tables will be created while request irq.

Signed-off-by: Rong Wang <wangrong68@huawei.com>
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
---
 drivers/iommu/iommu.c |  1 +
 drivers/vhost/vdpa.c  | 53 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index de91dd88705b..f6c65d5d8e2b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2623,6 +2623,7 @@ void iommu_get_resv_regions(struct device *dev, struct list_head *list)
 	if (ops->get_resv_regions)
 		ops->get_resv_regions(dev, list);
 }
+EXPORT_SYMBOL_GPL(iommu_get_resv_regions);
 
 /**
  * iommu_put_resv_regions - release resered regions
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f785dfde..31d3e9ed4cfa 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1103,6 +1103,48 @@ static ssize_t vhost_vdpa_chr_write_iter(struct kiocb *iocb,
 	return vhost_chr_write_iter(dev, from);
 }
 
+static bool vhost_vdpa_check_sw_msi(struct list_head *dev_resv_regions, phys_addr_t *base)
+{
+	struct iommu_resv_region *region;
+	bool ret = false;
+
+	list_for_each_entry(region, dev_resv_regions, list) {
+		/*
+		 * The presence of any 'real' MSI regions should take
+		 * precedence over the software-managed one if the
+		 * IOMMU driver happens to advertise both types.
+		 */
+		if (region->type == IOMMU_RESV_MSI) {
+			ret = false;
+			break;
+		}
+
+		if (region->type == IOMMU_RESV_SW_MSI) {
+			*base = region->start;
+			ret = true;
+		}
+	}
+
+	return ret;
+}
+
+static int vhost_vdpa_get_msi_cookie(struct iommu_domain *domain, struct device *dma_dev)
+{
+	struct list_head dev_resv_regions;
+	phys_addr_t resv_msi_base = 0;
+	int ret = 0;
+
+	INIT_LIST_HEAD(&dev_resv_regions);
+	iommu_get_resv_regions(dma_dev, &dev_resv_regions);
+
+	if (vhost_vdpa_check_sw_msi(&dev_resv_regions, &resv_msi_base))
+		ret = iommu_get_msi_cookie(domain, resv_msi_base);
+
+	iommu_put_resv_regions(dma_dev, &dev_resv_regions);
+
+	return ret;
+}
+
 static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -1128,11 +1170,16 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 
 	ret = iommu_attach_device(v->domain, dma_dev);
 	if (ret)
-		goto err_attach;
+		goto err_alloc_domain;
 
-	return 0;
+	ret = vhost_vdpa_get_msi_cookie(v->domain, dma_dev);
+	if (ret)
+		goto err_attach_device;
 
-err_attach:
+	return 0;
+err_attach_device:
+	iommu_detach_device(v->domain, dma_dev);
+err_alloc_domain:
 	iommu_domain_free(v->domain);
 	return ret;
 }
-- 
2.25.1

