Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998D031301
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfEaQuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:50:06 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33008 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaQuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:50:05 -0400
Received: by mail-pf1-f195.google.com with SMTP id x10so1434604pfi.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YJmpws5TGF/hnX4HmYz7C4rytybEFExKaeoFkpkkjDM=;
        b=p2F0m8vPVdIj+11/uYf392GRhrtF3WwLT9hZpOljhBjpVYzTVU9jQ4ivMPlgs2l706
         IKpwUKKTIqHTjgb2W/25+wytW+l0ORoeUtDc8TpxKBHVwKroO2P8SfNqZwSDh0MVeedD
         hWCbw7fahA2BXAZhjaIafQCkU2sbgEXQwSTOFgD8yoEwaZ71+wtxfrqA5uyK3rYn6wa5
         QPpR80hdg41Hrk97xfYQr/zjy+devosoBahN6SlbGQRMSgYddx9fOxXEVTZ3w213/0+N
         t2l2chV3/2fwEhqRZcLl5kQBWKoWciWmkIpkysWOgKIWcoJ6h7+Tdj7kM/Pv5NDh5YhT
         2ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YJmpws5TGF/hnX4HmYz7C4rytybEFExKaeoFkpkkjDM=;
        b=WReQj2Ush74bNF7Or2jnPI6h/naAnF3Dvaa+DJgGQLH7GCORMGothrAW8bHJG/oXCv
         3MBvb2fBPcqU/9P4vXKLKAf4waRKSOLVE9asrRClcCesH4EAKZ+VZ0SI3TOro4RVeurp
         iRTnt701+Fbb6hpnoFToSWiVlv8Do2h/LYOWN2CmMU8AQUTGmUColitnBiKw+Zm8So5y
         7gqC1Olp47WpgyWEZk+slP9oI0CU1tqrFGNuim/cBXKIzki5+rWVqLWo5+/NRnoX9zgh
         X6wEdEnCa06CmDyUmay079v4i5d+igcsaHKNy3DQhCypp5WRMU0dTQPW8ei7EiBeRFnR
         ZgQg==
X-Gm-Message-State: APjAAAUH1myzoeMo9CfRMha2umLG5RjpeiIuRkHtkZeIz+P2IZ+tShEr
        WpkJZh9aQ7iEpCbLxFUJa7A/vA==
X-Google-Smtp-Source: APXvYqwGh5ed/OYPhZ4Lkgi4xulMHlXOKD9TiyV52ZL19xIIusqpW58y1M2D1OKZ7hopj9KUlIkPIg==
X-Received: by 2002:a65:5206:: with SMTP id o6mr10636247pgp.248.1559321405076;
        Fri, 31 May 2019 09:50:05 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id e66sm8696835pfe.50.2019.05.31.09.50.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 May 2019 09:50:04 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com,
        ahabdels.dev@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC PATCH 2/6] seg6: Implement a TLV parsing loop
Date:   Fri, 31 May 2019 09:48:36 -0700
Message-Id: <1559321320-9444-3-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559321320-9444-1-git-send-email-tom@quantonium.net>
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a TLV parsing loop for segment routing. The code is uniform
with other instances of TLV parsing loops in the stack (e.g. parsing of
Hop-by-Hop and Destination Options).

seg_validate_srh calls this function. Note, this fixes a bug in the
original parsing code that PAD1 was not supported.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/seg6.h |  6 ++++++
 net/ipv6/seg6.c    | 60 +++++++++++++++++++++++++++++++-----------------------
 2 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 8b2dc68..563d4a6 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -38,6 +38,11 @@ static inline void update_csum_diff16(struct sk_buff *skb, __be32 *from,
 	skb->csum = ~csum_partial((char *)diff, sizeof(diff), ~skb->csum);
 }
 
+static inline unsigned int seg6_tlv_offset(struct ipv6_sr_hdr *srh)
+{
+	return sizeof(*srh) + ((srh->first_segment + 1) << 4);
+}
+
 struct seg6_pernet_data {
 	struct mutex lock;
 	struct in6_addr __rcu *tun_src;
@@ -62,6 +67,7 @@ extern void seg6_iptunnel_exit(void);
 extern int seg6_local_init(void);
 extern void seg6_local_exit(void);
 
+extern bool __seg6_parse_srh(struct ipv6_sr_hdr *srh);
 extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 0c5479e..e461357 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -30,44 +30,52 @@
 #include <net/seg6_hmac.h>
 #endif
 
-bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
+bool __seg6_parse_srh(struct ipv6_sr_hdr *srh)
 {
-	int trailing;
-	unsigned int tlv_offset;
+	int len = ipv6_optlen((struct ipv6_opt_hdr *)srh);
+	unsigned char *opt = (unsigned char *)srh;
+	unsigned int off;
 
-	if (srh->type != IPV6_SRCRT_TYPE_4)
-		return false;
+	off = seg6_tlv_offset(srh);
+	len -= off;
 
-	if (((srh->hdrlen + 1) << 3) != len)
-		return false;
+	while (len > 0) {
+		struct sr6_tlv *tlv;
+		unsigned int optlen;
 
-	if (srh->segments_left > srh->first_segment)
-		return false;
+		switch (opt[off]) {
+		case SR6_TLV_PAD1:
+			optlen = 1;
+			break;
+		default:
+			if (len < sizeof(*tlv))
+				return false;
 
-	tlv_offset = sizeof(*srh) + ((srh->first_segment + 1) << 4);
+			tlv = (struct sr6_tlv *)&opt[off];
+			optlen = sizeof(*tlv) + tlv->len;
 
-	trailing = len - tlv_offset;
-	if (trailing < 0)
-		return false;
+			break;
+		}
 
-	while (trailing) {
-		struct sr6_tlv *tlv;
-		unsigned int tlv_len;
+		off += optlen;
+		len -= optlen;
+	}
 
-		if (trailing < sizeof(*tlv))
-			return false;
+	return !len;
+}
 
-		tlv = (struct sr6_tlv *)((unsigned char *)srh + tlv_offset);
-		tlv_len = sizeof(*tlv) + tlv->len;
+bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
+{
+	if (srh->type != IPV6_SRCRT_TYPE_4)
+		return false;
 
-		trailing -= tlv_len;
-		if (trailing < 0)
-			return false;
+	if (ipv6_optlen((struct ipv6_opt_hdr *)srh) != len)
+		return false;
 
-		tlv_offset += tlv_len;
-	}
+	if (srh->segments_left > srh->first_segment)
+		return false;
 
-	return true;
+	return __seg6_parse_srh(srh);
 }
 
 static struct genl_family seg6_genl_family;
-- 
2.7.4

