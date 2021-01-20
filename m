Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31F42FC5FF
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbhATAmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 19:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbhATAm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 19:42:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D1A922C9E;
        Wed, 20 Jan 2021 00:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611103308;
        bh=BqpCD8VW4TUxI5wxII0neKE/ypOSFZlBkLR1285j3D0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QuMRBAlkMscH/Taxs/LJgMM80V1I2YvJEjpD6CQKOV0tLJtA7g/EYq/Mwg6JC3d+a
         6yAluSlvlizpiy9T1h/Cz+9E3zV36wTCpq1VO4vNuN8WyG/nLaIy6pdeiIlXlBPGEI
         knEmdAUOBOiZShFOXczcfBcrnFr4f3Ym7HBLmsIdWhCNymC98M8ksDIoFF924bTup3
         UM37loLPqzoHeS+kppngViwyptsO+RGylMagkwf0odHLi1yeIyB+a6fgRXn/+kC73i
         WegKSOrGkT8N7rtADZqIuNhil+9/ZiDTQkZKTXVGgXVrPwNDb3LEVOcMOLHul7Vcec
         yaJHiiGs02nIg==
Date:   Tue, 19 Jan 2021 16:41:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Message-ID: <20210119164147.36a77cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7272d1b6e6c447989cae07e7519422ab80518ca1.camel@intel.com>
References: <20210113234226.3638426-1-anthony.l.nguyen@intel.com>
        <20210114164252.74c1cf18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7272d1b6e6c447989cae07e7519422ab80518ca1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 00:12:26 +0000 Venkataramanan, Anirudh wrote:
> > > Attempt [0]: Enable the best-case scenario MSI-X vectors.
> > > 
> > > Attempt [1]: Enable MSI-X vectors with the number of pf-  
> > > >num_lan_msix  
> > > reduced by a factor of 2 from the previous attempt (i.e.
> > > num_online_cpus() / 2).
> > > 
> > > Attempt [2]: Same as attempt [1], except reduce by a factor of 4.
> > > 
> > > Attempt [3]: Enable the bare-minimum MSI-X vectors.
> > > 
> > > Also, if the adjusted_base_msix ever hits the minimum required for
> > > LAN,
> > > then just set the needed MSI-X for that feature to the minimum
> > > (similar to attempt [3]).  
> > 
> > I don't really get why you switch to this manual "exponential back-
> > off"
> > rather than continuing to use pci_enable_msix_range(), but fixing the
> > capping to ICE_MIN_LAN_VECS.  
> 
> As per the current logic, if the driver does not get the number of MSI-
> X vectors it needs, it will immediately drop to "Do I have at least two
> (ICE_MIN_LAN_VECS) MSI-X vectors?". If yes, the driver will enable a
> single Tx/Rx traffic queue pair, bound to one of the two MSI-X vectors.
> 
> This is a bit of an all-or-nothing type approach. There's a mid-ground
> that can allow more queues to be enabled (ex. driver asked for 300
> vectors, but got 68 vectors, so enabled 64 data queues) and this patch
> implements the mid-ground logic. 
> 
> This mid-ground logic can also be implemented based on the return value
> of pci_enable_msix_range() but IMHO the implementation in this patch
> using pci_enable_msix_exact is better because it's always only
> enabling/reserving as many MSI-X vectors as required, not more, not
> less.

What do you mean by "required" in the last sentence? The driver
requests num_online_cpus()-worth of IRQs, so it must work with any
number of IRQs. Why is num_cpus() / 1,2,4,8 "required"?
