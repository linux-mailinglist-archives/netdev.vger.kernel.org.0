Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDD8F4E8F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 15:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfKHOnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 09:43:40 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:62044 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfKHOnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 09:43:40 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA8EhVZe031255;
        Fri, 8 Nov 2019 06:43:32 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next] cxgb4: fix 64-bit division on i386
Date:   Fri,  8 Nov 2019 20:05:22 +0530
Message-Id: <1573223722-400-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following compile error on i386 architecture.

ERROR: "__udivdi3" [drivers/net/ethernet/chelsio/cxgb4/cxgb4.ko] undefined!

Fixes: 0e395b3cb1fb ("cxgb4: add FLOWC based QoS offload")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index fb28bce..143cb1f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -307,8 +307,8 @@ static int cxgb4_mqprio_alloc_tc(struct net_device *dev,
 	p.u.params.channel = pi->tx_chan;
 	for (i = 0; i < mqprio->qopt.num_tc; i++) {
 		/* Convert from bytes per second to Kbps */
-		p.u.params.minrate = mqprio->min_rate[i] * 8 / 1000;
-		p.u.params.maxrate = mqprio->max_rate[i] * 8 / 1000;
+		p.u.params.minrate = div_u64(mqprio->min_rate[i] * 8, 1000);
+		p.u.params.maxrate = div_u64(mqprio->max_rate[i] * 8, 1000);
 
 		e = cxgb4_sched_class_alloc(dev, &p);
 		if (!e) {
-- 
1.8.3.1

