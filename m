Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B846B2E1D97
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgLWOsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:48:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9641 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgLWOsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 09:48:31 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D1GJ50r8Hz15hxZ;
        Wed, 23 Dec 2020 22:47:01 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Wed, 23 Dec 2020
 22:47:37 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v3 2/2] vhost_net: fix tx queue stuck when sendmsg fails
Date:   Wed, 23 Dec 2020 22:47:36 +0800
Message-ID: <1608734856-12516-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Currently the driver don't drop a packet which can't be send by tun
(e.g bad packet). In this case, the driver will always process the
same packet lead to the tx queue stuck.

To fix this issue:
1. in the case of persistent failure (e.g bad packet), the driver
can skip this descriptior by ignoring the error.
2. in the case of transient failure (e.g -EAGAIN and -ENOMEM), the
driver schedules the worker to try again.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/vhost/net.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index c8784dfafdd7..e49dd64d086a 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -827,9 +827,8 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				msg.msg_flags &= ~MSG_MORE;
 		}
 
-		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
-		if (unlikely(err < 0)) {
+		if (unlikely(err == -EAGAIN || err == -ENOMEM)) {
 			vhost_discard_vq_desc(vq, 1);
 			vhost_net_enable_vq(net, vq);
 			break;
@@ -922,7 +921,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			msg.msg_flags &= ~MSG_MORE;
 		}
 
-		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (zcopy_used) {
@@ -931,9 +929,11 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
 					% UIO_MAXIOV;
 			}
-			vhost_discard_vq_desc(vq, 1);
-			vhost_net_enable_vq(net, vq);
-			break;
+			if (err == -EAGAIN || err == -ENOMEM) {
+				vhost_discard_vq_desc(vq, 1);
+				vhost_net_enable_vq(net, vq);
+				break;
+			}
 		}
 		if (err != len)
 			pr_debug("Truncated TX packet: "
-- 
2.23.0

