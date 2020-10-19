Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D163829294E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgJSO2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:28:36 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:11552 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgJSO2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 10:28:35 -0400
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2020 10:28:30 EDT
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 89CD05C0F4E;
        Mon, 19 Oct 2020 22:17:07 +0800 (CST)
From:   wenxu@ucloud.cn
To:     eli@mellanox.com
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, parav@mellanox.com
Subject: [PATCH net] vdpa/mlx5: Fix miss to set VIRTIO_NET_S_LINK_UP for virtio_net_config
Date:   Mon, 19 Oct 2020 22:17:07 +0800
Message-Id: <1603117027-24054-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSUNMQ00dShoeS0hDVkpNS0hKSkxLSUxNSENVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Phw6Ohw5MT4MN0s6HhQeMxAT
        HzwwChNVSlVKTUtISkpMS0lMTExIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpMS0s3Bg++
X-HM-Tid: 0a75413891022087kuqy89cd05c0f4e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Qemu get virtio_net_config from the vdpa driver. So The vdpa driver
should set the VIRTIO_NET_S_LINK_UP flag to virtio_net_config like
vdpa_sim. Or the link of virtio net NIC in the virtual machine will
never up.

Fixes:1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 74264e59..af6c74c 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1537,6 +1537,8 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
 	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
 	ndev->config.mtu = __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev),
 					     ndev->mtu);
+	ndev->config.status = __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev),
+					       VIRTIO_NET_S_LINK_UP);
 	return err;
 }
 
-- 
1.8.3.1

