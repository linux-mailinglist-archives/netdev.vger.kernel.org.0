Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4757E2FC8F0
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbhATD3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:29:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732103AbhATCaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3680022509;
        Wed, 20 Jan 2021 02:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611109763;
        bh=2n16C3EtnBZL2OrSWrwcP8YI7DSzFQRsfF9JKN2ItzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bbzBnhU3FglN+pDAyTYj97tCyzygoCXjIwJD6rwDD1dWM9DYvcdUoHTf44GXGsLcT
         tj9/IW1UVNFX7TxhJ4Y7vwVK9/HBrwM+78YvyUgfLSPANWrvP2TNtJr32hP57ZviLT
         Ka1z7nJgAwfRGLlXNbWZuBQZz2A/6HWtg8+WKH1zxOhK1k5ZgEKHJ4D79sh4axMZAe
         dBy4aASQbHzJtSjpxTQx/qQtmlosJyfwWOuFeXnEx7WHgpvkMuOcdyRJDr1OkmPlkH
         TV2fFBC6xr8PJs/hsLc+u/UKZjg/k/j+wlsvipJjIF0DvfEdiHe4RlkDxnHEcvK3im
         IGFSNEytmG2IQ==
Date:   Tue, 19 Jan 2021 18:29:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
Cc:     "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Message-ID: <20210119182922.1102ca91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <910a50d7ae84913e140d14aed11675f751254eb1.camel@intel.com>
References: <20210113234226.3638426-1-anthony.l.nguyen@intel.com>
        <20210114164252.74c1cf18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7272d1b6e6c447989cae07e7519422ab80518ca1.camel@intel.com>
        <20210119164147.36a77cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <910a50d7ae84913e140d14aed11675f751254eb1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 02:13:36 +0000 Venkataramanan, Anirudh wrote:
> > > As per the current logic, if the driver does not get the number of
> > > MSI-
> > > X vectors it needs, it will immediately drop to "Do I have at least
> > > two
> > > (ICE_MIN_LAN_VECS) MSI-X vectors?". If yes, the driver will enable
> > > a
> > > single Tx/Rx traffic queue pair, bound to one of the two MSI-X
> > > vectors.
> > > 
> > > This is a bit of an all-or-nothing type approach. There's a mid-
> > > ground
> > > that can allow more queues to be enabled (ex. driver asked for 300
> > > vectors, but got 68 vectors, so enabled 64 data queues) and this
> > > patch
> > > implements the mid-ground logic. 
> > > 
> > > This mid-ground logic can also be implemented based on the return
> > > value
> > > of pci_enable_msix_range() but IMHO the implementation in this
> > > patch
> > > using pci_enable_msix_exact is better because it's always only
> > > enabling/reserving as many MSI-X vectors as required, not more, not
> > > less.  
> > 
> > What do you mean by "required" in the last sentence?   
> 
> .. as "required" in that particular iteration of the loop.
> 
> > The driver
> > requests num_online_cpus()-worth of IRQs, so it must work with any
> > number of IRQs. Why is num_cpus() / 1,2,4,8 "required"?  
> 
> Let me back up a bit here. 
> 
> Ultimately, the issue we are trying to solve here is "what happens when
> the driver doesn't get as many MSI-X vectors as it needs, and how it's
> interpreted by the end user"
> 
> Let's say there are these two systems, each with 256 cores but the
> response to pci_enable_msix_range() is different:
> 
> System 1: 256 cores, pci_enable_msix_range returns 75 vectors
> System 2: 256 cores, pci_enable_msix_range returns 220 vectors 
> 
> In this case, the number of queues the user would see enabled on each
> of these systems would be very different (73 on system 1 and 218 on
> system 2). This variabilty makes it difficult to define what the
> expected behavior should be, because it's not exactly obvious to the
> user how many free MSI-X vectors a given system has. Instead, if the
> driver reduced it's demand for vectors in a well defined manner
> (num_cpus() / 1,2,4,8), the user visible difference between the two
> systems wouldn't be so drastic.
> 
> If this is plain wrong or if there's a preferred approach, I'd be happy
> to discuss further.

Let's stick to the standard Linux way of handling IRQ exhaustion, and
rely on pci_enable_msix_range() to pick the number. If the current
behavior of pci_enable_msix_range() is now what users want we can
change it. Each driver creating its own heuristic is worst of all
choices as most brownfield deployments will have a mix of NICs.
