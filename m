Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E2F20A667
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390554AbgFYUMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:12:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43057 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389344AbgFYUMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593115931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mN7Y1KGa2J2xgeNCzqBVm8zM5KlsQKQcbLdGW8o5Jko=;
        b=gqfyMhluIwMjrl5gqA/BGK7ylQEm+9a3Z18Nq9hZjtvYM+iAR8lpt8eg4loiGA0kyP/bcQ
        /KvoLgOQfq6YMSQOb3Gb3w+CsrAe2KiZvG4JxoHeeJJYPNFqPQKp7YdR/G9GoQClKoNXuw
        0Gy9kgets5GtFT7dp5r05OY1v2NUZwA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-Xa6OYOq3OCe6XK-l0-U-5Q-1; Thu, 25 Jun 2020 16:12:10 -0400
X-MC-Unique: Xa6OYOq3OCe6XK-l0-U-5Q-1
Received: by mail-ed1-f72.google.com with SMTP id h5so5970161edl.7
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mN7Y1KGa2J2xgeNCzqBVm8zM5KlsQKQcbLdGW8o5Jko=;
        b=jnT9psfukrnrN+lQavusbY5oR2Lp+jtJkS4gmPFXWo9BT70Bem6FFv+b/qJr4HjS1Y
         EEOry5BTuU0N2VIg45FKtq+Htkd2loTloQs3Gd2QTJU3mN1LX5hQyiW8AbbT8Ch5nOen
         n6e5Z3h+Ai6NtM5zDOKkYlrS1MTlvdIGdIlszmwvuzyrCvWldlGIwfmecSe68jNBkvtf
         oamnb34FLWEv6/vxpj5GuR6juXBiAJ7l4ttYjsxVMmpkb9roBXg6buPNCL1WuMIkIDAC
         YKDt1SQgrJO5iROb0RgOReyc2EUWqu1pb28oFUikTD6h3zGQ2+YIt4KK4VSqjJNaaVea
         DZHg==
X-Gm-Message-State: AOAM531gEY6N/LjiHasAFWL7M6/LfJ03bvzk5Z5/SpwPIR4bVUzh4Kml
        7hP/8p29ZNm2chmdm6x16KgTfFcHkaXsrmlNpG7bGss6Bc6XDdh9U8eiBCWmJNpDI5LUhY7f3ss
        51zKd94Y+PFfTKRSt
X-Received: by 2002:aa7:c407:: with SMTP id j7mr14112610edq.96.1593115928929;
        Thu, 25 Jun 2020 13:12:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyp7QvmjJwBiH/dfiy9QdMEtZMuD1OjwUyOp8+bCFpFIw2UNiSUMdidP3us9YRTOpD6oHnF9Q==
X-Received: by 2002:aa7:c407:: with SMTP id j7mr14112592edq.96.1593115928709;
        Thu, 25 Jun 2020 13:12:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f1sm18891018edn.66.2020.06.25.13.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 13:12:07 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 38F591814FA; Thu, 25 Jun 2020 22:12:07 +0200 (CEST)
Subject: [PATCH net 1/3] sch_cake: don't try to reallocate or unshare skb
 unconditionally
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 22:12:07 +0200
Message-ID: <159311592714.207748.900920527922661905.stgit@toke.dk>
In-Reply-To: <159311592607.207748.5904268231642411759.stgit@toke.dk>
References: <159311592607.207748.5904268231642411759.stgit@toke.dk>
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
index 60f8ae578819..cae006bef565 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1553,30 +1553,49 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 
 static u8 cake_handle_diffserv(struct sk_buff *skb, u16 wash)
 {
-	int wlen = skb_network_offset(skb);
+	const int offset = skb_network_offset(skb);
+	u16 *buf, buf_;
 	u8 dscp;
 
 	switch (tc_skb_protocol(skb)) {
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

