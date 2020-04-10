Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17CC1A4432
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgDJJGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:06:42 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36241 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJJGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 05:06:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id g2so490824plo.3
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 02:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L9fUSnN3oqWvl6RSBuLZ27gSZn6X9SEeQ/oYx5RqOAQ=;
        b=sX0K/Muhr0tAnr8HjLn0NUMZyScLhBQga8KFNQKA5fcloQbujuslfE6gJRvsSOR6CY
         aV95zTfIvk58W/8e5SkVCmPoRnFqikTg5oAButz7V6xSLvLA3uDKd7x7O4flEQewebWI
         nYweaopfqjogl2vqTZ7o9e9+YmQx5+4uQVu7DpssxCCQXeZBqMvZtSJHB45w/h8GjJmc
         /wKWQnhhc8b0eOWhekq+AyW2CzTKt2dkgqWHPQ45HPATABSX1bIw0tUXLsIk7beiF6PZ
         4Kz2eGo35+R7lk14XXBk8hdOfHMJF/N3CtydDt+EFf7F/4UYeG9zBc6uTFl0zV5KjY9A
         lm+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L9fUSnN3oqWvl6RSBuLZ27gSZn6X9SEeQ/oYx5RqOAQ=;
        b=mbfpcvGIcIbxzEh4buOswxoRdbUCdO4li/oUp4rfKJRbhcf2sAuOVxvc6yKs3T+4dM
         I7if4NfRfoR059Y3kdPxbXJzjLn1cEpQuxZ+Xrxtu5+8Iw0vF2VYXyfRAu/b2J6XMPiD
         o/k7QPNOesu0EDK0YfhZd8tGby7BiZ8zvU0Tiqp83tUD5Gqm1XQ6GKAMKEiBF3qRz29U
         DKrJtn18YWKd8TqtLpjaHNxT7FNQb4k6EB0CAcAjPbwYxyy1XO3rdKSdZOQNtITCm2P5
         FgqwBdWyGR2SF58IX0yRbXgaXcdkCEtjIwk81Zjp7XtGZc0xEZaj0G/25mec3VsX0XhC
         Td7Q==
X-Gm-Message-State: AGi0Pua4DcBFu69FjK1eIX2INpoJO5DKUXKtn/rd8JE00AjNAnud2ABM
        wughuwPqo8l6w1XXYKCU6iVlyU7h
X-Google-Smtp-Source: APiQypIiWcOU7964A7AY8uTGoTXsCYPTA27nEREDIxZ7nid4FHhHz8V1HM5xrcJc1ozRG+esjbsdGw==
X-Received: by 2002:a17:90a:e013:: with SMTP id u19mr4383387pjy.54.1586509599825;
        Fri, 10 Apr 2020 02:06:39 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 71sm1273196pfw.180.2020.04.10.02.06.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 02:06:39 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] xfrm: do pskb_pull properly in __xfrm_transport_prep
Date:   Fri, 10 Apr 2020 17:06:31 +0800
Message-Id: <8ee05a6dd512e7925d80f9890af20f2a4436be5e.1586509591.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
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

Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_device.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6cc7f7f..f50d1f9 100644
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

