Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863736DA62
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 06:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfGSEBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 00:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfGSEBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 291BB21851;
        Fri, 19 Jul 2019 04:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508905;
        bh=V4huZNzy8HgUqUG9Hs18Y4DPLc1zQdIPvTrO6il0Jp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCVa+NvSuDYvSIZZItDuyhIp90cmgKhxrHouR9TwJvrujabTZ2BqW0ICBIaYl7iZ+
         wtVuAH61AdhNJVnOHqf/FAUVSiImqrIRyGF1LyvchP/ipBWzGXqP1g+Dl6gl6gV2l2
         zI8XRnwOMWOuOClduApluTEQY6ilRon3N+Ps+ndA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aya Levin <ayal@mellanox.com>, Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 150/171] net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn
Date:   Thu, 18 Jul 2019 23:56:21 -0400
Message-Id: <20190719035643.14300-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit ef1ce7d7b67b46661091c7ccc0396186b7a247ef ]

Check return value from mlx5e_attach_netdev, add error path on failure.

Fixes: 48935bbb7ae8 ("net/mlx5e: IPoIB, Add netdevice profile skeleton")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 9ca492b430d8..603d294757b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -698,7 +698,9 @@ static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u8 port_num,
 
 	prof->init(mdev, netdev, prof, ipriv);
 
-	mlx5e_attach_netdev(epriv);
+	err = mlx5e_attach_netdev(epriv);
+	if (err)
+		goto detach;
 	netif_carrier_off(netdev);
 
 	/* set rdma_netdev func pointers */
@@ -714,6 +716,11 @@ static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u8 port_num,
 
 	return 0;
 
+detach:
+	prof->cleanup(epriv);
+	if (ipriv->sub_interface)
+		return err;
+	mlx5e_destroy_mdev_resources(mdev);
 destroy_ht:
 	mlx5i_pkey_qpn_ht_cleanup(netdev);
 	return err;
-- 
2.20.1

