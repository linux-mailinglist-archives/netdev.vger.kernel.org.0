Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE3326369F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 21:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgIIT2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 15:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgIIT2I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 15:28:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A22521D43;
        Wed,  9 Sep 2020 19:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599679687;
        bh=OyWimL7acV9WXiLtRmnudXX2Qe3WRNc37aLFgOBS3QA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BMh9bGM8jkqetXmWvjVX6DjXmkwHqqKyE+eEU4Dyc/zlsdgpkEO9IKkOUq0JaoHaP
         QgHhP9Ud384TnhH9zQhcSsslrabIAp7laQ+LAJHE3zLJrIDIiDTyebxqE0J2LgJzUd
         DcxTyJNo5OW3gYs+pmLKK0R92k3fB9gPRUVHR5Rs=
Date:   Wed, 9 Sep 2020 12:28:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>
Subject: Re: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to
 en_tx.c
Message-ID: <20200909122805.1157cbb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f99402b166904107f1ea8051fd0a9ab4b6143e79.camel@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
        <20200909012757.32677-4-saeedm@nvidia.com>
        <20200908.202836.574556740303703917.davem@davemloft.net>
        <20200908.202913.497073980249985510.davem@davemloft.net>
        <f99402b166904107f1ea8051fd0a9ab4b6143e79.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 19:22:02 +0000 Saeed Mahameed wrote:
> On Tue, 2020-09-08 at 20:29 -0700, David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Tue, 08 Sep 2020 20:28:36 -0700 (PDT)
> >   
> > > From: Saeed Mahameed <saeedm@nvidia.com>
> > > Date: Tue, 8 Sep 2020 18:27:48 -0700
> > >   
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > > > @@ -232,6 +232,29 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq
> > > > *sq, struct sk_buff *skb,
> > > >  	return -ENOMEM;
> > > >  }
> > > >  
> > > > +static inline bool mlx5e_transport_inline_tx_wqe(struct
> > > > mlx5_wqe_ctrl_seg *cseg)
> > > > +{
> > > > +	return cseg && !!cseg->tis_tir_num;
> > > > +}
> > > > +
> > > > +static inline u8
> > > > +mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct
> > > > mlx5_wqe_ctrl_seg *cseg,
> > > > +			 struct sk_buff *skb)
> > > > +{  
> > > 
> > > No inlines in foo.c files, please.  
> > 
> > I see you're doing this even more later in this series.
> > 
> > Please fix all of this up, thank you.  
> 
> Maxim really tried here to avoid this without huge performance
> degradation (~6.4% reduce in packet rate), due to the refactoring
> patches gcc yields non optimal code, as we explained in the commit
> messages and cover-letter
> 
> Our other option is making the code very ugly with no code reuse in the
> tx path, so we would really appreciate if you could relax the no-inline 
> guideline for this series.

Why are you requesting a whole pass on the series when only _some_
inlines make a difference here?
