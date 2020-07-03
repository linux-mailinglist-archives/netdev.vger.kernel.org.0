Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6191E213C30
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 16:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgGCO51 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jul 2020 10:57:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726098AbgGCO51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 10:57:27 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-B6n95fx-MtevLRK4tOPbJw-1; Fri, 03 Jul 2020 10:57:22 -0400
X-MC-Unique: B6n95fx-MtevLRK4tOPbJw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C69610059A7;
        Fri,  3 Jul 2020 14:57:21 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.195.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8910E2DE77;
        Fri,  3 Jul 2020 14:57:19 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>,
        Tobias Brunner <tobias@strongswan.org>
Subject: [PATCH ipsec] xfrm: esp6: fix encapsulation header offset computation
Date:   Fri,  3 Jul 2020 16:57:09 +0200
Message-Id: <37e23af3698e92fd095c401937ed0cacf5f2e455.1593785611.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 0146dca70b87, I incorrectly adapted the code that computes
the location of the UDP or TCP encapsulation header from IPv4 to
IPv6. In esp6_input_done2, skb->transport_header points to the ESP
header, so by adding skb_network_header_len, uh and th will point to
the ESP header, not the encapsulation header that's in front of it.

Since the TCP header's size can change with options, we have to start
from the IPv6 header and walk past possible extensions.

Fixes: 0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")
Fixes: 26333c37fc28 ("xfrm: add IPv6 support for espintcp")
Reported-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv6/esp6.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index c43592771126..55ae70be91b3 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -805,10 +805,16 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 
 	if (x->encap) {
 		const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+		int offset = skb_network_offset(skb) + sizeof(*ip6h);
 		struct xfrm_encap_tmpl *encap = x->encap;
-		struct udphdr *uh = (void *)(skb_network_header(skb) + hdr_len);
-		struct tcphdr *th = (void *)(skb_network_header(skb) + hdr_len);
-		__be16 source;
+		u8 nexthdr = ip6h->nexthdr;
+		__be16 frag_off, source;
+		struct udphdr *uh;
+		struct tcphdr *th;
+
+		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
+		uh = (void *)(skb->data + offset);
+		th = (void *)(skb->data + offset);
 
 		switch (x->encap->encap_type) {
 		case TCP_ENCAP_ESPINTCP:
-- 
2.27.0

