Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CF9261923
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731946AbgIHSIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732301AbgIHSIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 14:08:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A93A62078E;
        Tue,  8 Sep 2020 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599588480;
        bh=wD+PevNu9ZUwbSWWPVHeFyyXrhPgm4ZFmuFPJ/b6e9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e+Iv4MmmfEMy4/anNYsIUr99BEDCerhQ9y+EwZ8uzcPAyUiAILmk3SAWNVb3XdUCZ
         DCjIEtQcHKfJEyb2LJNZQ+QKHAsLrfKVRlfqxOYVazdi+7I3Ec43IAGza54rmVPd/h
         /G2ONatqqm5sOrb1v0LZGue4GyjlNGP7logB/YR4=
Date:   Tue, 8 Sep 2020 11:07:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 06/10] net/mlx5e: Support multiple SKBs in a TX WQE
Message-ID: <20200908110757.477bacb8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <489a69c6-d288-4cb4-fe32-8d4bd6f37667@nvidia.com>
References: <20200903210022.22774-1-saeedm@nvidia.com>
        <20200903210022.22774-7-saeedm@nvidia.com>
        <20200903154609.363e8c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <489a69c6-d288-4cb4-fe32-8d4bd6f37667@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 11:59:54 +0300 Maxim Mikityanskiy wrote:
> On 2020-09-04 01:46, Jakub Kicinski wrote:
> > On Thu, 3 Sep 2020 14:00:18 -0700 Saeed Mahameed wrote:  
> >> +static inline void mlx5e_tx_wi_consume_fifo_skbs(struct mlx5e_txqsq *sq,
> >> +						 struct mlx5e_tx_wqe_info *wi,
> >> +						 struct mlx5_cqe64 *cqe,
> >> +						 int napi_budget)
> >> +{
> >> +	int i;
> >> +
> >> +	for (i = 0; i < wi->num_fifo_pkts; i++) {
> >> +		struct sk_buff *skb = mlx5e_skb_fifo_pop(sq);
> >> +
> >> +		mlx5e_consume_skb(sq, skb, cqe, napi_budget);
> >> +	}
> >> +}  
> > 
> > The compiler was not inlining this one either?  
> 
> Regarding this one, gcc inlines it automatically, but I went on the safe 
> side and inlined it explicitly - it's small and called for every WQE, so 
> we never want it to be non-inline.

Everyone always wants to be on the safe side :/ That's not an argument
we accept in this context.
