Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC6B49B07F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455679AbiAYJhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:37:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:42541 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350789AbiAYJbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 04:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643103078; x=1674639078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=awqaYgTgRNiL9sT8pUM13xpikrGICfXMnPjsQvcVDjQ=;
  b=X0h9nO37vMJRDW5qKUVmKO+as3Xr9aA0MWJb+4wnmorGjJa+o/KRe/kv
   mJ2iApIEKFbEHRDszWDCaWNMg12YEF/rP+zn6Qqylc2ASxrjZjz6RCKLO
   jxBOpRV175dSimd8YwiC0nCcDMANe5F+3aUp38X/kJV3iovVWxEvBImzG
   wC0sAN89BzBE0v04xIRfkpwbyy0BRfO+dxoEHUZr9G6nQC7pUS/xQR2No
   DWImvP7c64ND9D81wFlBZu/++PVNXUGVFmY37FOU7t4HwvNNYpsCdXH9/
   mH9z17Y/yC8Z5GaLlO9NBbobVkvHPX6t9JSxRf0Utpu5rd5Y8Qa9N/Aec
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226240755"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="226240755"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:25:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="520318757"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:25:02 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 1/4] vDPA/ifcvf: implement IO read/write helpers in the header file
Date:   Tue, 25 Jan 2022 17:17:41 +0800
Message-Id: <20220125091744.115996-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125091744.115996-1-lingshan.zhu@intel.com>
References: <20220125091744.115996-1-lingshan.zhu@intel.com>
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
index 7d41dfe48ade..397692ae671c 100644
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
index c486873f370a..949b4fb9d554 100644
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

