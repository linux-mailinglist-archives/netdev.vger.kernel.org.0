Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788CD1E7B26
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgE2LEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:04:20 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39478 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgE2LEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:04:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F0FF5205E3;
        Fri, 29 May 2020 13:04:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TTmh8bf4upNb; Fri, 29 May 2020 13:04:13 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 78EDB205CF;
        Fri, 29 May 2020 13:04:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:04:13 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:04:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 13A2D3180266;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/15] xfrm: do pskb_pull properly in __xfrm_transport_prep
Date:   Fri, 29 May 2020 13:03:55 +0200
Message-ID: <20200529110408.6349-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

For transport mode, when ipv6 nexthdr is set, the packet format might
be like:

    ----------------------------------------------------
    |        | dest |     |     |      |  ESP    | ESP |
    | IP6 hdr| opts.| ESP | TCP | Data | Trailer | ICV |
    ----------------------------------------------------

and in __xfrm_transport_prep():

  pskb_pull(skb, skb->mac_len + sizeof(ip6hdr) + x->props.header_len);

it will pull the data pointer to the wrong position, as it missed the
nexthdrs/dest opts.

This patch is to fix it by using:

  pskb_pull(skb, skb_transport_offset(skb) + x->props.header_len);

as we can be sure transport_header points to ESP header at that moment.

It also fixes a panic when packets with ipv6 nexthdr are sent over
esp6 transport mode:

  [  100.473845] kernel BUG at net/core/skbuff.c:4325!
  [  100.478517] RIP: 0010:__skb_to_sgvec+0x252/0x260
  [  100.494355] Call Trace:
  [  100.494829]  skb_to_sgvec+0x11/0x40
  [  100.495492]  esp6_output_tail+0x12e/0x550 [esp6]
  [  100.496358]  esp6_xmit+0x1d5/0x260 [esp6_offload]
  [  100.498029]  validate_xmit_xfrm+0x22f/0x2e0
  [  100.499604]  __dev_queue_xmit+0x589/0x910
  [  100.502928]  ip6_finish_output2+0x2a5/0x5a0
  [  100.503718]  ip6_output+0x6c/0x120
  [  100.505198]  xfrm_output_resume+0x4bf/0x530
  [  100.508683]  xfrm6_output+0x3a/0xc0
  [  100.513446]  inet6_csk_xmit+0xa1/0xf0
  [  100.517335]  tcp_sendmsg+0x27/0x40
  [  100.517977]  sock_sendmsg+0x3e/0x60
  [  100.518648]  __sys_sendto+0xee/0x160

Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_device.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6cc7f7f1dd68..f50d1f97cf8e 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -25,12 +25,10 @@ static void __xfrm_transport_prep(struct xfrm_state *x, struct sk_buff *skb,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 
 	skb_reset_mac_len(skb);
-	pskb_pull(skb, skb->mac_len + hsize + x->props.header_len);
-
-	if (xo->flags & XFRM_GSO_SEGMENT) {
-		skb_reset_transport_header(skb);
+	if (xo->flags & XFRM_GSO_SEGMENT)
 		skb->transport_header -= x->props.header_len;
-	}
+
+	pskb_pull(skb, skb_transport_offset(skb) + x->props.header_len);
 }
 
 static void __xfrm_mode_tunnel_prep(struct xfrm_state *x, struct sk_buff *skb,
-- 
2.17.1

