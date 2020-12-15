Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9DC2DA5CD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgLOBtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:49:47 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9886 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729965AbgLOBta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 20:49:30 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cw1P737XTz7Ff2;
        Tue, 15 Dec 2020 09:48:11 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Tue, 15 Dec 2020
 09:48:41 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net 2/2] vhost_net: fix high cpu load when sendmsg fails
Date:   Tue, 15 Dec 2020 09:48:40 +0800
Message-ID: <4be47d3a325983f1bfc39f11f0e015767dd2aa3c.1608024547.git.wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
In-Reply-To: <cover.1608024547.git.wangyunjian@huawei.com>
References: <cover.1608024547.git.wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Currently we break the loop and wake up the vhost_worker when
sendmsg fails. When the worker wakes up again, we'll meet the
same error. This will cause high CPU load. To fix this issue,
we can skip this description by ignoring the error. When we
exceeds sndbuf, the return value of sendmsg is -EAGAIN. In
the case we don't skip the description and don't drop packet.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/vhost/net.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index c8784dfafdd7..f966592d8900 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -827,16 +827,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				msg.msg_flags &= ~MSG_MORE;
 		}
 
-		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
-		if (unlikely(err < 0)) {
+		if (unlikely(err == -EAGAIN)) {
 			vhost_discard_vq_desc(vq, 1);
 			vhost_net_enable_vq(net, vq);
 			break;
-		}
-		if (err != len)
-			pr_debug("Truncated TX packet: len %d != %zd\n",
-				 err, len);
+		} else if (unlikely(err < 0 || err != len))
+			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
 done:
 		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
 		vq->heads[nvq->done_idx].len = 0;
@@ -922,7 +919,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			msg.msg_flags &= ~MSG_MORE;
 		}
 
-		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (zcopy_used) {
@@ -931,13 +927,14 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
 					% UIO_MAXIOV;
 			}
-			vhost_discard_vq_desc(vq, 1);
-			vhost_net_enable_vq(net, vq);
-			break;
+			if (err == -EAGAIN) {
+				vhost_discard_vq_desc(vq, 1);
+				vhost_net_enable_vq(net, vq);
+				break;
+			}
 		}
 		if (err != len)
-			pr_debug("Truncated TX packet: "
-				 " len %d != %zd\n", err, len);
+			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
 		if (!zcopy_used)
 			vhost_add_used_and_signal(&net->dev, vq, head, 0);
 		else
-- 
2.23.0

