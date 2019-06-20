Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09684CD26
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 13:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbfFTLwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 07:52:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39054 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731670AbfFTLwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 07:52:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id 196so1466487pgc.6;
        Thu, 20 Jun 2019 04:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Z6qFnOPxGsxbBs0N1zHQ2cWMgLe8sCLq4jvA0AzCvtE=;
        b=DW7smYrl6VnTxf+mDW+fMhUBEgw71IO+UEx+WeJv5RmKsCPtJVgcZTOZ6uzRK9cpg+
         3F2GWDrvnFusDEEYOJfX/7wRA9gn4s3Y7+z8vwVcDOg1rWKRJACpXAofncOF/FpglibW
         pD+ddsWMArLdOQeVchNjZYgGPPIdQc8luRwtMQwuDFybRye0LiaLmkNj4VFOTdUedv2L
         kxkqPvoF3dXTORFvMwV/WFwKMtDrRXj4ZKm6XeRkJIKYpp1VFOYvkvZg0xokbieShECo
         qXYCyIKaPsFUrSEG/PD7dKPUSNfQZOr/SWOGhSRhHf1VIBa8kEL04xPIvpFwDatAQVrp
         D7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z6qFnOPxGsxbBs0N1zHQ2cWMgLe8sCLq4jvA0AzCvtE=;
        b=pQraYfvSKvU7l20ql+B+mNmyEQOzd6b/ClXwTFGbJw40QlG/7VqBf9PvXOkh8KY97k
         EmcCCnWcORDuwx8cmz5KME+TRJtscthT3/Uxjpv2TjjKuc8qpXHQqIsgKuGypIAL5WFF
         cx887Yz+u6vMBvs1wjuFyo85H+PWMAk8GV+9EIw3xT9OMx7GJ/o07Lgq//L2HU9ucRhe
         Lsmz2yjek6PHFEgeAdGWngq7b6HjjeisJ7rA35UfN4XPWdQKOuQ0e/z947ibUvBNkoI3
         32issgfMNZsMgHYoTHomEpdojNstgboAbhRuOfqUgNlyMNLjT9ko56lMpcRjNZHomsAI
         COxg==
X-Gm-Message-State: APjAAAWbhD9H85usDys4pe0PDuPmJkrK0FBtVxBrRB/xF7Xgn83IM0sR
        BOk/PoZQffH5hu5ignhdTni8ag8UxA==
X-Google-Smtp-Source: APXvYqyBR46+C8J5ufb+LcDaaLVeD8vQ3BWqbC3COAVNxMzLqA684j0K4yYzWKateXwAJRLxXAQZvQ==
X-Received: by 2002:a65:5a42:: with SMTP id z2mr12830723pgs.421.1561031524630;
        Thu, 20 Jun 2019 04:52:04 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.8])
        by smtp.gmail.com with ESMTPSA id x25sm21862942pfm.48.2019.06.20.04.52.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 04:52:03 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nfnext v4] netfilter: add support for matching IPv4 options
Date:   Thu, 20 Jun 2019 07:51:40 -0400
Message-Id: <20190620115140.3518-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the kernel change for the overall changes with this description:
Add capability to have rules matching IPv4 options. This is developed
mainly to support dropping of IP packets with loose and/or strict source
route route options.

v2: Fix style issues. Make this work with NFPROTO_INET (inet tables),
    NFPROTO_BRIDGE and the NFPROTO_NETDEV families. Check skb->protocol.
    Remove ability to input IP header offset for ipv4_find_option()
    function (all per Pablo Neira Ayuso).
