Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E4C209DE9
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404633AbgFYLzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:55:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404487AbgFYLzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:55:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593086109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z98FQrFFI6TBMbCHg6wJVE3Bm8z7MLEcouUfaDkGC9U=;
        b=EDRoV1WO6mHHlRbFATD/IJgkSb0wwPLWlrO3CXiKwmh1Cs5WSeruM76mEu8vUEqCGobOQ+
        P457AmteJk6Ox8kmegJyTaGWYHQkMq7CHmeGXIrbgOVzoqexIWDVqCq9Z0pJqpek+CfeNs
        a8aF8NKud3P4fV81SFKQ6zen6U9D1nM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-nHnLu6TiOTyXBXNPqdJN9Q-1; Thu, 25 Jun 2020 07:55:07 -0400
X-MC-Unique: nHnLu6TiOTyXBXNPqdJN9Q-1
Received: by mail-wm1-f69.google.com with SMTP id c66so6843863wma.8
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Z98FQrFFI6TBMbCHg6wJVE3Bm8z7MLEcouUfaDkGC9U=;
        b=gbJYzPyaE08IOD/PCJ/vxAENoBF3m7VU5vONMCswfvnb5+YLi8TgDhQvVbxsWWMeqO
         sPZoYEPPNbREPOrcCh41Y9Sxx5PoLOcyQWryvo7abqx6gXdimB4EGOmF6of1xNUXgeS6
         V3nM6QAJka+x76tGZM9+G/IoMLRgiWOEOBfyYd6dtw9H4++FuoMbj97NXt3Z0cW2H0ly
         KRPBi/KCopEzsf64aaD3kFcK8dwTCZaYjINaYuuX6N+hkZAsWpY3lRpUY0oeHR3TKZCA
         uNaLmI7OvFZcTWRexb9AhZCNJ3ZFpzudzAeCWXs0lcyCwDGWfG+wANdqQDoh/gsSKOIN
         OouA==
X-Gm-Message-State: AOAM532/BvBFek1o4fa3DJ2pc00WlLsNTM+I95qwwe2fnuet4X+PcpfO
        psGsJoyX8iU+IQ0/KyzqPw3IEkwKrck8lwpwDW64184L05giEYppa8cReOw2UJgm24Jn8L0P4yG
        hhwWBrO2mEShf8rkG
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr26496833wrx.286.1593086106877;
        Thu, 25 Jun 2020 04:55:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPg4eBO5p7yR0vm1SSGeY6BZ0h9JB+JlQVKoq3eiQbTCy2PH9vp5RNyrbVz5+QWDJ1ZZM4Nw==
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr26496817wrx.286.1593086106671;
        Thu, 25 Jun 2020 04:55:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 207sm13515653wme.13.2020.06.25.04.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 04:55:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 151F11814FC; Thu, 25 Jun 2020 13:55:05 +0200 (CEST)
Subject: [PATCH net-next 2/5] sch_cake: don't try to reallocate or unshare skb
 unconditionally
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 13:55:05 +0200
Message-ID: <159308610499.190211.5408420243803826056.stgit@toke.dk>
In-Reply-To: <159308610282.190211.9431406149182757758.stgit@toke.dk>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Ponetayev <i.ponetaev@ndmsystems.com>

cake_handle_diffserv() tries to linearize mac and network header parts of
skb and to make it writable unconditionally. In some cases it leads to full
skb reallocation, which reduces throughput and increases CPU load. Some
measurements of IPv4 forward + NAPT on MIPS router with 580 MHz single-core
CPU was conducted. It appears that on kernel 4.9 skb_try_make_writable()
reallocates skb, if skb was allocated in ethernet driver via so-called
'build skb' method from page cache (it was discovered by strange increase
of kmalloc-2048 slab at first).

Obtain DSCP value via read-only skb_header_pointer() call, and leave
linearization only for DSCP bleaching or ECN CE setting. And, as an
additional optimisation, skip diffserv parsing entirely if it is not needed
by the current configuration.

Fixes: c87b4ecdbe8d ("sch_cake: Make sure we can write the IP header before changing DSCP bits")
Signed-off-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
[ fix a few style issues, reflow commit message ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 0f594d88a957..cebcc36755ac 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1599,30 +1599,49 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 
 static u8 cake_handle_diffserv(struct sk_buff *skb, u16 wash)
 {
-	int wlen = skb_network_offset(skb);
+	const int offset = skb_network_offset(skb);
+	u16 *buf, buf_;
 	u8 dscp;
 
 	switch (cake_skb_proto(skb)) {
 	case htons(ETH_P_IP):
-		wlen += sizeof(struct iphdr);
-		if (!pskb_may_pull(skb, wlen) ||
-		    skb_try_make_writable(skb, wlen))
+		buf = skb_header_pointer(skb, offset, sizeof(buf_), &buf_);
+		if (unlikely(!buf))
 			return 0;
 
-		dscp = ipv4_get_dsfield(ip_hdr(skb)) >> 2;
-		if (wash && dscp)
+		/* ToS is in the second byte of iphdr */
+		dscp = ipv4_get_dsfield((struct iphdr *)buf) >> 2;
+
+		if (wash && dscp) {
+			const int wlen = offset + sizeof(struct iphdr);
+
+			if (!pskb_may_pull(skb, wlen) ||
+			    skb_try_make_writable(skb, wlen))
+				return 0;
+
 			ipv4_change_dsfield(ip_hdr(skb), INET_ECN_MASK, 0);
+		}
+
 		return dscp;
 
 	case htons(ETH_P_IPV6):
-		wlen += sizeof(struct ipv6hdr);
-		if (!pskb_may_pull(skb, wlen) ||
-		    skb_try_make_writable(skb, wlen))
+		buf = skb_header_pointer(skb, offset, sizeof(buf_), &buf_);
+		if (unlikely(!buf))
 			return 0;
 
-		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> 2;
-		if (wash && dscp)
+		/* Traffic class is in the first and second bytes of ipv6hdr */
+		dscp = ipv6_get_dsfield((struct ipv6hdr *)buf) >> 2;
+
+		if (wash && dscp) {
+			const int wlen = offset + sizeof(struct ipv6hdr);
+
+			if (!pskb_may_pull(skb, wlen) ||
+			    skb_try_make_writable(skb, wlen))
+				return 0;
+
 			ipv6_change_dsfield(ipv6_hdr(skb), INET_ECN_MASK, 0);
+		}
+
 		return dscp;
 
 	case htons(ETH_P_ARP):

