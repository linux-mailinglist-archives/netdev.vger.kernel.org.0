Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF35B12859A
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 00:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLTXjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 18:39:36 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39286 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfLTXje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 18:39:34 -0500
Received: by mail-pg1-f194.google.com with SMTP id b137so5700383pga.6
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 15:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PF2xxBw/8ZTqgRxuoSlACHBaNaHpk9hBOATBfltk5zo=;
        b=QL3oX++XcJeBmVbfS7+grUbOPv8k0zN7KCcKBJ7SZR/FnJM4uwR7rbpiJ/KVoRSQv0
         Z5U/hhE7rxPkkKc1wYL/MXSpk7fFGLq4c0nG3y75+T+Fej1bJNWx7IWw9zK+Mmvswx5E
         qZIKBPY3hE0ZyCNjfZpZBHhk7+iW8WN/HP5Wz5h9YUhLiObS71cKHEi9u/nGz//0ndQt
         xCeV2MdMxSjcrOBZg1UUiE9909Jsw9SKAXG4VIFR3W1fac/1enNULVkkPCKry2OdwC2t
         yLIMrKiFzWSmsD0//9UJxtDC/t8YgWEKXsu9v9HSnStNpKezQiJKpwgCTSQ9SevhGlp5
         qauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PF2xxBw/8ZTqgRxuoSlACHBaNaHpk9hBOATBfltk5zo=;
        b=NwC68i3BFSXyaxM7dQpQn6bwvT7TH7WWADi2EjgYHMewmaxy8VLZgCta9I9NwPPKrg
         YMvW98omDJdOzwoQCVyiO7XNBhNPAbeSzCYZrHL2OUy7i3yhu8QCZlZ32qJxmIocwyho
         BHAG1gJJMtrI3FlsmRLhd0z9gX4cm12uMfuilZFLoCQe/dRrQEq1iHWZh/7riMYUf0Ae
         OV+Ok1k4jHbTJk137Z/edh/G/3VfgrjlbgmBUa3UZukax1avA8kTxcEYXIS1XXueFhIV
         gzZ4ONpTZXx72VtTSXexDqlKyfMMmu3HppINoM4ZTRMGOb7DJTYA/sBR+1dhksEHexom
         1f1w==
X-Gm-Message-State: APjAAAUZ5m45FGNfYTxlRerj1BwmmaiDKuUbZR+flptc/wqH6aqY0MJ+
        hpg5YxWzsM87uhWw4hTooDxtNA==
X-Google-Smtp-Source: APXvYqx4t4wV/isLHY5BjdKQ31Ywu4Ozx7AawIZxirobE2zvmCsZzbh9d00PpaqIN+CrvQTm7h6cZw==
X-Received: by 2002:a63:1c13:: with SMTP id c19mr17866481pgc.450.1576885173373;
        Fri, 20 Dec 2019 15:39:33 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id 207sm14833555pfu.88.2019.12.20.15.39.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 15:39:32 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v6 net-next 5/9] ipeh: Add callback to ipeh_parse_tlv to handle errors
Date:   Fri, 20 Dec 2019 15:38:40 -0800
Message-Id: <1576885124-14576-6-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576885124-14576-1-git-send-email-tom@herbertland.com>
References: <1576885124-14576-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

Add a callback function to ipeh_parse_tlv so that the caller
can handler parsing errors in an appropriate way.

The enum ipeh_parse_errors contains the various errors and the
particular error is an argument of the callback.

ipv6_parse_error is the callback function for parsing IPv6 TLVs.
This mostly subsumes the functionality of ip6_tlvopt_unknown which
is removed.

The callback is called at various points in ipeh_parse_tlv when an
error is encountered. If the callback returns false then the packet
is discarded, else on true being returned the error is not fatal and
TLV processing continues (for instance, an unknown TLV is to be
ignored).

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 include/net/ipeh.h        | 17 +++++++++-
 net/ipv6/exthdrs.c        | 59 ++++++++++++++++++++++++++++++++--
 net/ipv6/exthdrs_common.c | 80 ++++++++++++++++++-----------------------------
 3 files changed, 103 insertions(+), 53 deletions(-)

diff --git a/include/net/ipeh.h b/include/net/ipeh.h
index 81f92f8..3d2bec6 100644
--- a/include/net/ipeh.h
+++ b/include/net/ipeh.h
@@ -31,6 +31,19 @@ struct ipv6_txoptions *ipeh_renew_options(struct sock *sk,
 struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
 					  struct ipv6_txoptions *opt);
 
