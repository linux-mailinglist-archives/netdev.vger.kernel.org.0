Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DA2333591
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCJFvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhCJFuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:50:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0131D64FEF;
        Wed, 10 Mar 2021 05:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615355454;
        bh=2DhMBcTJQmQLalLr92IqUGzEdsUlm1QvvfBDfUeZJcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AbUEYlgg8BBPTwGY5+n+b80FswbRdJe8CZRBy6GcwU5aYtN6sdp525zoJysJ5rCiO
         6Q99TGJjgKO48YVGHZ+aARTJOsi9LLrNmqgP/ZNpZTYt77iySA4evp6aH6cFVh1bai
         Rg1L8xh4oM6mJDMooegmUn2lbWlRyLG6gDwP9PlzDUEXcF9LrNIkFj8mjLT0IX+e9b
         5+ojWwhMesTyD8aygRAFKYLXyu1KUxgekHewgGrG7Vw/HMHlVKI7VKoMqkvuFHANSL
         Y4ovEm9IulvuOtf1mtNcDus6KIXAPcmBOhByDdmcZ7qWLpOOx16mZY1bxmOa7nwcvM
         9h78Fw01RbH0w==
Date:   Wed, 10 Mar 2021 07:50:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, alice.michael@intel.com,
        alan.brady@intel.com
Subject: Re: [RFC net-next] iavf: refactor plan proposal
Message-ID: <YEheOtKsKm1DfCR8@unreal>
References: <20210308162858.00004535@intel.com>
 <YEcRHkhJIkZnTgza@unreal>
 <20210309211146.00002f2d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309211146.00002f2d@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 09:11:46PM -0800, Jesse Brandeburg wrote:
> Leon Romanovsky wrote:
>
> > > 3) Plan is to make the "new" iavf driver the default iavf once
> > >    extensive regression testing can be completed.
> > > 	a. Current proposal is to make CONFIG_IAVF have a sub-option
> > > 	   CONFIG_IAVF_V2 that lets the user adopt the new code,
> > > 	   without changing the config for existing users or breaking
> > > 	   them.
> >
> > I don't think that .config options are considered ABIs, so it is unclear
> > what do you mean by saying "disrupting current users". Instead of the
> > complication wrote above, do like any other driver does: perform your
> > testing, submit the code and switch to the new code at the same time.
>
> Because this VF driver runs on multiple hardware PFs (they all expose
> the same VF device ID) the testing matrix is quite huge and will take
> us a while to get through it. We aim to avoid making users's life hard
> by having CONFIG_IAVF=m become a surprise new code base behind the back
> of the user.

Don't you already test your patches against that testing DB?
Like Jakub said, do incremental changes and it will be much saner for everyone.

>
> I've always thought that the .config options *are* a sort of ABI,
> because when you do "make oldconfig" it tries to pick up your previous
> configuration and if, for instance, a driver changes it's Kconfig name,
> it will not pick up the old value of the old driver Kconfig name for
> the new build, and with either default or ask the user. The way we're
> proposing I think will allow the old driver to stay default until the
> user answers Y to the "new option" for the new, iecm based code.

I understand the rationale, but no - .config is not ABI at all.
There are three types of "users" who are messing with configs:
1. Distro people
2. Kernel developers
3. "Experts" who wants/needs rebuild kernel

All of them are expected to be proficient enough to handle changes
in CONFIG_* land. In your proposal you are trying to solve non-existent
problem of having users who are building their own kernel, but dumb
enough do not understand what they are doing.

We are removing/adding/renaming CONFIG_* all the time, this is no
different.

>
> > > [1]
> > > https://lore.kernel.org/netdev/20200824173306.3178343-1-anthony.l.nguyen@intel.com/
> >
> > Please don't introduce module parameters in new code.
>
> Thanks, we certainly won't. :-)
> I'm not sure why you commented about module parameters, but the above
> link is to the previous submission for a new driver that uses some
> common code as a module (iecm) for a new device driver (idpf) we had
> sent. The point of this email was to solicit feedback and give notice
> about doing a complicated refactor/replace where we end up re-using
> iecm for the new version of the iavf code, with the intent to be up
> front and working with the community throughout the process. Because of
> the complexity, we want do the right thing the first time so we can to
> avoid a restart/redesign.

I commented simply because it jumped in front of my eyes when I looked
on the patches in that link. It was general enough to write it here,
rest of my comments are too specific and better to be posted as a reply
to the patches itself.

Thanks

>
> Thanks,
>  Jesse
