Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C232321AD1D
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGJCbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:31:24 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727050AbgGJCbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:31:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeG1Y4jFQZwOB5cRTkl6fMSK4JRBnHZ/qef7LKMlVYdQLGXHLsXsuMkIrAIfyj+0dN+rloysJe8jXkCHrXtnOz0fxD2FtidLtaXlELvkzFx4P+OFEvWLQRXlfpn7RpC10qbZfylVx2u4aw+Q9r+4o3UjFe+/B7GgP/lnYbzElwCljkk/QfWhH+Xp2GoyHGX8+A3w3gNIREHsefLtwuVHanW+8eIEf4kyeqNFcmUYYmPef3Xo8NSsXYRaC/rwIHTG1tcLvBkAqYy+zUzylEnb+vuV/kF3I1wR3GAL5xXjTLsapBnwDAPpHzXa7GnY3lg7nomzroztOdk9DdCIDgwliA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubc0475wr5lGvEcHK8CYygx+Y1/hfBlBzqLqDUGX1+g=;
 b=Gj4NsT9KdkZtjovq/6Zlm1E/B8wNE66I4YUi8F+kmBe0hhCA5nBOoNP5ESs0r35zSjhHczUHtioeNqKVhhpYFu96QNL9P4TUx+fAqmpWVirGXwtn0EchZZrPhhXEuTSRdOJthlXok54dQo8YviuqYFHrtArWnOK58V9jAMepWrmVtXpVvqcw/469YR+XiVQzsCGKnE6WDVYVbJC69ydnvqS/Qhv1PGLhrDJMNp9Gm22AYnVM4Jq1QM2DssgwkCQwypHjJC+Iil7Ol71ibvEAYLvnnzQHRhrZRyGgjHImi3YTWAud7ObIX2TLvro1dbGE/IMBK3Os6rlMQVmDVwhUeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubc0475wr5lGvEcHK8CYygx+Y1/hfBlBzqLqDUGX1+g=;
 b=KZslHqB7/xIQL7Jar/ViQYiLX1C+hOsiiVUjMKaYkIxfq779hlHPn47uoEPWzORLlaFYncFeMklYDbW7YgpJSj4ggS28hl3+BEV+Mx1ucpGqZeUXxhS1c3k9xOdWg+fgGKcM300wswb4bAddCDmu25r1J8TrXihEgout6iCr2NM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:31:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:31:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 8/9] net/mlx5e: Fix port buffers cell size value
Date:   Thu,  9 Jul 2020 19:30:17 -0700
Message-Id: <20200710023018.31905-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:31:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4736a393-3484-4d94-a962-08d824794be8
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7120208190CA80D4A3D6531DBE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aooh9111krNfD+LpU+HSQbf8Feuwd6aeWcnawy7OUAG24EgQrzhv1ia4My/U7tb7Qxj6vNEhQKCTgs+x3L5q74dm/IFkiaksdPXKscrxK0b25k3mMPI9WXE/i6LmT0zwQcqbRue/9HO24xQCzROrtuj7NDkhxfcnPnlpLL2xrJrEDkBWT/Q+3J38a+KZmfr57lJWbevLgdBYONiLJmjOaPdDnSfZD6ab9VOoygzTzw3UFR4n/IOiJPtOfTHRPOsUg92L76RplTcRVFA0BrT6E8fh4DXTIhI/Tt3z+ce1GErqDxF9ZXBZ5aUn8WW7zZj6fB9+6r1Nh5pRF+raUOc9DP18xpZ+7WOiIwF9/ji4pmAAS2PzrXAQ4lv7ANdSGPok
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(30864003)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dgUBownS3cpsABxAf0V5TTOOo/EK5DiXOnSQ3yXl6qQC0rPiw4kpYX6aO9DFWh7jB6Tcha/FAzAQZCy8WXvtZljiDk1e6k8foSasWAfHpLz7T+3JR7+Yh0fSLXZraKaZB2k3z8uPYukHuc1nHyA8MgQ1wVRfcM09TUvmF9bkvqMVdPxqB6KJ7WJYzWhAIji5VYOZ2pVpu0xCen/9LfFm+vzKfPcMvYcuj3UMoY31TnF+hhN6RrNfUtu0mZ0clvpWnX7xwaI3S+yP+gzSM4FxEfM0U6v3rPeA9LZyLBK8s4hb/a2YawghlBzkcfxRide9AYC3auXtcbrncoaVFugitC+nvRtZvudGGhdzAdtqYFGBITVT6LKG+eyIihdg1CZfjVzUEbGU91PXsHNpWeAtCvILlhQf3QPJm7+zYMG7Ru16U/Be0ZKBVZlPeCRBd/NOqeDG70CbRZZl/TUBE12WK7mH+ZrKXLvnppzRv2TWEDU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4736a393-3484-4d94-a962-08d824794be8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:31:05.9594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtNKRlS0ItIZ8ZpmXAQEGqZZnLnzFm4r9YN92d3I4cc8l3IupdDE1JT8o4XFQfR8n7OGctcdsAVdVygZ+DZKTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Device unit for port buffers size, xoff_threshold and xon_threshold is
cells. Fix a bug in driver where cell unit size was hard-coded to
128 bytes. This hard-coded value is buggy, as it is wrong for some hardware
versions.

