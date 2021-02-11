Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D913194EF
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhBKVNN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Feb 2021 16:13:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14683 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBKVMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:12:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60259d7a0001>; Thu, 11 Feb 2021 13:11:22 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 21:11:13 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 21:11:08 +0000
From:   Boris Pismenny <borisp@mellanox.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v4 net-next  04/21] net: skb copy(+hash) iterators for DDP offloads
Date:   Thu, 11 Feb 2021 23:10:27 +0200
Message-ID: <20210211211044.32701-5-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210211211044.32701-1-borisp@mellanox.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces new functions to support direct data placement
(DDP) NIC offloads that avoid copying data from SKBs.

Later patches will use this for nvme-tcp DDP offload.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/skbuff.h |  9 ++++++++
 net/core/datagram.c    | 48 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0d1be25574cc..0470eb3c9976 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3594,6 +3594,10 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
 			   struct iov_iter *to, int size);
+#ifdef CONFIG_TCP_DDP
+int skb_ddp_copy_datagram_iter(const struct sk_buff *from, int offset,
+			       struct iov_iter *to, int size);
+#endif
 static inline int skb_copy_datagram_msg(const struct sk_buff *from, int offset,
 					struct msghdr *msg, int size)
 {
@@ -3604,6 +3608,11 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb, int hlen,
 int skb_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
 			   struct iov_iter *to, int len,
 			   struct ahash_request *hash);
+#ifdef CONFIG_TCP_DDP
+int skb_ddp_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
+					struct iov_iter *to, int len,
+					struct ahash_request *hash);
+#endif
 int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 				 struct iov_iter *from, int len);
 int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *frm);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 81809fa735a7..f386d4d82b1b 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -495,6 +495,27 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 	return 0;
 }
 
+#ifdef CONFIG_TCP_DDP
+/**
+ *	skb_ddp_copy_and_hash_datagram_iter - Copies datagrams from skb frags to
+ *	an iterator and update a hash. If the iterator and skb frag point to the
+ *	same page and offset, then the copy is skipped.
+ *	@skb: buffer to copy
+ *	@offset: offset in the buffer to start copying from
+ *	@to: iovec iterator to copy to
+ *	@len: amount of data to copy from buffer to iovec
+ *      @hash: hash request to update
+ */
+int skb_ddp_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
+					struct iov_iter *to, int len,
+					struct ahash_request *hash)
+{
+	return __skb_datagram_iter(skb, offset, to, len, true,
+			ddp_hash_and_copy_to_iter, hash);
+}
+EXPORT_SYMBOL(skb_ddp_copy_and_hash_datagram_iter);
+#endif
+
 /**
  *	skb_copy_and_hash_datagram_iter - Copy datagram to an iovec iterator
  *          and update a hash.
@@ -513,6 +534,33 @@ int skb_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_and_hash_datagram_iter);
 
+#ifdef CONFIG_TCP_DDP
+static size_t simple_ddp_copy_to_iter(const void *addr, size_t bytes,
+				      void *data __always_unused,
+				      struct iov_iter *i)
+{
+	return ddp_copy_to_iter(addr, bytes, i);
+}
+
+/**
+ *	skb_ddp_copy_datagram_iter - Copies datagrams from skb frags to an
+ *	iterator. If the iterator and skb frag point to the same page and
+ *	offset, then the copy is skipped.
+ *	@skb: buffer to copy
+ *	@offset: offset in the buffer to start copying from
+ *	@to: iovec iterator to copy to
+ *	@len: amount of data to copy from buffer to iovec
+ */
+int skb_ddp_copy_datagram_iter(const struct sk_buff *skb, int offset,
+			       struct iov_iter *to, int len)
+{
+	trace_skb_copy_datagram_iovec(skb, len);
+	return __skb_datagram_iter(skb, offset, to, len, false,
+			simple_ddp_copy_to_iter, NULL);
+}
+EXPORT_SYMBOL(skb_ddp_copy_datagram_iter);
+#endif
+
 static size_t simple_copy_to_iter(const void *addr, size_t bytes,
 		void *data __always_unused, struct iov_iter *i)
 {
-- 
2.24.1

