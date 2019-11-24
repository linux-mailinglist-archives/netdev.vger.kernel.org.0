Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33B310835E
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 14:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKXNYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 08:24:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37673 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfKXNYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 08:24:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id t1so14221288wrv.4
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 05:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=h/sA0xMBs7QYRSG/VREkNXDxfrPl9iI1XD746Onk7G0=;
        b=dLcBW3BKQcUXngIxILincEA9xIkyS8RFtddtWMhd7oTNlX4PyfsXxjFqsQKfl+rSkP
         AJvakn2IszKGlVSe1oQOaKiGfOPylFMWK/B50GTWP2ntG1haOPBoDX08CBIFHlthap11
         33IUCEMGqWjCmP2pU4x74TyQqvQ8WAK1tjn9FJblE9dCz3z5tdtGizu5Wyi+9pT+Q1sV
         hWo66kGvx11K3RHLtik3ZnuW5Sgc5o/UNn3S18peob6HebRdqZF40t3f4mn5tiXMbuFI
         rx/zpXnOmk6BHJ3E2Gh2M16tw1HckpisdM112IhbswIL7cCcuahndusj5FwGZAVZbB+T
         6eZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=h/sA0xMBs7QYRSG/VREkNXDxfrPl9iI1XD746Onk7G0=;
        b=T7ZhsAR81UqXlNEUpGMyEaM1dICAIMGWdRuEpZeYYon0RK8swu18JA3Dfq5MZQWxT0
         nCIf0Utr+bXT2ODb4duST2Y5VV9MdXQTakBWBHXJkFACwsPKho36MGNc2RYisCQnxemI
         hLO8ARF5asRxmRTSubrJA12szQQf/2zq0ZcNIC86dLM87rq/1/Rb8+LhXuprlOLoZ9Sa
         N82qmQoVAt/5p7jx8O9z7L4d4ToYXKhYUhrbyHXbwzk4mPM929/jkrWGj3u6Afa8EDdj
         APL7xI+KLlhXsfNjyJPw2S8PgFKgY8yUVaL+ZPxJuST6ACgFchnCzDsn9HUvuq7mqVob
         N6fQ==
X-Gm-Message-State: APjAAAXAnKfg4anD/gvcau48rdyIfWOQhIMqJOWVlr4XEN+/jtSocXNo
        P59sIFg1uorWxL32gI4xa+Sj/BlytesZaQ==
X-Google-Smtp-Source: APXvYqwsPW8Ix9siZ6cEpm4PLlIwiyu7abcd0eYzx8gf1x2s+Sk6weXQ0o2Ny30W1nFLEUs00p0Sbg==
X-Received: by 2002:a5d:574d:: with SMTP id q13mr28231242wrw.263.1574601859992;
        Sun, 24 Nov 2019 05:24:19 -0800 (PST)
Received: from fuckup ([185.232.103.167])
        by smtp.gmail.com with ESMTPSA id a26sm4893973wmm.14.2019.11.24.05.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 05:24:19 -0800 (PST)
Date:   Sun, 24 Nov 2019 14:24:18 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment is not
 set
Message-ID: <20191124132418.GA13864@fuckup>
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
From RFC 6864 "Updated Specification of the IPv4 ID Field" section 4.1:
"The IPv4 ID field MUST NOT be used for purposes other than fragmentation and
reassembly."
Calculating the identification takes significant CPU time.
This patch will increase IP tunneling performance by ~10% unless DF is not set.
However, DF is set by default which is best practice.
For security reason this patch will set ID to zero when ID is not needed to
prevent leaking random information.

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
Changes in v2:
  - Add source of assertion into commit message.
  - Correct check of DF flag.
  - Set iph->id to 0 when DF if not set to avoid leaking information.

 net/ipv4/ip_tunnel_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 1452a97914a0..ea12c8cc9e83 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -73,7 +73,11 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 	iph->daddr	=	dst;
 	iph->saddr	=	src;
 	iph->ttl	=	ttl;
-	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
+
+	if (likely((iph->frag_off & htons(IP_DF)) == htons(IP_DF)))
+		iph->id = 0;
+	else
+		__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
 
 	err = ip_local_out(net, sk, skb);
 
-- 
2.19.1