+/* Generic extension header TLV parser */
+
+enum ipeh_parse_errors {
+	IPEH_PARSE_ERR_PAD1,		/* Excessive PAD1 */
+	IPEH_PARSE_ERR_PADN,		/* Excessive PADN */
+	IPEH_PARSE_ERR_PADNZ,		/* Non-zero padding data */
+	IPEH_PARSE_ERR_EH_TOOBIG,	/* Length of EH exceeds limit */
+	IPEH_PARSE_ERR_OPT_TOOBIG,	/* Option size exceeds limit */
+	IPEH_PARSE_ERR_OPT_TOOMANY,	/* Option count exceeds limit */
+	IPEH_PARSE_ERR_OPT_UNK_DISALW,	/* Unknown option disallowed */
+	IPEH_PARSE_ERR_OPT_UNK,		/* Unknown option */
+};
+
 /* The generic TLV parser assumes that the type value of PAD1 is 0, and PADN
  * is 1. This is true for IPv6 Destination and Hop-by-Hop Options. For Segment
  * Routing TLVs, PAD1 is also 0, however PADN is 4 so the latter necessitates
@@ -40,6 +53,8 @@ struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
 #define IPEH_TLV_PADN	1
 
 bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
-		    int max_count, int off, int len);
+		    int max_count, int off, int len,
+		    bool (*parse_error)(struct sk_buff *skb,
+					int off, enum ipeh_parse_errors error));
 
 #endif /* _NET_IPEH_H */
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index b094efe..d36ef0c 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -54,6 +54,61 @@
   Generic functions
  *********************/
 
+/* Handle parse errors from ipeh generic TLV parser */
+static bool ipv6_parse_error(struct sk_buff *skb, int off,
+			     enum ipeh_parse_errors error)
+{
+	switch (error) {
+	case IPEH_PARSE_ERR_OPT_UNK_DISALW:
+		/* If unknown TLVs are disallowed by configuration
+		 * then always silently drop packet. Note this also
+		 * means no ICMP parameter problem is sent which
+		 * could be a good property to mitigate a reflection DOS
+		 * attack.
+		 */
+
+		break;
+	case IPEH_PARSE_ERR_OPT_UNK:
+		/* High order two bits of option type indicate action to
+		 * take on unrecognized option.
+		 */
+		switch ((skb_network_header(skb)[off] & 0xC0) >> 6) {
+		case 0:
+			/* ignore */
+			return true;
+
+		case 1: /* drop packet */
+			break;
+
+		case 3: /* Send ICMP if not a multicast address and drop packet
+			 *
+			 * Actually, it is redundant check. icmp_send
+			 * will recheck in any case.
+			 */
+			if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr))
+				break;
+
+			/* fall through */
+		case 2: /* send ICMP PARM PROB regardless and drop packet */
+			icmpv6_send(skb, ICMPV6_PARAMPROB,
+				    ICMPV6_UNK_OPTION, off);
+			break;
+		}
+		break;
+	default:
+		/* Silent drop on other errors */
+
+		break;
+	}
+
+	/* Will be dropping packet */
+
+	__IP6_INC_STATS(dev_net(skb->dev), __in6_dev_get(skb->dev),
+			IPSTATS_MIB_INHDRERRORS);
+
+	return false;
+}
+
 static int ipv6_destopt_rcv(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
@@ -86,7 +141,7 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 
 	if (ipeh_parse_tlv(tlvprocdestopt_lst, skb,
 			   init_net.ipv6.sysctl.max_dst_opts_cnt,
-			   2, extlen - 2)) {
+			   2, extlen - 2, ipv6_parse_error)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -514,7 +569,7 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 	opt->flags |= IP6SKB_HOPBYHOP;
 	if (ipeh_parse_tlv(tlvprochopopt_lst, skb,
 			   init_net.ipv6.sysctl.max_hbh_opts_cnt,
-			   2, extlen - 2)) {
+			   2, extlen - 2, ipv6_parse_error)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index d0c4ec3..4d8a799 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -143,55 +143,18 @@ struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
 }
 EXPORT_SYMBOL_GPL(ipeh_fixup_options);
 
