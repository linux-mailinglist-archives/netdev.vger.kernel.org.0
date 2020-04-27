Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469351BA746
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgD0PGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:06:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57235 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727098AbgD0PGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:06:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E2D795C01EE;
        Mon, 27 Apr 2020 11:06:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:06:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WO2kakA5IjVhc5iPb
        9iWxydoyu5OdUnGIX68l+HG3zg=; b=nTDEIWy1TZH3V7czRU0IQZQv3tKh9BD7H
        wQ1kEp5Wv0gQ5OHvt84er/hcCI+4FzZt4uWuPy0ln23mpq9Xhs5ClcGV0em5YaJV
        Y7uiugmoYG7sXFpfqluBz23xT9dcWusQCUJLiCOQwfMa3ZoJA0zIB6dnN6cZXhlQ
        dgdJGTCIqcd0ikMARqhhlXoUHjFnqja/4lCyLp9Bsj9gGMvgauRJbopqvaiZzWrQ
        NRjukg0t4m/bUnNCSqS4MGrgsaJ4V0TVocVZWAB3JRT2+dvesntiClS5lfapdt3d
        vNlmw62sMoAJUP8El0XGTAWiybEtFjX5JjRRj89k9Yqx/4NhSruKQ==
X-ME-Sender: <xms:7vSmXrvYH55q-lTR5fgI62OJANXU5W_2-aKKzHq7RzFhaGvsCwx6Tg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:7vSmXp9BHbN6LI786KEHvvyaZH9oirusib-g5KDhj9DJZITKnCFonA>
    <xmx:7vSmXlGL6jo4icgxAgWDGijlIg-oZf_xqKd0fXJpL-eSH5yJhkJLVQ>
    <xmx:7vSmXhU_pKKOY9VVjCC9-WtiTTJYrZUeBpO7mH2vjhdZ9T4bc7tDKQ>
    <xmx:7vSmXpl7SYpYxbkK0bieioIiGmfbjNmUWdP4sjgNy1BKY1NT-BmgcA>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id B108C3280067;
        Mon, 27 Apr 2020 11:06:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum_acl_tcam: Position vchunk in a vregion list properly
Date:   Mon, 27 Apr 2020 18:05:47 +0300
Message-Id: <20200427150547.3949211-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Vregion helpers to get min and max priority depend on the correct
ordering of vchunks in the vregion list. However, the current code
always adds new chunk to the end of the list, no matter what the
priority is. Fix this by finding the correct place in the list and put
vchunk there.

Fixes: 22a677661f56 ("mlxsw: spectrum: Introduce ACL core with simple TCAM implementation")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c  | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 430da69003d8..a6e30e020b5c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -986,8 +986,9 @@ mlxsw_sp_acl_tcam_vchunk_create(struct mlxsw_sp *mlxsw_sp,
 				unsigned int priority,
 				struct mlxsw_afk_element_usage *elusage)
 {
+	struct mlxsw_sp_acl_tcam_vchunk *vchunk, *vchunk2;
 	struct mlxsw_sp_acl_tcam_vregion *vregion;
-	struct mlxsw_sp_acl_tcam_vchunk *vchunk;
+	struct list_head *pos;
 	int err;
 
 	if (priority == MLXSW_SP_ACL_TCAM_CATCHALL_PRIO)
@@ -1025,7 +1026,14 @@ mlxsw_sp_acl_tcam_vchunk_create(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	mlxsw_sp_acl_tcam_rehash_ctx_vregion_changed(vregion);
-	list_add_tail(&vchunk->list, &vregion->vchunk_list);
+
+	/* Position the vchunk inside the list according to priority */
+	list_for_each(pos, &vregion->vchunk_list) {
+		vchunk2 = list_entry(pos, typeof(*vchunk2), list);
+		if (vchunk2->priority > priority)
+			break;
+	}
+	list_add_tail(&vchunk->list, pos);
 	mutex_unlock(&vregion->lock);
 
 	return vchunk;
-- 
2.24.1

