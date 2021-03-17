Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D19A33ED80
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhCQJy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:54:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:59767 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229658AbhCQJyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 05:54:44 -0400
IronPort-SDR: 2SewFoZHUFOjfedgrWyEZjT9DFMNpIsZu0f+MKNuskfsAUyhL2TNBX3/wuoO7VY5DUrnlpmXC2
 PnO5fWBsuKzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="187058668"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="187058668"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:44 -0700
IronPort-SDR: VfzgDxxndlBbQuklan0wiatpYmNeTDnNFpyU9A9dExTwkCnpyU7jfre+SC/6YGrf1r52nLIXMW
 iETrflmn8pLA==
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="405873175"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:41 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 1/7] vDPA/ifcvf: get_vendor_id returns a device specific vendor id
Date:   Wed, 17 Mar 2021 17:49:27 +0800
Message-Id: <20210317094933.16417-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317094933.16417-1-lingshan.zhu@intel.com>
References: <20210317094933.16417-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this commit, ifcvf_get_vendor_id() will return
a device specific vendor id of the probed pci device
than a hard code.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index fa1af301cf55..e501ee07de17 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -324,7 +324,10 @@ static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
 
 static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
 {
-	return IFCVF_SUBSYS_VENDOR_ID;
+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
+	struct pci_dev *pdev = adapter->pdev;
+
+	return pdev->subsystem_vendor;
 }
 
 static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
-- 
2.27.0

