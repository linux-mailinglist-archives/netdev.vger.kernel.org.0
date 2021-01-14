Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201D22F63EC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbhANPML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:12:11 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38717 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727617AbhANPLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:11:39 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 14 Jan 2021 17:10:44 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EFAh01000835;
        Thu, 14 Jan 2021 17:10:43 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, dsahern@gmail.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v2 net-next 01/21] iov_iter: Introduce new procedures for copy to iter/pages
Date:   Thu, 14 Jan 2021 17:10:13 +0200
Message-Id: <20210114151033.13020-2-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210114151033.13020-1-borisp@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using direct data placement the NIC writes some of the payload
directly to the destination buffer, and constructs the SKB such that it
points to this data. As a result, the skb_copy datagram_iter call will
attempt to copy data when it is not necessary.

Introduce new procedures for copy to iter/pages in case that the
source of the copy operation might be identical to the destination,
in such cases the copy is skipped only for bio_vec, later commits
uses those functions to introduce new skb copy(+hash) functions.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/uio.h | 12 ++++++++++++
 lib/iov_iter.c      | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..3c42125a7f24 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -123,6 +123,7 @@ size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
 
 size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
+size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
 size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
 bool _copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i);
 size_t _copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i);
@@ -137,6 +138,15 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 		return _copy_to_iter(addr, bytes, i);
 }
 
+static __always_inline __must_check
+size_t ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
+{
+	if (unlikely(!check_copy_size(addr, bytes, true)))
+		return 0;
+	else
+		return _ddp_copy_to_iter(addr, bytes, i);
+}
+
 static __always_inline __must_check
 size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
@@ -265,6 +275,8 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct io
 bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i);
+size_t ddp_hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
+		struct iov_iter *i);
 
 struct iovec *iovec_from_user(const struct iovec __user *uvector,
 		unsigned long nr_segs, unsigned long fast_segs,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1635111c5bd2..92c07cf4a3c9 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -473,6 +473,16 @@ static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t
 	kunmap_atomic(from);
 }
 
+static void ddp_memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
+{
+	char *to = kmap_atomic(page);
+
+	if (to + offset != from)
+		memcpy(to + offset, from, len);
+
+	kunmap_atomic(to);
+}
+
 static void memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
 {
 	char *to = kmap_atomic(page);
@@ -625,6 +635,22 @@ static size_t csum_and_copy_to_pipe_iter(const void *addr, size_t bytes,
 	return bytes;
 }
 
+size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
+{
+	const char *from = addr;
+	if (unlikely(iov_iter_is_pipe(i)))
+		return copy_pipe_to_iter(addr, bytes, i);
+	if (iter_is_iovec(i))
+		might_fault();
+	iterate_and_advance(i, bytes, v, NULL,
+		ddp_memcpy_to_page(v.bv_page, v.bv_offset,
+				   (from += v.bv_len) - v.bv_len, v.bv_len),
+		NULL)
+
+	return bytes;
+}
+EXPORT_SYMBOL(_ddp_copy_to_iter);
+
 size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 {
 	const char *from = addr;
@@ -1566,6 +1592,25 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
 }
 EXPORT_SYMBOL(csum_and_copy_to_iter);
 
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
+
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i)
 {
-- 
2.24.1