Driver to read cell size from SBCAM register and translate bytes to cell
units accordingly.

In order to fix the bug, this patch exposes SBCAM (Shared buffer
capabilities mask) layout and defines.

If SBCAM.cap_cell_size is valid, use it for all bytes to cells
calculations. If not valid, fallback to 128.

Cell size do not change on the fly per device. Instead of issuing SBCAM
access reg command every time such translation is needed, cache it in
mlx5e_dcbx as part of mlx5e_dcbnl_initialize(). Pass dcbx.port_buff_cell_sz
as a param to every function that needs bytes to cells translation.

While fixing the bug, move MLX5E_BUFFER_CELL_SHIFT macro to
en_dcbnl.c, as it is only used by that file.

Fixes: 0696d60853d5 ("net/mlx5e: Receive buffer configuration")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/dcbnl.h    |  1 +
 .../mellanox/mlx5/core/en/port_buffer.c       | 53 ++++++++++---------
 .../mellanox/mlx5/core/en/port_buffer.h       |  1 -
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 19 +++++++
 include/linux/mlx5/driver.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 28 ++++++++++
 6 files changed, 78 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h b/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
index 7be6b2d36b60..9976de8b9047 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
@@ -29,6 +29,7 @@ struct mlx5e_dcbx {
 	bool                       manual_buffer;
 	u32                        cable_len;
 	u32                        xoff;
+	u16                        port_buff_cell_sz;
 };
 
 #define MLX5E_MAX_DSCP (64)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index ae99fac08b53..673f1c82d381 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -34,6 +34,7 @@
 int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 			    struct mlx5e_port_buffer *port_buffer)
 {
+	u16 port_buff_cell_sz = priv->dcbx.port_buff_cell_sz;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int sz = MLX5_ST_SZ_BYTES(pbmc_reg);
 	u32 total_used = 0;
@@ -57,11 +58,11 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 		port_buffer->buffer[i].epsb =
 			MLX5_GET(bufferx_reg, buffer, epsb);
 		port_buffer->buffer[i].size =
-			MLX5_GET(bufferx_reg, buffer, size) << MLX5E_BUFFER_CELL_SHIFT;
+			MLX5_GET(bufferx_reg, buffer, size) * port_buff_cell_sz;
 		port_buffer->buffer[i].xon =
-			MLX5_GET(bufferx_reg, buffer, xon_threshold) << MLX5E_BUFFER_CELL_SHIFT;
+			MLX5_GET(bufferx_reg, buffer, xon_threshold) * port_buff_cell_sz;
 		port_buffer->buffer[i].xoff =
-			MLX5_GET(bufferx_reg, buffer, xoff_threshold) << MLX5E_BUFFER_CELL_SHIFT;
+			MLX5_GET(bufferx_reg, buffer, xoff_threshold) * port_buff_cell_sz;
 		total_used += port_buffer->buffer[i].size;
 
 		mlx5e_dbg(HW, priv, "buffer %d: size=%d, xon=%d, xoff=%d, epsb=%d, lossy=%d\n", i,
@@ -73,7 +74,7 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 	}
 
 	port_buffer->port_buffer_size =
-		MLX5_GET(pbmc_reg, out, port_buffer_size) << MLX5E_BUFFER_CELL_SHIFT;
+		MLX5_GET(pbmc_reg, out, port_buffer_size) * port_buff_cell_sz;
 	port_buffer->spare_buffer_size =
 		port_buffer->port_buffer_size - total_used;
 
@@ -88,9 +89,9 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 static int port_set_buffer(struct mlx5e_priv *priv,
 			   struct mlx5e_port_buffer *port_buffer)
 {
+	u16 port_buff_cell_sz = priv->dcbx.port_buff_cell_sz;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int sz = MLX5_ST_SZ_BYTES(pbmc_reg);
-	void *buffer;
 	void *in;
 	int err;
 	int i;
@@ -104,16 +105,18 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 		goto out;
 
 	for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
-		buffer = MLX5_ADDR_OF(pbmc_reg, in, buffer[i]);
-
-		MLX5_SET(bufferx_reg, buffer, size,
-			 port_buffer->buffer[i].size >> MLX5E_BUFFER_CELL_SHIFT);
-		MLX5_SET(bufferx_reg, buffer, lossy,
-			 port_buffer->buffer[i].lossy);
-		MLX5_SET(bufferx_reg, buffer, xoff_threshold,
-			 port_buffer->buffer[i].xoff >> MLX5E_BUFFER_CELL_SHIFT);
-		MLX5_SET(bufferx_reg, buffer, xon_threshold,
-			 port_buffer->buffer[i].xon >> MLX5E_BUFFER_CELL_SHIFT);
+		void *buffer = MLX5_ADDR_OF(pbmc_reg, in, buffer[i]);
+		u64 size = port_buffer->buffer[i].size;
+		u64 xoff = port_buffer->buffer[i].xoff;
+		u64 xon = port_buffer->buffer[i].xon;
+
+		do_div(size, port_buff_cell_sz);
+		do_div(xoff, port_buff_cell_sz);
+		do_div(xon, port_buff_cell_sz);
+		MLX5_SET(bufferx_reg, buffer, size, size);
+		MLX5_SET(bufferx_reg, buffer, lossy, port_buffer->buffer[i].lossy);
+		MLX5_SET(bufferx_reg, buffer, xoff_threshold, xoff);
+		MLX5_SET(bufferx_reg, buffer, xon_threshold, xon);
 	}
 
 	err = mlx5e_port_set_pbmc(mdev, in);
@@ -143,7 +146,7 @@ static u32 calculate_xoff(struct mlx5e_priv *priv, unsigned int mtu)
 }
 
 static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
