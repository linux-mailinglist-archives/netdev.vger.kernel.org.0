Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8849C27E14
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfEWN0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:26:01 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:36668 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730081AbfEWN0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:26:01 -0400
Received: by mail-it1-f196.google.com with SMTP id e184so8485138ite.1;
        Thu, 23 May 2019 06:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=U4vr2IeJTvZOIAMpHGT3kpDOZxsCZJuyZg7hVsQVE0E=;
        b=OxXeKR7ryOUxjVAQ8cnF0yd4bMIFir+uGw0S/w5Ik8bu6t7UAWuyx7CQvp8kTb3gm/
         NOUs5OTIuUyLP9LDs2rlq5lb194PTSbZ+ONjEN6rxNjVLEXHGIzd02sQmsaidyxsTkQj
         L9XIJAroa06861WbglhpRIJ6EjcJW+7iOo1Xwl9w7S51AKn5TwVBy2F70pkyE/R+XhWc
         lI88ZjBa/SMs+QyvIFPhLGaw/HQJaaWXpsueC19cAzO5AAPC5/WASAX0rh6yiPfIH+CM
         c+PC+VZpm355LLGsYBCQV/nmgeMyVrB0YeHkA0+XICpkMTOqc2GO+W1FDXS971FK71Vq
         RdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U4vr2IeJTvZOIAMpHGT3kpDOZxsCZJuyZg7hVsQVE0E=;
        b=AA2MCHJhTKYBetFLueVL0PrcflGrHckRffHcw7gJAcl4KJAylMCJRn7i6fCQ1tM3nH
         J9kc4dmGiBpRg1W33xVlsl+2W4KCYcme0sfJYhBEjOiQbzBgZpAY5kN5s/NKKlFwbFsE
         6R+wHzKXgksVgp6uBrOxKGEv8/XjVztP0B5U55T7jS82dEiYFUAZryQBYthvvkZRk9Na
         rZDYRrU1qaEb1+1Ep6oHIXRF79NOe1FjTnQCxGjxjMDe9rcpPZU1gCcI3w0v4InHzQ6D
         rc7bj30EI/2SWt8dLYCbzCRIeLJ2xiPpeiIPcVtosC2DaSUnEEkZwN7LY4lwM0YmGJTY
         qpFw==
X-Gm-Message-State: APjAAAXb0LVinKeHP3ycUJoO7/R4wOeoQRcUy33l+6NHUpQ9lsTtqc5E
        Ip6AAL1VMsa8ug0kfLbZ3y6Asqg=
X-Google-Smtp-Source: APXvYqyULXGEBcgx36Q1HbhecBEVNNS6Q2wPJpyoFcfU3hbjES2PX5fl4flgNZnnEJWFqAJ5+sg+gg==
X-Received: by 2002:a24:16c6:: with SMTP id a189mr12604158ita.179.1558617959901;
        Thu, 23 May 2019 06:25:59 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.10])
        by smtp.gmail.com with ESMTPSA id y13sm8960399iol.68.2019.05.23.06.25.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 06:25:59 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nf-next] netfilter: add support for matching IPv4 options
