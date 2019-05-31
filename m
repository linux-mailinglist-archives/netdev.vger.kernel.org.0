Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27CD31380
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfEaRLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:11:08 -0400
Received: from mail.us.es ([193.147.175.20]:58226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfEaRLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:11:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3F21F6D007
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:11:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E71EDA70A
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:11:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 236D2DA701; Fri, 31 May 2019 19:11:04 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0795DA701;
        Fri, 31 May 2019 19:11:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 19:11:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CD7884265A31;
        Fri, 31 May 2019 19:11:01 +0200 (CEST)
Date:   Fri, 31 May 2019 19:11:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190531171101.5pttvxlbernhmlra@salvia>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523093801.3747-1-ssuryaextr@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Thu, May 23, 2019 at 05:38:01AM -0400, Stephen Suryaputra wrote:
> This is the kernel change for the overall changes with this description:
> Add capability to have rules matching IPv4 options. This is developed
> mainly to support dropping of IP packets with loose and/or strict source
> route route options. Nevertheless, the implementation include others and
> ability to get specific fields in the option.

Thanks for submitting your patch.

> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  include/net/inet_sock.h                  |   2 +-
[...]
>  net/ipv4/ip_options.c                    |   2 +

Please, place the update of these two files (which are not netfilter
specific) in a separated (initial) patch, we'll need an Acked-by: tag
from the general networking maintainer to get this in. It will make
things easier if this comes in a separated (initial) patch.

More comments below.

>  net/netfilter/nft_exthdr.c               | 136 +++++++++++++++++++++++
>  4 files changed, 141 insertions(+), 1 deletion(-)
> 
[...]
> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index a940c9fd9045..c4d47d274bbe 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -62,6 +62,128 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
>  	regs->verdict.code = NFT_BREAK;
>  }
>  
> +/* find the offset to specified option or the header beyond the options
> + * if target < 0.
> + *
> + * Note that *offset is used as input/output parameter, and if it is not zero,
> + * then it must be a valid offset to an inner IPv4 header. This can be used
> + * to explore inner IPv4 header, eg. ICMP error messages.

In other extension headers (IPv6 and TCP options) this offset is used
to match for a field inside the extension / option.

So this semantics you describe here are slightly different, right?

> + * If target header is found, its offset is set in *offset and return option
> + * number. Otherwise, return negative error.
> + *
> + * If the first fragment doesn't contain the End of Options it is considered
> + * invalid.
> + */
> +static int ipv4_find_option(struct net *net, struct sk_buff *skb, unsigned int *offset,
> +		     int target, unsigned short *fragoff, int *flags)

static int ipv4_find_option(struct net *net, struct sk_buff *skb,
                            unsigned int *offset, int target,
                            unsigned short *fragoff, int *flags)
                            ^
Align parameters to parens when breaking too long lines.

Please, also break lines at 80 chars.

