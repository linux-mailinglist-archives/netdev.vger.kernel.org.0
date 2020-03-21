Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B053A18DFCF
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 12:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgCUL3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 07:29:22 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:47576 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgCUL3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 07:29:21 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1DC6D41182;
        Sat, 21 Mar 2020 19:29:19 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next 2/3] netfilter: nf_flow_table: add nf_conn_acct for HW flowtable offload
Date:   Sat, 21 Mar 2020 19:29:17 +0800
Message-Id: <1584790158-9752-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584790158-9752-1-git-send-email-wenxu@ucloud.cn>
References: <1584790158-9752-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkxLS0tLSEpPTEpJTklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N006Myo4OTgzFhMpAxZDIQ9J
        MBoKCQxVSlVKTkNPTEJLSk5CSk1JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCTEo3Bg++
X-HM-Tid: 0a70fcdabf212086kuqy1dc6d41182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_conn_acct counter for the hardware flowtable offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a68136a..5b02bdd 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -784,6 +784,14 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
 				       lastused + NF_FLOW_TIMEOUT);
+	if (stats[0].pkts)
+		flow_offload_update_acct(offload->flow, stats[0].pkts,
+					 stats[0].bytes,
+					 FLOW_OFFLOAD_DIR_ORIGINAL);
+	if (stats[1].pkts)
+		flow_offload_update_acct(offload->flow, stats[1].pkts,
+					 stats[1].bytes,
+					 FLOW_OFFLOAD_DIR_REPLY);
 }
 
 static void flow_offload_work_handler(struct work_struct *work)
-- 
1.8.3.1

