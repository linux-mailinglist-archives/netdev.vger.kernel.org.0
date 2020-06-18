Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4031FF8E0
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732031AbgFRQKi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2438 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732006AbgFRQK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:10:27 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IGAR12009933
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:27 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q65dcyrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:27 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 4A66F3D44E140; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 09/21] include: add definitions for netgpu
Date:   Thu, 18 Jun 2020 09:09:29 -0700
Message-ID: <20200618160941.879717-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=493
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=1 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 cotscore=-2147483648
 phishscore=0 impostorscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the netgpu structure (which arguably should be private),
and some cruft to support using netgpu as a loadable module, which
should disappear.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/netgpu.h | 65 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 include/net/netgpu.h

diff --git a/include/net/netgpu.h b/include/net/netgpu.h
new file mode 100644
index 000000000000..fee84ba3db78
--- /dev/null
+++ b/include/net/netgpu.h
@@ -0,0 +1,65 @@
+#pragma once
+
+struct net_device;
+#include <uapi/misc/shqueue.h>		/* XXX */
+
+struct netgpu_pgcache {
+	struct netgpu_pgcache *next;
+	struct page *page[];
+};
+
+struct netgpu_ctx {
+	struct xarray xa;		/* contains regions */
+	unsigned int index;
+	refcount_t ref;
+	struct shared_queue fill;
+	struct shared_queue rx;
+	struct net_device *dev;
+	struct netgpu_pgcache *napi_cache;
+	struct netgpu_pgcache *spare_cache;
+	struct netgpu_pgcache *any_cache;
+	spinlock_t pgcache_lock;
+	struct page *dummy_page;
+	unsigned page_extra_refc;
+	int queue_id;
+	int napi_cache_count;
+	int any_cache_count;
+	struct user_struct *user;
+	unsigned account_mem : 1;
+};
+
+int netgpu_get_page(struct netgpu_ctx *ctx, struct page **page,
+		    dma_addr_t *dma);
+void netgpu_put_page(struct netgpu_ctx *ctx, struct page *page, bool napi);
+int netgpu_get_pages(struct sock *sk, struct page **pages, unsigned long addr,
+		 int count);
+
+/*---------------------------------------------------------------------------*/
+/* XXX temporary development support */
+
+extern int (*fn_netgpu_get_page)(struct netgpu_ctx *ctx,
+			  struct page **page, dma_addr_t *dma);
+extern void (*fn_netgpu_put_page)(struct netgpu_ctx *, struct page *, bool);
+extern int (*fn_netgpu_get_pages)(struct sock *, struct page **,
+                           unsigned long, int);
+extern struct netgpu_ctx *g_ctx;
+
+static inline int
+__netgpu_get_page(struct netgpu_ctx *ctx,
+                  struct page **page, dma_addr_t *dma)
+{
+        return fn_netgpu_get_page(ctx, page, dma);
+}
+
+static inline void
+__netgpu_put_page(struct netgpu_ctx *ctx, struct page *page, bool napi)
+{
+        return fn_netgpu_put_page(ctx, page, napi);
+}
+
+static inline int
+__netgpu_get_pages(struct sock *sk, struct page **pages,
+                   unsigned long addr, int count)
+{
+        return fn_netgpu_get_pages(sk, pages, addr, count);
+}
-- 
2.24.1

