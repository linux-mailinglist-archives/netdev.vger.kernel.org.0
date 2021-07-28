Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E223D9322
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhG1QYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:24:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhG1QYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627489477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jOo2JsCLb9TBbS6ldjkssK+2QlGTN2jf+nwfruktFaU=;
        b=bnG9SPGCGmiy616P131X4fwnWHmZYMBRbQRSfI7/smuiCem2+147lryUEb/Mj/IPTUlw1m
        uBnZtUA7lM3Rp7bual8KgYq7SmD7Ck3xpBZhjMxADE8v0+zoXIZIp8CYfrP6d4l/RExWUi
        uh5ZMCqCBo1609i2o+mh5rV5T7zJXXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-URRO55bgMdya8ack9nACJA-1; Wed, 28 Jul 2021 12:24:36 -0400
X-MC-Unique: URRO55bgMdya8ack9nACJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37A5618C8C03;
        Wed, 28 Jul 2021 16:24:35 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE30B5C1B4;
        Wed, 28 Jul 2021 16:24:33 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 2/6] sk_buff: track dst status in slow_gro
Date:   Wed, 28 Jul 2021 18:24:00 +0200
Message-Id: <a6d684d37ca7598dc89b1ff886f9b049393f0d99.1627405778.git.pabeni@redhat.com>
In-Reply-To: <cover.1627405778.git.pabeni@redhat.com>
References: <cover.1627405778.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the previous patch, but covering the dst field:
the slow_gro flag is additionally set when a dst is attached
to the skb

RFC -> v1:
 - use the existing flag instead of adding a new one

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h | 2 ++
 include/net/dst.h      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3ff18300d210..b1e5bbfcc926 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -992,6 +992,7 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
  */
 static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
 {
+	skb->slow_gro |= !!dst;
 	skb->_skb_refdst = (unsigned long)dst;
 }
 
@@ -1008,6 +1009,7 @@ static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
 static inline void skb_dst_set_noref(struct sk_buff *skb, struct dst_entry *dst)
 {
 	WARN_ON(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	skb->slow_gro = !!dst;
 	skb->_skb_refdst = (unsigned long)dst | SKB_DST_NOREF;
 }
 
diff --git a/include/net/dst.h b/include/net/dst.h
index 75b1e734e9c2..a057319aabef 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -277,6 +277,7 @@ static inline void skb_dst_drop(struct sk_buff *skb)
 
 static inline void __skb_dst_copy(struct sk_buff *nskb, unsigned long refdst)
 {
+	nskb->slow_gro |= !!refdst;
 	nskb->_skb_refdst = refdst;
 	if (!(nskb->_skb_refdst & SKB_DST_NOREF))
 		dst_clone(skb_dst(nskb));
@@ -316,6 +317,7 @@ static inline bool skb_dst_force(struct sk_buff *skb)
 			dst = NULL;
 
 		skb->_skb_refdst = (unsigned long)dst;
+		skb->slow_gro |= !!dst;
 	}
 
 	return skb->_skb_refdst != 0UL;
-- 
2.26.3

