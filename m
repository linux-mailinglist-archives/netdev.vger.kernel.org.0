Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4DF27F8BC
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgJAEdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgJAEdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:17 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABE42222BB;
        Thu,  1 Oct 2020 04:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526797;
        bh=mHYOk50c8aOGswdyk0HcBDNP7edkmNZJz1ITJcM+vtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM+RinsE6msR1Bu21Ep3jYst1/xuA4Hej43ONofgFMwmXfWRDq5nfgro73PgsdYo6
         T8CETbrr5Fm+adb3LWTVMJU1iVB98t4rhTT0/am/eqKOmZxp9tyXPJAIshhc1Zsb7p
         HYj31HES3Hi0dvZFHBv9/7TkbASi9jXQOBc49LVo=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, sunils <sunils@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5: E-switch, Use PF num in metadata reg c0
Date:   Wed, 30 Sep 2020 21:32:54 -0700
Message-Id: <20201001043302.48113-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunils <sunils@nvidia.com>

Currently only 256 vports can be supported as only 8 bits are
reserved for them and 8 bits are reserved for vhca_ids in
metadata reg c0. To support more than 256 vports, replace
vhca_id with a unique shorter 4-bit PF number which covers
upto 16 PF's. Use remaining 12 bits for vports ranging 1-4095.
This will continue to generate unique metadata even if
multiple PCI devices have same switch_id.

Signed-off-by: sunils <sunils@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 36 +++++++++----------
 include/linux/mlx5/eswitch.h                  | 15 ++++----
 2 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ffd5d540a19e..6b49c0d59099 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2019,31 +2019,31 @@ esw_check_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 
 u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
 {
-	u32 num_vports = GENMASK(ESW_VPORT_BITS - 1, 0) - 1;
-	u32 vhca_id_mask = GENMASK(ESW_VHCA_ID_BITS - 1, 0);
-	u32 vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
-	u32 start;
-	u32 end;
+	u32 vport_end_ida = (1 << ESW_VPORT_BITS) - 1;
+	u32 max_pf_num = (1 << ESW_PFNUM_BITS) - 1;
+	u32 pf_num;
 	int id;
 
-	/* Make sure the vhca_id fits the ESW_VHCA_ID_BITS */
-	WARN_ON_ONCE(vhca_id >= BIT(ESW_VHCA_ID_BITS));
-
-	/* Trim vhca_id to ESW_VHCA_ID_BITS */
-	vhca_id &= vhca_id_mask;
-
-	start = (vhca_id << ESW_VPORT_BITS);
-	end = start + num_vports;
-	if (!vhca_id)
-		start += 1; /* zero is reserved/invalid metadata */
-	id = ida_alloc_range(&esw->offloads.vport_metadata_ida, start, end, GFP_KERNEL);
+	/* Only 4 bits of pf_num */
+	pf_num = PCI_FUNC(esw->dev->pdev->devfn);
+	if (pf_num > max_pf_num)
+		return 0;
 
-	return (id < 0) ? 0 : id;
+	/* Metadata is 4 bits of PFNUM and 12 bits of unique id */
+	/* Use only non-zero vport_id (1-4095) for all PF's */
+	id = ida_alloc_range(&esw->offloads.vport_metadata_ida, 1, vport_end_ida, GFP_KERNEL);
+	if (id < 0)
+		return 0;
+	id = (pf_num << ESW_VPORT_BITS) | id;
+	return id;
 }
 
 void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata)
 {
-	ida_free(&esw->offloads.vport_metadata_ida, metadata);
+	u32 vport_bit_mask = (1 << ESW_VPORT_BITS) - 1;
+
+	/* Metadata contains only 12 bits of actual ida id */
+	ida_free(&esw->offloads.vport_metadata_ida, metadata & vport_bit_mask);
 }
 
 static int esw_offloads_vport_metadata_setup(struct mlx5_eswitch *esw,
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index c16827eeba9c..b0ae8020f13e 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -74,15 +74,16 @@ bool mlx5_eswitch_reg_c1_loopback_enabled(const struct mlx5_eswitch *esw);
 bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw);
 
 /* Reg C0 usage:
- * Reg C0 = < ESW_VHCA_ID_BITS(8) | ESW_VPORT BITS(8) | ESW_CHAIN_TAG(16) >
+ * Reg C0 = < ESW_PFNUM_BITS(4) | ESW_VPORT BITS(12) | ESW_CHAIN_TAG(16) >
  *
- * Highest 8 bits of the reg c0 is the vhca_id, next 8 bits is vport_num,
- * the rest (lowest 16 bits) is left for tc chain tag restoration.
- * VHCA_ID + VPORT comprise the SOURCE_PORT matching.
+ * Highest 4 bits of the reg c0 is the PF_NUM (range 0-15), 12 bits of
+ * unique non-zero vport id (range 1-4095). The rest (lowest 16 bits) is left
+ * for tc chain tag restoration.
+ * PFNUM + VPORT comprise the SOURCE_PORT matching.
  */
-#define ESW_VHCA_ID_BITS 8
-#define ESW_VPORT_BITS 8
-#define ESW_SOURCE_PORT_METADATA_BITS (ESW_VHCA_ID_BITS + ESW_VPORT_BITS)
+#define ESW_VPORT_BITS 12
+#define ESW_PFNUM_BITS 4
+#define ESW_SOURCE_PORT_METADATA_BITS (ESW_PFNUM_BITS + ESW_VPORT_BITS)
 #define ESW_SOURCE_PORT_METADATA_OFFSET (32 - ESW_SOURCE_PORT_METADATA_BITS)
 #define ESW_CHAIN_TAG_METADATA_BITS (32 - ESW_SOURCE_PORT_METADATA_BITS)
 #define ESW_CHAIN_TAG_METADATA_MASK GENMASK(ESW_CHAIN_TAG_METADATA_BITS - 1,\
-- 
2.26.2

