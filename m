Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E1A2E2A27
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 08:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgLYHZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 02:25:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9927 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgLYHZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 02:25:23 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D2JN51JP4zhv3M;
        Fri, 25 Dec 2020 15:24:05 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Fri, 25 Dec 2020
 15:24:34 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v5 2/2] vhost_net: fix tx queue stuck when sendmsg fails
Date:   Fri, 25 Dec 2020 15:24:33 +0800
Message-ID: <1608881073-19004-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Currently the driver doesn't drop a packet which can't be sent by tun
(e.g bad packet). In this case, the driver will always process the
same packet lead to the tx queue stuck.

To fix this issue:
1. in the case of persistent failure (e.g bad packet), the driver
   can skip this descriptor by ignoring the error.
2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
   the driver schedules the worker to try again.

Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 drivers/vhost/net.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index c8784dfafdd7..01558fb2c552 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -827,14 +827,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				msg.msg_flags &= ~MSG_MORE;
 		}
 
-		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
-		if (unlikely(err < 0)) {
+		if (unlikely(err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS)) {
 			vhost_discard_vq_desc(vq, 1);
 			vhost_net_enable_vq(net, vq);
 			break;
 		}
-		if (err != len)
+		if (err >= 0 && err != len)
 			pr_debug("Truncated TX packet: len %d != %zd\n",
 				 err, len);
 done:
@@ -922,7 +921,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			msg.msg_flags &= ~MSG_MORE;
 		}
 
-		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (zcopy_used) {
@@ -931,11 +929,13 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
 					% UIO_MAXIOV;
 			}
-			vhost_discard_vq_desc(vq, 1);
-			vhost_net_enable_vq(net, vq);
-			break;
+			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
+				vhost_discard_vq_desc(vq, 1);
+				vhost_net_enable_vq(net, vq);
+				break;
+			}
 		}
-		if (err != len)
+		if (err >= 0 && err != len)
 			pr_debug("Truncated TX packet: "
 				 " len %d != %zd\n", err, len);
 		if (!zcopy_used)
-- 
2.23.0

