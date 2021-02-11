Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FA03194E8
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhBKVMl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Feb 2021 16:12:41 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18857 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhBKVL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:11:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60259d750000>; Thu, 11 Feb 2021 13:11:17 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 21:11:08 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 21:11:03 +0000
From:   Boris Pismenny <borisp@mellanox.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v4 net-next  03/21] iov_iter: DDP copy to iter/pages
Date:   Thu, 11 Feb 2021 23:10:26 +0200
Message-ID: <20210211211044.32701-4-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210211211044.32701-1-borisp@mellanox.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using direct data placement (DDP) the NIC writes some of the payload
directly to the destination buffer, and constructs SKBs such that they
point to this data. To skip copies when SKB data already resides in the
destination we use the newly introduced routines in this commit, which
check if (src == dst), and skip the copy when that's true.

As the current user for these routines is in the block layer (nvme-tcp),
then we only apply the change for bio_vec. Other routines use the normal
methods for copying.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/uio.h | 17 +++++++++++++++
 lib/iov_iter.c      | 53 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..8438e6d5ac25 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -123,6 +123,9 @@ size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
 
 size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
+#ifdef CONFIG_TCP_DDP
+size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
+#endif
 size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
 bool _copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i);
 size_t _copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i);
@@ -137,6 +140,16 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 		return _copy_to_iter(addr, bytes, i);
 }
 
+#ifdef CONFIG_TCP_DDP
+static __always_inline __must_check
+size_t ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
+{
+	if (unlikely(!check_copy_size(addr, bytes, true)))
+		return 0;
+	return _ddp_copy_to_iter(addr, bytes, i);
+}
+#endif
+
 static __always_inline __must_check
 size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
@@ -265,6 +278,10 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct io
 bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i);
+#ifdef CONFIG_TCP_DDP
+size_t ddp_hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
+		struct iov_iter *i);
+#endif
 
 struct iovec *iovec_from_user(const struct iovec __user *uvector,
 		unsigned long nr_segs, unsigned long fast_segs,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index a21e6a5792c5..c5990275e583 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -473,6 +473,18 @@ static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t
 	kunmap_atomic(from);
 }
 
+#ifdef CONFIG_TCP_DDP
+static void ddp_memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
+{
+	char *to = kmap_atomic(page);
+
+	if (to + offset != from)
+		memcpy(to + offset, from, len);
+
+	kunmap_atomic(to);
+}
+#endif
+
 static void memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
 {
 	char *to = kmap_atomic(page);
@@ -625,6 +637,26 @@ static size_t csum_and_copy_to_pipe_iter(const void *addr, size_t bytes,
 	return bytes;
 }
 
+#ifdef CONFIG_TCP_DDP
+size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
+{
+	const char *from = addr;
+	if (unlikely(iov_iter_is_pipe(i)))
+		return copy_pipe_to_iter(addr, bytes, i);
+	if (iter_is_iovec(i))
+		might_fault();
+	iterate_and_advance(i, bytes, v,
+		copyout(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
+		ddp_memcpy_to_page(v.bv_page, v.bv_offset,
+				   (from += v.bv_len) - v.bv_len, v.bv_len),
+		memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len)
+		)
+
+	return bytes;
+}
+EXPORT_SYMBOL(_ddp_copy_to_iter);
+#endif
+
 size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 {
 	const char *from = addr;
@@ -1566,6 +1598,27 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
 }
 EXPORT_SYMBOL(csum_and_copy_to_iter);
 
+#ifdef CONFIG_TCP_DDP
+size_t ddp_hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
+		struct iov_iter *i)
+{
+#ifdef CONFIG_CRYPTO_HASH
+	struct ahash_request *hash = hashp;
+	struct scatterlist sg;
+	size_t copied;
+
+	copied = ddp_copy_to_iter(addr, bytes, i);
+	sg_init_one(&sg, addr, copied);
+	ahash_request_set_crypt(hash, &sg, NULL, copied);
+	crypto_ahash_update(hash);
+	return copied;
+#else
+	return 0;
+#endif
+}
+EXPORT_SYMBOL(ddp_hash_and_copy_to_iter);
+#endif
+
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i)
 {
-- 
2.24.1

