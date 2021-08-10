Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BE93E85E2
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 00:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbhHJWGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 18:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhHJWGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 18:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8841F60FDA;
        Tue, 10 Aug 2021 22:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628633145;
        bh=R4GRGaNIySxd/xPMfoThRnmGNl7gDjTUUrVAFKi+7lQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GuviWpCUVjjd2Pr77wTStrQ2o7ulYIu/GqVSEtDod86QAORRJYa7ssijx5T2CtK9e
         MoDly8/ECZRShxGUtkYuUq0ncRBPwDBtDyn7E42duhr9Q2la9Wb1UZRHwl4tf9+b+6
         joYD1Ml+E1jf/SPX7a4rZ+6FBgcDXw/Og/LjgvBHlSwL2mPoh8fLyT0vE2pZ0DC4Tv
         nFffcd3yGkl0GtywtndHMGiZ29Dmo5ioVRgETK8RxsYK3yHpAcr3rBgTW5kiukcWOl
         b7FTys7ybStK33O+FjsGUemmiWjfAtrzEd1SViuAUxDxQbh3lsqHx/H77QFFhA5iZ8
         1TXdEPq4NFjRg==
Date:   Tue, 10 Aug 2021 15:05:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRLlpCutXmthqtOg@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
        <20210809102152.719961-2-idosch@idosch.org>
        <YRE7kNndxlGQr+Hw@lunn.ch>
        <YRIqOZrrjS0HOppg@shredder>
        <YRKElHYChti9EeHo@lunn.ch>
        <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRLlpCutXmthqtOg@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 23:46:28 +0300 Ido Schimmel wrote:
> On Tue, Aug 10, 2021 at 06:59:54AM -0700, Jakub Kicinski wrote:
> > On Tue, 10 Aug 2021 15:52:20 +0200 Andrew Lunn wrote:  
> > > O.K. Thanks for the better explanation. Some of this should go into
> > > the commit message.
> > > 
> > > I suggest it gets a different name and semantics, to avoid
> > > confusion. I think we should consider this the default power mode for
> > > when the link is administratively down, rather than direct control
> > > over the modules power mode. The driver should transition the module
> > > to this setting on link down, be it high power or low power. That
> > > saves a lot of complexity, since i assume you currently need a udev
> > > script or something which sets it to low power mode on link down,
> > > where as you can avoid this be configuring the default and let the
> > > driver do it.  
> > 
> > Good point. And actually NICs have similar knobs, exposed via ethtool
> > priv flags today. Intel NICs for example. Maybe we should create a
> > "really power the port down policy" API?  
> 
> See below about Intel. I'm not sure it's the same thing...
> 
> I'm against adding a vague "really power the port down policy" API. The
> API proposed in the patch is well-defined, its implementation is
> documented in standards, its implications are clear and we offer APIs
> that give user space full observability into its operation.
> 
> A vague API means that it is going to be abused and user space will get
> different results over different implementations. After reading the
> *commit messages* about the private flags, I'm not sure what the flags
> really do, what is their true motivation, implications or how do I get
> observability into their operation. I'm not too hopeful about the user
> documentation.
> 
> Also, like I mentioned in the cover letter, given the complexity of
> these modules and as they become more common, it is likely that we will
> need to extend the API to control more parameters and expose more
> diagnostic information. I would really like to keep it clean and
> contained in 'ETHTOOL_MSG_MODULE_*' messages and not spread it over
> different APIs.

The patch is well defined but it doesn't provide user with the answer
to the question "why is the SFP still up if I asked it to be down?"
It's good to match specs closely but Linux may need to reconcile
multiple policies.

IIUC if Intel decides to keep the SFP up for "other" reasons the
situation will look like this:

 $ ethtool --show-module eth0
 Module parameters for eth0:
 low-power true

 # ethtool -m eth0
 Module State                              : 0x03 (ModuleReady)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : Off


IOW the low-power mode is a way for user to express preference to
shut down/keep up the SFP, but it's not necessarily going to be
the only "policy" that matters. If other policies (e.g. NC-SI) express
preference to keep the interface up it will stay up, right?

The LowPwrRequestSW is not directly controlled by low-power && IF_UP.

What I had in mind was something along the lines of a bitmap of reasons
which are allowed to keep the interface up, and for your use case
the reason would be something like SFP_ALWAYS_ON, but other reasons
(well defined) may also keep the ifc up.

That's just to explain what I meant, if it's going to be clear to
everyone that low-power != LowPwrRequestSW I'm fine either way.
