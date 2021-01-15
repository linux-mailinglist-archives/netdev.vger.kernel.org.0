Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85802F71B2
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbhAOErP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:47:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11535 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbhAOErO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:47:14 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DH7s41FNtzMK9n;
        Fri, 15 Jan 2021 12:45:12 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Fri, 15 Jan 2021
 12:46:22 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>,
        <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next v7] vhost_net: avoid tx queue stuck when sendmsg fails
Date:   Fri, 15 Jan 2021 12:46:20 +0800
Message-ID: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
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

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
v7:
   * code rebase
v6:
   * update code styles and commit log
---
 drivers/vhost/net.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 3b744031ec8f..df82b124170e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -828,14 +828,15 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				msg.msg_flags &= ~MSG_MORE;
 		}
 
-		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
-			vhost_discard_vq_desc(vq, 1);
-			vhost_net_enable_vq(net, vq);
-			break;
-		}
-		if (err != len)
+			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
+				vhost_discard_vq_desc(vq, 1);
+				vhost_net_enable_vq(net, vq);
+				break;
+			}
+			pr_debug("Fail to send packet: err %d", err);
+		} else if (unlikely(err != len))
 			pr_debug("Truncated TX packet: len %d != %zd\n",
 				 err, len);
 done:
@@ -924,7 +925,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			msg.msg_flags &= ~MSG_MORE;
 		}
 
-		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (zcopy_used) {
@@ -933,11 +933,13 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
 					% UIO_MAXIOV;
 			}
-			vhost_discard_vq_desc(vq, 1);
-			vhost_net_enable_vq(net, vq);
-			break;
-		}
-		if (err != len)
+			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
+				vhost_discard_vq_desc(vq, 1);
+				vhost_net_enable_vq(net, vq);
+				break;
+			}
+			pr_debug("Fail to send packet: err %d", err);
+		} else if (unlikely(err != len))
 			pr_debug("Truncated TX packet: "
 				 " len %d != %zd\n", err, len);
 		if (!zcopy_used)
-- 
2.23.0

