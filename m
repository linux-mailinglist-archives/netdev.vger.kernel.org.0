Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514C9233FDD
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgGaHSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:18:20 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49948 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731644AbgGaHSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E9891205F8;
        Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mAdZP9hkKA6t; Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 276F0205CB;
        Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:18:09 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:18:09 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6FE263184659;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 08/10] xfrm: esp6: fix the location of the transport header with encapsulation
Date:   Fri, 31 Jul 2020 09:18:02 +0200
Message-ID: <20200731071804.29557-9-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731071804.29557-1-steffen.klassert@secunet.com>
References: <20200731071804.29557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.17.1

