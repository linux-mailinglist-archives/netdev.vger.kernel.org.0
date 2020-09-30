Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F13E27EEE9
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgI3QUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:36 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50440 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731302AbgI3QUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:34 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:27 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2C032498;
        Wed, 30 Sep 2020 19:20:27 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH net-next RFC v1 01/10] iov_iter: Skip copy in memcpy_to_page if src==dst
Date:   Wed, 30 Sep 2020 19:20:01 +0300
Message-Id: <20200930162010.21610-2-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930162010.21610-1-borisp@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
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
index 3835a8a8e9ea..036df4073737 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -284,4 +284,6 @@ int iov_iter_for_each_range(struct iov_iter *i, size_t bytes,
 			    int (*f)(struct kvec *vec, void *context),
 			    void *context);
 
+extern struct static_key_false skip_copy_enabled;
+
 #endif
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 5e40786c8f12..27856c3db28b 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -13,6 +13,9 @@
 
 #define PIPE_PARANOIA /* for now */
 
+DEFINE_STATIC_KEY_FALSE(skip_copy_enabled);
+EXPORT_SYMBOL_GPL(skip_copy_enabled);
+
 #define iterate_iovec(i, n, __v, __p, skip, STEP) {	\
 	size_t left;					\
 	size_t wanted = n;				\
@@ -470,7 +473,13 @@ static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t
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

