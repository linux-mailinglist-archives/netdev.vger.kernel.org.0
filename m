Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3FE62D639
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiKQJP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbiKQJPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:15:21 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8347299F
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:15:20 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NCZ0f2QtDzqSWZ;
        Thu, 17 Nov 2022 17:11:30 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 17:15:19 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <linux_oss@crudebyte.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <v9fs-developer@lists.sourceforge.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/3 v2] 9p: Use P9_HDRSZ for header size
Date:   Thu, 17 Nov 2022 17:11:59 +0800
Message-ID: <20221117091159.31533-4-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221117091159.31533-1-guozihua@huawei.com>
References: <20221117091159.31533-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The m->rc.offset here actually represents the header size of a p9
message. So instead we use P9_HDRSZ directly. At the mean time, update
all header sizes as well.

Fixes: 3da2e34b64cd ("9p: Fix write overflow in p9_read_work")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 net/9p/trans_fd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 4ba602438550..89a51fcc831d 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -120,7 +120,7 @@ struct p9_conn {
 	struct list_head unsent_req_list;
 	struct p9_req_t *rreq;
 	struct p9_req_t *wreq;
-	char tmp_buf[7];
+	char tmp_buf[P9_HDRSZ];
 	struct p9_fcall rc;
 	int wpos;
 	int wsize;
@@ -291,7 +291,7 @@ static void p9_read_work(struct work_struct *work)
 	if (!m->rc.sdata) {
 		m->rc.sdata = m->tmp_buf;
 		m->rc.offset = 0;
-		m->rc.capacity = 7; /* start by reading header */
+		m->rc.capacity = P9_HDRSZ; /* start by reading header */
 	}
 
 	clear_bit(Rpending, &m->wsched);
@@ -314,7 +314,7 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new header\n");
 
 		/* Header size */
-		m->rc.size = 7;
+		m->rc.size = P9_HDRSZ;
 		err = p9_parse_header(&m->rc, &m->rc.size, NULL, NULL, 0);
 		if (err) {
 			p9_debug(P9_DEBUG_ERROR,
@@ -334,7 +334,7 @@ static void p9_read_work(struct work_struct *work)
 			goto error;
 		}
 
-		if (m->rc.size > m->rreq->rc.capacity - m->rc.offset) {
+		if (m->rc.size > m->rreq->rc.capacity - P9_HDRSZ) {
 			p9_debug(P9_DEBUG_ERROR,
 				 "requested packet size too big: %d for tag %d with capacity %zd\n",
 				 m->rc.size, m->rc.tag, m->rreq->rc.capacity);
-- 
2.17.1

