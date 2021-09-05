Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A644C400F1B
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 12:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhIEK0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 06:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234907AbhIEK0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 06:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36A6160FBF;
        Sun,  5 Sep 2021 10:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630837506;
        bh=3PAjj3SaJT0hnRJUyZeBCXEHyujmppNlV3CVnJhX0oE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EniM7BA5M8XaLacsY9t33f09kQpU6U/Y/DtOfmr6QzSLuUGfsCXIii/4n9gVJNgJl
         qPmOfw/2HLukwhzHGOOZBb/PDT//Qu34g8PtFpOVnr8IqoyjUzCOGJx4Hkxx0UsRvK
         bLJum3BCYAZQyMymaSvJ8dyHm94JUOS2zXAfCOS8jX7XXhFSsoaENUCrfuKiK9I07G
         mUzo6Q9U01wk41jBwF1qLdfa2XdR/IVIFHUVt+XFA+W3I/bZMhxgBiHQBYsBhGc50e
         EFi6kmBJIoV/+8y63MbfiyfiI15PpAUZ1kWBj9663ruyAOJHZRC3n+9TbfML8DSbps
         k+GwWUm2X+Z9Q==
Date:   Sun, 5 Sep 2021 13:25:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <YTSa/3XHe9qVz9t7@unreal>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905084518.emlagw76qmo44rpw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 11:45:18AM +0300, Vladimir Oltean wrote:
> On Sun, Sep 05, 2021 at 10:07:45AM +0300, Leon Romanovsky wrote:
> > On Fri, Sep 03, 2021 at 02:17:38AM +0300, Vladimir Oltean wrote:
> > > Commit 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
> > > decided it was fine to ignore errors on certain ports that fail to
> > > probe, and go on with the ports that do probe fine.
> > > 
> > > Commit fb6ec87f7229 ("net: dsa: Fix type was not set for devlink port")
> > > noticed that devlink_port_type_eth_set(dlp, dp->slave); does not get
> > > called, and devlink notices after a timeout of 3700 seconds and prints a
> > > WARN_ON. So it went ahead to unregister the devlink port. And because
> > > there exists an UNUSED port flavour, we actually re-register the devlink
> > > port as UNUSED.
> > > 
> > > Commit 08156ba430b4 ("net: dsa: Add devlink port regions support to
> > > DSA") added devlink port regions, which are set up by the driver and not
> > > by DSA.
> > > 
> > > When we trigger the devlink port deregistration and reregistration as
> > > unused, devlink now prints another WARN_ON, from here:
> > > 
> > > devlink_port_unregister:
> > > 	WARN_ON(!list_empty(&devlink_port->region_list));
> > > 
> > > So the port still has regions, which makes sense, because they were set
> > > up by the driver, and the driver doesn't know we're unregistering the
> > > devlink port.
> > > 
> > > Somebody needs to tear them down, and optionally (actually it would be
> > > nice, to be consistent) set them up again for the new devlink port.
> > > 
> > > But DSA's layering stays in our way quite badly here.
> > 
> > I don't know anything about DSA
> 
> It is sufficient to know in this case that it is a multi-port networking
> driver.
> 
> > and what led to the decision to ignore devlink registration errors,
> 
> But we are not ignoring devlink registration errors...
> 
> The devlink_port must be initialized prior to initializing the net_device.
> 
> Initializing a certain net_device may fail due to reasons such as "PHY
> not found". It is desirable in certain cases for a net_device
> initialization failure to not fail the entire switch probe.
> 
> So at the very least, rollback of the registration of that port must be
> performed before continuing => the devlink_port needs to be unregistered
> when the net_device initialization has failed.
> 
> > but devlink core is relying on the simple assumption that everything
> > is initialized correctly.
> > 
> > So if DSA needs to have not-initialized port, it should do all the needed
> > hacks internally.
> 
> So the current problem is that the DSA framework does not ask the hardware
> driver whether it has devlink port regions which need to be torn down
> before unregistering the devlink port.
> 
> I was expecting the feedback to be "we need to introduce new methods in
> struct dsa_switch_ops which do .port_setup and .port_teardown, similar
> to the already existing per-switch .setup and .teardown, and drivers
> which set up devlink port regions should set these up from the port
> methods, so that DSA can simply call those when it needs to tear down a
> devlink port without tearing down the entire switch and devlink instance".
> The proposed patch is horrible and I agree, but not for the reasons you
> might think it is.
> 
> Either way, "all the needed hacks" are already done internally, and from
> devlink's perspective everything is initialized correctly, not sure what
> this comment is about. I am really not changing anything in DSA's
> interaction with the devlink core, other than ensuring we do not
> unregister a devlink port with regions on it.

That sentence means that your change is OK and you did it right by not
changing devlink port to hold not-working ports.

Thanks
