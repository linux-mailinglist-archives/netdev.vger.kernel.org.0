Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA382AFB6D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgKKWgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgKKWeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:34:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 044B32151B;
        Wed, 11 Nov 2020 22:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605134055;
        bh=cDd9rSGpc+tj7CwD4EG1t7Fs/wSZq/5tOQJG8BSPAvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YDAzh+al9VcUpuEBd3VWtE5CY8gVkK+3DXkv9O3wtdTlNFjO7A+4+Uu/BBANd4oHh
         jeugcuWczf/oTzfoGvXpQNHinPhHJ/tJLkMD4AFMZYcNav+iNf9ttPEy2Iew5d5juG
         1mvmiJXBRS/T07nl9yQ6/941YCppObp+dMxWTO+c=
Date:   Wed, 11 Nov 2020 14:34:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
Subject: Re: [PATCH net-next v4 09/15] net/smc: Introduce SMCR get linkgroup
 command
Message-ID: <20201111143405.7f5fb92f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109151814.15040-10-kgraul@linux.ibm.com>
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
        <20201109151814.15040-10-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 16:18:08 +0100 Karsten Graul wrote:
> @@ -295,6 +377,14 @@ static int smc_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  
>  static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
>  {
> +	struct smc_diag_req_v2 *req = nlmsg_data(cb->nlh);
> +
> +	if (req->cmd == SMC_DIAG_GET_LGR_INFO) {
> +		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCR - 1))))
> +			smc_diag_fill_lgr_list(smc_diag_ops->get_lgr_list(),
> +					       skb, cb, req);
> +	}
> +
>  	return skb->len;
>  }

IDK if this is appropriate for socket diag handler.

Is there precedent for funneling commands through socket diag instead
of just creating a genetlink family?
