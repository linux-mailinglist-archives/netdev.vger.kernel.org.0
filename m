Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5DE123766
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 21:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfLQUih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 15:38:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:16399 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbfLQUib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 15:38:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 12:38:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="298171948"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.1.107])
  by orsmga001.jf.intel.com with ESMTP; 17 Dec 2019 12:38:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v3 11/11] skb: add helpers to allocate ext independently from sk_buff
Date:   Tue, 17 Dec 2019 12:38:07 -0800
Message-Id: <20191217203807.12579-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
References: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently we can allocate the extension only after the skb,
this change allows the user to do the opposite, will simplify
allocation failure handling from MPTCP.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/skbuff.h |  3 +++
 net/core/skbuff.c      | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1a261c3ee074..af9b6cf79a65 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4115,6 +4115,9 @@ struct skb_ext {
 	char data[0] __aligned(8);
 };
 
+struct skb_ext *__skb_ext_alloc(void);
+void *__skb_ext_set(struct sk_buff *skb, enum skb_ext_id id,
+		    struct skb_ext *ext);
 void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
 void __skb_ext_del(struct sk_buff *skb, enum skb_ext_id id);
 void __skb_ext_put(struct skb_ext *ext);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fa67036dd928..504e9bd5ebce 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5983,7 +5983,14 @@ static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
 	return (void *)ext + (ext->offset[id] * SKB_EXT_ALIGN_VALUE);
 }
 
-static struct skb_ext *skb_ext_alloc(void)
+/**
+ * __skb_ext_alloc - allocate a new skb extensions storage
+ *
+ * Returns the newly allocated pointer. The pointer can later attached to a
+ * skb via __skb_ext_set().
+ * Note: caller must handle the skb_ext as an opaque data.
+ */
+struct skb_ext *__skb_ext_alloc(void)
 {
 	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, GFP_ATOMIC);
 
@@ -6023,6 +6030,30 @@ static struct skb_ext *skb_ext_maybe_cow(struct skb_ext *old,
 	return new;
 }
 
+/**
+ * __skb_ext_set - attach the specified extension storage to this skb
+ * @skb: buffer
+ * @id: extension id
+ * @ext: extension storage previously allocated via __skb_ext_alloc()
+ *
+ * Existing extensions, if any, are cleared.
+ *
+ * Returns the pointer to the extension.
+ */
+void *__skb_ext_set(struct sk_buff *skb, enum skb_ext_id id,
+		    struct skb_ext *ext)
+{
+	unsigned int newlen, newoff = SKB_EXT_CHUNKSIZEOF(*ext);
+
+	skb_ext_put(skb);
+	newlen = newoff + skb_ext_type_len[id];
+	ext->chunks = newlen;
+	ext->offset[id] = newoff;
+	skb->extensions = ext;
+	skb->active_extensions = 1 << id;
+	return skb_ext_get_ptr(ext, id);
+}
+
 /**
  * skb_ext_add - allocate space for given extension, COW if needed
  * @skb: buffer
@@ -6056,7 +6087,7 @@ void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
 	} else {
 		newoff = SKB_EXT_CHUNKSIZEOF(*new);
 
-		new = skb_ext_alloc();
+		new = __skb_ext_alloc();
 		if (!new)
 			return NULL;
 	}
-- 
2.24.1

