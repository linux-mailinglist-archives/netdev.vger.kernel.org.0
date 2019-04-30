Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD711FBBE
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfD3Olj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:41:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7149 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726073AbfD3Olj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 10:41:39 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B43494593EFE64FF1F6E;
        Tue, 30 Apr 2019 22:41:36 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 22:41:29 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <ericvh@gmail.com>, <lucho@ionkov.net>,
        <asmadeus@codewreck.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <v9fs-developer@lists.sourceforge.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] 9p/xen: Add cleanup path in p9_trans_xen_init
Date:   Tue, 30 Apr 2019 22:39:33 +0800
Message-ID: <20190430143933.19368-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If xenbus_register_frontend() fails in p9_trans_xen_init,
we should call v9fs_unregister_trans() to do cleanup.

Fixes: 868eb122739a ("xen/9pfs: introduce Xen 9pfs transport driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/9p/trans_xen.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 29420eb..3963eb1 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -530,13 +530,19 @@ static struct xenbus_driver xen_9pfs_front_driver = {
 
 static int p9_trans_xen_init(void)
 {
+	int rc;
+
 	if (!xen_domain())
 		return -ENODEV;
 
 	pr_info("Initialising Xen transport for 9pfs\n");
 
 	v9fs_register_trans(&p9_xen_trans);
-	return xenbus_register_frontend(&xen_9pfs_front_driver);
+	rc = xenbus_register_frontend(&xen_9pfs_front_driver);
+	if (rc)
+		v9fs_unregister_trans(&p9_xen_trans);
+
+	return rc;
 }
 module_init(p9_trans_xen_init);
 
-- 
2.7.0


