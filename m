Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42A2F096
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfD3GiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:38:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48776 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfD3Ghe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CE5AD20284;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id t567717_JPw6; Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6ECC52026C;
        Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 13F6D31805E5;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 04/18] xfrm: prefer family stored in xfrm_mode struct
Date:   Tue, 30 Apr 2019 08:37:13 +0200
Message-ID: <20190430063727.10908-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 31BB105B-805B-4BEF-8ED8-9FE85135488F
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Now that we have the family available directly in the
xfrm_mode struct, we can use that and avoid one extra dereference.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c         | 2 +-
 net/ipv6/ip6_vti.c        | 2 +-
 net/xfrm/xfrm_input.c     | 4 ++--
 net/xfrm/xfrm_interface.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index a8474799fb79..3f3f6d6be318 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -137,7 +137,7 @@ static int vti_rcv_cb(struct sk_buff *skb, int err)
 		}
 	}
 
-	family = inner_mode->afinfo->family;
+	family = inner_mode->family;
 
 	skb->mark = be32_to_cpu(tunnel->parms.i_key);
 	ret = xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family);
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 8b6eefff2f7e..369803c581b7 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -372,7 +372,7 @@ static int vti6_rcv_cb(struct sk_buff *skb, int err)
 		}
 	}
 
-	family = inner_mode->afinfo->family;
+	family = inner_mode->family;
 
 	skb->mark = be32_to_cpu(t->parms.i_key);
 	ret = xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family);
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index b3b613660d44..ea5ac053c15d 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -216,7 +216,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop;
 		}
 
-		family = x->outer_mode->afinfo->family;
+		family = x->outer_mode->family;
 
 		/* An encap_type of -1 indicates async resumption. */
 		if (encap_type == -1) {
@@ -425,7 +425,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		 * transport mode so the outer address is identical.
 		 */
 		daddr = &x->id.daddr;
-		family = x->outer_mode->afinfo->family;
+		family = x->outer_mode->family;
 
 		err = xfrm_parse_spi(skb, nexthdr, &spi, &seq);
 		if (err < 0) {
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index dbb3c1945b5c..93efb0965e7d 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -285,7 +285,7 @@ static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 		}
 
 		if (!xfrm_policy_check(NULL, XFRM_POLICY_IN, skb,
-				       inner_mode->afinfo->family))
+				       inner_mode->family))
 			return -EPERM;
 	}
 
-- 
2.17.1

