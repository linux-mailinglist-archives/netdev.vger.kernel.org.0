Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422102D415E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbgLILt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:49:27 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8971 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbgLILt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:49:27 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Crb0H31f3zhpd9;
        Wed,  9 Dec 2020 19:48:15 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Dec 2020
 19:48:30 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <jerry.lilijun@huawei.com>,
        <chenchanghu@huawei.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
Date:   Wed, 9 Dec 2020 19:48:24 +0800
Message-ID: <1607514504-20956-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
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
we can skip this description by ignoring the error.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/vhost/net.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d703cd..ac950b1120f5 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -829,14 +829,8 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 
 		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
-		if (unlikely(err < 0)) {
-			vhost_discard_vq_desc(vq, 1);
-			vhost_net_enable_vq(net, vq);
-			break;
-		}
-		if (err != len)
-			pr_debug("Truncated TX packet: len %d != %zd\n",
-				 err, len);
+		if (unlikely(err < 0 || err != len))
+			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
 done:
 		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
 		vq->heads[nvq->done_idx].len = 0;
@@ -925,19 +919,11 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 
 		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
-		if (unlikely(err < 0)) {
-			if (zcopy_used) {
+		if (unlikely(err < 0 || err != len)) {
+			if (zcopy_used && err < 0)
 				vhost_net_ubuf_put(ubufs);
-				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
-					% UIO_MAXIOV;
-			}
-			vhost_discard_vq_desc(vq, 1);
-			vhost_net_enable_vq(net, vq);
-			break;
+			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
 		}
-		if (err != len)
-			pr_debug("Truncated TX packet: "
-				 " len %d != %zd\n", err, len);
 		if (!zcopy_used)
 			vhost_add_used_and_signal(&net->dev, vq, head, 0);
 		else
-- 
2.23.0

