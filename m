Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80F62E23A8
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 03:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgLXC0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 21:26:31 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10074 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728790AbgLXC0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 21:26:31 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D1YnJ48G3zM8jj;
        Thu, 24 Dec 2020 10:24:52 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Thu, 24 Dec 2020
 10:25:39 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v4 1/2] vhost_net: fix ubuf refcount incorrectly when sendmsg fails
Date:   Thu, 24 Dec 2020 10:25:38 +0800
Message-ID: <1608776738-21868-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Currently the vhost_zerocopy_callback() maybe be called to decrease
the refcount when sendmsg fails in tun. The error handling in vhost
handle_tx_zerocopy() will try to decrease the same refcount again.
This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.

Fixes: 0690899b4d45 ("tun: experimental zero copy tx support")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d703cd..c8784dfafdd7 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -863,6 +863,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	size_t len, total_len = 0;
 	int err;
 	struct vhost_net_ubuf_ref *ubufs;
+	struct ubuf_info *ubuf;
 	bool zcopy_used;
 	int sent_pkts = 0;
 
@@ -895,9 +896,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 
 		/* use msg_control to pass vhost zerocopy ubuf info to skb */
 		if (zcopy_used) {
-			struct ubuf_info *ubuf;
 			ubuf = nvq->ubuf_info + nvq->upend_idx;
-
 			vq->heads[nvq->upend_idx].id = cpu_to_vhost32(vq, head);
 			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
 			ubuf->callback = vhost_zerocopy_callback;
@@ -927,7 +926,8 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (zcopy_used) {
-				vhost_net_ubuf_put(ubufs);
+				if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
+					vhost_net_ubuf_put(ubufs);
 				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
 					% UIO_MAXIOV;
 			}
-- 
2.23.0

