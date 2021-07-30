Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01943DBD0E
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 18:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhG3QcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 12:32:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229510AbhG3Qb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 12:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627662714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KDpHZv1bYPDMHbzG8bBjvLY0hGTQaTYJRPHmwrupfv0=;
        b=gtNX6e/boaZgJUsMWe8b+GK9nU5wLSQ43FpvN1YES4Us0QcxEPc1saRCbqjA+6QKZkC5gh
        NhCtiyeuYv4xt0JlETdnDd7NkgPuyaBKcD1gwLB+jo4663+fG0jWU21JMDD7TKfeQidKkn
        gd2/pgphpOavvIQ1bgFhhKvaNcSVL+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-ZDWNMDelMr-c1ddWr2XsNA-1; Fri, 30 Jul 2021 12:31:50 -0400
X-MC-Unique: ZDWNMDelMr-c1ddWr2XsNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B16B8010F4;
        Fri, 30 Jul 2021 16:31:49 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DCF15D6AB;
        Fri, 30 Jul 2021 16:31:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next] sk_buff: avoid potentially clearing 'slow_gro' field
Date:   Fri, 30 Jul 2021 18:30:53 +0200
Message-Id: <aa42529252dc8bb02bd42e8629427040d1058537.1627662501.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb_dst_set_noref() is invoked with a NULL dst, the 'slow_gro'
field is cleared, too. That could lead to wrong behavior if
the skb later enters the GRO stage.

Fix the potential issue replacing preserving a non-zero value of
the 'slow_gro' field.

Additionally, fix a comment typo.

Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 8a886b142bd0 ("sk_buff: track dst status in slow_gro")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h | 2 +-
 net/core/dev.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b1e5bbfcc926..2bcdc8cd38be 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1009,7 +1009,7 @@ static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
 static inline void skb_dst_set_noref(struct sk_buff *skb, struct dst_entry *dst)
 {
 	WARN_ON(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
-	skb->slow_gro = !!dst;
+	skb->slow_gro |= !!dst;
 	skb->_skb_refdst = (unsigned long)dst | SKB_DST_NOREF;
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index b51e41d0a7fe..64e1a5f63f93 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6022,7 +6022,7 @@ static void gro_list_prepare(const struct list_head *head,
 				       skb_mac_header(skb),
 				       maclen);
 
-		/* in most common scenarions _state is 0
+		/* in most common scenarions 'slow_gro' is 0
 		 * otherwise we are already on some slower paths
 		 * either skip all the infrequent tests altogether or
 		 * avoid trying too hard to skip each of them individually
-- 
2.26.3

