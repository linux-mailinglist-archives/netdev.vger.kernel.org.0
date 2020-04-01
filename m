Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7191A19A817
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 10:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbgDAI7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 04:59:52 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51403 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731743AbgDAI7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 04:59:52 -0400
Received: by mail-pj1-f65.google.com with SMTP id w9so2428924pjh.1
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 01:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=TflXMlcMys7IBJhVZ+n8AKx8nIKzj1h9CxYN7R5Xa3c=;
        b=BNx+0y0FGJ+L4VL3+h3qmwHOPyoXZhrozuRt+j14H3AYb9A809VuDZJuODsk2WTddu
         CUznZYkUKn9aObBbzPqZBDBqwRPrUM6WulQiLZLcYowJXdBHUgwmTDFk78Jo32eHIqji
         C4EXYH1zQmL6m1YlNp9QJLbFtn1piV1ua/2EtCcO67y3IPHhz5Lm+jHNy0sdW3XTDw/4
         TIsrEPG1PzZ4ofMQd8BfAU6BzCpLpY9IyisXtPOq6nhsYvShrbHemraAgsdGZf2M2ez/
         g4DE3Ab5QTXbnb4HmSyp+IeX9JnscHwxRNJEwjHb2iKSKGv6WNzwvaaEmgaJL61BT1O9
         LYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=TflXMlcMys7IBJhVZ+n8AKx8nIKzj1h9CxYN7R5Xa3c=;
        b=X8szqwHqT0s1BtSU/zzPX3W5jG9o7L2tdpelwpiS2jWAYveZb5P3YTS3FlzKnyC97O
         3I8ziNr3q/pTZkbAz8dAlhSHorOv+Wx1uncG3yCuo2J4ya2hwgr1uHAbNCb/cOU2YbfI
         chY9hTk7uiBucLAPW++wO/zpeeZoNtT7V3IcLofJIrzPJ9uxWcMz2t0kdUzBd/U1NyYN
         QcBF6vcrbsL+VGS/6gpIi4STT5mfAHJ7hEIw1tM/XtgTh8G4nXszJbkQ2CbM/Wz03kxP
         xZpBRJnkDj9fByBQqtVGXpMj/qPfTr7BXHLje+PlmDkEk/B4Q4F0jZIVd8rZLfCMUVbU
         ixew==
X-Gm-Message-State: AGi0Pua0crak7UBAUjxpZaXqbstx0C/cSlz1DDragkiRlttINfDz3mII
        H9i3vgEP4WUs0+A6DQDbk0l+5vIc
X-Google-Smtp-Source: APiQypJghsQ+tf362wye97uXoQsTRzrXgF/smr1QFKmZXN7h1GSdq+kET/+WiDnYzHM9LHS66wiCzA==
X-Received: by 2002:a17:90a:2489:: with SMTP id i9mr3358237pje.183.1585731590727;
        Wed, 01 Apr 2020 01:59:50 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w125sm1011596pgw.45.2020.04.01.01.59.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 01:59:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 2/5] xfrm: do pskb_pull properly in __xfrm_transport_prep
Date:   Wed,  1 Apr 2020 16:59:22 +0800
Message-Id: <59aafccde155f156544d54db1145d54ecd018d74.1585731430.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c089597acfb559c70b1485ec84d01a78c8341bb3.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
 <c089597acfb559c70b1485ec84d01a78c8341bb3.1585731430.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_device.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index fa2a506..fbd2c21 100644
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
2.1.0

