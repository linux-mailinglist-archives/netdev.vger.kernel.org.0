Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309472EECB9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 05:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbhAHE4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 23:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbhAHE4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 23:56:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 932A622DBF;
        Fri,  8 Jan 2021 04:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610081762;
        bh=jZ1cX5gUXuxHIIddR3QdeHUg44LZndGZxvWCTC3kkxw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UhLnsGvo3Fqw6OcOtR58vikSUc9Q6b3BMokq768GN30qd6y8eIHug/Vs4YhSdpBW8
         d4bPFkWBlnjbv7dduvTxxsC+8Ru2FjnE0074Acip2iLKMg3F+WRg3cay/XiY5RCSv+
         viH90RumcTG9vRNZ9ilJSNBd8lpGsoOYbMnWFlV6Ci84DdOYOmpgPO+6gCjd/qCclE
         yLCzL0xWrnVlNJOtw9CCeHzc8MfpIVVsHI9NHO0w1WMYv6iG1sRdwPnM2jL/M4cSBr
         4HoZve3su6/tdtGHCh+8XO1l8dE24UZ0WmGKoAEmTR7xAQIieC3Ij5M19vm20WpWAQ
         K5+Q4a79cxazw==
Message-ID: <44dcfbd9ba4fd655c05c0b3a4a6e26042d5c2639.camel@kernel.org>
Subject: Re: [net 04/11] net/mlx5e: CT: Use per flow counter when CT flow
 accounting is enabled
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Date:   Thu, 07 Jan 2021 20:56:01 -0800
In-Reply-To: <20210107204058.7fd624ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210107202845.470205-1-saeed@kernel.org>
         <20210107202845.470205-5-saeed@kernel.org>
         <20210107190707.6279d0ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <c3291eb2e888ac0f86ce163931d4680fb56b11a8.camel@kernel.org>
         <59a7dcba82adfabb16cd49e89dafa02aa37b6fd4.camel@kernel.org>
         <20210107204058.7fd624ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-07 at 20:40 -0800, Jakub Kicinski wrote:
> On Thu, 07 Jan 2021 20:18:36 -0800 Saeed Mahameed wrote:
> > On Thu, 2021-01-07 at 20:06 -0800, Saeed Mahameed wrote:
> > > On Thu, 2021-01-07 at 19:07 -0800, Jakub Kicinski wrote:  
> > > > On Thu,  7 Jan 2021 12:28:38 -0800 Saeed Mahameed wrote:  
> > > > > +	int ret;
> > > > > +
> > > > > +	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
> > > > > +	if (!counter)
> > > > > +		return ERR_PTR(-ENOMEM);
> > > > > +
> > > > > +	counter->is_shared = false;
> > > > > +	counter->counter = mlx5_fc_create(ct_priv->dev, true);
> > > > > +	if (IS_ERR(counter->counter)) {
> > > > > +		ct_dbg("Failed to create counter for ct
> > > > > entry");
> > > > > +		ret = PTR_ERR(counter->counter);
> > > > > +		kfree(counter);
> > > > > +		return ERR_PTR(ret);  
> > > > 
> > > > The err ptr -> ret -> err ptr conversion seems entirely
> > > > pointless,
> > > > no?  
> > > Indeed, will address this in a net-next patch
> > >   
> > 
> > Actually no, because counter is being kfreed so we must return
> > ERR_PTR(ret).
> 
> Ah, good point, just the other one then:
> 
> +	shared_counter = mlx5_tc_ct_counter_create(ct_priv);
> +	if (IS_ERR(shared_counter)) {
> +		ret = PTR_ERR(shared_counter);
>  		return ERR_PTR(ret);
>  	}
Done, will send to net-next once this is back merged.

Thanks.

