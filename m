Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A3F261CBA
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbgIHTZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:25:44 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1582 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731072AbgIHQAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:00:40 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f577a220000>; Tue, 08 Sep 2020 05:33:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 05:33:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 05:33:51 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 12:33:50 +0000
Date:   Tue, 8 Sep 2020 15:33:46 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH v2] vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Message-ID: <20200908123346.GA169007@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599568418; bh=FX23fstj6uHn7NCicVrA8DIWtBbS7h/VWMQEvMeRbfg=;
        h=X-PGP-Universal:Date:From:To:Subject:Message-ID:MIME-Version:
         Content-Type:Content-Disposition:User-Agent:X-Originating-IP:
         X-ClientProxiedBy;
        b=X4rNdNUs2DQD2D2GpXJCdjxgIqekUSwJZeb+xbSK0IKiTHBd51UOAjfLNMA8B10I1
         N3MA6UlXb5PqG8J53fxpBrgPDJkPkg8YGhUi+QD/jrzfBqTBCjC1/kKnjr5wkA5G7h
         XOnmCkaRcVuvzK0eO33l9yQM/N2kRDLRYXzfivQUYogLzSiELWEtYXW9iQTHXBvUyz
         1SvGLH8FYzTRMywpIg/hsTkrZEGgU+v/tygVCXFfjhdH05FEO3uZLkoptslxuKk/Vw
         geWWkGszOa3ShEGPbE2E0RoO423KSaWI9nseBQa5Qk8qfrglD/WQZ7uzMuVzBtJbBC
         8TmS6Qq/4WNbw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

set_map() is used by mlx5 vdpa to create a memory region based on the
address map passed by the iotlb argument. If we get successive calls, we
will destroy the current memory region and build another one based on
the new address mapping. We also need to setup the hardware resources
since they depend on the memory region.

If these calls happen before DRIVER_OK, It means that driver VQs may
also not been setup and we may not create them yet. In this case we want
to avoid setting up the other resources and defer this till we get
DRIVER OK.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
V1->V2: Improve changelog description

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

