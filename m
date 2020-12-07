Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072702D1BA1
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgLGVHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:07:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45685 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726387AbgLGVHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:07:49 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 7 Dec 2020 23:06:52 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B7L6qI9029788;
        Mon, 7 Dec 2020 23:06:52 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v1 net-next 01/15] iov_iter: Skip copy in memcpy_to_page if src==dst
Date:   Mon,  7 Dec 2020 23:06:35 +0200
Message-Id: <20201207210649.19194-2-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201207210649.19194-1-borisp@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using direct data placement the NIC writes some of the payload
directly to the destination buffer, and constructs the SKB such that it
points to this data. As a result, the skb_copy datagram_iter call will
attempt to copy data when it is not necessary.

This patch adds a check to avoid this copy, and a static_key to enabled
it when TCP direct data placement is possible.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/uio.h |  2 ++
 lib/iov_iter.c      | 11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..05573d848ff5 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -282,4 +282,6 @@ int iov_iter_for_each_range(struct iov_iter *i, size_t bytes,
 			    int (*f)(struct kvec *vec, void *context),
 			    void *context);
 
+extern struct static_key_false skip_copy_enabled;
+
 #endif
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1635111c5bd2..206edb051135 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -15,6 +15,9 @@
 
 #define PIPE_PARANOIA /* for now */
 
+DEFINE_STATIC_KEY_FALSE(skip_copy_enabled);
+EXPORT_SYMBOL_GPL(skip_copy_enabled);
+
 #define iterate_iovec(i, n, __v, __p, skip, STEP) {	\
 	size_t left;					\
 	size_t wanted = n;				\
@@ -476,7 +479,13 @@ static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t
 static void memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
 {
 	char *to = kmap_atomic(page);
-	memcpy(to + offset, from, len);
+
+	if (static_branch_unlikely(&skip_copy_enabled)) {
+		if (to + offset != from)
+			memcpy(to + offset, from, len);
+	} else {
+		memcpy(to + offset, from, len);
+	}
 	kunmap_atomic(to);
 }
 
-- 
2.24.1

