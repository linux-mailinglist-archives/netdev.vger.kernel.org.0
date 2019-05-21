Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB372466D
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 05:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfEUDmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 23:42:31 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:13256 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfEUDmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 23:42:31 -0400
Received: from dalmore.blr.asicdesigners.com ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x4L3gFK7019944;
        Mon, 20 May 2019 20:42:21 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, indranil@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next] cxgb4: Revert "cxgb4: Remove SGE_HOST_PAGE_SIZE dependency on page size"
Date:   Tue, 21 May 2019 09:12:02 +0530
Message-Id: <1558410122-29341-1-git-send-email-vishal@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 2391b0030e241386d710df10e53e2cfc3c5d4fc1
SGE's BAR2 Doorbell/GTS Page Size is now interpreted correctly in the
firmware itself by using actual host page size. Hence previous commit
needs to be reverted.

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index f9b70be..93feb25 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -7253,10 +7253,21 @@ int t4_fixup_host_params(struct adapter *adap, unsigned int page_size,
 			 unsigned int cache_line_size)
 {
 	unsigned int page_shift = fls(page_size) - 1;
+	unsigned int sge_hps = page_shift - 10;
 	unsigned int stat_len = cache_line_size > 64 ? 128 : 64;
 	unsigned int fl_align = cache_line_size < 32 ? 32 : cache_line_size;
 	unsigned int fl_align_log = fls(fl_align) - 1;
 
+	t4_write_reg(adap, SGE_HOST_PAGE_SIZE_A,
+		     HOSTPAGESIZEPF0_V(sge_hps) |
+		     HOSTPAGESIZEPF1_V(sge_hps) |
+		     HOSTPAGESIZEPF2_V(sge_hps) |
+		     HOSTPAGESIZEPF3_V(sge_hps) |
+		     HOSTPAGESIZEPF4_V(sge_hps) |
+		     HOSTPAGESIZEPF5_V(sge_hps) |
+		     HOSTPAGESIZEPF6_V(sge_hps) |
+		     HOSTPAGESIZEPF7_V(sge_hps));
+
 	if (is_t4(adap->params.chip)) {
 		t4_set_reg_field(adap, SGE_CONTROL_A,
 				 INGPADBOUNDARY_V(INGPADBOUNDARY_M) |
-- 
1.8.3.1

