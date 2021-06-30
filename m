Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3586B3B7EFB
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 10:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhF3Ia3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 04:30:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:52739 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233278AbhF3Ia2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 04:30:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="208131961"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="208131961"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 01:28:00 -0700
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="419912864"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 01:27:58 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 3/3] vDPA/ifcvf: set_status() should get a adapter from the mgmt dev
Date:   Wed, 30 Jun 2021 16:21:45 +0800
Message-Id: <20210630082145.5729-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210630082145.5729-1-lingshan.zhu@intel.com>
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ifcvf_vdpa_set_status() should get a adapter from the
management device

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 7c2f64ca2163..28c71eef1d2b 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -212,13 +212,15 @@ static u8 ifcvf_vdpa_get_status(struct vdpa_device *vdpa_dev)
 
 static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
 {
+	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
 	struct ifcvf_adapter *adapter;
 	struct ifcvf_hw *vf;
 	u8 status_old;
 	int ret;
 
 	vf  = vdpa_to_vf(vdpa_dev);
-	adapter = dev_get_drvdata(vdpa_dev->dev.parent);
+	ifcvf_mgmt_dev = dev_get_drvdata(vdpa_dev->dev.parent);
+	adapter = ifcvf_mgmt_dev->adapter;
 	status_old = ifcvf_get_status(vf);
 
 	if (status_old == status)
-- 
2.27.0

