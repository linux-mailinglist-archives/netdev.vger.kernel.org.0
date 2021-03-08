Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC5B330B45
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 11:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhCHKcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 05:32:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231590AbhCHKcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 05:32:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615199543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzgm3Jq54JoBtwEStS2p3zfh75LFir9ok6NSzKhJVag=;
        b=WjVJ0FIH+3Y7Db+1KAFPx0XyXBmXj49fLVjveTjf0Dl4sfzuRX2CHyo68E5W5U2qcJcg7q
        ViiYGiho7FculT2xc9zOXnvb0ThkQwi9PyuLuxLtS78+bhMAGbMNlVVrHG/rFO+ksCQ9TO
        aqFgv+lz8/YF6QFMofIgBg1g3RugkG0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-JIv8FvDnMqW9ja_fv9GHLA-1; Mon, 08 Mar 2021 05:32:21 -0500
X-MC-Unique: JIv8FvDnMqW9ja_fv9GHLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 876CE108BD09;
        Mon,  8 Mar 2021 10:32:20 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-113-99.ams2.redhat.com [10.36.113.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8239360D79;
        Mon,  8 Mar 2021 10:32:18 +0000 (UTC)
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org, bnemeth@redhat.com
Subject: [PATCH v2 2/2] net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0
Date:   Mon,  8 Mar 2021 11:31:26 +0100
Message-Id: <85e04e1e6367f19c8f538d145b32f5bb93788d8a.1615199056.git.bnemeth@redhat.com>
In-Reply-To: <cover.1615199056.git.bnemeth@redhat.com>
References: <cover.1615199056.git.bnemeth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A packet with skb_inner_network_header(skb) == skb_network_header(skb)
and ETH_P_MPLS_UC will prevent mpls_gso_segment from pulling any headers
from the packet. Subsequently, the call to skb_mac_gso_segment will
again call mpls_gso_segment with the same packet leading to an infinite
loop.

Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
---
 net/mpls/mpls_gso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
index b1690149b6fa..cc1b6457fc93 100644
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -27,7 +27,7 @@ static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 
 	skb_reset_network_header(skb);
 	mpls_hlen = skb_inner_network_header(skb) - skb_network_header(skb);
-	if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
+	if (unlikely(!mpls_hlen || !pskb_may_pull(skb, mpls_hlen)))
 		goto out;
 
 	/* Setup inner SKB. */
-- 
2.29.2