Date:   Thu, 23 May 2019 05:38:01 -0400
Message-Id: <20190523093801.3747-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the kernel change for the overall changes with this description:
Add capability to have rules matching IPv4 options. This is developed
mainly to support dropping of IP packets with loose and/or strict source
route route options. Nevertheless, the implementation include others and
ability to get specific fields in the option.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/net/inet_sock.h                  |   2 +-
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/ipv4/ip_options.c                    |   2 +
 net/netfilter/nft_exthdr.c               | 136 +++++++++++++++++++++++
 4 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index e8eef85006aa..8db4f8639a33 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -55,7 +55,7 @@ struct ip_options {
 			ts_needaddr:1;
 	unsigned char	router_alert;
 	unsigned char	cipso;
-	unsigned char	__pad2;
+	unsigned char	end;
 	unsigned char	__data[0];
 };
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 061bb3eb20c3..81d31f4e4aa3 100644
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
index 3db31bb9df50..fc0e694aa97c 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -272,6 +272,7 @@ int __ip_options_compile(struct net *net,
 	for (l = opt->optlen; l > 0; ) {
 		switch (*optptr) {
 		case IPOPT_END:
+			opt->end = optptr - iph;
 			for (optptr++, l--; l > 0; optptr++, l--) {
 				if (*optptr != IPOPT_END) {
 					*optptr = IPOPT_END;
@@ -473,6 +474,7 @@ int __ip_options_compile(struct net *net,
 		*info = htonl((pp_ptr-iph)<<24);
 	return -EINVAL;
 }
+EXPORT_SYMBOL(__ip_options_compile);
 
 int ip_options_compile(struct net *net,
 		       struct ip_options *opt, struct sk_buff *skb)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a940c9fd9045..c4d47d274bbe 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -62,6 +62,128 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+/* find the offset to specified option or the header beyond the options
+ * if target < 0.
+ *
+ * Note that *offset is used as input/output parameter, and if it is not zero,
+ * then it must be a valid offset to an inner IPv4 header. This can be used
+ * to explore inner IPv4 header, eg. ICMP error messages.
+ *
+ * If target header is found, its offset is set in *offset and return option
+ * number. Otherwise, return negative error.
+ *
+ * If the first fragment doesn't contain the End of Options it is considered
+ * invalid.
+ */
+static int ipv4_find_option(struct net *net, struct sk_buff *skb, unsigned int *offset,
+		     int target, unsigned short *fragoff, int *flags)
+{
+	unsigned char optbuf[sizeof(struct ip_options) + 41];
+	struct ip_options *opt = (struct ip_options *)optbuf;
+	struct iphdr *iph, _iph;
+	unsigned int start;
+	__be32 info;
+	int optlen;
+	bool found = false;
+
+	if (fragoff)
+		*fragoff = 0;
+
+	if (!offset)
+		return -EINVAL;
+	if (!*offset)
+		*offset = skb_network_offset(skb);
+
+	iph = skb_header_pointer(skb, *offset, sizeof(_iph), &_iph);
+	if (!iph || iph->version != 4)
+		return -EBADMSG;
+	start = *offset + sizeof(struct iphdr);
+
+	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
+	if (optlen <= 0)
+		return -ENOENT;
+
+	memset(opt, 0, sizeof(struct ip_options));
+	/* Copy the options since __ip_options_compile() modifies
+	 * the options. Get one byte beyond the option for target < 0
+	 */
+	if (skb_copy_bits(skb, start, opt->__data, optlen + 1))
+		return -EBADMSG;
+	opt->optlen = optlen;
+
+	if (__ip_options_compile(net, opt, NULL, &info))
+		return -EBADMSG;
+
+	switch (target) {
+	case IPOPT_SSRR:
+	case IPOPT_LSRR:
+		if (opt->srr) {
+			found = target == IPOPT_SSRR ? opt->is_strictroute :
+						       !opt->is_strictroute;
+			if (found)
+				*offset = opt->srr + start;
+		}
+		break;
+	case IPOPT_RR:
+		if (opt->rr) {
+			*offset = opt->rr + start;
+			found = true;
+		}
+		break;
+	case IPOPT_RA:
+		if (opt->router_alert) {
+			*offset = opt->router_alert + start;
+			found = true;
+		}
+		break;
+	default:
+		/* Either not supported or not a specific search, treated as found */
+		found = true;
+		if (target < 0) {
+			if (opt->end) {
+				*offset = opt->end + start;
+				target = IPOPT_END;
+			} else {
+				/* Point to beyond the options. */
+				*offset = optlen + start;
+				target = opt->__data[optlen];
+			}
+		} else {
+			target = -EOPNOTSUPP;
+		}
+	}
+	if (!found)
+		target = -ENOENT;
+	return target;
+}
+
+static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	u32 *dest = &regs->data[priv->dreg];
+	struct sk_buff *skb = pkt->skb;
+	unsigned int offset = 0;
+	int err;
+
+	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type, NULL, NULL);
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
@@ -360,6 +482,14 @@ static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
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
@@ -400,6 +530,12 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
 		if (tb[NFTA_EXTHDR_DREG])
 			return &nft_exthdr_ipv6_ops;
 		break;
+	case NFT_EXTHDR_OP_IPV4:
+		if (ctx->family == NFPROTO_IPV4) {
+			if (tb[NFTA_EXTHDR_DREG])
+				return &nft_exthdr_ipv4_ops;
+		}
+		break;
 	}
 
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.17.1

