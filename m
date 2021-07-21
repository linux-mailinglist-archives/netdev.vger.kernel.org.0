Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50483D1465
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhGUQEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:04:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233471AbhGUQEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A774f2Th7dL8uyA+Ed6Ue0eihbrm9ddp25ruzofQLbA=;
        b=OdGmqLWSexS9jKNSe+g5MQcIsxi/1VMra+Q12rzbk5GMs0Xed3695/pZuN+wee9WsVigC0
        M9WKUJhyTcJmFlb+VP58349LW16H+iNcTQS0jOVRy1b7B4LaNxGjUYXTY/e413DXSC4OhP
        0cQRNsK//51DddWLfSHsrwqJaSMENFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-of5nlfWPMMCHLUc7DS-L-w-1; Wed, 21 Jul 2021 12:45:16 -0400
X-MC-Unique: of5nlfWPMMCHLUc7DS-L-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7879804140;
        Wed, 21 Jul 2021 16:45:14 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A677797C0;
        Wed, 21 Jul 2021 16:45:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 3/9] sk_buff: move the active_extensions into the state bitfield
Date:   Wed, 21 Jul 2021 18:44:35 +0200
Message-Id: <75a4e2fe7a521247984460b0687bc111239b71ef.1626882513.git.pabeni@redhat.com>
In-Reply-To: <cover.1626882513.git.pabeni@redhat.com>
References: <cover.1626882513.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change intended

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
 - add CHECK_SKB_FIELD(_state) in __copy_skb_header
2 problems:
- this restrict the storage for new skb extensions to 0 or at most 1
- can't provide a build time check to ensure SKB_EXT do not exceed
  active_extensions

I'm wondering about moving 2 random bits from the header section to
the old active_extensions location (and explicitly copy them on clone)
so that we can keep using 1 byte for extension and 1 byte for other
state things
---
 include/linux/skbuff.h | 11 +++++------
 net/core/skbuff.c      |  1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1b811585f6fc..03be9a774c58 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -670,7 +670,6 @@ typedef unsigned char *sk_buff_data_t;
  *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
  *	@pp_recycle: mark the packet for recycling instead of freeing (implies
  *		page_pool support on driver)
- *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
  *	@l4_hash: indicate hash is a canonical 4-tuple hash over transport
@@ -692,6 +691,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@_state: bitmap reporting the presence of some skb state info
  *	@has_nfct: @_state bit for nfct info
  *	@has_dst: @_state bit for dst pointer
+ *	@active_extensions: @_state bits for active extensions (skb_ext_id types)
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
@@ -796,9 +796,6 @@ struct sk_buff {
 				head_frag:1,
 				pfmemalloc:1,
 				pp_recycle:1; /* page_pool recycle indicator */
-#ifdef CONFIG_SKB_EXTENSIONS
-	__u8			active_extensions;
-#endif
 
 	/* fields enclosed in headers_start/headers_end are copied
 	 * using a single memcpy() in __copy_skb_header()
@@ -875,6 +872,9 @@ struct sk_buff {
 		struct {
 			__u8	has_nfct:1;
 			__u8	has_dst:1;
+#ifdef CONFIG_SKB_EXTENSIONS
+			__u8	active_extensions:5;
+#endif
 		};
 	};
 
@@ -4283,8 +4283,6 @@ static inline void skb_ext_put(struct sk_buff *skb)
 static inline void __skb_ext_copy(struct sk_buff *dst,
 				  const struct sk_buff *src)
 {
-	dst->active_extensions = src->active_extensions;
-
 	if (src->active_extensions) {
 		struct skb_ext *ext = src->extensions;
 
@@ -4296,6 +4294,7 @@ static inline void __skb_ext_copy(struct sk_buff *dst,
 static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *src)
 {
 	skb_ext_put(dst);
+	dst->active_extensions = src->active_extensions;
 	__skb_ext_copy(dst, src);
 }
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e94805bd8656..2ffe18595635 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1001,6 +1001,7 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	memcpy(&new->headers_start, &old->headers_start,
 	       offsetof(struct sk_buff, headers_end) -
 	       offsetof(struct sk_buff, headers_start));
+	CHECK_SKB_FIELD(_state);
 	CHECK_SKB_FIELD(protocol);
 	CHECK_SKB_FIELD(csum);
 	CHECK_SKB_FIELD(hash);
-- 
2.26.3

