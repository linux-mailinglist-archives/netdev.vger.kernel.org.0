Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD282F6FA8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbhAOAne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:43:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731278AbhAOAne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 19:43:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12CAC23A5E;
        Fri, 15 Jan 2021 00:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610671373;
        bh=VsydWM6fs5rKG013BFhXY2b20JXbJhomIchYYqOQ7Gk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AB5+eS3BzJ4ncJjR7NYEqlpTnVW6L0DgsavK/IDPrPz69uF9oEth3agTwrbEmiIrF
         0zrpG6rYAqvjLkIj1QLQDnj5BpMz5ZZ7BrAX4Lc9nFgN3dMCIO5MdPyArzzR5xsx60
         zaGfbCBLBz8aLa1s6Eb+jZ4LWbCv/RH2eF72g5xDEdx/Rwi4i3ozh9+3bbxnj2Ew/T
         L73HnaVXdstoXbmMDtybMu95WJFrwTilhG5dF/4Y9amvI9q822GPemjiEn0eULVrPp
         Wut9yVYcPUFHD0jWoA5IR1zATvxocOnFphVHyk1cwfeT35meT3hJKxHGfvcjwmTS4R
         0F3GXUMM38/nQ==
Date:   Thu, 14 Jan 2021 16:42:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Brett Creeley <brett.creeley@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Message-ID: <20210114164252.74c1cf18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113234226.3638426-1-anthony.l.nguyen@intel.com>
References: <20210113234226.3638426-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 15:42:26 -0800 Tony Nguyen wrote:
> From: Brett Creeley <brett.creeley@intel.com>
> 
> The current MSI-X enablement logic either tries to enable best-case
> MSI-X vectors and if that fails we only support a bare-minimum set.
> This is not very flexible and the current logic is broken when actually
> allocating and reserving MSI-X in the driver. Fix this by improving the
> fall-back logic and fixing the allocation/reservation of MSI-X when the
> best-case MSI-X vectors are not received from the OS.
> 
> The new fall-back logic is described below with each [#] being an
> attempt at enabling a certain number of MSI-X. If any of the steps
> succeed, then return the number of MSI-X enabled from
> ice_ena_msix_range(). If any of the attempts fail, then goto the next
> step.
> 
> Attempt [0]: Enable the best-case scenario MSI-X vectors.
> 
> Attempt [1]: Enable MSI-X vectors with the number of pf->num_lan_msix
> reduced by a factor of 2 from the previous attempt (i.e.
> num_online_cpus() / 2).
> 
> Attempt [2]: Same as attempt [1], except reduce by a factor of 4.
> 
> Attempt [3]: Enable the bare-minimum MSI-X vectors.
> 
> Also, if the adjusted_base_msix ever hits the minimum required for LAN,
> then just set the needed MSI-X for that feature to the minimum
> (similar to attempt [3]).

I don't really get why you switch to this manual "exponential back-off"
rather than continuing to use pci_enable_msix_range(), but fixing the
capping to ICE_MIN_LAN_VECS.

> To fix the allocation/reservation of MSI-X, the PF VSI needs to take
> into account the pf->num_lan_msix available and only allocate up to that
> many MSI-X vectors. To do this, limit the number of Tx and Rx queues
> based on pf->num_lan_msix. This is done because we don't want more than
> 1 Tx/Rx queue per interrupt due to performance concerns. Also, limit the
> number of MSI-X based on pf->num_lan_msix available.
> 
> Also, prevent users from enabling more combined queues than there are
> MSI-X available via ethtool.

Right, this part sounds like a fix, and should be a separate patch
against net, not net-next.

> Fixes: 152b978a1f90 ("ice: Rework ice_ena_msix_range")
> Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
