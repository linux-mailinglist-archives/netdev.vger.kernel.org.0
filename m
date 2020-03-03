Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D506B176B10
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgCCCsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbgCCCsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6979E24680;
        Tue,  3 Mar 2020 02:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203686;
        bh=oF0xEUGHLnM5+Uc5nUYYEJU5ATFGGvoruCj46yHPjcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQFZ9GPWz5GO8mewMjtMtCDfHAQB50BKVClH3eLvWJFEZkGDaea2tVUlH18ahGzKr
         73sTOeRqLlomADg2nF2f+gX3KhNO71TSPrWeOlf7kIoFhgFe3dNA56ModNDIs2IGuh
         qRCCIrGPmILc0594aKB4c9If1DgEbeHf7eCJVApM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/58] net: atlantic: check rpc result and wait for rpc address
Date:   Mon,  2 Mar 2020 21:47:03 -0500
Message-Id: <20200303024740.9511-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>

[ Upstream commit e7b5f97e6574dc4918e375d5f8d24ec31653cd6d ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 52646855495ed..873f9865f0d15 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -22,6 +22,7 @@
 #define HW_ATL_MIF_ADDR         0x0208U
 #define HW_ATL_MIF_VAL          0x020CU
 
+#define HW_ATL_MPI_RPC_ADDR     0x0334U
 #define HW_ATL_RPC_CONTROL_ADR  0x0338U
 #define HW_ATL_RPC_STATE_ADR    0x033CU
 
@@ -48,15 +49,14 @@
 #define FORCE_FLASHLESS 0
 
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
@@ -413,6 +413,10 @@ static int hw_atl_utils_init_ucp(struct aq_hw_s *self,
 					self, self->mbox_addr,
 					self->mbox_addr != 0U,
 					1000U, 10000U);
+	err = readx_poll_timeout_atomic(aq_fw1x_rpc_get, self,
+					self->rpc_addr,
+					self->rpc_addr != 0U,
+					1000U, 100000U);
 
 	return err;
 }
@@ -469,6 +473,12 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
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
@@ -950,6 +960,11 @@ static u32 hw_atl_utils_rpc_state_get(struct aq_hw_s *self)
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
2.20.1

