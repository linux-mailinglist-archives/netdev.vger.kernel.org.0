Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2266E30451
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfE3V4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:56:11 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:51614 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfE3V4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:56:11 -0400
Received: by mail-it1-f195.google.com with SMTP id m3so12535637itl.1
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YJmpws5TGF/hnX4HmYz7C4rytybEFExKaeoFkpkkjDM=;
        b=sMO1fe7n55hJzPH1pW8GBWTluQhDe+68+lU+M+74ZWmRpCDtzDpgDQ7/aZYLRwSZ8q
         CDlBB75ux8ThVYd6Hde0YteBNcJvSz2IaJb/wj5vvoc6kHcRDID92DEpYmZH6pAn8N/B
         28Q9Ekuh/PHhU7+qmscxBvCUbbt/1IkbVDd4kymJaEP+DE2hwP460fDb/XKP1vF5hB70
         Xp/WKqoldvpFENpjLo8/a+D0f/kHxU0AEc3Q8pshV3ywE8fQwuWCt2muqe/7+Ltz8Pgf
         9l64uIOKniWCUvlzNmByBJ3y7ID9HN/bwWT6SfFrEoN0tcvnVj4D2wwpEu0IN3c3+hib
         at3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YJmpws5TGF/hnX4HmYz7C4rytybEFExKaeoFkpkkjDM=;
        b=DFsmT36n8aj0I8tubfCfjEbvUhqvdA1d9KfPchZyAbCHJs6tspcR5a8Gg6rhxi+Uls
         3FFObcjqTslRXeKHlJsdTT3aefu9cf9XmNtyfdnKk2Q9YhOH0Jt4rvwHx+9GgWVMiSoz
         3m5bPQrueXq1skxXRSnevGB84hLuDt7u3oJkpkEDg1h8meL/QNiJaV3iHlPYbjldfA01
         ifT6FzxLj8TNCudUGRjSNUoUasrSFriNnc3Y/QSmhIjdgUhzzdp9BR4lVd4tqDF1Oal6
         KeKQjkbRysVcTNwjK54U4XpJbna68yD0G2+NIkY9FWMrr2XDyjri4shNwly8rLW1bNFS
         pDLg==
X-Gm-Message-State: APjAAAXWWOOn0vS4VH0fXU/XDeMRE/k1zaH1tPUsUQSTOXDbKTfta+nw
        AqC48X/2lE/IHQin+FbOKOzANg==
X-Google-Smtp-Source: APXvYqwlDSjwl8xvMJM+Dwfin2KBMeE8EeI85VqQTJK3VABV4Abl/WleuolkgHaNw8iOx/QG2bf4vA==
X-Received: by 2002:a24:16c6:: with SMTP id a189mr4414664ita.179.1559253054044;
        Thu, 30 May 2019 14:50:54 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id j125sm1662391itb.27.2019.05.30.14.50.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 14:50:53 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 2/6] seg6: Implement a TLV parsing loop
Date:   Thu, 30 May 2019 14:50:17 -0700
Message-Id: <1559253021-16772-3-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559253021-16772-1-git-send-email-tom@quantonium.net>
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
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

