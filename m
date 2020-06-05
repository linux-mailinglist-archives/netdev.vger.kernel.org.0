Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D133D1EF56A
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgFEKbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:31:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:57119 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgFEKbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 06:31:17 -0400
IronPort-SDR: sXaWKxSFYYfNT7jmkvjSDQ1pVRkH1t0Ol/nl9ELK0sxC5gKaqPqMqM2tC8j2C5aI9LlVTe9Teu
 8uh/RM1ls4JQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 03:31:15 -0700
IronPort-SDR: 0bnmV3ZfwMXxA2zLksdHpWARfLlbGjwdubLD8bLlPGSTLXWzssphfZ5b3Q4oRgssZCY8EbyV4l
 28ztewRd4jMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,476,1583222400"; 
   d="scan'208";a="305024968"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2020 03:31:13 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH RESEND 5/5] ifcvf: implement config interrupt in IFCVF
Date:   Fri,  5 Jun 2020 18:27:15 +0800
Message-Id: <1591352835-22441-6-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
References: <1591352835-22441-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements config interrupt support
in IFC VF

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |  3 +++
 drivers/vdpa/ifcvf/ifcvf_base.h |  4 ++++
 drivers/vdpa/ifcvf/ifcvf_main.c | 23 ++++++++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index e24371d..94bf032 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -185,6 +185,9 @@ void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
 
 void ifcvf_reset(struct ifcvf_hw *hw)
 {
+	hw->config_cb.callback = NULL;
+	hw->config_cb.private = NULL;
+
 	ifcvf_set_status(hw, 0);
 	/* flush set_status, make sure VF is stopped, reset */
 	ifcvf_get_status(hw);
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index e803070..f455441 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -27,6 +27,7 @@
 		((1ULL << VIRTIO_NET_F_MAC)			| \
 		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
 		 (1ULL << VIRTIO_F_VERSION_1)			| \
+		 (1ULL << VIRTIO_NET_F_STATUS)			| \
 		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
 		 (1ULL << VIRTIO_F_IOMMU_PLATFORM)		| \
 		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
@@ -81,6 +82,9 @@ struct ifcvf_hw {
 	void __iomem *net_cfg;
 	struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
 	void __iomem * const *base;
+	char config_msix_name[256];
+	struct vdpa_callback config_cb;
+
 };
 
 struct ifcvf_adapter {
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 63a6366..f5a60c1 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -18,6 +18,16 @@
 #define DRIVER_AUTHOR   "Intel Corporation"
 #define IFCVF_DRIVER_NAME       "ifcvf"
 
+static irqreturn_t ifcvf_config_changed(int irq, void *arg)
+{
+	struct ifcvf_hw *vf = arg;
+
+	if (vf->config_cb.callback)
+		return vf->config_cb.callback(vf->config_cb.private);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
 {
 	struct vring_info *vring = arg;
@@ -59,6 +69,14 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 		return ret;
 	}
 
+	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
+		 pci_name(pdev));
+	vector = 0;
+	irq = pci_irq_vector(pdev, vector);
+	ret = devm_request_irq(&pdev->dev, irq,
+			       ifcvf_config_changed, 0,
+			       vf->config_msix_name, vf);
+
 	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
 		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
 			 pci_name(pdev), i);
@@ -328,7 +346,10 @@ static void ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
 static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
 				     struct vdpa_callback *cb)
 {
-	/* We don't support config interrupt */
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+
+	vf->config_cb.callback = cb->callback;
+	vf->config_cb.private = cb->private;
 }
 
 /*
-- 
1.8.3.1

