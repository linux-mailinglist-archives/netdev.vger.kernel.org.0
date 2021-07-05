Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E846D3BBDE7
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhGEN4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 09:56:23 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10260 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhGEN4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 09:56:23 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GJRpn6byCz1CFcJ;
        Mon,  5 Jul 2021 21:48:17 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 21:53:44 +0800
Received: from localhost (10.174.242.204) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 5 Jul 2021
 21:53:43 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <dingxiaoxiong@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] virtio_net: check virtqueue_add_sgs() return value
Date:   Mon, 5 Jul 2021 21:53:39 +0800
Message-ID: <63453491987be2b31062449bd59224faca9f546a.1625486802.git.wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500008.china.huawei.com (7.185.36.136)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

As virtqueue_add_sgs() can fail, we should check the return value.

Addresses-Coverity-ID: 1464439 ("Unchecked return value")
Fixes: a7c58146cf9a ("virtio_net: don't crash if virtqueue is broken.")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/virtio_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b0b81458ca94..2b852578551e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1743,6 +1743,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 {
 	struct scatterlist *sgs[4], hdr, stat;
 	unsigned out_num = 0, tmp;
+	int ret;
 
 	/* Caller should know better */
 	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
@@ -1762,7 +1763,9 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	sgs[out_num] = &stat;
 
 	BUG_ON(out_num + 1 > ARRAY_SIZE(sgs));
-	virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
+	ret = virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
+	if (ret < 0)
+		return false;
 
 	if (unlikely(!virtqueue_kick(vi->cvq)))
 		return vi->ctrl->status == VIRTIO_NET_OK;
-- 
2.23.0

