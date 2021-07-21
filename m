Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7E23D1467
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhGUQEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:04:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhGUQEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfO2Ebo7y8Fig2s6wG5ow6OseNWKKFu01ENqBVxGNqo=;
        b=JYOfLPg3dfHjIhAMQLrA3EL6Cv/zAW4K+R2B/1ekGc38n14/Ypf98bGt5JBFW1kEiMUcgi
        98WNNYldXVZETYcvcNXlIPXFLYF4Rt7d2Mm4V/pH2XZFj+tSuIDsiNpLL47O3rXqvoxcQh
        sEP8zDJHH7MAq8ARP/HEfskJR/bOlvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-wPwmTwoHPKeT0pes4QJZ3Q-1; Wed, 21 Jul 2021 12:45:14 -0400
X-MC-Unique: wPwmTwoHPKeT0pes4QJZ3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B83B8192D785;
        Wed, 21 Jul 2021 16:45:12 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05D26797C0;
        Wed, 21 Jul 2021 16:45:10 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 2/9] sk_buff: track dst status in skb->_state
Date:   Wed, 21 Jul 2021 18:44:34 +0200
Message-Id: <596f20dc9e8b0cb0394c0f64fa8ce968c0187047.1626882513.git.pabeni@redhat.com>
In-Reply-To: <cover.1626882513.git.pabeni@redhat.com>
References: <cover.1626882513.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the previous patch, covering the dst field,
but limited to tracking only the dst status.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h | 4 ++++
 include/net/dst.h      | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ec3d34d8022f..1b811585f6fc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -691,6 +691,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@decrypted: Decrypted SKB
  *	@_state: bitmap reporting the presence of some skb state info
  *	@has_nfct: @_state bit for nfct info
+ *	@has_dst: @_state bit for dst pointer
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
@@ -873,6 +874,7 @@ struct sk_buff {
 		__u8		_state;		/* state of extended fields */
 		struct {
 			__u8	has_nfct:1;
+			__u8	has_dst:1;
 		};
 	};
 
@@ -998,6 +1000,7 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
  */
 static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
 {
+	skb->has_dst = !!dst;
 	skb->_skb_refdst = (unsigned long)dst;
 }
 
@@ -1014,6 +1017,7 @@ static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
 static inline void skb_dst_set_noref(struct sk_buff *skb, struct dst_entry *dst)
 {
 	WARN_ON(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	skb->has_dst = !!dst;
 	skb->_skb_refdst = (unsigned long)dst | SKB_DST_NOREF;
 }
 
diff --git a/include/net/dst.h b/include/net/dst.h
index 75b1e734e9c2..2cb765dabc6f 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -272,11 +272,13 @@ static inline void skb_dst_drop(struct sk_buff *skb)
 	if (skb->_skb_refdst) {
 		refdst_drop(skb->_skb_refdst);
 		skb->_skb_refdst = 0UL;
+		skb->has_dst = 0;
 	}
 }
 
 static inline void __skb_dst_copy(struct sk_buff *nskb, unsigned long refdst)
 {
+	nskb->has_dst = !!refdst;
 	nskb->_skb_refdst = refdst;
 	if (!(nskb->_skb_refdst & SKB_DST_NOREF))
 		dst_clone(skb_dst(nskb));
@@ -316,6 +318,7 @@ static inline bool skb_dst_force(struct sk_buff *skb)
 			dst = NULL;
 
 		skb->_skb_refdst = (unsigned long)dst;
+		skb->has_dst = !!dst;
 	}
 
 	return skb->_skb_refdst != 0UL;
-- 
2.26.3

