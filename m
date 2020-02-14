Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE1215DB4E
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgBNPpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:45:17 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17428 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728859AbgBNPpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:45:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EFj7u1005985;
        Fri, 14 Feb 2020 07:45:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=nTV3r0z1YTr4OmZgpxhxQqx2OcwJ7Th5v2u62MA2kgE=;
 b=evnA0cbzSqJBoRx+i8mGui9vs0NX2AKUFgVW1glXom1VVRtV+SSo4iptrbpQioJs1P6X
 umtLm6FDUKCATzQJfPuYP7xmpS42teRO+jg+ajT+4hgbn1upaiyY1bcWMGCVUe/ocx1x
 fDmPjTMVWdT5Xwexg5Ek0r3JTE+6F9jhvIm1Ej+T6bAvks1f0tgxabmgAXUwSzO28t0g
 MeYL5IfQPCbBmRP2sSvs7d6mvjIHSfQDM2tt0ggIOs8u6HoIQ98PSGS4D0GyvG9qf97p
 6MgpIh9dQI0pcXa020TvmHmrZfEoJkwPI62d8A0/L0jHRGmKMcnwiWKexB+1gyNHB8KT 1A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5k3par-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:45:15 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:13 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:13 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:45:12 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 06EC53F703F;
        Fri, 14 Feb 2020 07:45:10 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dbogdanov@marvell.com>, <pbelous@marvell.com>,
        <ndanilov@marvell.com>, <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 2/8] net: atlantic: check rpc result and wait for rpc address
Date:   Fri, 14 Feb 2020 18:44:52 +0300
Message-ID: <293b71eea3185bb39ac3957e6cf18b3998361585.1580299250.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1580299250.git.irusskikh@marvell.com>
References: <cover.1580299250.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Artificial HW reliability tests revealed a possible hangup in
the driver. Normally, when device disappears from bus, all
register reads returns 0xFFFFFFFF.

At remote procedure invocation towards FW there is a logic
where result is compared with -1 in a loop.
That caused an infinite loop if hardware due to some issues
disappears from bus.

Add extra result checks to prevent this.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index f547baa6c954..354705f9bc49 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -22,6 +22,7 @@
 #define HW_ATL_MIF_ADDR         0x0208U
 #define HW_ATL_MIF_VAL          0x020CU
 
+#define HW_ATL_MPI_RPC_ADDR     0x0334U
 #define HW_ATL_RPC_CONTROL_ADR  0x0338U
 #define HW_ATL_RPC_STATE_ADR    0x033CU
 
@@ -53,15 +54,14 @@ enum mcp_area {
 };
 
 static int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual);
-
 static int hw_atl_utils_mpi_set_state(struct aq_hw_s *self,
 				      enum hal_atl_utils_fw_state_e state);
-
 static u32 hw_atl_utils_get_mpi_mbox_tid(struct aq_hw_s *self);
 static u32 hw_atl_utils_mpi_get_state(struct aq_hw_s *self);
 static u32 hw_atl_utils_mif_cmd_get(struct aq_hw_s *self);
 static u32 hw_atl_utils_mif_addr_get(struct aq_hw_s *self);
 static u32 hw_atl_utils_rpc_state_get(struct aq_hw_s *self);
+static u32 aq_fw1x_rpc_get(struct aq_hw_s *self);
 
 int hw_atl_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
 {
@@ -476,6 +476,10 @@ static int hw_atl_utils_init_ucp(struct aq_hw_s *self,
 					self, self->mbox_addr,
 					self->mbox_addr != 0U,
 					1000U, 10000U);
+	err = readx_poll_timeout_atomic(aq_fw1x_rpc_get, self,
+					self->rpc_addr,
+					self->rpc_addr != 0U,
+					1000U, 100000U);
 
 	return err;
 }
@@ -531,6 +535,12 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 						self, fw.val,
 						sw.tid == fw.tid,
 						1000U, 100000U);
+		if (err < 0)
+			goto err_exit;
+
+		err = aq_hw_err_from_flags(self);
+		if (err < 0)
+			goto err_exit;
 
 		if (fw.len == 0xFFFFU) {
 			err = hw_atl_utils_fw_rpc_call(self, sw.len);
@@ -1025,6 +1035,11 @@ static u32 hw_atl_utils_rpc_state_get(struct aq_hw_s *self)
 	return aq_hw_read_reg(self, HW_ATL_RPC_STATE_ADR);
 }
 
+static u32 aq_fw1x_rpc_get(struct aq_hw_s *self)
+{
+	return aq_hw_read_reg(self, HW_ATL_MPI_RPC_ADDR);
+}
+
 const struct aq_fw_ops aq_fw_1x_ops = {
 	.init = hw_atl_utils_mpi_create,
 	.deinit = hw_atl_fw1x_deinit,
-- 
2.17.1

