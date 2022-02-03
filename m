Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4A84A7FE1
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 08:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349407AbiBCHey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 02:34:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:32403 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbiBCHew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 02:34:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643873692; x=1675409692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=awqaYgTgRNiL9sT8pUM13xpikrGICfXMnPjsQvcVDjQ=;
  b=TKilfZr1ZTfEeo6dcur3gJ6yugc4ZMtYN2UwAK1TsKJaWKP6MxYw8BiJ
   O8auC+vALoIWrx4eBTH7EyhJYn8hUj5FRV2qDL7qdbTHJv2welWyO34IB
   M4Zidb+yDUg72LThpqHGpwlAtwRpDwuNlKtx6lH4rdHZfxPhTMgZGhMSZ
   mfXcfwdXZJzK1OJeq9VYpHobu3p8Qli86jxMnssGNpg83TIZwb4Rw88/y
   Q/1ftlinWzgzL2N1+eqj+omkjHbmT2vVvxf0rVl46rWw6UhrRIlxXaXf1
   JruqbUZYZ+CgFzwE+CDuG/+hDpTPsDv66fysZLaK+bgeleySI5xQpW7cN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="311397569"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="311397569"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 23:34:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="771703678"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 23:34:50 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 1/4] vDPA/ifcvf: implement IO read/write helpers in the header file
Date:   Thu,  3 Feb 2022 15:27:32 +0800
Message-Id: <20220203072735.189716-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220203072735.189716-1-lingshan.zhu@intel.com>
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
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

