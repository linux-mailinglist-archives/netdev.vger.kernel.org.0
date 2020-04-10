Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5A31A4437
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDJJHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:07:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36416 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJJHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 05:07:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id n10so822555pff.3
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 02:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BRImzMxv3UzybUQdjgT3rEtHzQvjdenkBtuvZ7IQxfQ=;
        b=fpzFUjNn8qFxVw8sg62jYDxdHloxt4f9L35sqkWaCBRd4cZgvmDZKY6qVVj971N7Bw
         6d5bqyle66waFgIpwUFoLkCptBRxLW4e0LLOmlswmT6VAC0sjGaVMqZ29AguHHlvMwPj
         GJEsMpifwDDi+78YEtmYaEcelIfDF4zJcsrJjovMkIXX2Tft089CtVdmNS4tVVXvCKvu
         My4BF8802DgMpl6BRktWGgZFA85I6NJDksbp3AkMfXGgBPQGjRN7I/zLwJyn3tCCBH3y
         XeXj0n/k81FnfV69nHbU7kl8p9YiuwW45SZ+OMaF6EfjX2wsL98dgXOKCAzQuzwm7irn
         G8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BRImzMxv3UzybUQdjgT3rEtHzQvjdenkBtuvZ7IQxfQ=;
        b=uPdIv+CygHVbCP8t1yMwib/VhjJjg2Ca4dSLJsEJ0IczPGL6vJXVNNdG3+zRA8G2A0
         ogUI48bkd4mdWklzVQms2C8OnjCHJqMQYo+vcXdHtv89uCQnVPUlvMSkg2m/ZAW/YEqk
         1UR8yD3UEGgYTiPpPpn6dDzQi/lOLvuAAJGwabxAtvAfM4fHUw7Ng27i24KjwiCpHzD8
         QYMiMW+YlHpaLcAFZSnZF3Q7JwML/8gYysE571MPZ9i3V5Gpxya12RWTFYGlwm2Lbaej
         q9KDaKMKF/Z96N2dQ2hCrYB2UjapMF+EwKnnftH/VK13GyL3WbapNI6bmG6xD1C2ArqM
         mm8A==
X-Gm-Message-State: AGi0PuZ/z1EwxOet3fo2D1T0VLhpUWnZQS3z52CC58HsZhNscRTH9GEX
        FsLOC3z6OM/BoVR6ORvh3lye2TKC
X-Google-Smtp-Source: APiQypIKeKUzmkeH8yz8fSUTqM6Gc1FOZhwL+iZrggmGeFzf8NtXux+PgW3pkiT11iUsMPwxBkecHA==
X-Received: by 2002:a63:b542:: with SMTP id u2mr3596432pgo.352.1586509624694;
        Fri, 10 Apr 2020 02:07:04 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r4sm1126979pgi.6.2020.04.10.02.07.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 02:07:04 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] esp6: get the right proto for transport mode in esp6_gso_encap
Date:   Fri, 10 Apr 2020 17:06:56 +0800
Message-Id: <7f50634c051299833413aa8478083d061443cc7c.1586509616.git.lucien.xin@gmail.com>
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

What it wants to get for x-proto in esp6_gso_encap() is the proto that
will be set in ESP nexthdr. So it should skip all ipv6 nexthdrs and
get the real transport protocol. Othersize, the wrong proto number
will be set into ESP nexthdr.

This patch is to skip all ipv6 nexthdrs by calling ipv6_skip_exthdr()
in esp6_gso_encap().

Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/esp6_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 8eab2c8..b828508 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -123,9 +123,16 @@ static void esp6_gso_encap(struct xfrm_state *x, struct sk_buff *skb)
 	struct ip_esp_hdr *esph;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct xfrm_offload *xo = xfrm_offload(skb);
-	int proto = iph->nexthdr;
+	u8 proto = iph->nexthdr;
 
 	skb_push(skb, -skb_network_offset(skb));
+
+	if (x->outer_mode.encap == XFRM_MODE_TRANSPORT) {
+		__be16 frag;
+
+		ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag);
+	}
+
 	esph = ip_esp_hdr(skb);
 	*skb_mac_header(skb) = IPPROTO_ESP;
 
-- 
2.1.0

