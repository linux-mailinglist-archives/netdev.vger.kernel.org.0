Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A979782D16
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbfHFHsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 03:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbfHFHsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 03:48:17 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75CCD206A2;
        Tue,  6 Aug 2019 07:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565077697;
        bh=13CP357uqJDYp2yGgrBzeBL4lf24AxhuZ0UF4+J5Oew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvJIqCmBI8McAtvN9M/zBIloMYeAmM7+kCdqZvc4unXllEYZg3DTJdC8oVUz6XtTz
         VCj9G6kY4Suh6eK7N5ZxItbn460WyRd6Ju6Pm30KUjcJz8UT3NVbKEXIcxr6zo0s/e
         XiN5QzL29cldTZUr94H7xO9VExI1hCY3ocyHzKVM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v2 1/4] net/mlx5: Set ODP capabilities for DC transport
Date:   Tue,  6 Aug 2019 10:48:04 +0300
Message-Id: <20190806074807.9111-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190806074807.9111-1-leon@kernel.org>
References: <20190806074807.9111-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Query ODP capabilities for DC transport from FW.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 6 ++++++
 include/linux/mlx5/mlx5_ifc.h                  | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index b15b27a497fc..3995fc6d4d34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -495,6 +495,12 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.write);
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.read);
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.atomic);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.srq_receive);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.send);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.receive);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.write);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.read);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
 
 	if (do_set)
 		err = set_caps(dev, set_ctx, set_sz,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ec571fd7fcf8..b96d5c37f70f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -944,7 +944,9 @@ struct mlx5_ifc_odp_cap_bits {
 
 	struct mlx5_ifc_odp_per_transport_service_cap_bits xrc_odp_caps;
 
-	u8         reserved_at_100[0x700];
+	struct mlx5_ifc_odp_per_transport_service_cap_bits dc_odp_caps;
+
+	u8         reserved_at_120[0x6E0];
 };
 
 struct mlx5_ifc_calc_op {
-- 
2.20.1

