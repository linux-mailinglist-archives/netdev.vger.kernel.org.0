Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B732F1614B7
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgBQObU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:20 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44519 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727898AbgBQObT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:19 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CACE421F8E;
        Mon, 17 Feb 2020 09:31:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Yhd4Dq/ESiPSQABcmMLjt/rMyx0bFsxxq2K+uqY3MT4=; b=1BPwzcPW
        reIidDGr6CCLkpTyIR1/gaegcFcFKFUDknEGPgX5EFTfPvw84FeEa+QdnzjUf2QA
        ibnzvzIUQmfCDYLBK3x8uBdkwv6ltvTi2In3vOqeeqBF7bEPyrv+tsybTEXVb8fN
        HRg2ceU3rbofe3GuMWiNyxX8wyFmP4gj4xoAAV4hJSy8D1yjkwXTNBZZuJT33t6l
        LDKWNyNvOC1SKf5qWIRDymIU1VTleL0NyssY25XahXnN6rlZG8E4NLcMZkVLmvbA
        HTwm2qeWpyln9EFoOmTroU3V3H61Ero67mzhSsaTwMTtzhRlr+gUDgmP2wwnfOo0
        Ur2Mlb8dNKaEtw==
X-ME-Sender: <xms:taNKXlLaXZKoveWt6TYTMz8q2Vj0kumS_uM7TWlanYF2vz3YvntV9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:taNKXjgNQw22F4l8yrBFxkRGhPXOp3gQMlCLdrZbzrYhOv-X-N6pUQ>
    <xmx:taNKXvIrmGud1zHqphiTB8wJUhNJtSWlf96MFBa_L9ayxwqNOPMK4A>
    <xmx:taNKXoE03OBLjry6Za4lOfTF-0mB_lea9HrC3RqYIhFmTHNBm_acPQ>
    <xmx:taNKXo-_VmnPNDDEc44e4sGQpbCL3BA9Sn1L40Vk3cSglcPokQMj8A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADFC93060EF5;
        Mon, 17 Feb 2020 09:31:16 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum_fid: Use 'refcount_t' for FID reference counting
Date:   Mon, 17 Feb 2020 16:29:31 +0200
Message-Id: <20200217142940.307014-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217142940.307014-1-idosch@idosch.org>
References: <20200217142940.307014-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

'refcount_t' is very useful for catching over/under flows. Convert the
FID (Filtering Identifier) objects to use it instead of 'unsigned int'
for their reference count.

A subsequent patch in the series will change the way VXLAN devices hold
/ release the FID reference, which is why the conversion is made now.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 8df3cb21baa6..65486a90b526 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -8,6 +8,7 @@
 #include <linux/netdevice.h>
 #include <linux/rhashtable.h>
 #include <linux/rtnetlink.h>
+#include <linux/refcount.h>
 
 #include "spectrum.h"
 #include "reg.h"
@@ -24,7 +25,7 @@ struct mlxsw_sp_fid_core {
 struct mlxsw_sp_fid {
 	struct list_head list;
 	struct mlxsw_sp_rif *rif;
-	unsigned int ref_count;
+	refcount_t ref_count;
 	u16 fid_index;
 	struct mlxsw_sp_fid_family *fid_family;
 	struct rhash_head ht_node;
@@ -149,7 +150,7 @@ struct mlxsw_sp_fid *mlxsw_sp_fid_lookup_by_index(struct mlxsw_sp *mlxsw_sp,
 	fid = rhashtable_lookup_fast(&mlxsw_sp->fid_core->fid_ht, &fid_index,
 				     mlxsw_sp_fid_ht_params);
 	if (fid)
-		fid->ref_count++;
+		refcount_inc(&fid->ref_count);
 
 	return fid;
 }
@@ -183,7 +184,7 @@ struct mlxsw_sp_fid *mlxsw_sp_fid_lookup_by_vni(struct mlxsw_sp *mlxsw_sp,
 	fid = rhashtable_lookup_fast(&mlxsw_sp->fid_core->vni_ht, &vni,
 				     mlxsw_sp_fid_vni_ht_params);
 	if (fid)
-		fid->ref_count++;
+		refcount_inc(&fid->ref_count);
 
 	return fid;
 }
@@ -1030,7 +1031,7 @@ static struct mlxsw_sp_fid *mlxsw_sp_fid_lookup(struct mlxsw_sp *mlxsw_sp,
 	list_for_each_entry(fid, &fid_family->fids_list, list) {
 		if (!fid->fid_family->ops->compare(fid, arg))
 			continue;
-		fid->ref_count++;
+		refcount_inc(&fid->ref_count);
 		return fid;
 	}
 
@@ -1075,7 +1076,7 @@ static struct mlxsw_sp_fid *mlxsw_sp_fid_get(struct mlxsw_sp *mlxsw_sp,
 		goto err_rhashtable_insert;
 
 	list_add(&fid->list, &fid_family->fids_list);
-	fid->ref_count++;
+	refcount_set(&fid->ref_count, 1);
 	return fid;
 
 err_rhashtable_insert:
@@ -1093,7 +1094,7 @@ void mlxsw_sp_fid_put(struct mlxsw_sp_fid *fid)
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 	struct mlxsw_sp *mlxsw_sp = fid_family->mlxsw_sp;
 
-	if (--fid->ref_count != 0)
+	if (!refcount_dec_and_test(&fid->ref_count))
 		return;
 
 	list_del(&fid->list);
-- 
2.24.1

