Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D332EA363
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 03:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbhAECfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 21:35:38 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10544 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbhAECfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 21:35:38 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8xQ161GfzMDtm;
        Tue,  5 Jan 2021 10:33:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 10:34:45 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH] net: qrtr: fix null-ptr-deref in qrtr_ns_remove
Date:   Tue, 5 Jan 2021 10:40:51 +0800
Message-ID: <20210105024051.150451-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A null-ptr-deref bug is reported by Hulk Robot like this:
--------------
KASAN: null-ptr-deref in range [0x0000000000000128-0x000000000000012f]
Call Trace:
qrtr_ns_remove+0x22/0x40 [ns]
qrtr_proto_fini+0xa/0x31 [qrtr]
__x64_sys_delete_module+0x337/0x4e0
do_syscall_64+0x34/0x80
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x468ded
--------------

When qrtr_ns_init fails in qrtr_proto_init, qrtr_ns_remove which would
be called later on would raise a null-ptr-deref because qrtr_ns.workqueue
has been destroyed.

Fix it by making qrtr_ns_init have a return value and adding a check in
qrtr_proto_init.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 net/qrtr/ns.c   |  7 ++++---
 net/qrtr/qrtr.c | 14 +++++++++++---
 net/qrtr/qrtr.h |  2 +-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 56aaf8cb6..8d00dfe81 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -755,7 +755,7 @@ static void qrtr_ns_data_ready(struct sock *sk)
 	queue_work(qrtr_ns.workqueue, &qrtr_ns.work);
 }
 
-void qrtr_ns_init(void)
+int qrtr_ns_init(void)
 {
 	struct sockaddr_qrtr sq;
 	int ret;
@@ -766,7 +766,7 @@ void qrtr_ns_init(void)
 	ret = sock_create_kern(&init_net, AF_QIPCRTR, SOCK_DGRAM,
 			       PF_QIPCRTR, &qrtr_ns.sock);
 	if (ret < 0)
-		return;
+		return ret;
 
 	ret = kernel_getsockname(qrtr_ns.sock, (struct sockaddr *)&sq);
 	if (ret < 0) {
@@ -797,12 +797,13 @@ void qrtr_ns_init(void)
 	if (ret < 0)
 		goto err_wq;
 
-	return;
+	return 0;
 
 err_wq:
 	destroy_workqueue(qrtr_ns.workqueue);
 err_sock:
 	sock_release(qrtr_ns.sock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(qrtr_ns_init);
 
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index f4ab3ca6d..95533e451 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1288,12 +1288,20 @@ static int __init qrtr_proto_init(void)
 
 	rc = sock_register(&qrtr_family);
 	if (rc) {
-		proto_unregister(&qrtr_proto);
-		return rc;
+		goto err_proto;
 	}
 
-	qrtr_ns_init();
+	rc = qrtr_ns_init();
+	if (rc) {
+		goto err_sock;
+	}
 
+	return 0;
+
+err_sock:
+	sock_unregister(qrtr_family.family);
+err_proto:
+	proto_unregister(&qrtr_proto);
 	return rc;
 }
 postcore_initcall(qrtr_proto_init);
diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
index dc2b67f17..3f2d28696 100644
--- a/net/qrtr/qrtr.h
+++ b/net/qrtr/qrtr.h
@@ -29,7 +29,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep);
 
 int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len);
 
-void qrtr_ns_init(void);
+int qrtr_ns_init(void);
 
 void qrtr_ns_remove(void);
 
-- 
2.23.0

