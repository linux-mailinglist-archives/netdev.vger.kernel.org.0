Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69174421718
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbhJDTQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238350AbhJDTQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50C5B6124C;
        Mon,  4 Oct 2021 19:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633374898;
        bh=h005gJXSu/HG4evulDKTZ+adYQrFN1XtZ2/tOCKizqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwnA86Pw55ZD7QJQ6PKLNk/kIWyAGjz4F0BY7e5JLIVt9unWjJTzj5LtZNKp+dWQE
         9/ztCMPxniKqjVxfE3ZJNoeoPhP1BnjFw8FWtxkiicdKdWqWrAoah19DKkrqESJbBP
         b7lTN7fF5YAZNMqQC4pEv/UAaqAjz5IM7YhZnrZT+hhIH2Um5Rbc6OAAJRsMnV/al8
         Op/XU+ftMZXAZaYHELvzPea6v5SvwmBkxO8VTxNSI8W3e+ryxwgUHfKX+1wd8YwAot
         8H5njszWhde02JyMfUpHRq4/KhW+pgbrECi8vEF0qzZ/2gnVz+hEn8WG2dnknCgm11
         Bdaool2/THGvA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/4] mlx4: remove custom dev_addr clearing
Date:   Mon,  4 Oct 2021 12:14:45 -0700
Message-Id: <20211004191446.2127522-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211004191446.2127522-1-kuba@kernel.org>
References: <20211004191446.2127522-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx4_en_u64_to_mac() takes the dev->dev_addr pointer and writes
to it byte by byte. It also clears the two bytes _after_ ETH_ALEN
which seems unnecessary. dev->addr_len is set to ETH_ALEN just
before the call.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 76c8fe8e0125..dce228170b14 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -527,14 +527,12 @@ static int mlx4_en_vlan_rx_kill_vid(struct net_device *dev,
 	return err;
 }
 
-static void mlx4_en_u64_to_mac(unsigned char dst_mac[ETH_ALEN + 2], u64 src_mac)
+static void mlx4_en_u64_to_mac(struct net_device *dev, u64 src_mac)
 {
-	int i;
-	for (i = ETH_ALEN - 1; i >= 0; --i) {
-		dst_mac[i] = src_mac & 0xff;
-		src_mac >>= 8;
-	}
-	memset(&dst_mac[ETH_ALEN], 0, 2);
+	u8 addr[ETH_ALEN];
+
+	u64_to_ether_addr(src_mac, addr);
+	eth_hw_addr_set(dev, addr);
 }
 
 
@@ -3267,7 +3265,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 
 	/* Set default MAC */
 	dev->addr_len = ETH_ALEN;
-	mlx4_en_u64_to_mac(dev->dev_addr, mdev->dev->caps.def_mac[priv->port]);
+	mlx4_en_u64_to_mac(dev, mdev->dev->caps.def_mac[priv->port]);
 	if (!is_valid_ether_addr(dev->dev_addr)) {
 		en_err(priv, "Port: %d, invalid mac burned: %pM, quitting\n",
 		       priv->port, dev->dev_addr);
-- 
2.31.1