-/* An unknown option is detected, decide what to do */
-
-static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
-			       bool disallow_unknowns)
-{
-	if (disallow_unknowns) {
-		/* If unknown TLVs are disallowed by configuration
-		 * then always silently drop packet. Note this also
-		 * means no ICMP parameter problem is sent which
-		 * could be a good property to mitigate a reflection DOS
-		 * attack.
-		 */
-
-		goto drop;
-	}
-
-	switch ((skb_network_header(skb)[optoff] & 0xC0) >> 6) {
-	case 0: /* ignore */
-		return true;
-
-	case 1: /* drop packet */
-		break;
-
-	case 3: /* Send ICMP if not a multicast address and drop packet */
-		/* Actually, it is redundant check. icmp_send
-		 * will recheck in any case.
-		 */
-		if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr))
-			break;
-		/* fall through */
-	case 2: /* send ICMP PARM PROB regardless and drop packet */
-		icmpv6_param_prob(skb, ICMPV6_UNK_OPTION, optoff);
-		return false;
-	}
-
-drop:
-	kfree_skb(skb);
-	return false;
-}
-
 /* Generic extension header TLV parser
  *
  * Arguments:
  *   - skb_transport_header points to the extension header containing options
  *   - off is offset from skb_transport_header where first TLV is
  *   - len is length of TLV block
+ *   - parse_error is protocol specific function to handle parser errors
  */
 bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
-		    int max_count, int off, int len)
+		    int max_count, int off, int len,
+		    bool (*parse_error)(struct sk_buff *skb,
+					int off, enum ipeh_parse_errors error))
 {
 	const unsigned char *nh = skb_network_header(skb);
 	const struct tlvtype_proc *curr;
@@ -204,8 +167,15 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 		max_count = -max_count;
 	}
 
-	if (skb_transport_offset(skb) + off + len > skb_headlen(skb))
-		goto bad;
+	if (skb_transport_offset(skb) + off + len > skb_headlen(skb)) {
+		if (!parse_error(skb, skb_transport_offset(skb),
+				 IPEH_PARSE_ERR_EH_TOOBIG)) {
+			kfree_skb(skb);
+			return false;
+		}
+
+		len = skb_headlen(skb) - skb_transport_offset(skb) - off;
+	}
 
 	/* ops function based offset on network header */
 	off += skb_network_header_len(skb);
@@ -218,8 +188,10 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 		case IPEH_TLV_PAD1:
 			optlen = 1;
 			padlen++;
-			if (padlen > 7)
+			if (padlen > 7 &&
+			    !parse_error(skb, off, IPEH_PARSE_ERR_PAD1))
 				goto bad;
+
 			break;
 
 		case IPEH_TLV_PADN:
@@ -229,7 +201,8 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 			 * See also RFC 4942, Section 2.1.9.5.
 			 */
 			padlen += optlen;
-			if (padlen > 7)
+			if (padlen > 7 &&
+			    !parse_error(skb, off, IPEH_PARSE_ERR_PADN))
 				goto bad;
 
 			/* RFC 4942 recommends receiving hosts to
@@ -237,17 +210,21 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 			 * only zeroes.
 			 */
 			for (i = 2; i < optlen; i++) {
-				if (nh[off + i] != 0)
+				if (nh[off + i] != 0 &&
+				    !parse_error(skb, off + i,
+						 IPEH_PARSE_ERR_PADNZ))
 					goto bad;
 			}
 			break;
 
 		default: /* Other TLV code so scan list */
-			if (optlen > len)
+			if (optlen > len &&
+			    !parse_error(skb, off, IPEH_PARSE_ERR_OPT_TOOBIG))
 				goto bad;
 
 			tlv_count++;
-			if (tlv_count > max_count)
+			if (tlv_count > max_count &&
+			    !parse_error(skb, off, IPEH_PARSE_ERR_OPT_TOOMANY))
 				goto bad;
 
 			for (curr = procs; curr->type >= 0; curr++) {
@@ -262,8 +239,11 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
 				}
 			}
 			if (curr->type < 0 &&
-			    !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
-				return false;
+			    !parse_error(skb, off,
+					 disallow_unknowns ?
+						IPEH_PARSE_ERR_OPT_UNK_DISALW :
+						IPEH_PARSE_ERR_OPT_UNK))
+				goto bad;
 
 			padlen = 0;
 			break;
-- 
2.7.4

