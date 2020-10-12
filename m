Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B10628AF26
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgJLHkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:40:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57432 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727360AbgJLHkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:40:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09C7VvxG010864;
        Mon, 12 Oct 2020 00:40:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=mIT8l6xxChNBp/fwuCl16jRzEfyLjwLF92nvQp3o60A=;
 b=b0NA09ZKnKPfQpQ11tEdWQ9HO8y7STLL9iXQDhA7iU8byko8+Yoqg+pHqtwE5Tl1NeiF
 wCEfy1LaIvq35DPvMMRrZdhcY701uBixturBMzNl23ad9/dAe2FeXNzum9jDlQQorrXT
 lLjAklLD7MKDVkRvG2dHWIep0+54s+yKntkvh0HPvFv9RGH5RSM+SJkeIDBP7/hfLP0l
 XkinEpySvNAJJiIa8Sq2t0bO1MN1no0J85aF6XxPZOs6Dse36Pl5uNM2tZdJ4/ButNHX
 wSqKm4Ca97ltJkFWWRyQI9Vvn/fmdhwbeIWZ1UbVCL8z/j7QNu/0Vx8D4KnRivzTjPQA yg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 343cfj4qg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 00:40:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 00:40:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Oct 2020 00:40:04 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 9CC993F7040;
        Mon, 12 Oct 2020 00:39:59 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v5,net-next,01/13] octeontx2-pf: move lmt flush to include/linux/soc
Date:   Mon, 12 Oct 2020 13:09:19 +0530
Message-ID: <20201012073931.28766-2-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012073931.28766-1-schalla@marvell.com>
References: <20201012073931.28766-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_03:2020-10-12,2020-10-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OcteonTX2 platform CPT instruction enqueue and NIX
packet send are only possible via LMTST operations which
uses LDEOR instruction. This patch moves lmt flush
function from OcteonTX2 nic driver to include/linux/soc
since it will be used by OcteonTX2 CPT and NIC driver for
LMTST.

Change-Id: I148c654bc0196826fd2664986d204f08c632f793
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 MAINTAINERS                                   |  2 ++
 .../marvell/octeontx2/nic/otx2_common.h       | 13 +--------
 include/linux/soc/marvell/octeontx2/asm.h     | 29 +++++++++++++++++++
 3 files changed, 32 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/soc/marvell/octeontx2/asm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c80f87d7258c..ee903a39e2e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10441,6 +10441,7 @@ M:	Srujana Challa <schalla@marvell.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/marvell/
+F:	include/linux/soc/marvell/octeontx2/
 
 MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
 M:	Mirko Lindner <mlindner@marvell.com>
@@ -10513,6 +10514,7 @@ M:	hariprasad <hkelam@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/marvell/octeontx2/nic/
+F:	include/linux/soc/marvell/octeontx2/
 
 MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER
 M:	Sunil Goutham <sgoutham@marvell.com>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index d6253f2a414d..2e8288445dcb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -16,6 +16,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
+#include <linux/soc/marvell/octeontx2/asm.h>
 
 #include <mbox.h>
 #include "otx2_reg.h"
@@ -421,21 +422,9 @@ static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
 	return result;
 }
 
-static inline u64 otx2_lmt_flush(uint64_t addr)
-{
-	u64 result = 0;
-
-	__asm__ volatile(".cpu  generic+lse\n"
-			 "ldeor xzr,%x[rf],[%[rs]]"
-			 : [rf]"=r"(result)
-			 : [rs]"r"(addr));
-	return result;
-}
-
 #else
 #define otx2_write128(lo, hi, addr)
 #define otx2_atomic64_add(incr, ptr)		({ *ptr += incr; })
-#define otx2_lmt_flush(addr)			({ 0; })
 #endif
 
 /* Alloc pointer from pool/aura */
diff --git a/include/linux/soc/marvell/octeontx2/asm.h b/include/linux/soc/marvell/octeontx2/asm.h
new file mode 100644
index 000000000000..ae2279fe830a
--- /dev/null
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __SOC_OTX2_ASM_H
+#define __SOC_OTX2_ASM_H
+
+#if defined(CONFIG_ARM64)
+/*
+ * otx2_lmt_flush is used for LMT store operation.
+ * On octeontx2 platform CPT instruction enqueue and
+ * NIX packet send are only possible via LMTST
+ * operations and it uses LDEOR instruction targeting
+ * the coprocessor address.
+ */
+#define otx2_lmt_flush(ioaddr)                          \
+({                                                      \
+	u64 result = 0;                                 \
+	__asm__ volatile(".cpu  generic+lse\n"          \
+			 "ldeor xzr, %x[rf], [%[rs]]"   \
+			 : [rf]"=r" (result)            \
+			 : [rs]"r" (ioaddr));           \
+	(result);                                       \
+})
+#else
+#define otx2_lmt_flush(ioaddr)          ({ 0; })
+#endif
+
+#endif /* __SOC_OTX2_ASM_H */
-- 
2.28.0

