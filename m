Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C2C1E2A41
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388663AbgEZSpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgEZSpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:45:46 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61EDF2070A;
        Tue, 26 May 2020 18:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590518746;
        bh=dTkEYg4KSMJPZZj0UBOXCaw3CX1QFptE1NpfaQYBtzU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z0giFQYOAC4/gnwHuXpcY3ZaF9sY83uvESW06bwRd3DY+wd3kepO3vEelFhs/TtOy
         pMgm2VuYeWbapR0fiRubUazvYHMDeX61veQSuWZhANTNrVP2gawrOTcQmlFGsA/NDt
         UNPDY+kfvyRtzSH2b/HV3L4a932XLoJ6zpjAA/eg=
Date:   Tue, 26 May 2020 11:45:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] netfilter: conntrack: make conntrack userspace
 helpers work again
Message-ID: <20200526114544.2510d245@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200525215420.2290-5-pablo@netfilter.org>
References: <20200525215420.2290-1-pablo@netfilter.org>
        <20200525215420.2290-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 May 2020 23:54:19 +0200 Pablo Neira Ayuso wrote:
> +/* This packet is coming from userspace via nf_queue, complete the packet
> + * processing after the helper invocation in nf_confirm().
> + */
> +static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
> +			       enum ip_conntrack_info ctinfo)
> +{
> +	const struct nf_conntrack_helper *helper;
> +	const struct nf_conn_help *help;
> +	unsigned int protoff;
> +
> +	help = nfct_help(ct);
> +	if (!help)
> +		return 0;
> +
> +	helper = rcu_dereference(help->helper);
> +	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
> +		return 0;
> +
> +	switch (nf_ct_l3num(ct)) {
> +	case NFPROTO_IPV4:
> +		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case NFPROTO_IPV6: {
> +		__be16 frag_off;
> +		u8 pnum;
> +
> +		pnum = ipv6_hdr(skb)->nexthdr;
> +		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
> +					   &frag_off);
> +		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
> +			return 0;
> +		break;
> +	}

net/netfilter/nf_conntrack_core.c: In function nf_confirm_cthelper:
net/netfilter/nf_conntrack_core.c:2117:15: warning: comparison of unsigned expression in < 0 is always false [-Wtype-limits]
 2117 |   if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
      |               ^
