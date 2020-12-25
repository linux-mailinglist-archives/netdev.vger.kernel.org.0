Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB922E2A28
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 08:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgLYHZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 02:25:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9926 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgLYHZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 02:25:23 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D2JMw64gjzhs3n;
        Fri, 25 Dec 2020 15:23:56 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 25 Dec 2020
 15:24:26 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v5 1/2] vhost_net: fix ubuf refcount incorrectly when sendmsg fails
Date:   Fri, 25 Dec 2020 15:24:25 +0800
Message-ID: <1608881065-7572-1-git-send-email-wangyunjian@huawei.com>
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
Acked-by: Jason Wang <jasowang@redhat.com>
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

