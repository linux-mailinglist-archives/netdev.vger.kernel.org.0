Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A271F49CA21
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbiAZM4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:56:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:29543 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241558AbiAZM4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:56:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643201774; x=1674737774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=awqaYgTgRNiL9sT8pUM13xpikrGICfXMnPjsQvcVDjQ=;
  b=I+rm9Z47m8sLU7x1M5NLSZLQbt3qQX2VqycGUaNVePqttZyxwQ5k4C4E
   9iHX7mmH5O5PuRvwmGBZqS+7US6sgXBrb9zHMxF3c93Lq23YMz8ugUag7
   jiJsex/9LrAdBSey1KxfajTq7JnvmCydpicKFE5YdnZNh0z+WypLvhbDm
   TP2c8lxw5ktz/fsZxD0qnZ8IXLUvWZXWuElBBTrzZe4JVn3k0IyVWpdxz
   29aon3DBAoQFcTXkWs2XEfoV4VbKM6uiUQA0Sj2LNlsXPOZ/b51O6c51y
   x+AdTpWKUzJ00hlqKKkQGX83KlyQdbZ/7SYpcXGM/NyoZwj39YZ+MI/EJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244141258"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="244141258"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="520783488"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:12 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 1/4] vDPA/ifcvf: implement IO read/write helpers in the header file
Date:   Wed, 26 Jan 2022 20:49:09 +0800
Message-Id: <20220126124912.90205-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126124912.90205-1-lingshan.zhu@intel.com>
References: <20220126124912.90205-1-lingshan.zhu@intel.com>
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

