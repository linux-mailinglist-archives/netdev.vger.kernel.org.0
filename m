Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50814EFF3
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfD3Fav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:30:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46842 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfD3Fat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:30:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DCEC52026D;
        Tue, 30 Apr 2019 07:30:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rOGgmIfG0RjT; Tue, 30 Apr 2019 07:30:48 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 682762026C;
        Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E94EF31805C7;
 Tue, 30 Apr 2019 07:30:46 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/12] xfrm: Reset secpath in xfrm failure
Date:   Tue, 30 Apr 2019 07:30:20 +0200
Message-ID: <20190430053030.27009-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430053030.27009-1-steffen.klassert@secunet.com>
References: <20190430053030.27009-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 780BD6B9-BE30-4BB8-A1AC-34294C66A103
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Myungho Jung <mhjungk@gmail.com>

In esp4_gro_receive() and esp6_gro_receive(), secpath can be allocated
without adding xfrm state to xvec. Then, sp->xvec[sp->len - 1] would
fail and result in dereferencing invalid pointer in esp4_gso_segment()
and esp6_gso_segment(). Reset secpath if xfrm function returns error.

Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
Reported-by: syzbot+b69368fd933c6c592f4c@syzkaller.appspotmail.com
Signed-off-by: Myungho Jung <mhjungk@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 8 +++++---
 net/ipv6/esp6_offload.c | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8756e0e790d2..d3170a8001b2 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -52,13 +52,13 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 			goto out;
 
 		if (sp->len == XFRM_MAX_DEPTH)
-			goto out;
+			goto out_reset;
 
 		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
 				      (xfrm_address_t *)&ip_hdr(skb)->daddr,
 				      spi, IPPROTO_ESP, AF_INET);
 		if (!x)
-			goto out;
+			goto out_reset;
 
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
@@ -66,7 +66,7 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		xo = xfrm_offload(skb);
 		if (!xo) {
 			xfrm_state_put(x);
-			goto out;
+			goto out_reset;
 		}
 	}
 
@@ -82,6 +82,8 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 	xfrm_input(skb, IPPROTO_ESP, spi, -2);
 
 	return ERR_PTR(-EINPROGRESS);
+out_reset:
+	secpath_reset(skb);
 out:
 	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->same_flow = 0;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index d46b4eb645c2..cb99f6fb79b7 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -74,13 +74,13 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 			goto out;
 
 		if (sp->len == XFRM_MAX_DEPTH)
-			goto out;
+			goto out_reset;
 
 		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
 				      (xfrm_address_t *)&ipv6_hdr(skb)->daddr,
 				      spi, IPPROTO_ESP, AF_INET6);
 		if (!x)
-			goto out;
+			goto out_reset;
 
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
@@ -88,7 +88,7 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		xo = xfrm_offload(skb);
 		if (!xo) {
 			xfrm_state_put(x);
-			goto out;
+			goto out_reset;
 		}
 	}
 
@@ -109,6 +109,8 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 	xfrm_input(skb, IPPROTO_ESP, spi, -2);
 
 	return ERR_PTR(-EINPROGRESS);
+out_reset:
+	secpath_reset(skb);
 out:
 	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->same_flow = 0;
-- 
2.17.1

