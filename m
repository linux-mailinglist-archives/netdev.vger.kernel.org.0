Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EEE3D1462
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhGUQEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:04:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232964AbhGUQEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=elp1aKhIlv/PtbJrnD2zR/phQBsO+w1TcixXTfCb2D0=;
        b=BujYzomQ/3NlleoIMvjeFF2+uOuTB1TFVScthKLoRdLlK/3vQR0fJsHhlBt3kOCRDZp/oU
        aTpBcayG57kODt7reb/NfcZn9Nl7wvSthFwjwHtChtgDoeVkrhe/oRRcp3FgzPM41ZCOwz
        KxmZGtdsfYgUS9o8ZppEgogVc4zLFjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-Zk_5eCVFO5K79-c1oM8HgQ-1; Wed, 21 Jul 2021 12:45:12 -0400
X-MC-Unique: Zk_5eCVFO5K79-c1oM8HgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A40151008541;
        Wed, 21 Jul 2021 16:45:10 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E628F797C0;
        Wed, 21 Jul 2021 16:45:08 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 1/9] sk_buff: track nfct status in newly added skb->_state
Date:   Wed, 21 Jul 2021 18:44:33 +0200
Message-Id: <f3708c7208ac32cf35a69ae90e3203bda93be1ce.1626882513.git.pabeni@redhat.com>
In-Reply-To: <cover.1626882513.git.pabeni@redhat.com>
References: <cover.1626882513.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

so that we can skip initizialzing such field at skb
allocation and move such field after 'tail'.

_state uses one byte hole in the header section.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
 - : NULL
 - has_nfct = !!nfct -> ovs uses skb_set_nfct(NULL, 0) to clear skb->_nfct

should skb_nfct()/skb_get_nfct() return IP_CT_UNTRACKED
if SKB_HAS_NFCT is not set?
---
 include/linux/skbuff.h | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f19190820e63..ec3d34d8022f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -689,6 +689,8 @@ typedef unsigned char *sk_buff_data_t;
  *		CHECKSUM_UNNECESSARY (max 3)
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
+ *	@_state: bitmap reporting the presence of some skb state info
+ *	@has_nfct: @_state bit for nfct info
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
@@ -765,9 +767,6 @@ struct sk_buff {
 #endif
 	};
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-	unsigned long		 _nfct;
-#endif
 	unsigned int		len,
 				data_len;
 	__u16			mac_len,
@@ -870,6 +869,12 @@ struct sk_buff {
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
 #endif
+	union {
+		__u8		_state;		/* state of extended fields */
+		struct {
+			__u8	has_nfct:1;
+		};
+	};
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -936,6 +941,9 @@ struct sk_buff {
 	/* only useable after checking ->active_extensions != 0 */
 	struct skb_ext		*extensions;
 #endif
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	unsigned long		 _nfct;
+#endif
 };
 
 #ifdef __KERNEL__
@@ -4198,7 +4206,7 @@ static inline void skb_remcsum_process(struct sk_buff *skb, void *ptr,
 static inline struct nf_conntrack *skb_nfct(const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	return (void *)(skb->_nfct & NFCT_PTRMASK);
+	return skb->has_nfct ? (void *)(skb->_nfct & NFCT_PTRMASK) : NULL;
 #else
 	return NULL;
 #endif
@@ -4207,7 +4215,7 @@ static inline struct nf_conntrack *skb_nfct(const struct sk_buff *skb)
 static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	return skb->_nfct;
+	return skb->has_nfct ? skb->_nfct : 0;
 #else
 	return 0UL;
 #endif
@@ -4216,6 +4224,7 @@ static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
 static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	skb->has_nfct = !!nfct;
 	skb->_nfct = nfct;
 #endif
 }
-- 
2.26.3

