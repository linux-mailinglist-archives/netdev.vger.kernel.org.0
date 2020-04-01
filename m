Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7EF19A81F
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 11:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732154AbgDAJAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 05:00:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32948 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732110AbgDAJAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 05:00:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id c138so2154858pfc.0
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 02:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=FbfCv/VFiK++k/l6IxbsrJaOgfo8mznBykJsm9txdpo=;
        b=Grg7DHaG7AUas/+dOOpq0Rgf0REYB8TrZ85QIpbMb9NsxywZWdGbDOfcahbkAgTjXz
         BTqlxH72N5J+U+9fCzGNPC+u1EXNlcKvzJf7td0Ef7d859z1iZSvTPAHXBjF++3k63vA
         lLFZBNS9WVcUhzEl+ewVXzzctv0WgZ6oJhpkp0yq6n2ttW3wlOcT4CH9cCKwKkzlMFj/
         f7VG4Z0dgo3ZI/y8ZmsTx+sinw3iEo34SPNkjB0/bDsr2u0otq3foIu2C6rQkgSdalop
         e85QkY6JQONyHTMDM02d70Xpekz0K13Y5FM6Dk1bGfgpHjeWekjW/Hz9c/DGm+ShacHW
         kVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=FbfCv/VFiK++k/l6IxbsrJaOgfo8mznBykJsm9txdpo=;
        b=tnGzc/pxNjHasT0+4Aat3Jdz0RY4ycNPXn6dApk6VCDr1hS+7d2QocUxWxwCJjmdfC
         DoHYeMuyHSjDvDXaaQmML5dGeqAftztUwDPU0PCqeXDakDS4dBUsrAckHs/ypr8Xoc9t
         ppL3A1+qSoZFxjRIF14Sb+B31vosf4L638VdfEMuKTJ73tusmwWHzT/CMe0YG9qt0RXe
         d9XTPATJBOIyUNIlTDl7Aja35S2M4ynkSyrwqdwNC4mLnh+eyXJkH8/O5TOzRiE3Vd+h
         kALH2VA9QgjuQaY/F2uJmkaMWTKDg5NLRdOK6FizhyAHiCRLRBlgVzHdB6En/ULbcv1z
         V5rQ==
X-Gm-Message-State: ANhLgQ26hLgZiyUz790iqXbISoXDTtLrhsfbaQcl89e1YB5J48DBkzhh
        VZwPCqDcRnJM1a3sxac1T1nDzoXx
X-Google-Smtp-Source: ADFU+vtNfjkwKpRH6gY8vu62UQDuFYFFoSVZ76RsHPJdTKC6pNIu4s41sUqFOmLB671ZR48Ho9/q4w==
X-Received: by 2002:a63:374f:: with SMTP id g15mr22077325pgn.166.1585731607444;
        Wed, 01 Apr 2020 02:00:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x188sm1121879pfx.198.2020.04.01.02.00.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 02:00:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 4/5] esp6: support ipv6 nexthdrs process for beet gso segment
Date:   Wed,  1 Apr 2020 16:59:24 +0800
Message-Id: <585191d693fc74273d314d4dea9a781ccc7712c2.1585731430.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <3f782f13de69081251addd3b7b37d155805feba2.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
 <c089597acfb559c70b1485ec84d01a78c8341bb3.1585731430.git.lucien.xin@gmail.com>
 <59aafccde155f156544d54db1145d54ecd018d74.1585731430.git.lucien.xin@gmail.com>
 <3f782f13de69081251addd3b7b37d155805feba2.1585731430.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP6 hdr| ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

Before doing gso segment in xfrm6_beet_gso_segment(), it should
skip all nexthdrs and get the real transport proto, and set
transport_header properly.

This patch is to fix it by simply calling ipv6_skip_exthdr()
in xfrm6_beet_gso_segment().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/esp6_offload.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index b828508..021f58c 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -173,7 +173,7 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
-	int proto = xo->proto;
+	u8 proto = xo->proto;
 
 	skb->transport_header += x->props.header_len;
 
@@ -184,7 +184,13 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 		proto = ph->nexthdr;
 	}
 
-	if (x->sel.family != AF_INET6) {
+	if (x->sel.family == AF_INET6) {
+		int offset = skb_transport_offset(skb);
+		__be16 frag;
+
+		offset = ipv6_skip_exthdr(skb, offset, &proto, &frag);
+		skb->transport_header += offset;
+	} else {
 		skb->transport_header -=
 			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
 
-- 
2.1.0

