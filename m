Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43D831304
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfEaQuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:50:13 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33077 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaQuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:50:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id h17so4373816pgv.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vpCDadP+lypEq2qDT0dWFaVIhZacvzoPNWNfggfQPmk=;
        b=m34g5cKaekcZotfuEZ1MA04b5YwWQBHBjA+REf7/XN311W6O36ViTZ1RUWMG6zeKmH
         IjwiESHBv5NidjHUaqzwU+yr8SrzwA6xfumpsJqAwe7Gt02oEzrlWyDFDTVJT39bjQ17
         Cyt6M6c01c91V6yKF4bqsb8HgGp16aLscwQJ0g80+kkpxaTNG0ewQZd4utcthmnXk+Ft
         5AkX5Xj16VN/b80FzeLNJd1PtVUXpUz1LYJ3Y29iXI0IAFqGqS7hPGB/SU367wj0dlrn
         7Cvs5gsnjm5Y9GLdgb3aitmh9mHgc4dF0KlweHT9iF8wcndVqmk/i5Vq4RgsomFkL+yn
         a/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vpCDadP+lypEq2qDT0dWFaVIhZacvzoPNWNfggfQPmk=;
        b=X0jXnC/ahd7QvnUM2h29cVDrO+REjjSOuZm7L4UBzeIWephEGUxuEV+ozAsWqXdImM
         5Jl7lD7gPgqw/ESn2bldBVoRyk74LMmxaZu8p5l1g9pM4mQKygBRP9rt/b5nGCaoVkVv
         VyPUYUf3HBKN+9Jjba7fVG3nSZI3s63tXjp2ZRzZrvFtcHhXw01wS7INx9JcU68VgXhG
         jBrdtIEfkBUBN81nnd8AtCuSDsKuyxn1Scvd9DuD18i5cQzsuPEjihFc5GeHuYrXsx00
         Is78ZyJCh6aajhlaEBp7KJ7wKh/TEmpoOvIeu57YRPro4XJFVVgPDvEo4ftEHly2P0hB
         62Vw==
X-Gm-Message-State: APjAAAWv4YZI2ULSkW21qlJKvC67wbjchNBbjLh8fHvbkeX02r+qxg0e
        IHeBAQdV0jwnlr3kOjasAekYjg==
X-Google-Smtp-Source: APXvYqzg095K9eao8MVjfk1AX44tekMVeCFV8RoruRa5F72jche4aNZqs8QLi/0yV6PVgtAZR3EePQ==
X-Received: by 2002:a62:3741:: with SMTP id e62mr11382064pfa.213.1559321411307;
        Fri, 31 May 2019 09:50:11 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id e66sm8696835pfe.50.2019.05.31.09.50.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 May 2019 09:50:10 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com,
        ahabdels.dev@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC PATCH 5/6] ah6: Be explicit about which routing types are processed.
Date:   Fri, 31 May 2019 09:48:39 -0700
Message-Id: <1559321320-9444-6-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559321320-9444-1-git-send-email-tom@quantonium.net>
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code assumes that all routing headers can be processed
as type 0 when rearranging the routing header for AH verification.
Change this to be explicit. Type 0 and type 2 are supported and are
processed the same way with regards to AH.

Also check if rearranging routing header fails. Update reference
in comment to more current RFC.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 net/ipv6/ah6.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 1e80157..032491c 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -145,7 +145,7 @@ static bool zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr)
 /**
  *	ipv6_rearrange_destopt - rearrange IPv6 destination options header
  *	@iph: IPv6 header
- *	@destopt: destionation options header
+ *	@destopt: destination options header
  */
 static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *destopt)
 {
@@ -204,15 +204,16 @@ static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *des
 #endif
 
 /**
- *	ipv6_rearrange_rthdr - rearrange IPv6 routing header
+ *	ipv6_rearrange_type0_rthdr - rearrange type 0 IPv6 routing header
  *	@iph: IPv6 header
  *	@rthdr: routing header
  *
  *	Rearrange the destination address in @iph and the addresses in @rthdr
  *	so that they appear in the order they will at the final destination.
- *	See Appendix A2 of RFC 2402 for details.
+ *	See Appendix A2 of RFC 4302 for details.
  */
-static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
+static bool ipv6_rearrange_type0_rthdr(struct ipv6hdr *iph,
+				       struct ipv6_rt_hdr *rthdr)
 {
 	int segments, segments_left;
 	struct in6_addr *addrs;
@@ -220,15 +221,13 @@ static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 
 	segments_left = rthdr->segments_left;
 	if (segments_left == 0)
-		return;
+		return true;
 	rthdr->segments_left = 0;
 
 	/* The value of rthdr->hdrlen has been verified either by the system
 	 * call if it is locally generated, or by ipv6_rthdr_rcv() for incoming
 	 * packets.  So we can assume that it is even and that segments is
 	 * greater than or equal to segments_left.
-	 *
-	 * For the same reason we can assume that this option is of type 0.
 	 */
 	segments = rthdr->hdrlen >> 1;
 
@@ -240,6 +239,24 @@ static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 
 	addrs[0] = iph->daddr;
 	iph->daddr = final_addr;
+
+	return true;
+}
+
+static bool ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
+{
+	switch (rthdr->type) {
+	case IPV6_SRCRT_TYPE_2:
+		/* Simplified format of type 0 so same processing */
+		/* fallthrough */
+	case IPV6_SRCRT_TYPE_0: /* Deprecated */
+		return ipv6_rearrange_type0_rthdr(iph, rthdr);
+	default:
+		/* Bad or unidentified routing header, we don't know how
+		 * to fix this header for security purposes. Return failure.
+		 */
+		return false;
+	}
 }
 
 static int ipv6_clear_mutable_options(struct ipv6hdr *iph, int len, int dir)
@@ -271,7 +288,11 @@ static int ipv6_clear_mutable_options(struct ipv6hdr *iph, int len, int dir)
 			break;
 
 		case NEXTHDR_ROUTING:
-			ipv6_rearrange_rthdr(iph, exthdr.rth);
+			if (!ipv6_rearrange_rthdr(iph, exthdr.rth)) {
+				net_dbg_ratelimited("bad routing header\n");
+				return -EINVAL;
+			}
+
 			break;
 
 		default:
-- 
2.7.4