-				 u32 xoff, unsigned int max_mtu)
+				 u32 xoff, unsigned int max_mtu, u16 port_buff_cell_sz)
 {
 	int i;
 
@@ -155,7 +158,7 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
 		}
 
 		if (port_buffer->buffer[i].size <
-		    (xoff + max_mtu + (1 << MLX5E_BUFFER_CELL_SHIFT))) {
+		    (xoff + max_mtu + port_buff_cell_sz)) {
 			pr_err("buffer_size[%d]=%d is not enough for lossless buffer\n",
 			       i, port_buffer->buffer[i].size);
 			return -ENOMEM;
@@ -175,6 +178,7 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
  *	@pfc_en: <input> current pfc configuration
  *	@buffer: <input> current prio to buffer mapping
  *	@xoff:   <input> xoff value
+ *	@port_buff_cell_sz: <input> port buffer cell_size
  *	@port_buffer: <output> port receive buffer configuration
  *	@change: <output>
  *
@@ -189,7 +193,7 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
  *	sets change to true if buffer configuration was modified.
  */
 static int update_buffer_lossy(unsigned int max_mtu,
-			       u8 pfc_en, u8 *buffer, u32 xoff,
+			       u8 pfc_en, u8 *buffer, u32 xoff, u16 port_buff_cell_sz,
 			       struct mlx5e_port_buffer *port_buffer,
 			       bool *change)
 {
@@ -225,7 +229,7 @@ static int update_buffer_lossy(unsigned int max_mtu,
 	}
 
 	if (changed) {
-		err = update_xoff_threshold(port_buffer, xoff, max_mtu);
+		err = update_xoff_threshold(port_buffer, xoff, max_mtu, port_buff_cell_sz);
 		if (err)
 			return err;
 
@@ -262,6 +266,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 				    u32 *buffer_size,
 				    u8 *prio2buffer)
 {
+	u16 port_buff_cell_sz = priv->dcbx.port_buff_cell_sz;
 	struct mlx5e_port_buffer port_buffer;
 	u32 xoff = calculate_xoff(priv, mtu);
 	bool update_prio2buffer = false;
@@ -282,7 +287,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 
 	if (change & MLX5E_PORT_BUFFER_CABLE_LEN) {
 		update_buffer = true;
-		err = update_xoff_threshold(&port_buffer, xoff, max_mtu);
+		err = update_xoff_threshold(&port_buffer, xoff, max_mtu, port_buff_cell_sz);
 		if (err)
 			return err;
 	}
@@ -292,7 +297,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 		if (err)
 			return err;
 
-		err = update_buffer_lossy(max_mtu, pfc->pfc_en, buffer, xoff,
+		err = update_buffer_lossy(max_mtu, pfc->pfc_en, buffer, xoff, port_buff_cell_sz,
 					  &port_buffer, &update_buffer);
 		if (err)
 			return err;
@@ -304,7 +309,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 		if (err)
 			return err;
 
-		err = update_buffer_lossy(max_mtu, curr_pfc_en, prio2buffer,
+		err = update_buffer_lossy(max_mtu, curr_pfc_en, prio2buffer, port_buff_cell_sz,
 					  xoff, &port_buffer, &update_buffer);
 		if (err)
 			return err;
@@ -329,7 +334,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 			return -EINVAL;
 
 		update_buffer = true;
-		err = update_xoff_threshold(&port_buffer, xoff, max_mtu);
+		err = update_xoff_threshold(&port_buffer, xoff, max_mtu, port_buff_cell_sz);
 		if (err)
 			return err;
 	}
@@ -337,7 +342,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 	/* Need to update buffer configuration if xoff value is changed */
 	if (!update_buffer && xoff != priv->dcbx.xoff) {
 		update_buffer = true;
-		err = update_xoff_threshold(&port_buffer, xoff, max_mtu);
+		err = update_xoff_threshold(&port_buffer, xoff, max_mtu, port_buff_cell_sz);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
index 34f55b81a0de..80af7a5ac604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
@@ -36,7 +36,6 @@
 #include "port.h"
 
 #define MLX5E_MAX_BUFFER 8
-#define MLX5E_BUFFER_CELL_SHIFT 7
 #define MLX5E_DEFAULT_CABLE_LEN 7 /* 7 meters */
 
 #define MLX5_BUFFER_SUPPORTED(mdev) (MLX5_CAP_GEN(mdev, pcam_reg) && \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index bc102d094bbd..d20243d6a032 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1217,6 +1217,24 @@ static int mlx5e_trust_initialize(struct mlx5e_priv *priv)
 	return 0;
 }
 
+#define MLX5E_BUFFER_CELL_SHIFT 7
+
+static u16 mlx5e_query_port_buffers_cell_size(struct mlx5e_priv *priv)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u32 out[MLX5_ST_SZ_DW(sbcam_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(sbcam_reg)] = {};
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return (1 << MLX5E_BUFFER_CELL_SHIFT);
+
+	if (mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out),
+				 MLX5_REG_SBCAM, 0, 0))
+		return (1 << MLX5E_BUFFER_CELL_SHIFT);
+
+	return MLX5_GET(sbcam_reg, out, cap_cell_size);
+}
+
 void mlx5e_dcbnl_initialize(struct mlx5e_priv *priv)
 {
 	struct mlx5e_dcbx *dcbx = &priv->dcbx;
@@ -1234,6 +1252,7 @@ void mlx5e_dcbnl_initialize(struct mlx5e_priv *priv)
 	if (priv->dcbx.mode == MLX5E_DCBX_PARAM_VER_OPER_HOST)
 		priv->dcbx.cap |= DCB_CAP_DCBX_HOST;
 
+	priv->dcbx.port_buff_cell_sz = mlx5e_query_port_buffers_cell_size(priv);
 	priv->dcbx.manual_buffer = false;
 	priv->dcbx.cable_len = MLX5E_DEFAULT_CABLE_LEN;
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 13c0e4556eda..1e6ca716635a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -147,6 +147,7 @@ enum {
 	MLX5_REG_MCDA		 = 0x9063,
 	MLX5_REG_MCAM		 = 0x907f,
 	MLX5_REG_MIRC		 = 0x9162,
+	MLX5_REG_SBCAM		 = 0xB01F,
 	MLX5_REG_RESOURCE_DUMP   = 0xC000,
 };
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ca1887dd0423..073b79eacc99 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9960,6 +9960,34 @@ struct mlx5_ifc_pptb_reg_bits {
 	u8         untagged_buff[0x4];
 };
 
+struct mlx5_ifc_sbcam_reg_bits {
+	u8         reserved_at_0[0x8];
+	u8         feature_group[0x8];
+	u8         reserved_at_10[0x8];
+	u8         access_reg_group[0x8];
+
+	u8         reserved_at_20[0x20];
+
+	u8         sb_access_reg_cap_mask[4][0x20];
+
+	u8         reserved_at_c0[0x80];
+
+	u8         sb_feature_cap_mask[4][0x20];
+
+	u8         reserved_at_1c0[0x40];
+
+	u8         cap_total_buffer_size[0x20];
+
+	u8         cap_cell_size[0x10];
+	u8         cap_max_pg_buffers[0x8];
+	u8         cap_num_pool_supported[0x8];
+
+	u8         reserved_at_240[0x8];
+	u8         cap_sbsr_stat_size[0x8];
+	u8         cap_max_tclass_data[0x8];
+	u8         cap_max_cpu_ingress_tclass_sb[0x8];
+};
+
 struct mlx5_ifc_pbmc_reg_bits {
 	u8         reserved_at_0[0x8];
 	u8         local_port[0x8];
-- 
2.26.2

