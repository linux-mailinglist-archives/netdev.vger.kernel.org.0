Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D333634BA
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 13:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhDRLHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 07:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhDRLHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 07:07:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8653761207;
        Sun, 18 Apr 2021 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618744030;
        bh=HTbwRQUZ+vGFyKEPetl1Ur9dkU3AasCstAz+YU+zUQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y6pQ/KG+LHuURCzPRR7MncCx1rmu4mhpcvY1kfejExNbDrDzpI2MDpeyTcUxjdSoL
         P5bQpBAVnsWqBFaiQzJuU2l9yA8bUAzbTx8ohuUj0m7rcp2JX7W/9MX8H785lVpu8r
         qz/iq4ls1rngTwtH8GALZQjA7kh3xC+P9evvEC2fOOoWOp/2w018cjwfS32bHNYW0P
         /pYvPNqLB2haLauDarwC/n+n7d6lrCqJjphxj2TdGFgWIOqm+QZCm22ScKlZfUw7rq
         v/RF/A4pB3n9kY+eMKZIb/QZUryhQXSTOermcvJkZaAvEfRuuzsdfPRmz508tpZHgX
         t8dtgLTdRIFAQ==
Date:   Sun, 18 Apr 2021 14:07:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2] rdma: stat: initialize ret in
 stat_qp_show_parse_cb()
Message-ID: <YHwS2pu/oSdC4qFt@unreal>
References: <2b6d2d8c4fdcf53baea43c9fbe9f929d99257809.1618350667.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b6d2d8c4fdcf53baea43c9fbe9f929d99257809.1618350667.git.aclaudi@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 12:50:57AM +0200, Andrea Claudi wrote:
> In the unlikely case in which the mnl_attr_for_each_nested() cycle is
> not executed, this function return an uninitialized value.
> 
> Fix this initializing ret to 0.
> 
> Fixes: 5937552b42e4 ("rdma: Add "stat qp show" support")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  rdma/stat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rdma/stat.c b/rdma/stat.c
> index 75d45288..3abedae7 100644
> --- a/rdma/stat.c
> +++ b/rdma/stat.c
> @@ -307,7 +307,7 @@ static int stat_qp_show_parse_cb(const struct nlmsghdr *nlh, void *data)
>  	struct rd *rd = data;
>  	const char *name;
>  	uint32_t idx;
> -	int ret;
> +	int ret = 0;

It should be MNL_CB_OK which is 1 and not 0.

Thanks.

>  
>  	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
>  	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
> -- 
> 2.30.2
> 
