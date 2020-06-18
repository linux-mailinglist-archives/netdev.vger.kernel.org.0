Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC1B1FF8D1
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731858AbgFRQKP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33098 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731939AbgFRQKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:10:02 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9lES004749
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:01 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q653mse9-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:01 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 672EA3D44E14E; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 16/21] lib: have __zerocopy_sg_from_iter get netgpu pages for a sk
Date:   Thu, 18 Jun 2020 09:09:36 -0700
Message-ID: <20200618160941.879717-17-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 priorityscore=1501 impostorscore=0 cotscore=-2147483648 suspectscore=1
 spamscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=632 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a sock is marked as sending zc data, have the iterator
retrieve the correct zc pages from the netgpu module.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/uio.h |  4 ++++
 lib/iov_iter.c      | 45 +++++++++++++++++++++++++++++++++++++++++++++
 net/core/datagram.c |  6 +++++-
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 9576fd8158d7..d4c15205a248 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -227,6 +227,10 @@ ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
+struct sock;
+ssize_t iov_iter_sk_get_pages(struct iov_iter *i, struct sock *sk,
+                   size_t maxsize, struct page **pages, unsigned maxpages,
+                   size_t *pgoff);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags);
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index bf538c2bec77..a50fa3999de3 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -10,6 +10,9 @@
 #include <linux/scatterlist.h>
 #include <linux/instrumented.h>
 
+#include <net/netgpu.h>
+#include <net/sock.h>
+
 #define PIPE_PARANOIA /* for now */
 
 #define iterate_iovec(i, n, __v, __p, skip, STEP) {	\
@@ -1349,6 +1352,48 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 }
 EXPORT_SYMBOL(iov_iter_get_pages);
 
+ssize_t iov_iter_sk_get_pages(struct iov_iter *i, struct sock *sk,
+		   size_t maxsize, struct page **pages, unsigned maxpages,
+		   size_t *pgoff)
+{
+	const struct iovec *iov;
+	unsigned long addr;
+	struct iovec v;
+	size_t len;
+	unsigned n;
+	int ret;
+
+	if (!sk->sk_user_data)
+		return iov_iter_get_pages(i, pages, maxsize, maxpages, pgoff);
+
+	if (maxsize > i->count)
+		maxsize = i->count;
+
+	if (!iter_is_iovec(i))
+		return -EFAULT;
+
+	if (iov_iter_rw(i) != WRITE)
+		return -EFAULT;
+
+	iterate_iovec(i, maxsize, v, iov, i->iov_offset, ({
+		addr = (unsigned long)v.iov_base;
+		*pgoff = addr & (PAGE_SIZE - 1);
+		len = v.iov_len + *pgoff;
+
+		if (len > maxpages * PAGE_SIZE)
+			len = maxpages * PAGE_SIZE;
+
+		n = DIV_ROUND_UP(len, PAGE_SIZE);
+
+		ret = __netgpu_get_pages(sk, pages, addr, n);
+		if (ret > 0)
+			ret = (ret == n ? len : ret * PAGE_SIZE) - *pgoff;
+		return ret;
+	0;}));
+	return 0;
+}
+EXPORT_SYMBOL(iov_iter_sk_get_pages);
+
 static struct page **get_pages_array(size_t n)
 {
 	return kvmalloc_array(n, sizeof(struct page *), GFP_KERNEL);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 639745d4f3b9..7dd8814c222a 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -530,6 +530,10 @@ int skb_copy_datagram_iter(const struct sk_buff *skb, int offset,
 			   struct iov_iter *to, int len)
 {
 	trace_skb_copy_datagram_iovec(skb, len);
+	if (skb->zc_netgpu) {
+		pr_err("skb netgpu datagram on !netgpu sk\n");
+		return -EFAULT;
+	}
 	return __skb_datagram_iter(skb, offset, to, len, false,
 			simple_copy_to_iter, NULL);
 }
@@ -631,7 +635,7 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 		if (frag == MAX_SKB_FRAGS)
 			return -EMSGSIZE;
 
-		copied = iov_iter_get_pages(from, pages, length,
+		copied = iov_iter_sk_get_pages(from, sk, length, pages,
 					    MAX_SKB_FRAGS - frag, &start);
 		if (copied < 0)
 			return -EFAULT;
-- 
2.24.1

