Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5257325F457
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgIGHvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:51:44 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12009 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgIGHvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:51:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f55e6810000>; Mon, 07 Sep 2020 00:51:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 07 Sep 2020 00:51:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 07 Sep 2020 00:51:43 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Sep
 2020 07:51:40 +0000
Date:   Mon, 7 Sep 2020 10:51:36 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH] vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Message-ID: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599465089; bh=4wJx5vySYqIKYNmdXnK44k/rmIs1k26+0WdFAFm17FE=;
        h=X-PGP-Universal:Date:From:To:Subject:Message-ID:MIME-Version:
         Content-Type:Content-Disposition:User-Agent:X-Originating-IP:
         X-ClientProxiedBy;
        b=kdXknpWgcDYHYWHbrIVU4SSDhYV+2akWdvxxdYa42SFt4QB1BNir/IsCTXGiIkDVR
         LYBTk+X9tYykpPz9b847XvDLf8es7l/EOnjNDcgCVE2213sd37X/ilju7TgZRlMj5P
         WxvM4Z9vk0BGCUsHgM26npM/I+lvIqKKfRk9n76Bis+X3gJqcab1YMIxz8ChN7sItI
         7LaHIPfP36SURi4FXxNaG6uouWIHiA4DfunWZWn7OEQA1RefEXzHsw6phPyosVpy/h
         MG1Vev3dtNDEdUUHLf0J1wo0Kfmlk2gjpgUJpOvhcVzCj+NyVO4JTpK93bFfVxMJEZ
         UW7YoobqlQzIg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the memory map changes before the driver status is
VIRTIO_CONFIG_S_DRIVER_OK, don't attempt to create resources because it
may fail. For example, if the VQ is not ready there is no point in
creating resources.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 9df69d5efe8c..c89cd48a0aab 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1645,6 +1645,9 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_net *ndev, struct vhost_iotlb *
 	if (err)
 		goto err_mr;
 
+	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
+		return 0;
+
 	restore_channels_info(ndev);
 	err = setup_driver(ndev);
 	if (err)
-- 
2.26.0

