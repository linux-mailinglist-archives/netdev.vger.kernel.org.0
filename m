Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0034F1B7A64
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgDXPoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:44:20 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48119 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728739AbgDXPoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:44:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C6D65C07C5;
        Fri, 24 Apr 2020 11:44:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 24 Apr 2020 11:44:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=aFG7BbbBqsiFSblgbxyAXZwbqhm4Zv+Sv2R7JBCXwHE=; b=eqDtQUNu
        ocEmCVNh1C5iNDQMhOwwkDTeweoF64xXPI7568Kf9ZzhvFIt3OgTkOKPz2bAsUyD
        +0MEG2T4389oG72/H6mWG/r1TXB1VZHSSe6/J8xCKuKYiTosHU+D6lcbZ9vqeYUc
        fTtaxkLyYSu9fkQsPC9Rcf/5HONjbTCBJy+onbUKLpCB6IFQy5exIxREY/P2nS6T
        r0E3LxIbBLbAv8emax1BQBVQmIhsOliJdJbNOsrs241pLe1X6DX4dHiJ63rVcQBc
        WCKQoRgAh2i8A5P2q7vi2+3cnAnIaVYbr7di8E6XXPI9eyXS9ZZNaRNttysIGugu
        V7vPAAaXRxgmNA==
X-ME-Sender: <xms:UgmjXpNuDA_wY20BaoF61vOdXS83cRLAcr-Gi50Q00oZOtVz3rSBhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrhedugdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:UgmjXgMcTJ5CL57pX0u51ngmRMl4T34uufZXS9H32PfD-pN5vjNO4Q>
    <xmx:UgmjXjSMAfZUXtbOoecLYNS4A8kCauVYAhnoBxjEejkuC6NhgMQfpQ>
    <xmx:UgmjXqBzjokbwB88PAcvsJ_d6p226xw3VKrsNVITUGyyIJiqsNvpvQ>
    <xmx:UgmjXp9ByqhF-SmK3tQXsH_wXNdEDCvJP4my9WNz4wVS-bel9SyJJQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id E12353065D9A;
        Fri, 24 Apr 2020 11:44:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/5] mlxsw: spectrum_span: Use 'refcount_t' for reference counting
Date:   Fri, 24 Apr 2020 18:43:44 +0300
Message-Id: <20200424154345.3677009-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200424154345.3677009-1-idosch@idosch.org>
References: <20200424154345.3677009-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

'refcount_t' is very useful for catching over/under flows. Convert the
SPAN agent objects to use it instead of 'int' for their reference count.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c  | 16 ++++++++--------
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h  |  3 ++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 14c5edc71239..235556be58f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -3,6 +3,7 @@
 
 #include <linux/if_bridge.h>
 #include <linux/list.h>
+#include <linux/refcount.h>
 #include <linux/rtnetlink.h>
 #include <linux/workqueue.h>
 #include <net/arp.h>
@@ -664,7 +665,7 @@ mlxsw_sp_span_entry_create(struct mlxsw_sp *mlxsw_sp,
 
 	/* find a free entry to use */
 	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
-		if (!mlxsw_sp->span->entries[i].ref_count) {
+		if (!refcount_read(&mlxsw_sp->span->entries[i].ref_count)) {
 			span_entry = &mlxsw_sp->span->entries[i];
 			break;
 		}
@@ -674,7 +675,7 @@ mlxsw_sp_span_entry_create(struct mlxsw_sp *mlxsw_sp,
 
 	atomic_inc(&mlxsw_sp->span->active_entries_count);
 	span_entry->ops = ops;
-	span_entry->ref_count = 1;
+	refcount_set(&span_entry->ref_count, 1);
 	span_entry->to_dev = to_dev;
 	mlxsw_sp_span_entry_configure(mlxsw_sp, span_entry, sparms);
 
@@ -697,7 +698,7 @@ mlxsw_sp_span_entry_find_by_port(struct mlxsw_sp *mlxsw_sp,
 	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
 		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 
-		if (curr->ref_count && curr->to_dev == to_dev)
+		if (refcount_read(&curr->ref_count) && curr->to_dev == to_dev)
 			return curr;
 	}
 	return NULL;
@@ -718,7 +719,7 @@ mlxsw_sp_span_entry_find_by_id(struct mlxsw_sp *mlxsw_sp, int span_id)
 	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
 		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 
-		if (curr->ref_count && curr->id == span_id)
+		if (refcount_read(&curr->ref_count) && curr->id == span_id)
 			return curr;
 	}
 	return NULL;
@@ -735,7 +736,7 @@ mlxsw_sp_span_entry_get(struct mlxsw_sp *mlxsw_sp,
 	span_entry = mlxsw_sp_span_entry_find_by_port(mlxsw_sp, to_dev);
 	if (span_entry) {
 		/* Already exists, just take a reference */
-		span_entry->ref_count++;
+		refcount_inc(&span_entry->ref_count);
 		return span_entry;
 	}
 
@@ -745,8 +746,7 @@ mlxsw_sp_span_entry_get(struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_span_entry_put(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_span_entry *span_entry)
 {
-	WARN_ON(!span_entry->ref_count);
-	if (--span_entry->ref_count == 0)
+	if (refcount_dec_and_test(&span_entry->ref_count))
 		mlxsw_sp_span_entry_destroy(mlxsw_sp, span_entry);
 	return 0;
 }
@@ -1018,7 +1018,7 @@ static void mlxsw_sp_span_respin_work(struct work_struct *work)
 		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 		struct mlxsw_sp_span_parms sparms = {NULL};
 
-		if (!curr->ref_count)
+		if (!refcount_read(&curr->ref_count))
 			continue;
 
 		err = curr->ops->parms_set(curr->to_dev, &sparms);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 01273e54ba20..d23abdf957fa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 #include <linux/if_ether.h>
+#include <linux/refcount.h>
 
 #include "spectrum_router.h"
 
@@ -43,7 +44,7 @@ struct mlxsw_sp_span_entry {
 	const struct mlxsw_sp_span_entry_ops *ops;
 	struct mlxsw_sp_span_parms parms;
 	struct list_head bound_ports_list;
-	int ref_count;
+	refcount_t ref_count;
 	int id;
 };
 
-- 
2.24.1

