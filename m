Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56397125A
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbfGWHNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732685AbfGWHNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 03:13:02 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E4B72238C;
        Tue, 23 Jul 2019 07:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563865981;
        bh=/AeZYX+JUna3ZCh05UfteU3NUn8L0WgCT1Lwr+ICNrQ=;
        h=From:To:Cc:Subject:Date:From;
        b=z+xNKoUVIlNdv2D5IaEK37LRzlxrQJVSXHIYklLzrmaF9+DDfFgmPxArZj/7K38Kk
         KJ03eP5esud2Pofl7zjPvdfk2bujnq+8IX4sDhJDOTpdc2dLsrGqnSIJGZ+a6a3r1P
         XA1qveE1yTjyrjAL19691BFGb7c79VhTgBUBnzws=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Edward Srouji <edwards@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
Date:   Tue, 23 Jul 2019 10:12:55 +0300
Message-Id: <20190723071255.6588-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Srouji <edwards@mellanox.com>

Fix modify_cq_in alignment to match the device specification.
After this fix the 'cq_umem_valid' field will be in the right offset.

Cc: <stable@vger.kernel.org> # 4.19
Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
Signed-off-by: Edward Srouji <edwards@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b3d5752657d9..ec571fd7fcf8 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5975,10 +5975,12 @@ struct mlx5_ifc_modify_cq_in_bits {

 	struct mlx5_ifc_cqc_bits cq_context;

-	u8         reserved_at_280[0x40];
+	u8         reserved_at_280[0x60];

 	u8         cq_umem_valid[0x1];
-	u8         reserved_at_2c1[0x5bf];
+	u8         reserved_at_2e1[0x1f];
+
+	u8         reserved_at_300[0x580];

 	u8         pas[0][0x40];
 };
--
2.20.1

