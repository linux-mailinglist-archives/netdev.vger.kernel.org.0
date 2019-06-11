Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0E03CABF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 14:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404554AbfFKMKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 08:10:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37402 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404538AbfFKMKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 08:10:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so6487269pfa.4;
        Tue, 11 Jun 2019 05:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uEbaWZ7CSywpPD1njQAxIRl3QQVRG3+Pm3u0i4SdA7w=;
        b=ppU7ATNEH4eVI+b3YTmA2WI8aydvfOxgeCE251gUk1SWEdQESfNX9QDRW8RJ6E86OR
         vnlHkY9f+wS5+shq/WlulC3/zI5MczLRSOYUOowMFREnefN6X+Z0in/n2CGUL5DKMowD
         MGtWZgW8yH27fcd4TrLQ6LGZa/HOihyOIXj9eSIwPSHt4DwsibbRJ0+loudMidVX8iZx
         Xj9XJtPlOP1ng1D4vePZ7KUD7Wskfk0Y/l+X3QrnvMcumgx9JtQD/sy1/akXJyHQA4po
         O2X70z7tshtTo2ocXsyWVXwX7iIqVuHCB379ACA9ahjzkhKfYi26XuCKpyyNdGRpb21w
         owLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uEbaWZ7CSywpPD1njQAxIRl3QQVRG3+Pm3u0i4SdA7w=;
        b=Ven98uF58MTumQGaLUD4aVobbA5Gy4fiKAWiPLMxt76uhbGP6jZuYJT4oDIh6t7kKn
         3quTozwKoj3IU3984TgnWmt6Q0DBCDPikMKwCIXSa57O2V4rZb5sPZhWrbKtNspM8dxn
         3NXxtRPxU3IVkMoovfsAbW2qucoktt6Eop6FUFItgTeTMrgFmBlcN3eOft1KA4PJ2kU0
         OKDTJVn/8LI6HsHeOx226p3LybXYVLweiwbEYtx1ktGhZdQFyQXtxj2/o1ZDYrqYXtJG
         aPN/fs21h+aCFvpV9XsI/fWBEcKtPmEj2gthH4JLsi1JdRXgBvftF8wtpKR+LFOWo1sL
         dIYw==
X-Gm-Message-State: APjAAAXhmyslcDCtFCwaTv/VezIAzX7ze+8vTm7huASnYu7peHBXHK9t
        A4oGL/FHOOk/q4YnLMIucDbLGN0=
X-Google-Smtp-Source: APXvYqyvSTfHuLK9wZeiufbXgu0Lal3TwdIQsTAac85wa28carbQwNXaARNHontNBg1Ex0eUZjFalQ==
X-Received: by 2002:aa7:8d98:: with SMTP id i24mr11968467pfr.199.1560255003091;
        Tue, 11 Jun 2019 05:10:03 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.8])
        by smtp.gmail.com with ESMTPSA id d7sm16469287pfn.89.2019.06.11.05.09.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 05:10:02 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH RESEND nf-next] netfilter: add support for matching IPv4 options
Date:   Tue, 11 Jun 2019 08:09:12 -0400
Message-Id: <20190611120912.3825-1-ssuryaextr@gmail.com>
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

v2: Fix style issues. Make this work with NFPROTO_INET (inet tables),
    NFPROTO_BRIDGE and the NFPROTO_NETDEV families. Check skb->protocol.
    Remove ability to input IP header offset for ipv4_find_option()
    function (all per Pablo Neira Ayuso).

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/net/inet_sock.h                  |   2 +-
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/ipv4/ip_options.c                    |   2 +
 net/netfilter/nft_exthdr.c               | 133 +++++++++++++++++++++++
 4 files changed, 138 insertions(+), 1 deletion(-)

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
index a940c9fd9045..4155a32fade7 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -62,6 +62,125 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+/* find the offset to specified option or the header beyond the options
+ * if target < 0.
+ *
+ * If target header is found, its offset is set in *offset and return option
+ * number. Otherwise, return negative error.
+ *
+ * If the first fragment doesn't contain the End of Options it is considered
+ * invalid.
+ */
+static int ipv4_find_option(struct net *net, struct sk_buff *skb,
+			    unsigned int *offset, int target,
+			    unsigned short *fragoff, int *flags)
+{
+	unsigned char optbuf[sizeof(struct ip_options) + 41];
+	struct ip_options *opt = (struct ip_options *)optbuf;
+	struct iphdr *iph, _iph;
+	unsigned int start;
+	bool found = false;
+	__be32 info;
+	int optlen;
+
+	if (fragoff)
+		*fragoff = 0;
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
+		if (!opt->srr)
+			break;
+		found = target == IPOPT_SSRR ? opt->is_strictroute :
+					       !opt->is_strictroute;
+		if (found)
+			*offset = opt->srr + start;
+		break;
+	case IPOPT_RR:
+		if (opt->rr)
+			break;
+		*offset = opt->rr + start;
+		found = true;
+		break;
+	case IPOPT_RA:
+		if (opt->router_alert)
+			break;
+		*offset = opt->router_alert + start;
+		found = true;
+		break;
+	default:
+		/* Either not supported or not a specific search, treated as
+		 * found
+		 */
+		found = true;
+		if (target >= 0) {
+			target = -EOPNOTSUPP;
+			break;
+		}
+		if (opt->end) {
+			*offset = opt->end + start;
+			target = IPOPT_END;
+		} else {
+			/* Point to beyond the options. */
+			*offset = optlen + start;
+			target = opt->__data[optlen];
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
+	unsigned int offset;
+	int err;
+
+	if (skb->protocol != htons(ETH_P_IP))
+		goto err;
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
@@ -360,6 +479,14 @@ static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
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
@@ -400,6 +527,12 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
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

