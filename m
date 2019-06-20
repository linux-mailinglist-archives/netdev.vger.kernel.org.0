Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF284CE69
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731926AbfFTNPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:15:36 -0400
Received: from mail.us.es ([193.147.175.20]:56246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfFTNPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 09:15:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4144AC1D49
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 15:15:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EC7EDA702
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 15:15:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 24573DA706; Thu, 20 Jun 2019 15:15:34 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16554DA702;
        Thu, 20 Jun 2019 15:15:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 15:15:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E66D04265A2F;
        Thu, 20 Jun 2019 15:15:31 +0200 (CEST)
Date:   Thu, 20 Jun 2019 15:15:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nfnext v4] netfilter: add support for matching IPv4
 options
Message-ID: <20190620131531.26kkdnvcpwuemw2d@salvia>
References: <20190620115140.3518-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620115140.3518-1-ssuryaextr@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 07:51:40AM -0400, Stephen Suryaputra wrote:
[...]
> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index a940c9fd9045..703269359dba 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -62,6 +62,103 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
>  	regs->verdict.code = NFT_BREAK;
>  }
>  
> +/* find the offset to specified option.
> + *
> + * If target header is found, its offset is set in *offset and return option
> + * number. Otherwise, return negative error.
> + *
> + * If the first fragment doesn't contain the End of Options it is considered
> + * invalid.
> + */
> +static int ipv4_find_option(struct net *net, struct sk_buff *skb,
> +			    unsigned int *offset, int target)
> +{
> +	unsigned char optbuf[sizeof(struct ip_options) + 40];
> +	struct ip_options *opt = (struct ip_options *)optbuf;
> +	struct iphdr *iph, _iph;
> +	unsigned int start;
> +	bool found = false;
> +	__be32 info;
> +	int optlen;
> +
> +	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> +	if (!iph || iph->version != 4)

Nitpick: I think you can remove this check for iph->version != 4, if
skb->protocol already points to ETH_P_IP, then this already has a
valid IP version 4 header.

> +		return -EBADMSG;
> +	start = sizeof(struct iphdr);
> +
> +	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
> +	if (optlen <= 0)
> +		return -ENOENT;
> +
> +	memset(opt, 0, sizeof(struct ip_options));
> +	/* Copy the options since __ip_options_compile() modifies
> +	 * the options.
> +	 */
> +	if (skb_copy_bits(skb, start, opt->__data, optlen))
> +		return -EBADMSG;
> +	opt->optlen = optlen;
> +
> +	if (__ip_options_compile(net, opt, NULL, &info))
> +		return -EBADMSG;
> +
> +	switch (target) {
> +	case IPOPT_SSRR:
> +	case IPOPT_LSRR:
> +		if (!opt->srr)
> +			break;
> +		found = target == IPOPT_SSRR ? opt->is_strictroute :
> +					       !opt->is_strictroute;
> +		if (found)
> +			*offset = opt->srr + start;
> +		break;
> +	case IPOPT_RR:
> +		if (!opt->rr)
> +			break;
> +		*offset = opt->rr + start;
> +		found = true;
> +		break;
> +	case IPOPT_RA:
> +		if (!opt->router_alert)
> +			break;
> +		*offset = opt->router_alert + start;
> +		found = true;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +	return found ? target : -ENOENT;
> +}
> +
> +static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
> +				 struct nft_regs *regs,
> +				 const struct nft_pktinfo *pkt)
> +{
> +	struct nft_exthdr *priv = nft_expr_priv(expr);
> +	u32 *dest = &regs->data[priv->dreg];
> +	struct sk_buff *skb = pkt->skb;
> +	unsigned int offset;
> +	int err;
> +
> +	if (skb->protocol != htons(ETH_P_IP))
> +		goto err;
> +
> +	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type);
> +	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
> +		*dest = (err >= 0);
> +		return;
> +	} else if (err < 0) {
> +		goto err;
> +	}
> +	offset += priv->offset;
> +
> +	dest[priv->len / NFT_REG32_SIZE] = 0;
> +	if (skb_copy_bits(pkt->skb, offset, dest, priv->len) < 0)
> +		goto err;
> +	return;
> +err:
> +	regs->verdict.code = NFT_BREAK;
> +}
> +
>  static void *
>  nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
>  		       unsigned int len, void *buffer, unsigned int *tcphdr_len)
> @@ -360,6 +457,14 @@ static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
>  	.dump		= nft_exthdr_dump,
>  };
>  
> +static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
> +	.type		= &nft_exthdr_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
> +	.eval		= nft_exthdr_ipv4_eval,
> +	.init		= nft_exthdr_init,

Sorry, I just realized this one. Could you add a new
nft_exthdr_ipv4_init() function?

The idea is if priv->type different from:

IPOPT_SSRR
IPOPT_LSRR
IPOPT_RR
IPOPT_RA

are rejected with -EOPNOTSUPP.

If anyone extends this to support for more options, old kernels with
new nft binaries will result in EOPNOTSUPP for options that are not
supported.

The existing TCP options extension does not need this, since it
matches any type. This IPv4 option extension is special, since we
require the option parser to match on options.

I can see you return -EOPNOTSUPP from _eval() path, but that is too
late. It would be good to validate this from the control plane path.

Thanks for your patience.
