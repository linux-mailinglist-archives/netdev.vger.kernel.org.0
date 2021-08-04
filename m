Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6D23E087D
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 21:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240486AbhHDTHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 15:07:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240443AbhHDTHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 15:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628104038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vs/wUv7LInl+rb6VabGCiRlDPHTEKrgRHujGUJXyUs0=;
        b=i5gi5x1urRPS5l+qvuP+prZA8460IfbEe98P3wjnAB4g7kFlzkSyuErINlb3d1NE1WMjRO
        Bh4vJJUjR2FpZKUFpoi1KYzeT5Lwi9jerHJVVUpOrVUWzATJoV6R/i9PmR7SNVS3uKu/Pq
        CZAXb0W4q817TIAkCZz6XF+2eMvwS5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-GMgoQgGpOC2JUqCV2OKM7A-1; Wed, 04 Aug 2021 15:07:16 -0400
X-MC-Unique: GMgoQgGpOC2JUqCV2OKM7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A33F190B2A3;
        Wed,  4 Aug 2021 19:07:15 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED7A05D6B1;
        Wed,  4 Aug 2021 19:07:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next] net: fix GRO skb truesize update
Date:   Wed,  4 Aug 2021 21:07:00 +0200
Message-Id: <9134e63fd0d42787e4fbd4bd890d330d6fda9f81.1628097645.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb carring sock
reference") introduces a serious regression at the GRO layer setting
the wrong truesize for stolen-head skbs.

Restore the correct truesize: SKB_DATA_ALIGN(...) instead of
SKB_TRUESIZE(...)

Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Fixes: 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb carring sock reference")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 97ed77a86bb0..02a603556408 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4375,7 +4375,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		memcpy(frag + 1, skbinfo->frags, sizeof(*frag) * skbinfo->nr_frags);
 		/* We dont need to clear skbinfo->nr_frags here */
 
-		new_truesize = SKB_TRUESIZE(sizeof(struct sk_buff));
+		new_truesize = SKB_DATA_ALIGN(sizeof(struct sk_buff));
 		delta_truesize = skb->truesize - new_truesize;
 		skb->truesize = new_truesize;
 		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE_STOLEN_HEAD;
-- 
2.26.3

