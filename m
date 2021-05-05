Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A497C373EA3
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 17:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhEEPhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 11:37:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233451AbhEEPhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 11:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620228973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=veIe36wt1iFqwVKLfJM7bzNLO9cPjV1Dy1lTkdUQn8A=;
        b=EfMqQtG6WClq6RpE1W3/WdrLhzSi+pHzvLvrA2bvrultC/aS4M8vOrBt5/LDcVjDjgHiic
        IsyiNmfgo+htHB9N5DPsx8qaVFBqrYqJs3oxoehACIHmHgfap3BmbKlU5wdKYBtSPcp7Lc
        l2Mc92ervu1lj1Lg3owFViAQa3tDm3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-QG2AYR44Mnmea44XsIM-nw-1; Wed, 05 May 2021 11:36:11 -0400
X-MC-Unique: QG2AYR44Mnmea44XsIM-nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E582310CE780;
        Wed,  5 May 2021 15:36:09 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-175.ams2.redhat.com [10.36.113.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6498D5C1A3;
        Wed,  5 May 2021 15:36:08 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
Date:   Wed,  5 May 2021 17:35:01 +0200
Message-Id: <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
In-Reply-To: <cover.1620223174.git.pabeni@redhat.com>
References: <cover.1620223174.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While segmenting a SKB_GSO_FRAGLIST GSO packet, if the destructor
callback is available, the skb destructor is invoked on each
aggregated packet via skb_release_head_state().

Such field (and the pairer skb->sk) is left untouched, so the same
destructor is invoked again when the segmented skbs are freed, leading
to double-free/UaF of the relevant socket.

The problem is observable since commit c75fb320d482 ("veth: use
skb_orphan_partial instead of skb_orphan"), which allowed non orphaned
skbs to enter the GRO engine, but the root cause is there since the
introduction of GSO fraglist

This change addresses the above issue explixitly clearing the segmented
skb destructor after the skb_release_head_state() call.

Fixes: c75fb320d482 ("veth: use skb_orphan_partial instead of skb_orphan")
Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/skbuff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad22870298c..75f3e70f8cd5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3818,6 +3818,12 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		skb_release_head_state(nskb);
 		 __copy_skb_header(nskb, skb);
 
+		/* __copy_skb_header() does not initialize the sk-related fields,
+		 * and skb_release_head_state() already orphaned nskb
+		 */
+		nskb->sk = NULL;
+		nskb->destructor = NULL;
+
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
 		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
 						 nskb->data - tnl_hlen,
-- 
2.26.2

