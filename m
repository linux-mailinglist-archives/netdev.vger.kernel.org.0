Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5522FC67
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgG0WpK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:45:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64294 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727846AbgG0WpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:45:07 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMePom022667
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:45:05 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32gj8kh8pr-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:45:05 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id DFFA33FAB6F71; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 12/21] lib: have __zerocopy_sg_from_iter get netgpu pages for a sk
Date:   Mon, 27 Jul 2020 15:44:35 -0700
Message-ID: <20200727224444.2987641-13-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=812 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=1
 bulkscore=0 priorityscore=1501 clxscore=1034 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

If a sock is marked as sending zc data, have the iterator
retrieve the correct zc pages from the netgpu module.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/uio.h |  4 ++++
 lib/iov_iter.c      | 53 +++++++++++++++++++++++++++++++++++++++++++++
 net/core/datagram.c |  9 ++++++--
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 9576fd8158d7..9d9a68e224b0 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -227,6 +227,10 @@ ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
+struct sock;
+ssize_t iov_iter_sk_get_pages(struct iov_iter *i, struct page **pages,
+			size_t maxsize, unsigned maxpages, size_t *pgoff,
+			struct sock *sk);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags);
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index bf538c2bec77..69457df64339 100644
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
@@ -1349,6 +1352,56 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 }
 EXPORT_SYMBOL(iov_iter_get_pages);
 
+#if IS_ENABLED(CONFIG_NETGPU)
+ssize_t iov_iter_sk_get_pages(struct iov_iter *i, struct page **pages,
+		size_t maxsize, unsigned maxpages, size_t *pgoff,
+		struct sock *sk)
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
+		ret = netgpu_get_pages(sk, pages, addr, n);
+		if (ret > 0)
+			ret = (ret == n ? len : ret * PAGE_SIZE) - *pgoff;
+		return ret;
+	0;}));
+	return 0;
+}
+#else
+ssize_t iov_iter_sk_get_pages(struct iov_iter *i, struct page **pages,
+		size_t maxsize, unsigned maxpages, size_t *pgoff,
+		struct sock *sk)
+{
+	return iov_iter_get_pages(i, pages, maxsize, maxpages, pgoff);
+}
+#endif
+
 static struct page **get_pages_array(size_t n)
 {
 	return kvmalloc_array(n, sizeof(struct page *), GFP_KERNEL);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 639745d4f3b9..d91f14dc56be 100644
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
@@ -631,8 +635,9 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 		if (frag == MAX_SKB_FRAGS)
 			return -EMSGSIZE;
 
-		copied = iov_iter_get_pages(from, pages, length,
-					    MAX_SKB_FRAGS - frag, &start);
+		copied = iov_iter_sk_get_pages(from, pages, length,
+					       MAX_SKB_FRAGS - frag, &start,
+					       sk);
 		if (copied < 0)
 			return -EFAULT;
 
-- 
2.24.1

