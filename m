Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11615CF834
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfJHLbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:31:02 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:6372 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730572AbfJHLbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1143; q=dns/txt; s=iport;
  t=1570534262; x=1571743862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=BnaYUTeQLCnmHsj6wD/ErSO9e2IZixZXZrQiSlZKyBc=;
  b=C9h+TtsFVNxzkcNgcRN7nUQrXRqE6UKXGMQSb8yO0XMAHQD/3pbWnTgH
   UUmoMoWQKpl2iFx/RHEX37E8T5jTYNVYngeF27pRYmYlAtotaEp9XtC5f
   MFH33YB7HhPcodDsnsILzvVsIwuxyndNbGIAAUCHv0gsjjkIy10+9pZmv
   k=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; 
   d="scan'208";a="17697349"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Oct 2019 11:23:54 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id x98BNe51031991;
        Tue, 8 Oct 2019 11:23:53 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Georg Kohmann <geokohma@cisco.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 stable 03/10] ipv6: do not increment mac header when it's unset
Date:   Tue,  8 Oct 2019 13:23:02 +0200
Message-Id: <20191008112309.9571-4-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20191008112309.9571-1-geokohma@cisco.com>
References: <20191008112309.9571-1-geokohma@cisco.com>
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit b678aa578c9e ("ipv6: do not increment mac header when it's unset")
Author: Jason A. Donenfeld <Jason@zx2c4.com>
Date:   Fri Oct 21 18:28:25 2016 +0900

Otherwise we'll overflow the integer. This occurs when layer 3 tunneled
packets are handed off to the IPv6 layer.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv6/reassembly.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index ec917f5..2842ccf 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -418,7 +418,8 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 	skb_network_header(head)[nhoff] = skb_transport_header(head)[0];
 	memmove(head->head + sizeof(struct frag_hdr), head->head,
 		(head->data - head->head) - sizeof(struct frag_hdr));
-	head->mac_header += sizeof(struct frag_hdr);
+	if (skb_mac_header_was_set(head))
+		head->mac_header += sizeof(struct frag_hdr);
 	head->network_header += sizeof(struct frag_hdr);
 
 	skb_reset_transport_header(head);
-- 
2.10.2

