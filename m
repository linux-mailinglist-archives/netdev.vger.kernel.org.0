Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D4789A7A
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfHLJw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:52:29 -0400
Received: from smtprelay08.ispgateway.de ([134.119.228.111]:33948 "EHLO
        smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHLJw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:52:28 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2019 05:52:27 EDT
Received: from [79.249.13.39] (helo=C02YV1XMLVDM.Speedport_W_724V_01011603_06_003)
        by smtprelay08.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-SHA256:128)
        (Exim 4.92)
        (envelope-from <marc@koderer.com>)
        id 1hx6qF-0004O4-Qd; Mon, 12 Aug 2019 11:42:15 +0200
From:   Marc Koderer <marc@koderer.com>
To:     idryomov@gmail.com, jlayton@kernel.org, sage@redhat.com,
        davem@davemloft.net
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Koderer <marc@koderer.com>
Subject: [PATCH] net/ceph replace ceph_kvmalloc with kvmalloc
Date:   Mon, 12 Aug 2019 11:42:42 +0200
Message-Id: <20190812094242.44735-1-marc@koderer.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Df-Sender: bWFyY0Brb2RlcmVyLmNvbQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is nearly no difference between both implemenations.
ceph_kvmalloc existed before kvmalloc which makes me think it's
a leftover.

Signed-off-by: Marc Koderer <marc@koderer.com>
---
 net/ceph/buffer.c      |  3 +--
 net/ceph/ceph_common.c | 11 -----------
 net/ceph/crypto.c      |  2 +-
 net/ceph/messenger.c   |  2 +-
 4 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/net/ceph/buffer.c b/net/ceph/buffer.c
index 5622763ad402..6ca273d2246a 100644
--- a/net/ceph/buffer.c
+++ b/net/ceph/buffer.c
@@ -7,7 +7,6 @@
 
 #include <linux/ceph/buffer.h>
 #include <linux/ceph/decode.h>
-#include <linux/ceph/libceph.h> /* for ceph_kvmalloc */
 
 struct ceph_buffer *ceph_buffer_new(size_t len, gfp_t gfp)
 {
@@ -17,7 +16,7 @@ struct ceph_buffer *ceph_buffer_new(size_t len, gfp_t gfp)
 	if (!b)
 		return NULL;
 
-	b->vec.iov_base = ceph_kvmalloc(len, gfp);
+	b->vec.iov_base = kvmalloc(len, gfp);
 	if (!b->vec.iov_base) {
 		kfree(b);
 		return NULL;
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4eeea4d5c3ef..6c1769a815af 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -185,17 +185,6 @@ int ceph_compare_options(struct ceph_options *new_opt,
 }
 EXPORT_SYMBOL(ceph_compare_options);
 
-void *ceph_kvmalloc(size_t size, gfp_t flags)
-{
-	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *ptr = kmalloc(size, flags | __GFP_NOWARN);
-		if (ptr)
-			return ptr;
-	}
-
-	return __vmalloc(size, flags, PAGE_KERNEL);
-}
-
 
 static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 {
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 5d6724cee38f..a9deead1e4ff 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -144,7 +144,7 @@ void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
 static const u8 *aes_iv = (u8 *)CEPH_AES_IV;
 
 /*
- * Should be used for buffers allocated with ceph_kvmalloc().
+ * Should be used for buffers allocated with kvmalloc().
  * Currently these are encrypt out-buffer (ceph_buffer) and decrypt
  * in-buffer (msg front).
  *
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 962f521c863e..f1f2fcc6f780 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3334,7 +3334,7 @@ struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_items,
 
 	/* front */
 	if (front_len) {
-		m->front.iov_base = ceph_kvmalloc(front_len, flags);
+		m->front.iov_base = kvmalloc(front_len, flags);
 		if (m->front.iov_base == NULL) {
 			dout("ceph_msg_new can't allocate %d bytes\n",
 			     front_len);
-- 
2.22.0

