Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1233488FC5
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbiAJF1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:27:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:9535 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238702AbiAJF0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792413; x=1673328413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O4t9i/AKNYnzGZdgGMZEdQetQ7hbhCioKYXvHK22hEk=;
  b=B6Dz8Duo9dgeGfYlox3wKJ5lkdGco9YYNIK+QSyKmoxvx/bKlMaEzwUC
   3wjTST5lE3LXs4xVQIK1zdMI1x1TZAbrr4+o/y2V/6Pv7Y5qN2YWgGqTq
   ZDvA2DLUmGuG5hVWK+6gLlxwhzlVmFgG62Dho5sXRT6zGRQw/+yYqklW6
   An+Niy7wNDz/E83G8JUZA/+hFw59hosmvoCyx96bCL0nU6QEcbF6r77TT
   npAEJcDbB/jaZMVbUCseXctf3g6r+ByWqTCAzzTBkAYUKR+8kyLrj0xQL
   8N+tb07exCCER/3QMEZ41E0CzWKwRYHpGnqQTogf/Z6bzZILTzRM9ehIm
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479489"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479489"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="489892268"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:51 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/7] vDPA/ifcvf: implement IO read/write helpers in the header file
Date:   Mon, 10 Jan 2022 13:19:41 +0800
Message-Id: <20220110051947.84901-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110051947.84901-1-lingshan.zhu@intel.com>
References: <20220110051947.84901-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

re-implement IO read/write helpers in the header file, so that
they can be utilized among modules.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 36 --------------------------------
 drivers/vdpa/ifcvf/ifcvf_base.h | 37 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 2808f1ba9f7b..0b5df4cfaf06 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -10,42 +10,6 @@
 
 #include "ifcvf_base.h"
 
-static inline u8 ifc_ioread8(u8 __iomem *addr)
-{
-	return ioread8(addr);
-}
-static inline u16 ifc_ioread16 (__le16 __iomem *addr)
-{
-	return ioread16(addr);
-}
-
-static inline u32 ifc_ioread32(__le32 __iomem *addr)
-{
-	return ioread32(addr);
-}
-
-static inline void ifc_iowrite8(u8 value, u8 __iomem *addr)
-{
-	iowrite8(value, addr);
-}
-
-static inline void ifc_iowrite16(u16 value, __le16 __iomem *addr)
-{
-	iowrite16(value, addr);
-}
-
-static inline void ifc_iowrite32(u32 value, __le32 __iomem *addr)
-{
-	iowrite32(value, addr);
-}
-
-static void ifc_iowrite64_twopart(u64 val,
-				  __le32 __iomem *lo, __le32 __iomem *hi)
-{
-	ifc_iowrite32((u32)val, lo);
-	ifc_iowrite32(val >> 32, hi);
-}
-
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
 {
 	return container_of(hw, struct ifcvf_adapter, vf);
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 09918af3ecf8..c924a7673afb 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -42,6 +42,43 @@
 #define ifcvf_private_to_vf(adapter) \
 	(&((struct ifcvf_adapter *)adapter)->vf)
 
+static inline u8 ifc_ioread8(u8 __iomem *addr)
+{
+	return ioread8(addr);
+}
+
+static inline u16 ifc_ioread16(__le16 __iomem *addr)
+{
+	return ioread16(addr);
+}
+
+static inline u32 ifc_ioread32(__le32 __iomem *addr)
+{
+	return ioread32(addr);
+}
+
+static inline void ifc_iowrite8(u8 value, u8 __iomem *addr)
+{
+	iowrite8(value, addr);
+}
+
+static inline void ifc_iowrite16(u16 value, __le16 __iomem *addr)
+{
+	iowrite16(value, addr);
+}
+
+static inline void ifc_iowrite32(u32 value, __le32 __iomem *addr)
+{
+	iowrite32(value, addr);
+}
+
+static inline void ifc_iowrite64_twopart(u64 val,
+				  __le32 __iomem *lo, __le32 __iomem *hi)
+{
+	ifc_iowrite32((u32)val, lo);
+	ifc_iowrite32(val >> 32, hi);
+}
+
 struct vring_info {
 	u64 desc;
 	u64 avail;
-- 
2.27.0

