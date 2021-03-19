Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC4B3411F6
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbhCSBGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:06:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52618 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhCSBGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:06:22 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EAB45630BF;
        Fri, 19 Mar 2021 02:06:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/9] netfilter: flowtable: Make sure GC works periodically in idle system
Date:   Fri, 19 Mar 2021 02:06:07 +0100
Message-Id: <20210319010608.9758-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210319010608.9758-1-pablo@netfilter.org>
References: <20210319010608.9758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Currently flowtable's GC work is initialized as deferrable, which
means GC cannot work on time when system is idle. So the hardware
offloaded flow may be deleted for timeout, since its used time is
not timely updated.

Resolve it by initializing the GC work as delayed work instead of
deferrable.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 5fa657b8e03d..c77ba8690ed8 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -506,7 +506,7 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 {
 	int err;
 
-	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
+	INIT_DELAYED_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
 	init_rwsem(&flowtable->flow_block_lock);
 
-- 
2.20.1

