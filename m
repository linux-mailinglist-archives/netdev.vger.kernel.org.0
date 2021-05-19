Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D25388C95
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349868AbhESLUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:20:14 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:35274 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349779AbhESLUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 07:20:08 -0400
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 14JBIfVi032445;
        Wed, 19 May 2021 04:18:42 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net] cxgb4: avoid accessing registers when clearing filters
Date:   Wed, 19 May 2021 16:48:31 +0530
Message-Id: <20210519111831.12478-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware register having the server TID base can contain
invalid values when adapter is in bad state (for example,
due to AER fatal error). Reading these invalid values in the
register can lead to out-of-bound memory access. So, fix
by using the saved server TID base when clearing filters.

Fixes: b1a79360ee86 ("cxgb4: Delete all hash and TCAM filters before resource cleanup")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index bc581b149b11..22c9ac922eba 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1042,7 +1042,7 @@ void clear_all_filters(struct adapter *adapter)
 				cxgb4_del_filter(dev, f->tid, &f->fs);
 		}
 
-		sb = t4_read_reg(adapter, LE_DB_SRVR_START_INDEX_A);
+		sb = adapter->tids.stid_base;
 		for (i = 0; i < sb; i++) {
 			f = (struct filter_entry *)adapter->tids.tid_tab[i];
 
-- 
2.9.5

