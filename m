Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EA431305
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfEaQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:50:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36843 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfEaQuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:50:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id u22so6552837pfm.3
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3fARnAA4saHrsr4JO3DkGH7joPaWQTWPgsS0UFtWefI=;
        b=i3NGirUgdB+JgKnMWfZ/mkvmGpAE5gc6hiOT3qLhO0sy7/Ja5/92MVGG1Ke3yWGwKI
         671UPmRePhO4zo9RtAMbIwejNkK+ygeMi4F/gOFbrwiNVdexiVvFU+vtq2x2PIarG5Ad
         JLopBj5TNCqfha+gW6mmaNMVAVUcW3a5f0SBkSe6bYJIn0mVmzj5MDIjF/mgSXP9X3w4
         BrdNOD2vosYsZqp9PM1IcsaWJh/jRyQXPGtONVepMienY8rbyrXuFOVz7uWKQbHgOmKC
         ymJoprqw3OdHmDxqIWoFIxX59/Eu/JzOPj0If8wvPzeoCh5Xjn7nptJq0RneEwJ0Zk+L
         +Z4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3fARnAA4saHrsr4JO3DkGH7joPaWQTWPgsS0UFtWefI=;
        b=kW8CdOHZNCbgPDCyf9NPQO/11LgHJiKOJ7BWWSXFv3bEpNmGiLi0YRCIO4E69qOxwh
         S8eOR/fHRGHbd0W1ggCL4tK/8GcFPka0pxrfklP0zLeQrwaLTiaRu6SI5IUth1UGm+AA
         Iygo2Br9EVG6/7dwwMLJaTgURdALz59h1/enBzz0HUC65SNpfWS4H8/YsMwUZuZs460z
         CYWUIKjyXhNR3vs1szItE07GW2c+NpOo7MJWNJVTM0NG99BD1MqFdqePkIa0q8xZcTb7
         GVm7oZOKiJEFJKuQmmfHlmn/JQphYIfz1YVKhJkd3Up1c9YoWeK2MrAqJGF0Pah27z61
         k4Xw==
X-Gm-Message-State: APjAAAWlPIIHVyU/VeSAbmbpzJkhWeGMHa1ka2kAbbzCAyM9bHUQWWNg
        /AX9n7WSoOhGzSWs0pFZ5grGyA==
X-Google-Smtp-Source: APXvYqzrUQBM1vWA9tLZWnUXRjpfeZws7KRnero/WT7imxiIwPSaQMnBm9luGjAB4b/OF28xUKNgrg==
X-Received: by 2002:a17:90a:8c82:: with SMTP id b2mr10400285pjo.97.1559321413223;
        Fri, 31 May 2019 09:50:13 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id e66sm8696835pfe.50.2019.05.31.09.50.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 May 2019 09:50:12 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com,
        ahabdels.dev@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC PATCH 6/6] seg6: Add support to rearrange SRH for AH ICV calculation
Date:   Fri, 31 May 2019 09:48:40 -0700
Message-Id: <1559321320-9444-7-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559321320-9444-1-git-send-email-tom@quantonium.net>
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
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

