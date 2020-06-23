Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14390205FB2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 22:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403814AbgFWUfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:35:07 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:55181 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391583AbgFWUfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:35:06 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKZ38W019551;
        Tue, 23 Jun 2020 13:35:04 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 10/12] cxgb4: fix set but unused variable when DCB is disabled
Date:   Wed, 24 Jun 2020 01:51:40 +0530
Message-Id: <22b6fe475c24910885012a5627f287b41cd62dfb.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the set but unused variable when DCB is disabled. Instead,
do the calculation directly inline.

Fixes following warning in make W=1:
cxgb4_main.c: In function 'cfg_queues':
cxgb4_main.c:5380:29: warning: variable 'n1g' set but not used
[-Wunused-but-set-variable]
  u32 i, n10g = 0, qidx = 0, n1g = 0;
                             ^

Fixes: 116ca924aea6 ("cxgb4: fix checks for max queues to allocate")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 1e66159de079..472e7c9e47bd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5377,10 +5377,10 @@ static inline bool is_x_10g_port(const struct link_config *lc)
 static int cfg_queues(struct adapter *adap)
 {
 	u32 avail_qsets, avail_eth_qsets, avail_uld_qsets;
-	u32 i, n10g = 0, qidx = 0, n1g = 0;
 	u32 ncpus = num_online_cpus();
 	u32 niqflint, neq, num_ulds;
 	struct sge *s = &adap->sge;
+	u32 i, n10g = 0, qidx = 0;
 	u32 q10g = 0, q1g;
 
 	/* Reduce memory usage in kdump environment, disable all offload. */
@@ -5426,7 +5426,6 @@ static int cfg_queues(struct adapter *adap)
 	if (n10g)
 		q10g = (avail_eth_qsets - (adap->params.nports - n10g)) / n10g;
 
-	n1g = adap->params.nports - n10g;
 #ifdef CONFIG_CHELSIO_T4_DCB
 	/* For Data Center Bridging support we need to be able to support up
 	 * to 8 Traffic Priorities; each of which will be assigned to its
@@ -5444,7 +5443,8 @@ static int cfg_queues(struct adapter *adap)
 	else
 		q10g = max(8U, q10g);
 
-	while ((q10g * n10g) > (avail_eth_qsets - n1g * q1g))
+	while ((q10g * n10g) >
+	       (avail_eth_qsets - (adap->params.nports - n10g) * q1g))
 		q10g--;
 
 #else /* !CONFIG_CHELSIO_T4_DCB */
-- 
2.24.0

