Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075E2FC784
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfKNNbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:31:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbfKNNbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 08:31:42 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A51BA206DA;
        Thu, 14 Nov 2019 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573738301;
        bh=ygb/boYw8Uezh5eGU8BiXRVFI4l8+F6Vp33MmeACJ9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zd/VkNS/9yICz0q/qej3jF4M9rYUMm2L7suPpAUyE/EZzPVGlCPYBj2bAGcVbOzGu
         PjGAXGtcTWCYpckt5ZGDhyJ+17S1a1flXtvaF6zKk/MEZhSNFy88x5jfUWgMwg4uY4
         kiC9n0jCCkJ7umjIQZt8onxrrGbaDjzIQnVEgB7U=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 3/4] IB/ipoib: Add ndo operation for getting VFs GUID attributes
Date:   Thu, 14 Nov 2019 15:31:25 +0200
Message-Id: <20191114133126.238128-5-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114133126.238128-1-leon@kernel.org>
References: <20191114133126.238128-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

Add ndo operation to the network driver that enables configuring
ipoib_get_vf_guid operation. The operation allows to get a VF port
and node GUIDs.

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index ac0583ff280d..e5f438ab716c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2019,6 +2019,15 @@ static int ipoib_set_vf_guid(struct net_device *dev, int vf, u64 guid, int type)
 	return ib_set_vf_guid(priv->ca, vf, priv->port, guid, type);
 }

+static int ipoib_get_vf_guid(struct net_device *dev, int vf,
+			     struct ifla_vf_guid *node_guid,
+			     struct ifla_vf_guid *port_guid)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+
+	return ib_get_vf_guid(priv->ca, vf, priv->port, node_guid, port_guid);
+}
+
 static int ipoib_get_vf_stats(struct net_device *dev, int vf,
 			      struct ifla_vf_stats *vf_stats)
 {
@@ -2045,6 +2054,7 @@ static const struct net_device_ops ipoib_netdev_ops_pf = {
 	.ndo_set_vf_link_state	 = ipoib_set_vf_link_state,
 	.ndo_get_vf_config	 = ipoib_get_vf_config,
 	.ndo_get_vf_stats	 = ipoib_get_vf_stats,
+	.ndo_get_vf_guid	 = ipoib_get_vf_guid,
 	.ndo_set_vf_guid	 = ipoib_set_vf_guid,
 	.ndo_set_mac_address	 = ipoib_set_mac,
 	.ndo_get_stats64	 = ipoib_get_stats,
--
2.20.1

