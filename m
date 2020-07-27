Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7868322EE30
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgG0OE2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 10:04:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24041 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726222AbgG0OE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:04:28 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-OG50WFWfP62rKRLanKh3xw-1; Mon, 27 Jul 2020 10:04:23 -0400
X-MC-Unique: OG50WFWfP62rKRLanKh3xw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A33BE186A823;
        Mon, 27 Jul 2020 14:04:22 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15B59712D9;
        Mon, 27 Jul 2020 14:04:20 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>,
        Xiumei Mu <xmu@redhat.com>
Subject: [PATCH ipsec] xfrm: esp6: fix the location of the transport header with encapsulation
Date:   Mon, 27 Jul 2020 16:03:47 +0200
Message-Id: <2159be20972bd53beefeb0b8ad31adac2792105d.1595858511.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 17175d1a27c6 ("xfrm: esp6: fix encapsulation header offset
computation") changed esp6_input_done2 to correctly find the size of
the IPv6 header that precedes the TCP/UDP encapsulation header, but
didn't adjust the final call to skb_set_transport_header, which I
assumed was correct in using skb_network_header_len.

Xiumei Mu reported that when we create xfrm states that include port
numbers in the selector, traffic from the user sockets is dropped. It
turns out that we get a state mismatch in __xfrm_policy_check, because
we end up trying to compare the encapsulation header's ports with the
selector that's based on user traffic ports.

Fixes: 0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")
Fixes: 26333c37fc28 ("xfrm: add IPv6 support for espintcp")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv6/esp6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 55ae70be91b3..52c2f063529f 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -815,6 +815,7 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
 		uh = (void *)(skb->data + offset);
 		th = (void *)(skb->data + offset);
+		hdr_len += offset;
 
 		switch (x->encap->encap_type) {
 		case TCP_ENCAP_ESPINTCP:
-- 
2.27.0

