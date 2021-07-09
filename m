Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BC73C2223
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 12:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhGIKYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 06:24:21 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11242 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhGIKYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 06:24:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GLpw41Crmz1CGwK;
        Fri,  9 Jul 2021 18:16:04 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 9 Jul 2021 18:21:35 +0800
Received: from localhost (10.174.242.204) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 9 Jul 2021
 18:21:35 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <dingxiaoxiong@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] virtio_net: check virtqueue_add_sgs() return value
Date:   Fri, 9 Jul 2021 18:21:31 +0800
Message-ID: <1625826091-42668-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500008.china.huawei.com (7.185.36.136)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

As virtqueue_add_sgs() can fail, we should check the return value.

Addresses-Coverity-ID: 1464439 ("Unchecked return value")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
v2:
  add warn log and remove fix tag
---
 drivers/net/virtio_net.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b0b81458ca94..30a0ca2fef1a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1743,6 +1743,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 {
 	struct scatterlist *sgs[4], hdr, stat;
 	unsigned out_num = 0, tmp;
+	int ret;
 
 	/* Caller should know better */
 	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
@@ -1762,7 +1763,12 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	sgs[out_num] = &stat;
 
 	BUG_ON(out_num + 1 > ARRAY_SIZE(sgs));
-	virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
+	ret = virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
+	if (ret < 0) {
+		dev_warn(&vi->vdev->dev,
+			 "Failed to add sgs for vq: %d\n.", ret);
+		return false;
+	}
 
 	if (unlikely(!virtqueue_kick(vi->cvq)))
 		return vi->ctrl->status == VIRTIO_NET_OK;
-- 
2.23.0

