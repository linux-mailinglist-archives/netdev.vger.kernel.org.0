Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADF42DBC8E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 09:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgLPIVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 03:21:43 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9210 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPIVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 03:21:43 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cwp2s1Dc1zkppM;
        Wed, 16 Dec 2020 16:20:05 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Wed, 16 Dec 2020
 16:20:46 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg fails
Date:   Wed, 16 Dec 2020 16:20:37 +0800
Message-ID: <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
In-Reply-To: <cover.1608065644.git.wangyunjian@huawei.com>
References: <cover.1608065644.git.wangyunjian@huawei.com>
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
index c8784dfafdd7..3d33f3183abe 100644
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
+		} else if (unlikely(err != len))
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

