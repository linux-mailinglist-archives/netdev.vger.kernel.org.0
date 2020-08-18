Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A47F248A37
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgHRPlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:41:40 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:36597 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgHRPl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:41:26 -0400
Received: from localhost (fedora32ganji.blr.asicdesigners.com [10.193.80.135])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07IFfDXT024132;
        Tue, 18 Aug 2020 08:41:13 -0700
From:   Ganji Aravind <ganji.aravind@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: [PATCH net 1/2] cxgb4: Fix work request size calculation for loopback test
Date:   Tue, 18 Aug 2020 21:10:57 +0530
Message-Id: <20200818154058.1770002-2-ganji.aravind@chelsio.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
References: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Work request used for sending loopback packet needs to add
the firmware work request only once. So, fix by using
correct structure size.

Fixes: 7235ffae3d2c ("cxgb4: add loopback ethtool self-test")
Signed-off-by: Ganji Aravind <ganji.aravind@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index d2b587d1670a..7c9fe4bc235b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2553,8 +2553,8 @@ int cxgb4_selftest_lb_pkt(struct net_device *netdev)
 
 	pkt_len = ETH_HLEN + sizeof(CXGB4_SELFTEST_LB_STR);
 
-	flits = DIV_ROUND_UP(pkt_len + sizeof(struct cpl_tx_pkt) +
-			     sizeof(*wr), sizeof(__be64));
+	flits = DIV_ROUND_UP(pkt_len + sizeof(*cpl) + sizeof(*wr),
+			     sizeof(__be64));
 	ndesc = flits_to_desc(flits);
 
 	lb = &pi->ethtool_lb;
-- 
2.26.2

