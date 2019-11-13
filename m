Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EFCFAFC9
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfKMLeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:34:06 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50398 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfKMLeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 06:34:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7D2002058E;
        Wed, 13 Nov 2019 12:34:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 78b0WY_7cKzZ; Wed, 13 Nov 2019 12:34:04 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CA3E820582;
        Wed, 13 Nov 2019 12:34:03 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 12:34:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A7E5031801CB;
 Wed, 13 Nov 2019 12:34:01 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/2] xfrm: ifdef setsockopt(UDP_ENCAP_ESPINUDP/UDP_ENCAP_ESPINUDP_NON_IKE)
Date:   Wed, 13 Nov 2019 12:33:58 +0100
Message-ID: <20191113113358.4740-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113113358.4740-1-steffen.klassert@secunet.com>
References: <20191113113358.4740-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

If IPsec is not configured, there is no reason to delay the inevitable.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h | 7 -------
 net/ipv4/udp.c     | 2 ++
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index aa08a7a5f6ac..dda3c025452e 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1613,13 +1613,6 @@ static inline int xfrm_user_policy(struct sock *sk, int optname, u8 __user *optv
 {
  	return -ENOPROTOOPT;
 }
-
-static inline int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
-{
- 	/* should not happen */
- 	kfree_skb(skb);
-	return 0;
-}
 #endif
 
 struct dst_entry *__xfrm_dst_lookup(struct net *net, int tos, int oif,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cf755156a684..f1c514cb4e87 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2520,9 +2520,11 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	case UDP_ENCAP:
 		switch (val) {
 		case 0:
+#ifdef CONFIG_XFRM
 		case UDP_ENCAP_ESPINUDP:
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
 			up->encap_rcv = xfrm4_udp_encap_rcv;
+#endif
 			/* FALLTHROUGH */
 		case UDP_ENCAP_L2TPINUDP:
 			up->encap_type = val;
-- 
2.17.1

