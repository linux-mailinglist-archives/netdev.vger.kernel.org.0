Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07618107EF7
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 16:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKWO6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 09:58:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38546 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWO6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 09:58:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so12132327wro.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 06:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=xM5gPOLCUq+kvzAVSHT7RZ6/R1yyScg8haFg0r902rA=;
        b=NJ0XTZSl4lHhBJw+xLO6zdoivE4wCJVAKnog5XfMgKVbL+yp08w2iDlxwpEhIgavfv
         wkMZcNFGe27b9J2SA6/GANZACLWC+NY1J1dEktE0DoZHK7FaBe2jO8KldNbxK742iI7V
         aOA/Gouvswqxm9kH+gukOpBCpxD38Nw3O+Irx2xPESOf/8f0E7fk7n1k/s7UDkgg11+w
         JTWc35NYnDOE9r0b9QLmxpxeVphjE+xQi37V1Amx7YQuSRP5qkBVQzf102y7YAwRsrnn
         qum3m7wIiMs8hCBFkBe8iHAG731yEFgWh7Z5GgqatwvKz5UiNPGYLyiYvF9IW2nmDSZ2
         mZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=xM5gPOLCUq+kvzAVSHT7RZ6/R1yyScg8haFg0r902rA=;
        b=sMbT9Hq7KRnYornqXFAahNpgxY+HryFWB2p/Dyxgqcsz+Vy/3WiXMw+KIX/WeccBCe
         yKb48QBCqAp8vr04QQFhYp1nWGrdUHCJ3TIu+Uv3jtLzanWhdPVUwgsFCwrEqt0++N3o
         OUNO+ps8vvFkQnFYm+edv3eS3klh84udFv7l1CdiN501yOese7cI/Jrfwk2vDcV6Fn6n
         wpLMFuDo5T9F514lDi6IVlp/+p2iKScQwBYPR7FRgYew8mx2rw1zgtKCqmceyE/+ndwk
         pzEO4x7V9utApQ1Kb66E6uxqnDt0cF5tWt5G7jgH/esHKko2aVP5PjfAIT+MOeE12mpq
         TD0g==
X-Gm-Message-State: APjAAAVTypFBNB0e+3ErqW+qmfxTkqjy9ZK3n3psYblbsl08ps+Lgu6m
        U7Q01cCeZuqR5UzHApCEvdl+HuQwR7JBxA==
X-Google-Smtp-Source: APXvYqyzc9/jxsKfN+4q9+jZdF3JosFCHNTy2OrMNprhkKR6BdihKhoqRFmkXdLzsoIqvunlwPNQOw==
X-Received: by 2002:adf:f005:: with SMTP id j5mr22471607wro.295.1574521099904;
        Sat, 23 Nov 2019 06:58:19 -0800 (PST)
Received: from fuckup ([2a02:8071:21bc:200:5ca6:296d:d886:1cca])
        by smtp.gmail.com with ESMTPSA id v184sm2200883wme.31.2019.11.23.06.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 06:58:18 -0800 (PST)
Date:   Sat, 23 Nov 2019 15:58:18 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: ip/tnl: Set iph->id only when don't fragment is not set
Message-ID: <20191123145817.GA22321@fuckup>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In IPv4 the identification field ensures that fragments of different datagrams
are not mixed by the receiver. Packets with Don't Fragment (DF) flag set are not
to be fragmented in transit and thus don't need an identification.
Calculating the identification takes significant CPU time.
This patch will increase IP tunneling performance by ~10% unless DF is not set.
However, DF is set by default which is best practice.

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 1452a97914a0..8636c1e0e7b7 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -73,7 +73,9 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 	iph->daddr	=	dst;
 	iph->saddr	=	src;
 	iph->ttl	=	ttl;
-	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
+
+	if (unlikely((iph->frag_off & htons(IP_DF)) == false))
+		__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
 
 	err = ip_local_out(net, sk, skb);
 
-- 
2.19.1

