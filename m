Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2396F2EEC97
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 05:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbhAHElk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 23:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbhAHElj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 23:41:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15EC722A99;
        Fri,  8 Jan 2021 04:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610080859;
        bh=88X1ldRLcvLO2m7GnfiseDFFwIi0ZZJbgtW+jOJ823M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WgRKHq0WrxwlEroP6pbdant0dDl9k7TytFUZAE1EH5sJeFF8cR9HgQruB13ImXWlf
         LNOlJVJD3p92Ml8lPtEhBFrV9AKuX0VmaVnSEUDAP4Q1d2Ifkgmk0PcF9IF9EGh6WV
         SNUYLBK2Y9BbbkziLfwCa4v2xyLfZNVZ76lASZs8wJzKkJ0ukakHqlvmABK44vWHpQ
         4KO6lL5/mRWYth/yRn2sI6HQJ61VxVarh/HT63p3q7QfEhZQR1SfMEu1VZkuJUBZoK
         9xJq67BXNCGxO7TrVKAoCl8O61sS6N3QddbHzgpGTdfNX3/rs1hRFPe5jnBqtGqRfq
         +v/EMdS3sJnPg==
Date:   Thu, 7 Jan 2021 20:40:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [net 04/11] net/mlx5e: CT: Use per flow counter when CT flow
 accounting is enabled
Message-ID: <20210107204058.7fd624ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <59a7dcba82adfabb16cd49e89dafa02aa37b6fd4.camel@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
        <20210107202845.470205-5-saeed@kernel.org>
        <20210107190707.6279d0ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c3291eb2e888ac0f86ce163931d4680fb56b11a8.camel@kernel.org>
        <59a7dcba82adfabb16cd49e89dafa02aa37b6fd4.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 07 Jan 2021 20:18:36 -0800 Saeed Mahameed wrote:
> On Thu, 2021-01-07 at 20:06 -0800, Saeed Mahameed wrote:
> > On Thu, 2021-01-07 at 19:07 -0800, Jakub Kicinski wrote:  
> > > On Thu,  7 Jan 2021 12:28:38 -0800 Saeed Mahameed wrote:  
> > > > +	int ret;
> > > > +
> > > > +	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
> > > > +	if (!counter)
> > > > +		return ERR_PTR(-ENOMEM);
> > > > +
> > > > +	counter->is_shared = false;
> > > > +	counter->counter = mlx5_fc_create(ct_priv->dev, true);
> > > > +	if (IS_ERR(counter->counter)) {
> > > > +		ct_dbg("Failed to create counter for ct entry");
> > > > +		ret = PTR_ERR(counter->counter);
> > > > +		kfree(counter);
> > > > +		return ERR_PTR(ret);  
> > > 
> > > The err ptr -> ret -> err ptr conversion seems entirely pointless,
> > > no?  
> > Indeed, will address this in a net-next patch
> >   
> 
> Actually no, because counter is being kfreed so we must return
> ERR_PTR(ret).

Ah, good point, just the other one then:

+	shared_counter = mlx5_tc_ct_counter_create(ct_priv);
+	if (IS_ERR(shared_counter)) {
+		ret = PTR_ERR(shared_counter);
 		return ERR_PTR(ret);
 	}
