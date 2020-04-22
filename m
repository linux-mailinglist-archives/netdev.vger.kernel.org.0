Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50BB1B34E6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 04:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgDVCOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 22:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgDVCOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 22:14:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED243206D5;
        Wed, 22 Apr 2020 02:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587521641;
        bh=zKyF/MwJBEMd7FA9/9KjiDYARyu3bp5rlOhuoefhVNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0pi1yvz1oUyfmd/gKTC7tIb0olR9HGr2NCavjgIqthtVZG4BwkUZXy68DAdTzg5Y9
         aJrwZiNkLCXvfScg4iw2THi3pMAl/11Sq47Xh3LgjusMslFa6KFvOMyGuv1K00lIko
         931d851EX+cf+v8dK8C2uJrMlUJISf+sBrB4l6EQ=
Date:   Tue, 21 Apr 2020 19:13:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kwapulinski, Piotr" <piotr.kwapulinski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
Subject: Re: [net-next 3/4] i40e: Add support for a new feature: Total Port
 Shutdown
Message-ID: <20200421191359.0a48133b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D9404498670105@ORSMSX112.amr.corp.intel.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
        <20200421014932.2743607-4-jeffrey.t.kirsher@intel.com>
        <20200421105551.6f41673a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61CC2BC414934749BD9F5BF3D5D9404498670105@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020 22:36:21 +0000 Kirsher, Jeffrey T wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, April 21, 2020 10:56
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > Cc: davem@davemloft.net; Kubalewski, Arkadiusz
> > <arkadiusz.kubalewski@intel.com>; netdev@vger.kernel.org;
> > nhorman@redhat.com; sassmann@redhat.com; Kwapulinski, Piotr
> > <piotr.kwapulinski@intel.com>; Loktionov, Aleksandr
> > <aleksandr.loktionov@intel.com>; Bowers, AndrewX
> > <andrewx.bowers@intel.com>
> > Subject: Re: [net-next 3/4] i40e: Add support for a new feature: Total Port
> > Shutdown
> > 
> > On Mon, 20 Apr 2020 18:49:31 -0700 Jeff Kirsher wrote:  
> > > From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> > >
> > > Currently after requesting to down a link on a physical network port,
> > > the traffic is no longer being processed but the physical link with a
> > > link partner is still established.
> > >
> > > Total Port Shutdown allows to completely shutdown the port on the
> > > link-down procedure by physically removing the link from the port.
> > >
> > > Introduced changes:
> > > - probe NVM if the feature was enabled at initialization of the port
> > > - special handling on link-down procedure to let FW physically
> > > shutdown the port if the feature was enabled  
> > 
> > How is this different than link-down-on-close?  
> [Kirsher, Jeffrey T] 
> 
> First of all total-port-shutdown is a read only flag, the user cannot set it
> from the OS.  It is possible to set it in bios, but only if the motherboard
> supports it and the NIC has that capability.  Also, the behavior on both
> slightly differs, link-down-on-close brings the link down by sending
> (to firmware) phy_type=0, while total-port-shutdown does not, the
> phy_type is not changed, instead firmware is using
> I40E_AQ_PHY_ENABLE_LINK flag. 

I see. IOW it's a flag that says the other flag is hard wired to on.

Why is it important to prevent user from performing the configuration?
What if an old kernel is run which won't prevent it?

Let's drill down into what we actually want to express here and then
look at the API. Michal has already converted ethtool link info to
netlink..

> > Perhaps it'd be good to start documenting the private flags in Documentation/  
> [Kirsher, Jeffrey T] 
> 
> We could look at adding that information into our kernel documentation, I am
> planning on updating the driver documentation in a follow-up patch set.  Would
> a descriptive code comment help in this case? 

Documentation should be sufficient, IMHO, if it's coming soon.
