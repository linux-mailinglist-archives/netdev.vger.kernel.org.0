Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA72184327
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCMJDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:03:05 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:54806 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgCMJDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:03:05 -0400
Received: from fcoe-test9.blr.asicdesigners.com (fcoe-test9.blr.asicdesigners.com [10.193.185.176])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02D9308E020965;
        Fri, 13 Mar 2020 02:03:00 -0700
From:   Shahjada Abul Husain <shahjada@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com, shahjada@chelsio.com
Subject: [PATCH net] cxgb4: fix delete filter entry fail in unload path
Date:   Fri, 13 Mar 2020 14:32:57 +0530
Message-Id: <20200313090257.26733-1-shahjada@chelsio.com>
X-Mailer: git-send-email 2.23.0.256.g4c86140
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the hardware TID index is assumed to start from index 0.
However, with the following changeset,

commit c21939998802 ("cxgb4: add support for high priority filters")

hardware TID index can start after the high priority region, which
has introduced a regression resulting in remove filters entry
failure for cxgb4 unload path. This patch fix that.

Fixes: c21939998802 ("cxgb4: add support for high priority filters")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 2a2938bbb93a..fc05248984fc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -902,7 +902,7 @@ void clear_all_filters(struct adapter *adapter)
 				adapter->tids.tid_tab[i];
 
 			if (f && (f->valid || f->pending))
-				cxgb4_del_filter(dev, i, &f->fs);
+				cxgb4_del_filter(dev, f->tid, &f->fs);
 		}
 
 		sb = t4_read_reg(adapter, LE_DB_SRVR_START_INDEX_A);
@@ -910,7 +910,7 @@ void clear_all_filters(struct adapter *adapter)
 			f = (struct filter_entry *)adapter->tids.tid_tab[i];
 
 			if (f && (f->valid || f->pending))
-				cxgb4_del_filter(dev, i, &f->fs);
+				cxgb4_del_filter(dev, f->tid, &f->fs);
 		}
 	}
 }
-- 
2.23.0.256.g4c86140

