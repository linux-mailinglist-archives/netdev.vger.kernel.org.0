Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4022C4C01
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgKZA0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgKZA0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 19:26:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C9F820872;
        Thu, 26 Nov 2020 00:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606350364;
        bh=8Su3BFyICxePXADOf5aMAJTD72efA//tE0ETB0oHBBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VfJ+fqJwo9tSvsaJ7BonHfB35J0RZ4mafsmcdcJFWIfvD86qMBZ1rIf05xWjm7Guw
         nTVfLGMd/GtnR2cT8qZs5Ihhvuhq2CBCgloHmxbGvP6omgqHz/QEM65vpMjKPteHAV
         q0iKCv9rQZ6XkJI/v36Cw9NsNnfWrL0ynfaPJYcM=
Date:   Wed, 25 Nov 2020 16:26:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next v5 09/14] net/smc: Add support for obtaining
 system information
Message-ID: <20201125162603.4a465e01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124175047.56949-10-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
        <20201124175047.56949-10-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 18:50:42 +0100 Karsten Graul wrote:
> @@ -214,6 +217,67 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
>  	conn->lgr = NULL;
>  }
>  
> +int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
> +	char hostname[SMC_MAX_HOSTNAME_LEN + 1];
> +	int snum = cb_ctx->pos[0], num = 0;
> +	char smc_seid[SMC_MAX_EID_LEN + 1];
> +	struct smcd_dev *smcd_dev;
> +	struct nlattr *attrs;
> +	u8 *seid = NULL;
> +	u8 *host = NULL;
> +	void *nlh;
> +
> +	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
> +			  &smc_gen_nl_family, NLM_F_MULTI,
> +			  SMC_NETLINK_GET_SYS_INFO);
> +	if (!nlh)
> +		goto errout;
> +	if (snum > num)

can just say if (snum) or if (cb_ctx->pos[0])

> +		goto errout;
> +	attrs = nla_nest_start_noflag(skb, SMC_GEN_SYS_INFO);
> +	if (!attrs)
> +		goto errout;
> +	if (nla_put_u8(skb, SMC_NLA_SYS_VER, SMC_V2) < 0)
> +		goto errattr;
> +	if (nla_put_u8(skb, SMC_NLA_SYS_REL, SMC_RELEASE) < 0)
> +		goto errattr;
> +	if (nla_put_u8(skb, SMC_NLA_SYS_IS_ISM_V2,
> +		       smc_ism_is_v2_capable()) < 0)
> +		goto errattr;
> +	smc_clc_get_hostname(&host);
> +	if (host) {
> +		memset(hostname, 0, sizeof(hostname));

This memset looks unnecessary.

> +		snprintf(hostname, sizeof(hostname), "%s", host);
> +		if (nla_put_string(skb, SMC_NLA_SYS_LOCAL_HOST, hostname) < 0)
> +			goto errattr;
> +	}
> +	mutex_lock(&smcd_dev_list.mutex);
> +	smcd_dev = list_first_entry_or_null(&smcd_dev_list.list,
> +					    struct smcd_dev, list);
> +	if (smcd_dev)
> +		smc_ism_get_system_eid(smcd_dev, &seid);
> +	mutex_unlock(&smcd_dev_list.mutex);
> +	if (seid && smc_ism_is_v2_capable()) {
> +		memset(smc_seid, 0, sizeof(smc_seid));

ditto

> +		snprintf(smc_seid, sizeof(smc_seid), "%s", seid);
> +		if (nla_put_string(skb, SMC_NLA_SYS_SEID, smc_seid) < 0)
> +			goto errattr;
> +	}
> +	nla_nest_end(skb, attrs);
> +	genlmsg_end(skb, nlh);
> +	num++;
> +	cb_ctx->pos[0] = num;

and set this to 1, num seems pointless (I don't see this function
extended in the next patches, maybe I missed it).

> +	return skb->len;
> +
> +errattr:
> +	nla_nest_cancel(skb, attrs);
> +errout:
> +	genlmsg_cancel(skb, nlh);
> +	return skb->len;
> +}

>  static const struct nla_policy smc_gen_nl_policy[SMC_GEN_MAX + 1] = {
>  	[SMC_GEN_UNSPEC]	= { .type = NLA_UNSPEC, },
> +	[SMC_GEN_SYS_INFO]	= { .type = NLA_NESTED, },

You never use this as an input attribute, you don't have to add it to
policy. Policy is for input validation.

>  };
>  
> +static int smc_nl_start(struct netlink_callback *cb)
> +{
> +	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
> +
> +	cb_ctx->pos[0] = 0;

IIRC context is memset to 0 at the start, no need for this.

> +	return 0;
> +}
