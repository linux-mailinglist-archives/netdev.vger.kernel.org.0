Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2192EEBB0
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbhAHDHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbhAHDHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 22:07:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 893F82368A;
        Fri,  8 Jan 2021 03:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610075228;
        bh=nrMCl51A3Af3kjVw3IPmSs2Jss0zuzC6nChzWAzhAdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PRxyQSbQ/GPzzCUjMcOdaisSZ9JCV60KajYC8mPwqDtplkp/cvDiZhwPzCQl5p34M
         0mhn9F4uBre5pfuPSkJDR+OImA5COkZBq65PMCLitv1ZtyhNLunZVaOJKdg9BXg9kT
         oj0CdkONRjkM4vQK5OMX3C5pURTzc3gC9FirYTQ3FbTGoKJ+nQv/VpSmWC035N3EXh
         b9VYRY6FU7GPRbrmgXhciqVeDx1HHmEudy15rI8AAwSgv/MGUglVKalWKD0839NpVU
         5pVZRRlpsVvJpafClUa9AphKQNOfbF6ml2+xXzTc/4Od/VAS1C/Na+RUtHpR7l7/I5
         z8i4wYqAmHy2g==
Date:   Thu, 7 Jan 2021 19:07:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 04/11] net/mlx5e: CT: Use per flow counter when CT flow
 accounting is enabled
Message-ID: <20210107190707.6279d0ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107202845.470205-5-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
        <20210107202845.470205-5-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 12:28:38 -0800 Saeed Mahameed wrote:
> +	int ret;
> +
> +	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
> +	if (!counter)
> +		return ERR_PTR(-ENOMEM);
> +
> +	counter->is_shared = false;
> +	counter->counter = mlx5_fc_create(ct_priv->dev, true);
> +	if (IS_ERR(counter->counter)) {
> +		ct_dbg("Failed to create counter for ct entry");
> +		ret = PTR_ERR(counter->counter);
> +		kfree(counter);
> +		return ERR_PTR(ret);

The err ptr -> ret -> err ptr conversion seems entirely pointless, no?
