Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E7F20B879
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgFZSlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:41:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7516 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgFZSlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:41:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIf4Sw010743;
        Fri, 26 Jun 2020 11:41:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=nxvq5+MiLh7mD/XeI6ySyBI5tX3ndtuR5Rq5riBetC8=;
 b=eD1cXt5zAu2dhD6eWfy5jVxJTnv7HI97O7tfnHbEb4h0WTg5dXSe8jpWWk9tPeYEZT0D
 Ra0TDMSuQK0+nB2qR1PrnAmAgJpDJvdGPi4hwZh5tbLd5wLZBf6ZnMr+4Kt5FxN9eJc0
 bCGxLwRJxHFpJjN7fX7Q8K1nu1EC4LoGlBlpW5Pc5MxRuLKNHseJfRbFs9xA8c80hLp7
 trV1YWF+0e/Wl4KAj+B4vO74hP5tz88m8shzMXW9IUPwGsCAIBC205zEIxg9AdHZJdBK
 VtvmMYmlcVSQuAeYHExqIiQFPkzHJ7jtL9QhtMgO2XU7My3in2U3it0MbtrZFDyjF6f2 tQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh5u8c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:41:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:56 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 381DB3F703F;
        Fri, 26 Jun 2020 11:40:54 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 7/8] net: atlantic: add alignment checks in hw_atl2_utils_fw.c
Date:   Fri, 26 Jun 2020 21:40:37 +0300
Message-ID: <20200626184038.857-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626184038.857-1-irusskikh@marvell.com>
References: <20200626184038.857-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds alignment checks in all the helper macros in
hw_atl2_utils_fw.c
These alignment checks are compile-time, so runtime is not affected.

All these helper macros assume the length to be aligned (multiple of 4).
If it's not aligned, then there might be issues, e.g. stack corruption.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index 3a9352190816..a8ce9a2c1c51 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -16,15 +16,29 @@
 #define AQ_A2_FW_READ_TRY_MAX 1000
 
 #define hw_atl2_shared_buffer_write(HW, ITEM, VARIABLE) \
+{\
+	BUILD_BUG_ON_MSG((offsetof(struct fw_interface_in, ITEM) % \
+			 sizeof(u32)) != 0,\
+			 "Unaligned write " # ITEM);\
+	BUILD_BUG_ON_MSG((sizeof(VARIABLE) %  sizeof(u32)) != 0,\
+			 "Unaligned write length " # ITEM);\
 	hw_atl2_mif_shared_buf_write(HW,\
 		(offsetof(struct fw_interface_in, ITEM) / sizeof(u32)),\
-		(u32 *)&(VARIABLE), sizeof(VARIABLE) / sizeof(u32))
+		(u32 *)&(VARIABLE), sizeof(VARIABLE) / sizeof(u32));\
+}
 
 #define hw_atl2_shared_buffer_get(HW, ITEM, VARIABLE) \
+{\
+	BUILD_BUG_ON_MSG((offsetof(struct fw_interface_in, ITEM) % \
+			 sizeof(u32)) != 0,\
+			 "Unaligned get " # ITEM);\
+	BUILD_BUG_ON_MSG((sizeof(VARIABLE) %  sizeof(u32)) != 0,\
+			 "Unaligned get length " # ITEM);\
 	hw_atl2_mif_shared_buf_get(HW, \
 		(offsetof(struct fw_interface_in, ITEM) / sizeof(u32)),\
 		(u32 *)&(VARIABLE), \
-		sizeof(VARIABLE) / sizeof(u32))
+		sizeof(VARIABLE) / sizeof(u32));\
+}
 
 /* This should never be used on non atomic fields,
  * treat any > u32 read as non atomic.
@@ -33,7 +47,9 @@
 {\
 	BUILD_BUG_ON_MSG((offsetof(struct fw_interface_out, ITEM) % \
 			 sizeof(u32)) != 0,\
-			 "Non aligned read " # ITEM);\
+			 "Unaligned read " # ITEM);\
+	BUILD_BUG_ON_MSG((sizeof(VARIABLE) %  sizeof(u32)) != 0,\
+			 "Unaligned read length " # ITEM);\
 	BUILD_BUG_ON_MSG(sizeof(VARIABLE) > sizeof(u32),\
 			 "Non atomic read " # ITEM);\
 	hw_atl2_mif_shared_buf_read(HW, \
@@ -42,10 +58,18 @@
 }
 
 #define hw_atl2_shared_buffer_read_safe(HW, ITEM, DATA) \
+({\
+	BUILD_BUG_ON_MSG((offsetof(struct fw_interface_out, ITEM) % \
+			 sizeof(u32)) != 0,\
+			 "Unaligned read_safe " # ITEM);\
+	BUILD_BUG_ON_MSG((sizeof(((struct fw_interface_out *)0)->ITEM) % \
+			 sizeof(u32)) != 0,\
+			 "Unaligned read_safe length " # ITEM);\
 	hw_atl2_shared_buffer_read_block((HW), \
 		(offsetof(struct fw_interface_out, ITEM) / sizeof(u32)),\
 		sizeof(((struct fw_interface_out *)0)->ITEM) / sizeof(u32),\
-		(DATA))
+		(DATA));\
+})
 
 static int hw_atl2_shared_buffer_read_block(struct aq_hw_s *self,
 					    u32 offset, u32 dwords, void *data)
-- 
2.25.1

