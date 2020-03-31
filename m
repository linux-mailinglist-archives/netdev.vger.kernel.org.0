Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F685199F81
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgCaT5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 15:57:20 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:39869 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgCaT5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 15:57:20 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02VJvBCn031053;
        Tue, 31 Mar 2020 12:57:12 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, herat@chelsio.com, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: [PATCH net] cxgb4: fix MPS index overwrite when setting MAC address
Date:   Wed,  1 Apr 2020 01:16:09 +0530
Message-Id: <1585683969-17582-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herat Ramani <herat@chelsio.com>

cxgb4_update_mac_filt() earlier requests firmware to add a new MAC
address into MPS TCAM. The MPS TCAM index returned by firmware is
stored in pi->xact_addr_filt. However, the saved MPS TCAM index gets
overwritten again with the return value of cxgb4_update_mac_filt(),
which is wrong.

When trying to update to another MAC address later, the wrong MPS TCAM
index is sent to firmware, which causes firmware to return error,
because it's not the same MPS TCAM index that firmware had sent
earlier to driver.

So, fix by removing the wrong overwrite being done after call to
cxgb4_update_mac_filt().

Fixes: 3f8cfd0d95e6 ("cxgb4/cxgb4vf: Program hash region for {t4/t4vf}_change_mac()")
Signed-off-by: Herat Ramani <herat@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 97f90edbc068..6767c73c87a1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3138,7 +3138,6 @@ static int cxgb_set_mac_addr(struct net_device *dev, void *p)
 		return ret;
 
 	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
-	pi->xact_addr_filt = ret;
 	return 0;
 }
 
-- 
2.24.0

