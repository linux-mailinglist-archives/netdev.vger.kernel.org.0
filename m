Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878B317784F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgCCOI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:08:56 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41254 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729478AbgCCOIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:08:55 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 16:08:52 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023E8fBm019613;
        Tue, 3 Mar 2020 16:08:51 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     parav@mellanox.com, jiri@mellanox.com, moshe@mellanox.com,
        vladyslavt@mellanox.com, saeedm@mellanox.com, leon@kernel.org
Subject: [PATCH] Revert "RDMA/cma: Simplify rdma_resolve_addr() error flow"
Date:   Tue,  3 Mar 2020 08:08:34 -0600
Message-Id: <20200303140834.7501-5-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200303140834.7501-1-parav@mellanox.com>
References: <20200303140834.7501-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 219d2e9dfda9431b808c28d5efc74b404b95b638.

In below flow requires cm_id_priv's destination address to be setup
before performing rdma_bind_addr().
Without which source port allocation for existing bind list fails when
port range is small, resulting into rdma_resolve_addr() failure.

rdma_resolve_addr()
  cma_bind_addr()
    rdma_bind_addr()
      cma_get_port()
        cma_alloc_any_port()
          cma_port_is_unique() <- compares with zero daddr

issue: 2064711
Change-Id: Ib81faae224a78d10879b10c94aae8b141b8debc6
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/infiniband/core/cma.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 43a6f07e0afe..ada28075d946 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3180,19 +3180,25 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+	memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	if (id_priv->state == RDMA_CM_IDLE) {
 		ret = cma_bind_addr(id, src_addr, dst_addr);
-		if (ret)
+		if (ret) {
+			memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
 			return ret;
+		}
 	}
 
-	if (cma_family(id_priv) != dst_addr->sa_family)
+	if (cma_family(id_priv) != dst_addr->sa_family) {
+		memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
 		return -EINVAL;
+	}
 
-	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY))
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY)) {
+		memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
 		return -EINVAL;
+	}
 
-	memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	if (cma_any_addr(dst_addr)) {
 		ret = cma_resolve_loopback(id_priv);
 	} else {
-- 
2.19.2

