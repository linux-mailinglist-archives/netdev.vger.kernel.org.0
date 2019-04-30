Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E79F595
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 13:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfD3L3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 07:29:35 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7147 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726648AbfD3L3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 07:29:34 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C001333D6EAC89B7A63C;
        Tue, 30 Apr 2019 19:29:31 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 19:29:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] appletalk: Set error code while register_snap_client
Date:   Tue, 30 Apr 2019 19:28:40 +0800
Message-ID: <20190430112840.43452-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If register_snap_client fails in atalk_init,
error code should be set, otherwise it will
triggers NULL pointer dereference while unloading
module.

Fixes: 9804501fa122 ("appletalk: Fix potential NULL pointer dereference in unregister_snap_client")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/appletalk/ddp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 709d254..dbe8b19 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1920,6 +1920,7 @@ static int __init atalk_init(void)
 	ddp_dl = register_snap_client(ddp_snap_id, atalk_rcv);
 	if (!ddp_dl) {
 		pr_crit("Unable to register DDP with SNAP.\n");
+		rc = -ENOMEM;
 		goto out_sock;
 	}
 
-- 
2.7.0


