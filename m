Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BC0111B43
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 23:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfLCWBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 17:01:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727416AbfLCWBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 17:01:20 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xB3LqlHR010889
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 14:01:18 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2wnd6sdc0k-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 14:01:18 -0800
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 3 Dec 2019 14:01:17 -0800
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 402EC70BE9FB; Tue,  3 Dec 2019 14:01:14 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <kernel-team@fb.com>, <brouer@redhat.com>,
        <grygorii.strashko@ti.com>
Smtp-Origin-Cluster: vll1c12
Subject: [net PATCH] xdp: obtain the mem_id mutex before trying to remove an entry.
Date:   Tue, 3 Dec 2019 14:01:14 -0800
Message-ID: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_07:2019-12-02,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 mlxlogscore=800 lowpriorityscore=0 clxscore=1034 suspectscore=2
 adultscore=0 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912030163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lockdep splat was observed when trying to remove an xdp memory
model from the table since the mutex was obtained when trying to
remove the entry, but not before the table walk started:

Fix the splat by obtaining the lock before starting the table walk.

Fixes: c3f812cea0d7 ("page_pool: do not release pool until inflight == 0.")
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/core/xdp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index e334fad0a6b8..7c8390ad4dc6 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -80,12 +80,8 @@ static void mem_xa_remove(struct xdp_mem_allocator *xa)
 {
 	trace_mem_disconnect(xa);
 
-	mutex_lock(&mem_id_lock);
-
 	if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
 		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
-
-	mutex_unlock(&mem_id_lock);
 }
 
 static void mem_allocator_disconnect(void *allocator)
@@ -93,6 +89,8 @@ static void mem_allocator_disconnect(void *allocator)
 	struct xdp_mem_allocator *xa;
 	struct rhashtable_iter iter;
 
+	mutex_lock(&mem_id_lock);
+
 	rhashtable_walk_enter(mem_id_ht, &iter);
 	do {
 		rhashtable_walk_start(&iter);
@@ -106,6 +104,8 @@ static void mem_allocator_disconnect(void *allocator)
 
 	} while (xa == ERR_PTR(-EAGAIN));
 	rhashtable_walk_exit(&iter);
+
+	mutex_unlock(&mem_id_lock);
 }
 
 static void mem_id_disconnect(int id)
-- 
2.17.1

