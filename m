Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905F12C4C10
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgKZAah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgKZAah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 19:30:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC72020872;
        Thu, 26 Nov 2020 00:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606350636;
        bh=N4lNPIU4pyCxCLmsiqSBe3XkWKbkSsItyN++mgnOHdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YHCiyQVBwEaKwkgPE8oFO1RrkXle8N7VDfIi/x+i/Pzk/c3ZP7zB3wbnu2u2U9Y1L
         gYsQ+bED71Ymk/Clo5QbbC1w7zLG6d1JHLFUy/5D5HIFeVpZDKw6CYM3bMGiT0eZRG
         OCKBnZSKkDGTjvMBvCqVgVjYq+SFg5o9JmmO/+bA=
Date:   Wed, 25 Nov 2020 16:30:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next v5 10/14] net/smc: Introduce SMCR get linkgroup
 command
Message-ID: <20201125163034.7a4c526e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124175047.56949-11-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
        <20201124175047.56949-11-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 18:50:43 +0100 Karsten Graul wrote:
> +static int smc_nl_fill_lgr(struct smc_link_group *lgr,
> +			   struct sk_buff *skb,
> +			   struct netlink_callback *cb)
> +{
> +	char smc_target[SMC_MAX_PNETID_LEN + 1];
> +	struct nlattr *attrs;
> +
> +	attrs = nla_nest_start_noflag(skb, SMC_GEN_LGR_SMCR);
> +	if (!attrs)
> +		goto errout;
> +
> +	if (nla_put_u32(skb, SMC_NLA_LGR_R_ID, *((u32 *)&lgr->id)) < 0)
> +		goto errattr;
> +	if (nla_put_u32(skb, SMC_NLA_LGR_R_CONNS_NUM, lgr->conns_num) < 0)
> +		goto errattr;
> +	if (nla_put_u8(skb, SMC_NLA_LGR_R_ROLE, lgr->role) < 0)
> +		goto errattr;
> +	if (nla_put_u8(skb, SMC_NLA_LGR_R_TYPE, lgr->type) < 0)
> +		goto errattr;
> +	if (nla_put_u8(skb, SMC_NLA_LGR_R_VLAN_ID, lgr->vlan_id) < 0)
> +		goto errattr;
> +	memset(smc_target, 0, sizeof(smc_target));

unnecessary

> +	snprintf(smc_target, sizeof(smc_target), "%s", lgr->pnet_id);
> +	if (nla_put_string(skb, SMC_NLA_LGR_R_PNETID, smc_target) < 0)
> +		goto errattr;
> +
> +	nla_nest_end(skb, attrs);
> +	return 0;
> +errattr:
> +	nla_nest_cancel(skb, attrs);
> +errout:
> +	return -EMSGSIZE;
> +}
> +
> +static int smc_nl_handle_lgr(struct smc_link_group *lgr,
> +			     struct sk_buff *skb,
> +			     struct netlink_callback *cb)
> +{
> +	int rc = 0;

unnecessary init

> +	void *nlh;
> +
> +	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
> +			  &smc_gen_nl_family, NLM_F_MULTI,
> +			  SMC_NETLINK_GET_LGR_SMCR);
> +	if (!nlh)
> +		return -EMSGSIZE;
> +	rc = smc_nl_fill_lgr(lgr, skb, cb);
> +	if (rc < 0)
> +		goto errout;
> +
> +	genlmsg_end(skb, nlh);
> +	return rc;

smc_nl_fill_lgr() never return positive values (why would it?)
so:

	if (rc)
		...
	...

	return 0;

> +errout:
> +	genlmsg_cancel(skb, nlh);
> +	return rc;
> +}

>  static const struct nla_policy smc_gen_nl_policy[SMC_GEN_MAX + 1] = {
>  	[SMC_GEN_UNSPEC]	= { .type = NLA_UNSPEC, },
>  	[SMC_GEN_SYS_INFO]	= { .type = NLA_NESTED, },
> +	[SMC_GEN_LGR_SMCR]	= { .type = NLA_NESTED, },

not an input attr
