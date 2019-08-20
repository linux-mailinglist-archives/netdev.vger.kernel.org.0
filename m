Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B208396C62
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbfHTWdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730930AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q8j9KokhURHH0lN02kIgFmPMPrSz2fFuerT1/ziZ5ZI=; b=g9HrJsUEWVm5tLbqH3wOXYRdQP
        bAUvHutIf5FfV4HsvIcYWkFoYexA3xDxpLv8rfYucnBrCQwSdCvZQeDYwqo2lr6ee72sFvQ+dxIX4
        pvKiS/Wohkie+HS+5A6css3G6040aGNIok2vGEihxn4iwLbqGAPPQER/DVjL5c27wjYmycnVtEs+W
        LJV0sIX6uDXVH9Taoht8Gj0MuRe/hoG0BxU2bV+2pb1dQdoXeinjdxO8mU0PWryBeHwEmSA7JoB4Q
        fLZxZBFfRK2Fn3WoCAsMuk1ZOIYoPe9HvvFQnmkQ23WHyJ/MFEvhaavAAH61CPgPQnwC4mV2ZECTu
        jEdPJzhA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005q9-0u; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 07/38] mlx5: Convert fpga IDRs to XArray
Date:   Tue, 20 Aug 2019 15:32:28 -0700
Message-Id: <20190820223259.22348-8-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Leave the locking as irq-disabling since it appears we can release
entries from interrupt context.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 .../ethernet/mellanox/mlx5/core/fpga/tls.c    | 54 +++++++------------
 .../ethernet/mellanox/mlx5/core/fpga/tls.h    |  6 +--
 2 files changed, 21 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
index 22a2ef111514..dbc09c8659a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
@@ -121,16 +121,12 @@ static void mlx5_fpga_tls_cmd_send(struct mlx5_fpga_device *fdev,
 	spin_unlock_irqrestore(&tls->pending_cmds_lock, flags);
 }
 
-/* Start of context identifiers range (inclusive) */
-#define SWID_START	0
 /* End of context identifiers range (exclusive) */
 #define SWID_END	BIT(24)
 
-static int mlx5_fpga_tls_alloc_swid(struct idr *idr, spinlock_t *idr_spinlock,
-				    void *ptr)
+static int mlx5_fpga_tls_alloc_swid(struct xarray *xa, void *flow)
 {
-	unsigned long flags;
-	int ret;
+	int ret, id;
 
 	/* TLS metadata format is 1 byte for syndrome followed
 	 * by 3 bytes of swid (software ID)
@@ -139,24 +135,22 @@ static int mlx5_fpga_tls_alloc_swid(struct idr *idr, spinlock_t *idr_spinlock,
 	 */
 	BUILD_BUG_ON((SWID_END - 1) & 0xFF000000);
 
-	idr_preload(GFP_KERNEL);
-	spin_lock_irqsave(idr_spinlock, flags);
-	ret = idr_alloc(idr, ptr, SWID_START, SWID_END, GFP_ATOMIC);
-	spin_unlock_irqrestore(idr_spinlock, flags);
-	idr_preload_end();
+	ret = xa_alloc_irq(xa, &id, flow, XA_LIMIT(0, SWID_END - 1),
+			GFP_KERNEL);
+	if (!ret)
+		return id;
 
 	return ret;
 }
 
-static void *mlx5_fpga_tls_release_swid(struct idr *idr,
-					spinlock_t *idr_spinlock, u32 swid)
+static void *mlx5_fpga_tls_release_swid(struct xarray *xa, u32 swid)
 {
 	unsigned long flags;
 	void *ptr;
 
-	spin_lock_irqsave(idr_spinlock, flags);
-	ptr = idr_remove(idr, swid);
-	spin_unlock_irqrestore(idr_spinlock, flags);
+	xa_lock_irqsave(xa, flags);
+	ptr = __xa_erase(xa, swid);
+	xa_unlock_irqrestore(xa, flags);
 	return ptr;
 }
 
@@ -210,7 +204,7 @@ int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
 	cmd = (buf + 1);
 
 	rcu_read_lock();
-	flow = idr_find(&mdev->fpga->tls->rx_idr, ntohl(handle));
+	flow = xa_load(&mdev->fpga->tls->rx_flows, ntohl(handle));
 	if (unlikely(!flow)) {
 		rcu_read_unlock();
 		WARN_ONCE(1, "Received NULL pointer for handle\n");
@@ -269,13 +263,9 @@ void mlx5_fpga_tls_del_flow(struct mlx5_core_dev *mdev, u32 swid,
 	void *flow;
 
 	if (direction_sx)
-		flow = mlx5_fpga_tls_release_swid(&tls->tx_idr,
-						  &tls->tx_idr_spinlock,
-						  swid);
+		flow = mlx5_fpga_tls_release_swid(&tls->tx_flows, swid);
 	else
-		flow = mlx5_fpga_tls_release_swid(&tls->rx_idr,
-						  &tls->rx_idr_spinlock,
-						  swid);
+		flow = mlx5_fpga_tls_release_swid(&tls->rx_flows, swid);
 
 	if (!flow) {
 		mlx5_fpga_err(mdev->fpga, "No flow information for swid %u\n",
@@ -483,10 +473,8 @@ int mlx5_fpga_tls_init(struct mlx5_core_dev *mdev)
 	spin_lock_init(&tls->pending_cmds_lock);
 	INIT_LIST_HEAD(&tls->pending_cmds);
 
-	idr_init(&tls->tx_idr);
-	idr_init(&tls->rx_idr);
-	spin_lock_init(&tls->tx_idr_spinlock);
-	spin_lock_init(&tls->rx_idr_spinlock);
+	xa_init_flags(&tls->tx_flows, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&tls->rx_flows, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	fdev->tls = tls;
 	return 0;
 
@@ -591,11 +579,9 @@ int mlx5_fpga_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
 	u32 swid;
 
 	if (direction_sx)
-		ret = mlx5_fpga_tls_alloc_swid(&tls->tx_idr,
-					       &tls->tx_idr_spinlock, flow);
+		ret = mlx5_fpga_tls_alloc_swid(&tls->tx_flows, flow);
 	else
-		ret = mlx5_fpga_tls_alloc_swid(&tls->rx_idr,
-					       &tls->rx_idr_spinlock, flow);
+		ret = mlx5_fpga_tls_alloc_swid(&tls->rx_flows, flow);
 
 	if (ret < 0)
 		return ret;
@@ -612,11 +598,9 @@ int mlx5_fpga_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
 	return 0;
 free_swid:
 	if (direction_sx)
-		mlx5_fpga_tls_release_swid(&tls->tx_idr,
-					   &tls->tx_idr_spinlock, swid);
+		mlx5_fpga_tls_release_swid(&tls->tx_flows, swid);
 	else
-		mlx5_fpga_tls_release_swid(&tls->rx_idr,
-					   &tls->rx_idr_spinlock, swid);
+		mlx5_fpga_tls_release_swid(&tls->rx_flows, swid);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
index 3b2e37bf76fe..0b56332f453b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
@@ -45,10 +45,8 @@ struct mlx5_fpga_tls {
 	u32 caps;
 	struct mlx5_fpga_conn *conn;
 
-	struct idr tx_idr;
-	struct idr rx_idr;
-	spinlock_t tx_idr_spinlock; /* protects the IDR */
-	spinlock_t rx_idr_spinlock; /* protects the IDR */
+	struct xarray tx_flows;
+	struct xarray rx_flows;
 };
 
 int mlx5_fpga_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
-- 
2.23.0.rc1