v3: Remove unused ipv4_find_option() arguments (per Pablo Neira Ayuso).
v4: Change the code to not follow ipv6_find_hdr() and just do what are
    needed to support source-route, record route and router alert (per
    Pablo Neira Ayuso). Fix bugs that are introduced while addressing
    review comments.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/ipv4/ip_options.c                    |   1 +
 net/netfilter/nft_exthdr.c               | 111 +++++++++++++++++++++++
 3 files changed, 114 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 505393c6e959..168d741f42c5 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -730,10 +730,12 @@ enum nft_exthdr_flags {
  *
  * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
  * @NFT_EXTHDR_OP_TCP: match against tcp options
+ * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
+	NFT_EXTHDR_OP_IPV4,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 3db31bb9df50..ddaa01ec2bce 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -473,6 +473,7 @@ int __ip_options_compile(struct net *net,
 		*info = htonl((pp_ptr-iph)<<24);
 	return -EINVAL;
 }
+EXPORT_SYMBOL(__ip_options_compile);
 
 int ip_options_compile(struct net *net,
 		       struct ip_options *opt, struct sk_buff *skb)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a940c9fd9045..703269359dba 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -62,6 +62,103 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+/* find the offset to specified option.
+ *
+ * If target header is found, its offset is set in *offset and return option
+ * number. Otherwise, return negative error.
+ *
+ * If the first fragment doesn't contain the End of Options it is considered
+ * invalid.
+ */
+static int ipv4_find_option(struct net *net, struct sk_buff *skb,
+			    unsigned int *offset, int target)
+{
+	unsigned char optbuf[sizeof(struct ip_options) + 40];
+	struct ip_options *opt = (struct ip_options *)optbuf;
+	struct iphdr *iph, _iph;
+	unsigned int start;
+	bool found = false;
+	__be32 info;
+	int optlen;
+
+	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
+	if (!iph || iph->version != 4)
+		return -EBADMSG;
+	start = sizeof(struct iphdr);
+
+	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
+	if (optlen <= 0)
+		return -ENOENT;
+
+	memset(opt, 0, sizeof(struct ip_options));
+	/* Copy the options since __ip_options_compile() modifies
+	 * the options.
+	 */
+	if (skb_copy_bits(skb, start, opt->__data, optlen))
+		return -EBADMSG;
+	opt->optlen = optlen;
+
+	if (__ip_options_compile(net, opt, NULL, &info))
+		return -EBADMSG;
+
+	switch (target) {
+	case IPOPT_SSRR:
+	case IPOPT_LSRR:
+		if (!opt->srr)
+			break;
+		found = target == IPOPT_SSRR ? opt->is_strictroute :
+					       !opt->is_strictroute;
+		if (found)
+			*offset = opt->srr + start;
+		break;
+	case IPOPT_RR:
+		if (!opt->rr)
+			break;
+		*offset = opt->rr + start;
+		found = true;
+		break;
+	case IPOPT_RA:
+		if (!opt->router_alert)
+			break;
+		*offset = opt->router_alert + start;
+		found = true;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return found ? target : -ENOENT;
+}
+
+static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	u32 *dest = &regs->data[priv->dreg];
+	struct sk_buff *skb = pkt->skb;
+	unsigned int offset;
+	int err;
+
+	if (skb->protocol != htons(ETH_P_IP))
+		goto err;
+
+	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type);
+	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
+		*dest = (err >= 0);
+		return;
+	} else if (err < 0) {
+		goto err;
+	}
+	offset += priv->offset;
+
+	dest[priv->len / NFT_REG32_SIZE] = 0;
+	if (skb_copy_bits(pkt->skb, offset, dest, priv->len) < 0)
+		goto err;
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
+}
+
 static void *
 nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
 		       unsigned int len, void *buffer, unsigned int *tcphdr_len)
@@ -360,6 +457,14 @@ static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.dump		= nft_exthdr_dump,
 };
 
+static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
+	.type		= &nft_exthdr_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
+	.eval		= nft_exthdr_ipv4_eval,
+	.init		= nft_exthdr_init,
+	.dump		= nft_exthdr_dump,
+};
+
 static const struct nft_expr_ops nft_exthdr_tcp_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
@@ -400,6 +505,12 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
 		if (tb[NFTA_EXTHDR_DREG])
 			return &nft_exthdr_ipv6_ops;
 		break;
+	case NFT_EXTHDR_OP_IPV4:
+		if (ctx->family != NFPROTO_IPV6) {
+			if (tb[NFTA_EXTHDR_DREG])
+				return &nft_exthdr_ipv4_ops;
+		}
+		break;
 	}
 
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.17.1

