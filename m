Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59D231847C
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 06:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBKFK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 00:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhBKFKX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 00:10:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18EDF64E38;
        Thu, 11 Feb 2021 05:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613020182;
        bh=zqdtb3fGIGTUEp17VaGDnURn/UBoksNTM5/Kan26Qug=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sbdea4K/m/vYWhVcYy+Ttr50L4qyqbLC3Ee3He2OJFC9wt1doE+5AtbE0pJMfTZEZ
         jLS/8MxtrI/T7lmeFNruU3cV4BYLpbq7UsxhXph8NwopDRvAMjyQH1Dtp6K7L8uQyK
         yhzXHziGYOwjMwl++j0hBIVaOo8WnuRdr3v1ac1TEqYPrpduKluxeeNAb98aeCUg1q
         4/87wYiC6VJr5Z9T82h9+VVozlcy+LCDv8WNedJuX5aEKuP8PmqoImcCccA3mTWROE
         2Ysisp57SWhV3Nmd/mtMElH6y0YJnwWnIpzfoItd/PW87ygdEnlM1/slrKJDanZR5Q
         QbZPQQoJrFSKg==
Message-ID: <30482e059a48fb35f90a7594355bc27dcd71dacc.camel@kernel.org>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     Chris Mi <cmi@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, kernel test robot <lkp@intel.com>
Date:   Wed, 10 Feb 2021 21:09:41 -0800
In-Reply-To: <20210209064702.GB139298@unreal>
References: <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
         <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
         <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20210130144231.GA3329243@shredder.lan>
         <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
         <20210201180837.GB3456040@shredder.lan> <20210208070350.GB4656@unreal>
         <20210208085746.GA179437@shredder.lan> <20210208090702.GB20265@unreal>
         <20210208170735.GA207830@shredder.lan> <20210209064702.GB139298@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-02-09 at 08:47 +0200, Leon Romanovsky wrote:
> On Mon, Feb 08, 2021 at 07:07:35PM +0200, Ido Schimmel wrote:
> > On Mon, Feb 08, 2021 at 11:07:02AM +0200, Leon Romanovsky wrote:
> > 
> > 

[...]

> > I don't know. What are they complaining about? That psample needs
> > to be
> > installed for mlx5_core to be loaded? How come the rest of the
> > dependencies are installed?
> 
> The psample module was first dependency that caught our attention. It
> is
> here as an example of such not-needed dependency. Like Saeed said, we
> are
> interested in more general solution that will allow us to use
> external
> modules in fully dynamic mode.
> 
> Internally, as a preparation to the submission of mlx5 code that used
> nf_conntrack,
> we found that restart of firewald service will bring down our
> mlx5_core driver, because
> of such dependency.
> 
> So to answer on your question, HPC didn't complain yet, but we don't
> have any plans
> to wait till they complain.
> 
> > 
> > Or are they complaining about the size / memory footprint of
> > psample?
> > Because then they should first check mlx5_core when all of its
> > options
> > are blindly enabled as part of a distribution config.
> 
> You are too focused on psample, while Saeed and I are saying more
> general statement "I prefer to have 0 dependency on external modules
> in a HW driver."
> 
> > 
> > AFAICS, mlx5 still does not have any code that uses psample. You
> > can
> > wrap it in a config option and keep the weak dependency on psample.
> > Something like:
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > index ad45d20f9d44..d17d03d8cc8b 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > @@ -104,6 +104,15 @@ config MLX5_TC_CT
> > 
> >           If unsure, set to Y
> > 
> > +config MLX5_TC_SAMPLE
> > +       bool "MLX5 TC sample offload support"
> > +       depends on MLX5_CLS_ACT
> > +       depends on PSAMPLE || PSAMPLE=n
> > +       default n
> > +       help
> > +         Say Y here if you want to support offloading tc rules
> > that use sample
> > +          action.
> > +
> 

This won't solve anything other than compilation time dependency
between built-in modules to external modules, this is not the case.

our case is when both mlx5 and psample are modules, you can't load mlx5
without loading psample, even if you are not planning to use psample or
mlx5 psample features, which is 99.99% of the cases.

What we are asking for here is not new, and is a common practice in
netdev stack

see :
udp_tunnel_nic_ops
netfilter is full of these, see nf_ct_hook..

I don't see anything wrong with either repeating this practice for any
module or having some sort of a generic proxy in the built-in netdev
layer..




