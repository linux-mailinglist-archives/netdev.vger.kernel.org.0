Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4786330463
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfE3V6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:58:33 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:37531 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfE3V6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:58:33 -0400
Received: by mail-it1-f195.google.com with SMTP id s16so11981319ita.2
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u0wxAgS7Z04gKq+rNXYKLmGUgzsQiof5BnxwwNZbDGE=;
        b=fL2gtpioVH9ojFTDJmjtgMGh6lcy+CV4nA29p5lVQnBgALHnhMIkM+6vLn9JVu8s20
         bb5t6+TvdAVWUIPVWDr40bIcYMdBgIopkynG+NSLJduzUArbfEAPVmawW5iUsr/EMSkp
         kJ/lQ+0MqLDyK8tRuA/UsMQxd02tTpf1TPvBXaOYyBij0D4Qh63o1BHzQeQYF+mJbaPA
         ma7u4X+aVOr8b0zWVs5ba7Nr5TcpfzksyzjUCD34QTh8PP7cg8tjVrEkuebyuAODBQEn
         XapYgGqLBh0+uAmBzrjJoh9+BDCV6fUKK7uDWRZMX2UT/DlCumwWwXpDkfgxKoR8mD3T
         8aRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u0wxAgS7Z04gKq+rNXYKLmGUgzsQiof5BnxwwNZbDGE=;
        b=BSGVDNkDsNdfCt7sZV7CEJ5OHOnqdWp2b1J2fY9jAKLHtkR3TMgzCYbgwFX4HcIn20
         CbtlJqsiKZHBfKFYNcfN6J7NOVByjfHiX5k0xOzZiiemor2DDrbRyMhI3ymFfIybGhyp
         HHbpS7iNsD8sb+lk7MhOxTU9JngaRx116/HRxgeuHYZVmVsjbb5GaekrXso0HUbpOxtD
         HTPpD14IbVA7msmKg3rMr4ZpiVqXOoj/v7RHli5r8DQOrqPcVxe0ritENWRFODuhxdGi
         6XHBx35Q8z/OUQwp+4iqdjOz7TL69Ml3dt0MSJhun4T+ORxooUFjXfAah5XzkS7oVsSM
         iVAw==
X-Gm-Message-State: APjAAAWRWsjDU4eCQxBQB4yoChzhpVFSEgAvbfPumATLF0shL3YN5vNZ
        nValxY6wc07U0e4DM+48vOajPw==
X-Google-Smtp-Source: APXvYqxqxb0528ie53xElUrwakG++8qTsNpozwrBMs4UmdBSENabvsQqKtMrMpxapLyKj8GubANmig==
X-Received: by 2002:a05:660c:1cc:: with SMTP id s12mr3833910itk.170.1559253055515;
        Thu, 30 May 2019 14:50:55 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id j125sm1662391itb.27.2019.05.30.14.50.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 14:50:55 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 3/6] seg6: Remove HMAC flag and implement seg6_find_hmac_tlv
Date:   Thu, 30 May 2019 14:50:18 -0700
Message-Id: <1559253021-16772-4-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559253021-16772-1-git-send-email-tom@quantonium.net>
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HMAC flag is no longer defined in the SRH specification. Remove
it and any uses of it.

This includes removal of sr_has_hmac. We replace this function with
seg6_find_hmac_tlv. That function parses (via __seg6_parse_srh) a
TLV list and returns the pointer to an HMAC TLV if one exists. The
parsing function also eliminates the assumption in seg6_get_tlv_hmac
that the HMAC TLV must be the first TLV.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/seg6.h        | 12 +++++++++++-
 include/uapi/linux/seg6.h |  3 ---
 net/ipv6/exthdrs.c        |  2 +-
 net/ipv6/seg6.c           | 12 ++++++++++--
 net/ipv6/seg6_hmac.c      |  8 +++-----
 net/ipv6/seg6_iptunnel.c  |  4 ++--
 6 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 563d4a6..47e7c90 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -17,6 +17,7 @@
 #include <linux/net.h>
 #include <linux/ipv6.h>
 #include <linux/seg6.h>
+#include <linux/seg6_hmac.h>
 #include <linux/rhashtable-types.h>
 
 static inline void update_csum_diff4(struct sk_buff *skb, __be32 from,
@@ -67,11 +68,20 @@ extern void seg6_iptunnel_exit(void);
 extern int seg6_local_init(void);
 extern void seg6_local_exit(void);
 
-extern bool __seg6_parse_srh(struct ipv6_sr_hdr *srh);
+extern bool __seg6_parse_srh(struct ipv6_sr_hdr *srh,
+			     struct sr6_tlv_hmac **hmacp);
 extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
 extern int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 			       u32 tbl_id);
