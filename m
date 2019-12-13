Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C8611E06E
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 10:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLMJQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 04:16:20 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:17084 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfLMJQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 04:16:20 -0500
Received: from dalmore.blr.asicdesigners.com ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBD9GEWp024058;
        Fri, 13 Dec 2019 01:16:15 -0800
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@daveloft.net
Cc:     nirranjan@chelsio.com, Vishal Kulkarni <vishal@chelsio.com>,
        Herat Ramani <herat@chelsio.com>
Subject: [PATCH net] cxgb4: Fix kernel panic while accessing sge_info
Date:   Fri, 13 Dec 2019 06:39:39 +0530
Message-Id: <1576199379-24260-1-git-send-email-vishal@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sge_info debugfs collects offload queue info even when offload capability
is disabled and leads to panic.

[  144.139871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  144.139874] CR2: 0000000000000000 CR3: 000000082d456005 CR4: 00000000001606e0
[  144.139876] Call Trace:
[  144.139887]  sge_queue_start+0x12/0x30 [cxgb4]
[  144.139897]  seq_read+0x1d4/0x3d0
[  144.139906]  full_proxy_read+0x50/0x70
[  144.139913]  vfs_read+0x89/0x140
[  144.139916]  ksys_read+0x55/0xd0
[  144.139924]  do_syscall_64+0x5b/0x1d0
[  144.139933]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  144.139936] RIP: 0033:0x7f4b01493990

Fix this crash by skipping the offload queue access in sge_qinfo when
offload capability is disabled

Signed-off-by: Herat Ramani <herat@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 93868dc..aca9f7a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3048,6 +3048,9 @@ static int sge_queue_entries(const struct adapter *adap)
 	int tot_uld_entries = 0;
 	int i;
 
+	if (!is_uld(adap))
+		goto lld_only;
+
 	mutex_lock(&uld_mutex);
 	for (i = 0; i < CXGB4_TX_MAX; i++)
 		tot_uld_entries += sge_qinfo_uld_txq_entries(adap, i);
@@ -3058,6 +3061,7 @@ static int sge_queue_entries(const struct adapter *adap)
 	}
 	mutex_unlock(&uld_mutex);
 
+lld_only:
 	return DIV_ROUND_UP(adap->sge.ethqsets, 4) +
 	       (adap->sge.eohw_txq ? DIV_ROUND_UP(adap->sge.eoqsets, 4) : 0) +
 	       tot_uld_entries +
-- 
1.8.3.1

