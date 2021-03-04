Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC1F32D33C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240948AbhCDMd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:28654 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240816AbhCDMdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:20 -0500
IronPort-SDR: OUo+ydWREe2SOT7ByBBCfA9oY9UrJalX2LPeMvBvY3cm3Ub1TjFll3WkNguOqFKGYi5olp+rUw
 OdX5js/iS+dQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="272407033"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="272407033"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:32 -0800
IronPort-SDR: a0wT1WU+ciekmGg3kQiHWH2AZImMuiKCKWu82FvGrvrWL/DS4kgcYoiccodbeTQZmt7WPiJZPj
 KaSbx+GEfl3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="374534678"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 04 Mar 2021 04:31:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 982734D7; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 11/18] thunderbolt: Use dedicated flow control for DMA tunnels
Date:   Thu,  4 Mar 2021 15:31:18 +0300
Message-Id: <20210304123125.43630-12-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The USB4 inter-domain service spec recommends using dedicated flow
control scheme so update the driver accordingly.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/tunnel.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index 6557b6e07009..2e7ec037a73e 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -794,24 +794,14 @@ static u32 tb_dma_credits(struct tb_port *nhi)
 	return min(max_credits, 13U);
 }
 
-static int tb_dma_activate(struct tb_tunnel *tunnel, bool active)
-{
-	struct tb_port *nhi = tunnel->src_port;
-	u32 credits;
-
-	credits = active ? tb_dma_credits(nhi) : 0;
-	return tb_port_set_initial_credits(nhi, credits);
-}
-
-static void tb_dma_init_path(struct tb_path *path, unsigned int isb,
-			     unsigned int efc, u32 credits)
+static void tb_dma_init_path(struct tb_path *path, unsigned int efc, u32 credits)
 {
 	int i;
 
 	path->egress_fc_enable = efc;
 	path->ingress_fc_enable = TB_PATH_ALL;
 	path->egress_shared_buffer = TB_PATH_NONE;
-	path->ingress_shared_buffer = isb;
+	path->ingress_shared_buffer = TB_PATH_NONE;
 	path->priority = 5;
 	path->weight = 1;
 	path->clear_fc = true;
@@ -856,7 +846,6 @@ struct tb_tunnel *tb_tunnel_alloc_dma(struct tb *tb, struct tb_port *nhi,
 	if (!tunnel)
 		return NULL;
 
-	tunnel->activate = tb_dma_activate;
 	tunnel->src_port = nhi;
 	tunnel->dst_port = dst;
 
@@ -869,8 +858,7 @@ struct tb_tunnel *tb_tunnel_alloc_dma(struct tb *tb, struct tb_port *nhi,
 			tb_tunnel_free(tunnel);
 			return NULL;
 		}
-		tb_dma_init_path(path, TB_PATH_NONE, TB_PATH_SOURCE | TB_PATH_INTERNAL,
-				 credits);
+		tb_dma_init_path(path, TB_PATH_SOURCE | TB_PATH_INTERNAL, credits);
 		tunnel->paths[i++] = path;
 	}
 
@@ -881,7 +869,7 @@ struct tb_tunnel *tb_tunnel_alloc_dma(struct tb *tb, struct tb_port *nhi,
 			tb_tunnel_free(tunnel);
 			return NULL;
 		}
-		tb_dma_init_path(path, TB_PATH_SOURCE, TB_PATH_ALL, credits);
+		tb_dma_init_path(path, TB_PATH_ALL, credits);
 		tunnel->paths[i++] = path;
 	}
 
-- 
2.30.1

