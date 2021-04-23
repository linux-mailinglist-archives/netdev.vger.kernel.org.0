Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30AC368F99
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 11:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241900AbhDWJns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 05:43:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17396 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241898AbhDWJnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 05:43:47 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FRTnM57L5zlZHb;
        Fri, 23 Apr 2021 17:41:11 +0800 (CST)
Received: from localhost (10.174.242.151) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Fri, 23 Apr 2021
 17:42:59 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <chuck.lever@oracle.com>,
        <bfields@fieldses.org>, <dingxiaoxiong@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] SUNRPC: Fix null pointer dereference in svc_rqst_free()
Date:   Fri, 23 Apr 2021 17:42:58 +0800
Message-ID: <1619170978-15192-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.151]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

When alloc_pages_node() returns null in svc_rqst_alloc(), the
null rq_scratch_page pointer will be dereferenced when calling
put_page() in svc_rqst_free(). Fix it by adding a null check.

Addresses-Coverity: ("Dereference after null check")
Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on the server-side")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/sunrpc/svc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index d76dc9d95d16..0de918cb3d90 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -846,7 +846,8 @@ void
 svc_rqst_free(struct svc_rqst *rqstp)
 {
 	svc_release_buffer(rqstp);
-	put_page(rqstp->rq_scratch_page);
+	if (rqstp->rq_scratch_page)
+		put_page(rqstp->rq_scratch_page);
 	kfree(rqstp->rq_resp);
 	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
-- 
2.23.0