+
+static inline struct sr6_tlv_hmac *seg6_find_hmac_tlv(struct ipv6_sr_hdr *srh)
+{
+	struct sr6_tlv_hmac *hmacp = NULL;
+
+	return __seg6_parse_srh(srh, &hmacp) ? hmacp : NULL;
+}
+
 #endif
diff --git a/include/uapi/linux/seg6.h b/include/uapi/linux/seg6.h
index a69ce16..ca14df4 100644
--- a/include/uapi/linux/seg6.h
+++ b/include/uapi/linux/seg6.h
@@ -36,14 +36,11 @@ struct ipv6_sr_hdr {
 #define SR6_FLAG1_PROTECTED	(1 << 6)
 #define SR6_FLAG1_OAM		(1 << 5)
 #define SR6_FLAG1_ALERT		(1 << 4)
-#define SR6_FLAG1_HMAC		(1 << 3)
 
 #define SR6_TLV_PAD1		0
 #define SR6_TLV_PADDING		1
 #define SR6_TLV_HMAC		5
 
-#define sr_has_hmac(srh) ((srh)->flags & SR6_FLAG1_HMAC)
-
 struct sr6_tlv {
 	__u8 type;
 	__u8 len;
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 20291c2..112e2fd 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -922,7 +922,7 @@ static void ipv6_push_rthdr4(struct sk_buff *skb, u8 *proto,
 	}
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	if (sr_has_hmac(sr_phdr)) {
+	if (seg6_find_hmac_tlv(sr_phdr)) {
 		struct net *net = NULL;
 
 		if (skb->dev)
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index e461357..1e782a6 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -30,7 +30,7 @@
 #include <net/seg6_hmac.h>
 #endif
 
-bool __seg6_parse_srh(struct ipv6_sr_hdr *srh)
+bool __seg6_parse_srh(struct ipv6_sr_hdr *srh, struct sr6_tlv_hmac **hmacp)
 {
 	int len = ipv6_optlen((struct ipv6_opt_hdr *)srh);
 	unsigned char *opt = (unsigned char *)srh;
@@ -39,6 +39,8 @@ bool __seg6_parse_srh(struct ipv6_sr_hdr *srh)
 	off = seg6_tlv_offset(srh);
 	len -= off;
 
+	*hmacp = NULL;
+
 	while (len > 0) {
 		struct sr6_tlv *tlv;
 		unsigned int optlen;
@@ -47,6 +49,10 @@ bool __seg6_parse_srh(struct ipv6_sr_hdr *srh)
 		case SR6_TLV_PAD1:
 			optlen = 1;
 			break;
+		case SR6_TLV_HMAC:
+			if (!*hmacp)
+				*hmacp = (struct sr6_tlv_hmac *)&opt[off];
+			/* Fall through */
 		default:
 			if (len < sizeof(*tlv))
 				return false;
@@ -66,6 +72,8 @@ bool __seg6_parse_srh(struct ipv6_sr_hdr *srh)
 
 bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
 {
+	struct sr6_tlv_hmac *hmacp;
+
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
 
@@ -75,7 +83,7 @@ bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
 	if (srh->segments_left > srh->first_segment)
 		return false;
 
-	return __seg6_parse_srh(srh);
+	return __seg6_parse_srh(srh, &hmacp);
 }
 
 static struct genl_family seg6_genl_family;
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 8546f94..92b398c 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -95,13 +95,11 @@ static struct sr6_tlv_hmac *seg6_get_tlv_hmac(struct ipv6_sr_hdr *srh)
 	if (srh->hdrlen < (srh->first_segment + 1) * 2 + 5)
 		return NULL;
 
-	if (!sr_has_hmac(srh))
+	tlv = seg6_find_hmac_tlv(srh);
+	if (!tlv)
 		return NULL;
 
-	tlv = (struct sr6_tlv_hmac *)
-	      ((char *)srh + ((srh->hdrlen + 1) << 3) - 40);
-
-	if (tlv->tlvhdr.type != SR6_TLV_HMAC || tlv->tlvhdr.len != 38)
+	if (tlv->tlvhdr.len != sizeof(*tlv) - 2)
 		return NULL;
 
 	return tlv;
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 7a525fd..5344bee 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -161,7 +161,7 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	if (sr_has_hmac(isrh)) {
+	if (seg6_find_hmac_tlv(isrh)) {
 		err = seg6_push_hmac(net, &hdr->saddr, isrh);
 		if (unlikely(err))
 			return err;
@@ -211,7 +211,7 @@ int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 	hdr->daddr = isrh->segments[isrh->first_segment];
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	if (sr_has_hmac(isrh)) {
+	if (seg6_find_hmac_tlv(isrh)) {
 		struct net *net = dev_net(skb_dst(skb)->dev);
 
 		err = seg6_push_hmac(net, &hdr->saddr, isrh);
-- 
2.7.4

