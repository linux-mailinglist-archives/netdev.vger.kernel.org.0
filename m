Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E264D389
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbfFTQUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 12:20:12 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44717 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfFTQUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 12:20:12 -0400
Received: by mail-qt1-f193.google.com with SMTP id x47so3735340qtk.11;
        Thu, 20 Jun 2019 09:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W4QVDrc5zpdgus3iohLsYeU/6dZ6en85OOAjxmhu79M=;
        b=KkXsMR+aJp7kedxr4ekkmlKIyxBIDQnT17JqByqwdXICsn4X+zvNrRX3FmLulNmlpY
         zxMI5sOVp5i0mmN2EoZXQ1/lD1XsvWdIZk9MyRxbEMt4J8QKZWU4TlLeynhYOr7e7d8y
         W2Lo15CQxy/fsDuBQUKdY+aDEnZiJObyYAXLGD7mUla7fAIqRW+inWwqqASnLgf3PwdZ
         nfq8DBHi/nOytI7e0Q+WVJ8hcUHJtn6s8xqSRwDxWzWNWodM9h/W+TA4PBBy9RDVnmOe
         uGjIdMM3eYiNAHnDvhmZYu4x8jdEjsJmAuai2ieihXJydq3g++S1cwI7sf8RHes6kVYw
         3BhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W4QVDrc5zpdgus3iohLsYeU/6dZ6en85OOAjxmhu79M=;
        b=SKwAXWXRz9xrZIIoTeSc6NwTn2tJuVvzpyO5tfeG0Mm81N96BVnCUHovo27XjNlyI7
         L3E7mM48pAi0c7rOw777Fm/9JTT7WW+dF6jyDQ1UQS7t606kYzgmnLlYrdJ/C8FwuUDm
         TJD0C0uZ1MglJtEulnVwEdWJHzw/QmAtOxkI35aOqrpj6RsWqYxiaccuHC5QDUcebnp3
         bVTZ5jMUkJqITYJNpLnmWZLaUG62qly00u1FVt3DXXMV15H07bvyv7CO8rOsJzSikqrG
         +TwzRXfq3pqTSY1eHjmKQoiHAvuz4QCgVgbKc81qRTOhGoJ6FG/i06kcoL5mGMAHo9Bg
         IipA==
X-Gm-Message-State: APjAAAWc1pRPnMtX6fB+UcC7hGo35tejjB/7IF0yErT8HDMEZY0lPhyt
        oh13a23xueSRJ7oEzaunf2+txs0=
X-Google-Smtp-Source: APXvYqyRFzo2xRSC/MiUxK04H1E9PvofOEIziorxZt0AkJsaL87lGnDTFQWfZOQ5yP9X1JWwDIRfzQ==
X-Received: by 2002:a0c:9695:: with SMTP id a21mr40167933qvd.24.1561047610716;
        Thu, 20 Jun 2019 09:20:10 -0700 (PDT)
Received: from localhost.localdomain ([104.194.218.57])
        by smtp.gmail.com with ESMTPSA id s25sm41704qkm.130.2019.06.20.09.20.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 09:20:09 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nf-next v5] netfilter: add support for matching IPv4 options
Date:   Thu, 20 Jun 2019 12:19:59 -0400
Message-Id: <20190620161959.7252-1-ssuryaextr@gmail.com>
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
v5: Add nft_exthdr_ipv4_init(). Remove redundant check of IP version
    (feedback from Pablo Neira Ayuso).

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/ipv4/ip_options.c                    |   1 +
 net/netfilter/nft_exthdr.c               | 133 +++++++++++++++++++++++
 3 files changed, 136 insertions(+)

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
index 45c8a6c07783..8032b2937c7f 100644
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
+	if (!iph)
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
@@ -315,6 +412,28 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 	return nft_validate_register_load(priv->sreg, priv->len);
 }
 
+static int nft_exthdr_ipv4_init(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nlattr * const tb[])
+{
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	int err = nft_exthdr_init(ctx, expr, tb);
+
+	if (err < 0)
+		return err;
+
+	switch (priv->type) {
+	case IPOPT_SSRR:
+	case IPOPT_LSRR:
+	case IPOPT_RR:
+	case IPOPT_RA:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
 static int nft_exthdr_dump_common(struct sk_buff *skb, const struct nft_exthdr *priv)
 {
 	if (nla_put_u8(skb, NFTA_EXTHDR_TYPE, priv->type))
@@ -361,6 +480,14 @@ static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.dump		= nft_exthdr_dump,
 };
 
+static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
+	.type		= &nft_exthdr_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
+	.eval		= nft_exthdr_ipv4_eval,
+	.init		= nft_exthdr_ipv4_init,
+	.dump		= nft_exthdr_dump,
+};
+
 static const struct nft_expr_ops nft_exthdr_tcp_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
@@ -401,6 +528,12 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
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