> +{
> +	unsigned char optbuf[sizeof(struct ip_options) + 41];
> +	struct ip_options *opt = (struct ip_options *)optbuf;
> +	struct iphdr *iph, _iph;
> +	unsigned int start;
> +	__be32 info;
> +	int optlen;
> +	bool found = false;

Please, define variables using reverse xmas tree, ie.

        unsigned char optbuf[sizeof(struct ip_options) + 41];
        struct ip_options *opt = (struct ip_options *)optbuf;
        struct iphdr *iph, _iph;
        unsigned int start;
        bool found = false;
        __be32 info;
        int optlen;

From longest line to shortest one.

> +	if (fragoff)
> +		*fragoff = 0;
> +
> +	if (!offset)
> +		return -EINVAL;
> +	if (!*offset)
> +		*offset = skb_network_offset(skb);
> +
> +	iph = skb_header_pointer(skb, *offset, sizeof(_iph), &_iph);
> +	if (!iph || iph->version != 4)
> +		return -EBADMSG;
> +	start = *offset + sizeof(struct iphdr);
> +
> +	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
> +	if (optlen <= 0)
> +		return -ENOENT;

You could just:

                return -1;

in all these errors in ipv4_find_option() since nft_exthdr_ipv4_eval()
does not use it.

> +	memset(opt, 0, sizeof(struct ip_options));
> +	/* Copy the options since __ip_options_compile() modifies
> +	 * the options. Get one byte beyond the option for target < 0
> +	 */
> +	if (skb_copy_bits(skb, start, opt->__data, optlen + 1))
> +		return -EBADMSG;
> +	opt->optlen = optlen;
> +
> +	if (__ip_options_compile(net, opt, NULL, &info))
> +		return -EBADMSG;
> +
> +	switch (target) {
> +	case IPOPT_SSRR:
> +	case IPOPT_LSRR:
> +		if (opt->srr) {

I'd suggest:

                if (!opt->srr)
                        break;

So you save one level of indentation below.

> +			found = target == IPOPT_SSRR ? opt->is_strictroute :
> +						       !opt->is_strictroute;
> +			if (found)
> +				*offset = opt->srr + start;
> +		}
> +		break;
> +	case IPOPT_RR:
> +		if (opt->rr) {

same here:

                if (!opt->rr)
                        break;

and same thing for other extensions.

> +			*offset = opt->rr + start;
> +			found = true;
> +		}
> +		break;
> +	case IPOPT_RA:
> +		if (opt->router_alert) {
> +			*offset = opt->router_alert + start;
> +			found = true;
> +		}
> +		break;
> +	default:
> +		/* Either not supported or not a specific search, treated as found */
> +		found = true;
> +		if (target < 0) {
> +			if (opt->end) {
> +				*offset = opt->end + start;
> +				target = IPOPT_END;
> +			} else {
> +				/* Point to beyond the options. */
> +				*offset = optlen + start;
> +				target = opt->__data[optlen];
> +			}
> +		} else {
> +			target = -EOPNOTSUPP;
> +		}
> +	}
> +	if (!found)
> +		target = -ENOENT;
> +	return target;

Hm, 'target' value is never used, right?

> +}
> +
> +static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
> +				 struct nft_regs *regs,
> +				 const struct nft_pktinfo *pkt)
> +{
> +	struct nft_exthdr *priv = nft_expr_priv(expr);
> +	u32 *dest = &regs->data[priv->dreg];
> +	struct sk_buff *skb = pkt->skb;
> +	unsigned int offset = 0;
> +	int err;
> +
> +	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type, NULL, NULL);
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
> @@ -360,6 +482,14 @@ static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
>  	.dump		= nft_exthdr_dump,
>  };
>  
> +static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
> +	.type		= &nft_exthdr_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
> +	.eval		= nft_exthdr_ipv4_eval,
> +	.init		= nft_exthdr_init,
> +	.dump		= nft_exthdr_dump,
> +};
> +
>  static const struct nft_expr_ops nft_exthdr_tcp_ops = {
>  	.type		= &nft_exthdr_type,
>  	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
> @@ -400,6 +530,12 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
>  		if (tb[NFTA_EXTHDR_DREG])
>  			return &nft_exthdr_ipv6_ops;
>  		break;
> +	case NFT_EXTHDR_OP_IPV4:
> +		if (ctx->family == NFPROTO_IPV4) {

This should also work for the NFPROTO_INET (inet tables), NFPROTO_BRIDGE
and the NFPROTO_NETDEV families.

I would turn this into:

		if (ctx->family != NFPROTO_IPV6) {

> +			if (tb[NFTA_EXTHDR_DREG])
> +				return &nft_exthdr_ipv4_ops;
> +		}
> +		break;

Then, from the _eval() path:

You have to replace iph->version == 4 check abive, you could use
skb->protocol instead, and check for htons(ETH_P_IP) packets.

Thanks!
