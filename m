Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308EE4A56B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbfFRPbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:31:17 -0400
Received: from mail.us.es ([193.147.175.20]:45338 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbfFRPbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 11:31:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 807CF10328F
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 17:31:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F2D9DA705
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 17:31:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6E82EDA702; Tue, 18 Jun 2019 17:31:15 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 596BBDA708;
        Tue, 18 Jun 2019 17:31:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 17:31:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 32A1C4265A31;
        Tue, 18 Jun 2019 17:31:13 +0200 (CEST)
Date:   Tue, 18 Jun 2019 17:31:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND nf-next] netfilter: add support for matching IPv4
 options
Message-ID: <20190618153112.jwomdzit6mdawssi@salvia>
References: <20190611120912.3825-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611120912.3825-1-ssuryaextr@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 08:09:12AM -0400, Stephen Suryaputra wrote:
[...]
> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index a940c9fd9045..4155a32fade7 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -62,6 +62,125 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
>  	regs->verdict.code = NFT_BREAK;
>  }
>  
> +/* find the offset to specified option or the header beyond the options
> + * if target < 0.
> + *
> + * If target header is found, its offset is set in *offset and return option
> + * number. Otherwise, return negative error.
> + *
> + * If the first fragment doesn't contain the End of Options it is considered
> + * invalid.
> + */
> +static int ipv4_find_option(struct net *net, struct sk_buff *skb,
> +			    unsigned int *offset, int target,
> +			    unsigned short *fragoff, int *flags)

flags is never used, please remove it.

> +{
> +	unsigned char optbuf[sizeof(struct ip_options) + 41];

In other parts of the kernel this is + 40:

net/ipv4/cipso_ipv4.c:  unsigned char optbuf[sizeof(struct ip_options) + 40];

here it is + 41.

> +	struct ip_options *opt = (struct ip_options *)optbuf;
> +	struct iphdr *iph, _iph;
> +	unsigned int start;
> +	bool found = false;
> +	__be32 info;
> +	int optlen;
> +
> +	if (fragoff)
> +		*fragoff = 0;

fragoff is set and never used. Please, remove this parameter.

> +	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> +	if (!iph || iph->version != 4)
> +		return -EBADMSG;
> +	start = sizeof(struct iphdr);
> +
> +	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
> +	if (optlen <= 0)
> +		return -ENOENT;
> +
> +	memset(opt, 0, sizeof(struct ip_options));
> +	/* Copy the options since __ip_options_compile() modifies
> +	 * the options. Get one byte beyond the option for target < 0

How does this "one byte beyond the option" trick works?

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
> +		if (!opt->srr)
> +			break;
> +		found = target == IPOPT_SSRR ? opt->is_strictroute :
> +					       !opt->is_strictroute;
> +		if (found)
> +			*offset = opt->srr + start;
> +		break;
> +	case IPOPT_RR:
> +		if (opt->rr)
> +			break;
> +		*offset = opt->rr + start;
> +		found = true;
> +		break;
> +	case IPOPT_RA:
> +		if (opt->router_alert)
> +			break;
> +		*offset = opt->router_alert + start;
> +		found = true;
> +		break;
> +	default:
> +		/* Either not supported or not a specific search, treated as
> +		 * found
> +		 */
> +		found = true;
> +		if (target >= 0) {
> +			target = -EOPNOTSUPP;
> +			break;
> +		}
> +		if (opt->end) {
> +			*offset = opt->end + start;
> +			target = IPOPT_END;

May I ask, what's the purpose of IPOPT_END? :-)

> +		} else {
> +			/* Point to beyond the options. */
> +			*offset = optlen + start;
> +			target = opt->__data[optlen];
> +		}
> +	}
> +	if (!found)
> +		target = -ENOENT;
> +	return target;

nitpick: Probably replace code above.

        return found ? target : -ENOENT;

Apart from the above, this looks good to me.

Thanks!
