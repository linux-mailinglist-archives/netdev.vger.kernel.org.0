Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344044BF75
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbfFSRSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:18:37 -0400
Received: from mail.us.es ([193.147.175.20]:33598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbfFSRSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 13:18:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 44C04C1D51
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 19:18:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 35574DA710
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 19:18:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2ABB7DA70B; Wed, 19 Jun 2019 19:18:35 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33CC3DA702;
        Wed, 19 Jun 2019 19:18:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 19:18:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 142E74265A2F;
        Wed, 19 Jun 2019 19:18:33 +0200 (CEST)
Date:   Wed, 19 Jun 2019 19:18:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND nf-next] netfilter: add support for matching IPv4
 options
Message-ID: <20190619171832.om7losybbkysuk4r@salvia>
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
[...]
> +static int ipv4_find_option(struct net *net, struct sk_buff *skb,
> +			    unsigned int *offset, int target,
> +			    unsigned short *fragoff, int *flags)
> +{
[...]
> +	switch (target) {
> +	case IPOPT_SSRR:
> +	case IPOPT_LSRR:
[...]
> +	case IPOPT_RR:
[...]
> +	case IPOPT_RA:
[...]
> +	default:
> +		/* Either not supported or not a specific search, treated as
> +		 * found
> +		 */
> +		found = true;
> +		if (target >= 0) {
> +			target = -EOPNOTSUPP;
> +			break;
> +		}

Rules with this options will load fine:

ip option eol type 1
ip option noop type 1
ip option sec type 1
ip option timestamp type 1
ip option rr type 1
ip option sid type 1

However, they will not ever match I think.

found is set to true, but target is set to EOPNOTSUPP, then...

[...]
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
> +	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type, NULL, NULL);

... ipv4_find_option() returns -EOPNOTSUPP which says header does
not exist.

> +	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
> +		*dest = (err >= 0);
> +		return;
> +	} else if (err < 0) {
> +		goto err;
> +	}
