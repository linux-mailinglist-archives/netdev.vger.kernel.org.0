Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798D235F1AA
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhDNKtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:49:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233897AbhDNKt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618397342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=We9uznYlK5dDZxYFXapdGy47V4QK+f7aFI5+V/isz3E=;
        b=hDMN/KvQbyuca5T6NawzgVPVyXH99HmqJGX86v8Sf23UEsgqDxhYfYQumiy2voZPUv+dq5
        GoeW8KKLolfEVbLTpRbmR7t7BUhZzhLHZdGId0m0txz13+X6QQlrCu9f+9QkofL86xhcQz
        zbT9jXBh+zX/9xi8D2JaujZqYnfWDhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-FmX7bh8WNxWSGVe29FSozw-1; Wed, 14 Apr 2021 06:49:01 -0400
X-MC-Unique: FmX7bh8WNxWSGVe29FSozw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E265186833B;
        Wed, 14 Apr 2021 10:49:00 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B063B610A8;
        Wed, 14 Apr 2021 10:48:58 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] skbuff: revert "skbuff: remove some unnecessary operation in skb_segment_list()"
Date:   Wed, 14 Apr 2021 12:48:48 +0200
Message-Id: <f092ecf89336221af04310c9feac800e49d4647f.1618397249.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the commit 1ddc3229ad3c ("skbuff: remove some unnecessary operation
in skb_segment_list()") introduces an issue very similar to the
one already fixed by commit 53475c5dd856 ("net: fix use-after-free when
UDP GRO with shared fraglist").

If the GSO skb goes though skb_clone() and pskb_expand_head() before
entering skb_segment_list(), the latter  will unshare the frag_list
skbs and will release the old list. With the reverted commit in place,
when skb_segment_list() completes, skb->next points to the just
released list, and later on the kernel will hit UaF.

Note that since commit e0e3070a9bc9 ("udp: properly complete L4 GRO
over UDP tunnel packet") the critical scenario can be reproduced also
receiving UDP over vxlan traffic with:

NIC (NETIF_F_GRO_FRAGLIST enabled) -> vxlan -> UDP sink

Attaching a packet socket to the NIC will cause skb_clone() and the
tunnel decapsulation will call pskb_expand_head().

Fixes: 1ddc3229ad3c ("skbuff: remove some unnecessary operation in skb_segment_list()")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/skbuff.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad9e8425ab2..14010c0eec48 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3773,13 +3773,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 	unsigned int tnl_hlen = skb_tnl_header_len(skb);
 	unsigned int delta_truesize = 0;
 	unsigned int delta_len = 0;
+	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb, *tmp;
 	int err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
 	skb_shinfo(skb)->frag_list = NULL;
-	skb->next = list_skb;
 
 	do {
 		nskb = list_skb;
@@ -3797,8 +3797,17 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 			}
 		}
 
-		if (unlikely(err))
+		if (!tail)
+			skb->next = nskb;
+		else
+			tail->next = nskb;
+
+		if (unlikely(err)) {
+			nskb->next = list_skb;
 			goto err_linearize;
+		}
+
+		tail = nskb;
 
 		delta_len += nskb->len;
 		delta_truesize += nskb->truesize;
@@ -3825,7 +3834,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 	skb_gso_reset(skb);
 
-	skb->prev = nskb;
+	skb->prev = tail;
 
 	if (skb_needs_linearize(skb, features) &&
 	    __skb_linearize(skb))
-- 
2.26.2

