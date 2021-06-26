Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848DC3B500E
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 22:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhFZUUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 16:20:30 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47369 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFZUU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 16:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1624738688; x=1656274688;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vj06UnUe+oVLWflWqrlGCKDMOgEci9fLJMM5g30tqRE=;
  b=sb2nlx9+zTH4mOjIPgo1acbnIkCj80jqq6MxcNpXg1GsTtQ7qdhIshN3
   6w9hWIPDDZk0p7+tCTQGUITZbU2iJ5b0Gpc73l+1GWAGkVxc8dkqA//hP
   BZtt58bFfyQ2lKBWiasZ907FbZWlYYas1IsA1LatvPlElB2ifrjtqRwpF
   mAb3SBZQCzfB8znpyOPEZj5C5bbkX+UZN2rxh9oNec1NgY/gdv9Yf5nrc
   nL8gyM6litaHLjri3+t0Vool06K3j4gp7Io8B4kvyAL38lBIeWKoBr6Lp
   rPIj4SJIyhKsJyzKro6wghbJY3E/xIK+ZnXV73KoCzHXq35cyNveRIYXN
   w==;
IronPort-SDR: ztSG1olJ2Bds/m8/Gi1TACcSWf+gP6A2orPaDBuiIYeKTvm4L353Pf+vrzsJZ7F4DWQFsWX7FA
 80boQk1bZ4oMETSrbt6xjvtChVuEAAdx333bkLfiH1+E2RkiLLMQvSVh+Xzb/8XBKgOASK3lde
 yZL7RbAkyCTOKl43GncNKSeAW24vTKF5sWkiwSmbQ5e0JLkzSxw6t6DUNmpGibWWzJ+FraNG6i
 x0646KabKvTH0+YbIQpo4xXJst9VJJ8A6MLVMr0tkWwAB5Su0e43mHQaZamxNy1Bv8xkr4Rw+f
 mRs=
X-IronPort-AV: E=Sophos;i="5.83,302,1616482800"; 
   d="scan'208";a="126184537"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2021 13:18:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 13:18:06 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Sat, 26 Jun 2021 13:18:05 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <roopa@nvidia.com>, <nikolay@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <bridge@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: bridge: mrp: Update the Test frames for MRA
Date:   Sat, 26 Jun 2021 22:18:04 +0200
Message-ID: <20210626201804.1737815-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the standard IEC 62439-2, in case the node behaves as MRA
and needs to send Test frames on ring ports, then these Test frames need
to have an Option TLV and a Sub-Option TLV which has the type AUTO_MGR.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c         | 27 +++++++++++++++++++++++++++
 net/bridge/br_private_mrp.h | 11 +++++++++++
 2 files changed, 38 insertions(+)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index f7012b7d7ce4..fd2de35ffb3c 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -204,6 +204,33 @@ static struct sk_buff *br_mrp_alloc_test_skb(struct br_mrp *mrp,
 	hdr->timestamp = cpu_to_be32(jiffies_to_msecs(jiffies));
 
 	br_mrp_skb_common(skb, mrp);
+
+	/* In case the node behaves as MRA then the Test frame needs to have
+	 * an Option TLV which includes eventually a sub-option TLV that has
+	 * the type AUTO_MGR
+	 */
+	if (mrp->ring_role == BR_MRP_RING_ROLE_MRA) {
+		struct br_mrp_sub_option1_hdr *sub_opt = NULL;
+		struct br_mrp_tlv_hdr *sub_tlv = NULL;
+		struct br_mrp_oui_hdr *oui = NULL;
+		u8 length;
+
+		length = sizeof(*sub_opt) + sizeof(*sub_tlv) + sizeof(oui) +
+			MRP_OPT_PADDING;
+		br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_OPTION, length);
+
+		oui = skb_put(skb, sizeof(*oui));
+		memset(oui, 0x0, sizeof(*oui));
+		sub_opt = skb_put(skb, sizeof(*sub_opt));
+		memset(sub_opt, 0x0, sizeof(*sub_opt));
+
+		sub_tlv = skb_put(skb, sizeof(*sub_tlv));
+		sub_tlv->type = BR_MRP_SUB_TLV_HEADER_TEST_AUTO_MGR;
+
+		/* 32 bit alligment shall be ensured therefore add 2 bytes */
+		skb_put(skb, MRP_OPT_PADDING);
+	}
+
 	br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_END, 0x0);
 
 	return skb;
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 9559aa2750fb..bda8e1896712 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -6,6 +6,8 @@
 #include "br_private.h"
 #include <uapi/linux/mrp_bridge.h>
 
+#define MRP_OPT_PADDING		0x2
+
 struct br_mrp {
 	/* list of mrp instances */
 	struct hlist_node		list;
@@ -134,4 +136,13 @@ struct br_mrp_in_test_hdr {
 	__be32 timestamp;
 } __attribute__((__packed__));
 
+struct br_mrp_oui_hdr {
+	__u8 oui[MRP_OUI_LENGTH];
+};
+
+struct br_mrp_sub_option1_hdr {
+	__u8 type;
+	__u8 data[MRP_MANUFACTURE_DATA_LENGTH];
+};
+
 #endif /* _BR_PRIVATE_MRP_H */
-- 
2.31.1

