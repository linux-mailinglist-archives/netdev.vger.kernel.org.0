Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E9822FC6C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgG0WpT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:45:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727842AbgG0Wox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:53 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfda4010751
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:52 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h50vprn7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:52 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id C38FC3FAB6F63; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 05/21] uapi/misc: add shqueue.h for shared queues
Date:   Mon, 27 Jul 2020 15:44:28 -0700
Message-ID: <20200727224444.2987641-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=635 priorityscore=1501 adultscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Shared queues between user and kernel use their own private structures
for accessing a shared data area, but they need to use the same queue
functions.

Have the kernel use the same UAPI file - this can be made private at
a later date if required.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/misc/shqueue.h | 200 ++++++++++++++++++++++++++++++++++++
 1 file changed, 200 insertions(+)
 create mode 100644 include/uapi/misc/shqueue.h

diff --git a/include/uapi/misc/shqueue.h b/include/uapi/misc/shqueue.h
new file mode 100644
index 000000000000..ff945942734c
--- /dev/null
+++ b/include/uapi/misc/shqueue.h
@@ -0,0 +1,200 @@
+#ifndef _UAPI_MISC_SHQUEUE_H
+#define _UAPI_MISC_SHQUEUE_H
+
+/* Placed under UAPI in order to avoid two identical copies between
+ * user and kernel space.
+ */
+
+/* user and kernel private copy - identical in order to share sq* fcns */
+struct shared_queue {
+	unsigned *prod;
+	unsigned *cons;
+	unsigned char *data;
+	unsigned elt_sz;
+	unsigned mask;
+	unsigned cached_prod;
+	unsigned cached_cons;
+	unsigned entries;
+
+	unsigned map_sz;
+	void *map_ptr;
+};
+
+/*
+ * see documenation in tools/include/linux/ring_buffer.h
+ * using  explicit smp_/_ONCE is an optimization over smp_{store|load}
+ */
+
+static inline void __sq_load_acquire_cons(struct shared_queue *q)
+{
+	/* Refresh the local tail pointer */
+	q->cached_cons = READ_ONCE(*q->cons);
+	/* A, matches D */
+}
+
+static inline void __sq_store_release_cons(struct shared_queue *q)
+{
+	smp_mb(); /* D, matches A */
+	WRITE_ONCE(*q->cons, q->cached_cons);
+}
+
+static inline void __sq_load_acquire_prod(struct shared_queue *q)
+{
+	/* Refresh the local pointer */
+	q->cached_prod = READ_ONCE(*q->prod);
+	smp_rmb(); /* C, matches B */
+}
+
+static inline void __sq_store_release_prod(struct shared_queue *q)
+{
+	smp_wmb(); /* B, matches C */
+	WRITE_ONCE(*q->prod, q->cached_prod);
+}
+
+static inline void sq_cons_refresh(struct shared_queue *q)
+{
+	__sq_store_release_cons(q);
+	__sq_load_acquire_prod(q);
+}
+
+static inline bool sq_is_empty(struct shared_queue *q)
+{
+	return READ_ONCE(*q->prod) == READ_ONCE(*q->cons);
+}
+
+static inline bool sq_cons_empty(struct shared_queue *q)
+{
+	return q->cached_prod == q->cached_cons;
+}
+
+static inline unsigned __sq_cons_ready(struct shared_queue *q)
+{
+	return q->cached_prod - q->cached_cons;
+}
+
+static inline unsigned sq_cons_ready(struct shared_queue *q)
+{
+	if (sq_cons_empty(q))
+		__sq_load_acquire_prod(q);
+
+	return __sq_cons_ready(q);
+}
+
+static inline bool sq_cons_avail(struct shared_queue *q, unsigned count)
+{
+	if (count <= __sq_cons_ready(q))
+		return true;
+	__sq_load_acquire_prod(q);
+	return count <= __sq_cons_ready(q);
+}
+
+static inline void *sq_get_ptr(struct shared_queue *q, unsigned idx)
+{
+	return q->data + (idx & q->mask) * q->elt_sz;
+}
+
+static inline void sq_cons_complete(struct shared_queue *q)
+{
+	__sq_store_release_cons(q);
+}
+
+static inline void *sq_cons_peek(struct shared_queue *q)
+{
+	if (sq_cons_empty(q)) {
+		sq_cons_refresh(q);
+		if (sq_cons_empty(q))
+			return NULL;
+	}
+	return sq_get_ptr(q, q->cached_cons);
+}
+
+static inline unsigned
+sq_peek_batch(struct shared_queue *q, void **ptr, unsigned count)
+{
+	unsigned i, idx, ready;
+
+	ready = sq_cons_ready(q);
+	if (!ready)
+		return 0;
+
+	count = count > ready ? ready : count;
+
+	idx = q->cached_cons;
+	for (i = 0; i < count; i++)
+		ptr[i] = sq_get_ptr(q, idx++);
+
+	q->cached_cons += count;
+
+	return count;
+}
+
+static inline unsigned
+sq_cons_batch(struct shared_queue *q, void **ptr, unsigned count)
+{
+	unsigned i, idx, ready;
+
+	ready = sq_cons_ready(q);
+	if (!ready)
+		return 0;
+
+	count = count > ready ? ready : count;
+
+	idx = q->cached_cons;
+	for (i = 0; i < count; i++)
+		ptr[i] = sq_get_ptr(q, idx++);
+
+	q->cached_cons += count;
+	sq_cons_complete(q);
+
+	return count;
+}
+
+static inline void sq_cons_advance(struct shared_queue *q)
+{
+	q->cached_cons++;
+}
+
+static inline unsigned __sq_prod_space(struct shared_queue *q)
+{
+	return q->entries - (q->cached_prod - q->cached_cons);
+}
+
+static inline unsigned sq_prod_space(struct shared_queue *q)
+{
+	unsigned space;
+
+	space = __sq_prod_space(q);
+	if (!space) {
+		__sq_load_acquire_cons(q);
+		space = __sq_prod_space(q);
+	}
+	return space;
+}
+
+static inline bool sq_prod_avail(struct shared_queue *q, unsigned count)
+{
+	if (count <= __sq_prod_space(q))
+		return true;
+	__sq_load_acquire_cons(q);
+	return count <= __sq_prod_space(q);
+}
+
+static inline void *sq_prod_get_ptr(struct shared_queue *q)
+{
+	return sq_get_ptr(q, q->cached_prod++);
+}
+
+static inline void *sq_prod_reserve(struct shared_queue *q)
+{
+	if (!sq_prod_space(q))
+		return NULL;
+
+	return sq_prod_get_ptr(q);
+}
+
+static inline void sq_prod_submit(struct shared_queue *q)
+{
+	__sq_store_release_prod(q);
+}
+
+#endif /* _UAPI_MISC_SHQUEUE_H */
-- 
2.24.1

