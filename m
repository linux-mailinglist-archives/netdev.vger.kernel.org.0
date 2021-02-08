Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9025312AFC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBHHEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhBHHEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 02:04:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D3E764E6F;
        Mon,  8 Feb 2021 07:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612767835;
        bh=N75mXS1/xQ073PsCL5kSLG2k8JxkkouUcv+uhwYmyHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A5k4JD2ozFojYOwaXxz/BqlqO6+CuOGvUiRJzLdmDGG4kcWCZoGa59qmD4VhWtwmt
         emojzLtWcSiH2Y1V9uV/1QmSP6Z1cjRFvKM8eltSKF6c1iKnrWJPfM7L7D6Pv7ytKZ
         5T2tM15D+FXC45ASbykBuw8OMvpTB8uesfUBhrrc4e/zbQ9VPt3uiIAxoozms+I+3c
         cxMjkpTlgSak517+hyRk5/S5X44UZbidMBWMjy+UXwaR3TQCeRTTI86ecrlCVWylec
         7iRAaToCiTs71+IuhCsVk8czuBbmstS4Tvprd+O+pmBcLNC2IG5BGd5+Io1kwUX2f8
         2ztKGj6cNxtrQ==
Date:   Mon, 8 Feb 2021 09:03:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Chris Mi <cmi@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210208070350.GB4656@unreal>
References: <20210128014543.521151-1-cmi@nvidia.com>
 <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
 <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
 <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan>
 <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
 <20210201180837.GB3456040@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201180837.GB3456040@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 08:08:37PM +0200, Ido Schimmel wrote:
> On Mon, Feb 01, 2021 at 09:37:11AM +0800, Chris Mi wrote:
> > Hi Ido,
> >
> > On 1/30/2021 10:42 PM, Ido Schimmel wrote:
> > > On Fri, Jan 29, 2021 at 12:30:09PM -0800, Jakub Kicinski wrote:
> > > > On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
> > > > > Instead of discussing it several days, maybe it's better to review
> > > > > current patch, so that we can move forward :)
> > > > It took you 4 revisions to post a patch which builds cleanly and now
> > > > you want to hasten the review? My favorite kind of submission.
> > > >
> > > > The mlxsw core + spectrum drivers are 65 times the size of psample
> > > > on my system. Why is the dependency a problem?
> > > mlxsw has been using psample for ~4 years and I don't remember seeing a
> > > single complaint about the dependency. I don't understand why this patch
> > > is needed.
> > Please see Saeed's comment in previous email:
> >
> > "
> >
> > The issue is with distros who ship modules independently.. having a
> > hard dependency will make it impossible for basic mlx5_core.ko users to
> > load the driver when psample is not installed/loaded.
> >
> > I prefer to have 0 dependency on external modules in a HW driver.
> > "
>
> I saw it, but it basically comes down to personal preferences.

It is more than personal preferences. In opposite to the mlxsw which is
used for netdev only, the mlx5_core is used by other subsystems, e.g. RDMA,
so Saeed's request to avoid extra dependencies makes sense.

We don't need psample dependency to run RDMA traffic.

>
> >
> > We are working on a tc sample offload feature for mlx5_core. The distros
> > are likely to request us to do this. So we address it before submitting
> > the driver changes.
>
> Which distros? Can they comment here? mlxsw is in RHEL and I don't
> remember queries from them about the psample module.

There is a huge difference between being in RHEL and actively work with
partners as mlx5 does.

The open mailing list is not the right place to discuss our partnership
relations.

Thanks

>
> >
> > Regards,
> > Chris
> >
