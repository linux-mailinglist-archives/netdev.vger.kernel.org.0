Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B2B30466
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfE3V6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:58:45 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51023 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfE3V6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:58:45 -0400
Received: by mail-it1-f194.google.com with SMTP id a186so12566455itg.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3fARnAA4saHrsr4JO3DkGH7joPaWQTWPgsS0UFtWefI=;
        b=eWLAcZ9oj5H7z1SChhhz+Q4J+v0AXhPw7NjyM40/fIs9hfEQ40lJOk/P1rdSIB4KyP
         Lu8eHvPjQ85xOhDIUXRbRNKyvW1kxDoWtbrUFUTt06pvcsQPWfH0NHx5R5OL8+bLzqMn
         uPfvP3W+yJg9R04N/sANwOmkDk3+Jxyx26nnmkvjKWRhOPCVGOEMou0DcQdsp98YkRns
         U82D/Zl0KnuXmD6zyoeWsaDgUCWIlGU4jU4+NTmQawAO0nYpC8BDA6mgnhATV+zIGj+/
         quHq1ueBLp19LUxQPpyfrKFB5bchTC7KcRQcseHzkxvz0d64+3MkbGY5k5bCnUY2/mBF
         B4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3fARnAA4saHrsr4JO3DkGH7joPaWQTWPgsS0UFtWefI=;
        b=mcMXh25LVvLt57yJbdqm00Ire5b2IxQeOjnU/UhZ2KddwWULcKoec8uGAUIjKAWHVS
         mllGsfAMwzBqOrO/qE+KCZEf3qaeI/3mNRpzalfMW+mNPjRnoOmU3gWxk9UvnptXor9e
         Y2Bcxpzj2e6ZVUNGQSQdGbsoTZSdfg2WB7KMSmBscKulaMkDORysBOlX5tX53BoWE78C
         hHyNtE69wMi12+Go3ObfMn14DUZ7QNZtKngPiZd90M45G4KlJWLoJI/LRLvjKBj9lU6x
         Zlv/Ddg7tuOAKizv0gulHwO3LrRr3ouO8hbd6yf/ZNJegieNLbCviEyaTpw5iUdT/uJC
         0Iyg==
X-Gm-Message-State: APjAAAWOw3hik8GuIVkiNH2u0NafQ+PCw4yMtISyxeilGS4Z69FzlFh9
        lZCQUAfLs3TjhzrcMHlKO6n66A==
X-Google-Smtp-Source: APXvYqxrgcBfueAgzxmKvNIXqoe5R667v9x553hrmNxLGI1Q7oOOEpbQ80sfJhfbnNPrXz1Iyz7kZw==
X-Received: by 2002:a24:764e:: with SMTP id z75mr4499342itb.52.1559253061762;
        Thu, 30 May 2019 14:51:01 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id j125sm1662391itb.27.2019.05.30.14.51.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 14:51:01 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 6/6] seg6: Add support to rearrange SRH for AH ICV calculation
Date:   Thu, 30 May 2019 14:50:21 -0700
Message-Id: <1559253021-16772-7-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559253021-16772-1-git-send-email-tom@quantonium.net>
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mutable fields related to segment routing are: destination address,
segments left, and modifiable TLVs (those whose high order bit is set).

Add support to rearrange a segment routing (type 4) routing header to
handle these mutability requirements. This is described in
draft-herbert-ipv6-srh-ah-00.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 net/ipv6/ah6.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 032491c..0c5ca29 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -27,6 +27,7 @@
 #include <net/icmp.h>
 #include <net/ipv6.h>
 #include <net/protocol.h>
+#include <net/seg6.h>
 #include <net/xfrm.h>
 
 #define IPV6HDR_BASELEN 8
@@ -141,6 +142,13 @@ static bool zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr)
 	return __zero_out_mutable_opts(opthdr, 2, 0x20, IPV6_TLV_PAD1);
 }
 
+static bool zero_out_mutable_srh_opts(struct ipv6_sr_hdr *srh)
+{
+	return __zero_out_mutable_opts((struct ipv6_opt_hdr *)srh,
+				       seg6_tlv_offset(srh), 0x80,
+				       SR6_TLV_PAD1);
+}
+
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 /**
  *	ipv6_rearrange_destopt - rearrange IPv6 destination options header
@@ -243,6 +251,20 @@ static bool ipv6_rearrange_type0_rthdr(struct ipv6hdr *iph,
 	return true;
 }
 
+static bool ipv6_rearrange_type4_rthdr(struct ipv6hdr *iph,
+				       struct ipv6_rt_hdr *rthdr)
+{
+	struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)rthdr;
+
+	if (!zero_out_mutable_srh_opts(srh))
+		return false;
+
+	rthdr->segments_left = 0;
+	iph->daddr = srh->segments[0];
+
+	return true;
+}
+
 static bool ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 {
 	switch (rthdr->type) {
@@ -251,6 +273,8 @@ static bool ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 		/* fallthrough */
 	case IPV6_SRCRT_TYPE_0: /* Deprecated */
 		return ipv6_rearrange_type0_rthdr(iph, rthdr);
+	case IPV6_SRCRT_TYPE_4:
+		return ipv6_rearrange_type4_rthdr(iph, rthdr);
 	default:
 		/* Bad or unidentified routing header, we don't know how
 		 * to fix this header for security purposes. Return failure.
-- 
2.7.4

