Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B462F63DC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbhANPLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:11:38 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38722 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729245AbhANPLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:11:37 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 14 Jan 2021 17:10:44 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EFAh04000835;
        Thu, 14 Jan 2021 17:10:44 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, dsahern@gmail.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v2 net-next 04/21] net: SKB copy(+hash) iterators for DDP offloads
Date:   Thu, 14 Jan 2021 17:10:16 +0200
Message-Id: <20210114151033.13020-5-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210114151033.13020-1-borisp@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-ishay <benishay@nvidia.com>

This commit introduces new functions to support direct data placement
operation, when using direct data placement the copy of the data from
the SKB to the destination buffer might be unnecessary and thus the
copy should be skipped, those functions take care of it in cases that
the destination buffer is represented by bio_vec.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/skbuff.h |  5 +++++
 net/core/datagram.c    | 44 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a841bc974452..96847aabba5b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3536,6 +3536,8 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
 			   struct iov_iter *to, int size);
+int skb_ddp_copy_datagram_iter(const struct sk_buff *from, int offset,
+			       struct iov_iter *to, int size);
 static inline int skb_copy_datagram_msg(const struct sk_buff *from, int offset,
 					struct msghdr *msg, int size)
 {
@@ -3546,6 +3548,9 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb, int hlen,
 int skb_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
 			   struct iov_iter *to, int len,
 			   struct ahash_request *hash);
+int skb_ddp_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
+					struct iov_iter *to, int len,
+					struct ahash_request *hash);
 int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 				 struct iov_iter *from, int len);
 int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *frm);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 81809fa735a7..bbc476cadc71 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -495,6 +495,25 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 	return 0;
 }
 
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
+
 /**
  *	skb_copy_and_hash_datagram_iter - Copy datagram to an iovec iterator
  *          and update a hash.
@@ -513,6 +532,31 @@ int skb_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_and_hash_datagram_iter);
 
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
+
 static size_t simple_copy_to_iter(const void *addr, size_t bytes,
 		void *data __always_unused, struct iov_iter *i)
 {
-- 
2.24.1

