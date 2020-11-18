Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9658B2B7F78
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgKROce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:32:34 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:53335 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgKROcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:32:33 -0500
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0AIEWOjh032374;
        Wed, 18 Nov 2020 06:32:25 -0800
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net] cxgb4: fix the panic caused by non smac rewrite
Date:   Wed, 18 Nov 2020 20:02:13 +0530
Message-Id: <20201118143213.13319-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMT entry is allocated only when loopback Source MAC
rewriting is requested. Accessing SMT entry for non
smac rewrite cases results in kernel panic.

Fix the panic caused by non smac rewrite

Fixes: 937d84205884 ("cxgb4: set up filter action after rewrites")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 4e55f7081644..83b46440408b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -880,7 +880,8 @@ int set_filter_wr(struct adapter *adapter, int fidx)
 		 FW_FILTER_WR_OVLAN_VLD_V(f->fs.val.ovlan_vld) |
 		 FW_FILTER_WR_IVLAN_VLDM_V(f->fs.mask.ivlan_vld) |
 		 FW_FILTER_WR_OVLAN_VLDM_V(f->fs.mask.ovlan_vld));
-	fwr->smac_sel = f->smt->idx;
+	if (f->fs.newsmac)
+		fwr->smac_sel = f->smt->idx;
 	fwr->rx_chan_rx_rpl_iq =
 		htons(FW_FILTER_WR_RX_CHAN_V(0) |
 		      FW_FILTER_WR_RX_RPL_IQ_V(adapter->sge.fw_evtq.abs_id));
-- 
2.9.5

