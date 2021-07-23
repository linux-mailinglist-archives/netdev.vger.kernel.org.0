Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0143D3CED
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbhGWPOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:14:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57300 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbhGWPNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:13:53 -0400
Received: from localhost.localdomain (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id 815916429D;
        Fri, 23 Jul 2021 17:53:55 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/6] netfilter: flowtable: avoid possible false sharing
Date:   Fri, 23 Jul 2021 17:54:08 +0200
Message-Id: <20210723155412.17916-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210723155412.17916-1-pablo@netfilter.org>
References: <20210723155412.17916-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flowtable follows the same timeout approach as conntrack, use the
same idiom as in cc16921351d8 ("netfilter: conntrack: avoid same-timeout
update") but also include the fix provided by e37542ba111f ("netfilter:
conntrack: avoid possible false sharing").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1e50908b1b7e..551976e4284c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -331,7 +331,11 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
-	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
+	u32 timeout;
+
+	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
+	if (READ_ONCE(flow->timeout) != timeout)
+		WRITE_ONCE(flow->timeout, timeout);
 
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
-- 
2.20.1

