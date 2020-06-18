Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772DA1FF8D0
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbgFRQKN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52056 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731946AbgFRQKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:10:05 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9xhL011546
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:03 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q656mqsb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:03 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 4612B3D44E13E; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 08/21] misc: add shqueue.h for prototyping
Date:   Thu, 18 Jun 2020 09:09:28 -0700
Message-ID: <20200618160941.879717-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 bulkscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=896 clxscore=1034 cotscore=-2147483648 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 impostorscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shared queues between user and kernel use their own private structures
for accessing a shared data area, but they need to use the same queue
functions.

Rather than doing the 'right' thing and duplicating the file for
each domain, temporary cheat for prototyping and use a single shared
file.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/misc/shqueue.h | 205 ++++++++++++++++++++++++++++++++++++
 1 file changed, 205 insertions(+)
 create mode 100644 include/uapi/misc/shqueue.h

diff --git a/include/uapi/misc/shqueue.h b/include/uapi/misc/shqueue.h
new file mode 100644
index 000000000000..258b9db35dbd
--- /dev/null
+++ b/include/uapi/misc/shqueue.h
@@ -0,0 +1,205 @@
+#pragma once
+
+/* XXX
+ * This is not a user api, but placed here for prototyping, in order to
+ * avoid two nigh identical copies for user and kernel space.
+ */
+
+/* kernel only */
+struct shared_queue_map {
+	unsigned prod ____cacheline_aligned_in_smp;
+	unsigned cons ____cacheline_aligned_in_smp;
+	char data[] ____cacheline_aligned_in_smp;
+};
+
+/* user and kernel private copy - identical in order to share sq* fcns */
+struct shared_queue {
+	unsigned *prod;
+	unsigned *cons;
+	char *data;
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
+static inline bool sq_empty(struct shared_queue *q)
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
+	if (q->cached_prod == q->cached_cons)
+		__sq_load_acquire_prod(q);
+
+	return q->cached_prod - q->cached_cons;
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
-- 
2.24.1

