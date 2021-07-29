Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6A03DA9EC
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhG2RSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhG2RSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:18:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CB8C061798;
        Thu, 29 Jul 2021 10:17:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ec13so8686453edb.0;
        Thu, 29 Jul 2021 10:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qMIB2ROb9Jl4hKjccOFMhpclOaN08ueTHwZ/9EPgJ28=;
        b=SsvxOqWbwYPZhdl0g9sC7Fk6Kadv0FrK/30uje13Y6wUQFiqoeq+uMF+8k+5zUqsXi
         iYpwe1ZQf6+b+0FBkJKIQdefOuLt8zXzFN/OsID9sgi04OZsEYxLkQ4bKGpKwCCI1BSc
         cG3DBQalrU4lWuBIH0vxd3aUSy3KmTsZmk3Qw88tZ96sNlyufczi8rhh/bhd6fpETlmW
         3oOqOTwu+iNY701y6GBVZPtLSmRpYfcUDwnsSaQXwhKNRGA9mdwV4Xv2a4c4A1mZF9Hm
         4li2N1Gz0AVm1W3/jlCGFHu8pLZSpS+gFZAKWw7yTR5MRCcqgK3p6rdqPqQsHGt2XZ2y
         zKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qMIB2ROb9Jl4hKjccOFMhpclOaN08ueTHwZ/9EPgJ28=;
        b=SjRFjkdP3uFhzYDiqhVDVDibZOHlJQAwmlpX/jU3kZJjIlPV6hS0biHZC2c7w6TlEh
         s1Dalw+KY7K4GjXZiIqkwN1LTRHPjsPlFb/2EfBWbuPSB5OeeOLi3wLwnvDqGIyA02C+
         EyfFgawNLIFAkduzN+P1gH9xzP/uVtALhC9wSAxAMSlJcxMhU2zBh0DOtpXcIKS3r/wX
         rQFSTcNL+MsykA/1dJ8OO77l649Wel0OzLK+VtYEqTDSyW1Ctjf/IAbtdLPd3vKUgAij
         /JY9Hhq6SUugfCll/AJ7gCYWG3eICflhQ3zx1ufdQRhrQTZJJBXp+Pm9j6fW+bRQm/Rj
         1gSQ==
X-Gm-Message-State: AOAM530lWjz0N3BVTURZKqSAoi9lCjLqt8BQmzgV4nTYsnsHT2eq+vmb
        pnnp60a4bPche9diVQXhppE=
X-Google-Smtp-Source: ABdhPJwAD6VlOAALw3ZyWigZdfp6SkDf2jZRw9Q8TRuQ3jp/Wy0q7/iyAERCZnt4pFhWJzAMNYYUqQ==
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr7153839edu.221.1627579076261;
        Thu, 29 Jul 2021 10:17:56 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:55 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 8/9] dpaa2-switch: offload shared block mirror filters when binding to a port
Date:   Thu, 29 Jul 2021 20:19:00 +0300
Message-Id: <20210729171901.3211729-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

When mirroring rules are added in shared filter blocks, the same
mirroring rule has to be configured on all the switch ports that are
part of the same block.

In case a switch port joins a shared block after mirroring filters have
been already added to it, then all the mirror rules should be offloaded
to the port. The reverse, removal of mirroring rules, has to be done at
block unbind.

For this purpose, the dpaa2_switch_block_offload_mirror() and
dpaa2_switch_block_unoffload_mirror() functions are added and called
upon binding and unbinding a switch port to/from a block.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 51 +++++++++++++++++++
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 14 +++++
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  6 +++
 3 files changed, 71 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index 3c4f5ada12fd..d6eefbbf163f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -803,6 +803,57 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
 	}
 }
 
+int dpaa2_switch_block_offload_mirror(struct dpaa2_switch_filter_block *block,
+				      struct ethsw_port_priv *port_priv)
+{
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpaa2_switch_mirror_entry *tmp;
+	int err;
+
+	list_for_each_entry(tmp, &block->mirror_entries, list) {
+		err = dpsw_if_add_reflection(ethsw->mc_io, 0,
+					     ethsw->dpsw_handle,
+					     port_priv->idx, &tmp->cfg);
+		if (err)
+			goto unwind_add;
+	}
+
+	return 0;
+
+unwind_add:
+	list_for_each_entry(tmp, &block->mirror_entries, list)
+		dpsw_if_remove_reflection(ethsw->mc_io, 0,
+					  ethsw->dpsw_handle,
+					  port_priv->idx, &tmp->cfg);
+
+	return err;
+}
+
+int dpaa2_switch_block_unoffload_mirror(struct dpaa2_switch_filter_block *block,
+					struct ethsw_port_priv *port_priv)
+{
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpaa2_switch_mirror_entry *tmp;
+	int err;
+
+	list_for_each_entry(tmp, &block->mirror_entries, list) {
+		err = dpsw_if_remove_reflection(ethsw->mc_io, 0,
+						ethsw->dpsw_handle,
+						port_priv->idx, &tmp->cfg);
+		if (err)
+			goto unwind_remove;
+	}
+
+	return 0;
+
+unwind_remove:
+	list_for_each_entry(tmp, &block->mirror_entries, list)
+		dpsw_if_add_reflection(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				       port_priv->idx, &tmp->cfg);
+
+	return err;
+}
+
 int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls)
 {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 3857d9093623..71129724d9ca 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1229,6 +1229,13 @@ static int dpaa2_switch_port_block_bind(struct ethsw_port_priv *port_priv,
 	struct dpaa2_switch_filter_block *old_block = port_priv->filter_block;
 	int err;
 
+	/* Offload all the mirror entries found in the block on this new port
+	 * joining it.
+	 */
+	err = dpaa2_switch_block_offload_mirror(block, port_priv);
+	if (err)
+		return err;
+
 	/* If the port is already bound to this ACL table then do nothing. This
 	 * can happen when this port is the first one to join a tc block
 	 */
@@ -1256,6 +1263,13 @@ dpaa2_switch_port_block_unbind(struct ethsw_port_priv *port_priv,
 	struct dpaa2_switch_filter_block *new_block;
 	int err;
 
+	/* Unoffload all the mirror entries found in the block from the
+	 * port leaving it.
+	 */
+	err = dpaa2_switch_block_unoffload_mirror(block, port_priv);
+	if (err)
+		return err;
+
 	/* We are the last port that leaves a block (an ACL table).
 	 * We'll continue to use this table.
 	 */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 79e8a40f97f7..f69d940f3c5b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -253,4 +253,10 @@ int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_filter_block *block,
 
 int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *block,
 			       struct dpaa2_switch_acl_entry *entry);
+
+int dpaa2_switch_block_offload_mirror(struct dpaa2_switch_filter_block *block,
+				      struct ethsw_port_priv *port_priv);
+
+int dpaa2_switch_block_unoffload_mirror(struct dpaa2_switch_filter_block *block,
+					struct ethsw_port_priv *port_priv);
 #endif	/* __ETHSW_H */
-- 
2.31.1

