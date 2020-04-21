Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038F11B2EA4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgDURzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDURzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:55:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0172220663;
        Tue, 21 Apr 2020 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587491753;
        bh=5fM1xxeS4RFDsWX/PVANuOzUGIYCgXH23ehRNDGKFAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1D4gJynJyhNtzpK+SJncthZk2yDowdBA+KkiyQHwZZMzy7juw3r2ep8AA0E3xwhMx
         NRHy3i1MWWkaUyEHwG2e4upxChtWHytoyDTXjGBGFd9Fmsi5r6Es5/MIlVrozz8iBg
         VW2jrxxheT31aOSC4mJwSBnxzxXbOVJ2Lell6jKI=
Date:   Tue, 21 Apr 2020 10:55:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 3/4] i40e: Add support for a new feature: Total Port
 Shutdown
Message-ID: <20200421105551.6f41673a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200421014932.2743607-4-jeffrey.t.kirsher@intel.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
        <20200421014932.2743607-4-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020 18:49:31 -0700 Jeff Kirsher wrote:
> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> 
> Currently after requesting to down a link on a physical network port,
> the traffic is no longer being processed but the physical link
> with a link partner is still established.
> 
> Total Port Shutdown allows to completely shutdown the port on the
> link-down procedure by physically removing the link from the port.
> 
> Introduced changes:
> - probe NVM if the feature was enabled at initialization of the port
> - special handling on link-down procedure to let FW physically
> shutdown the port if the feature was enabled

How is this different than link-down-on-close?

Perhaps it'd be good to start documenting the private flags in
Documentation/

> Testing Hints (required if no HSD):
> Link up/down, link-down-on-close
> 
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> @@ -12012,6 +12085,16 @@ static int i40e_sw_init(struct i40e_pf *pf)
>  
>  	pf->tx_timeout_recovery_level = 1;
>  
> +	if (pf->hw.mac.type != I40E_MAC_X722 &&
> +	    i40e_is_total_port_shutdown_enabled(pf)) {
> +		/* Link down on close must be on when total port shutdown
> +		 * is enabled for a given port
> +		 */
> +		pf->flags |= (I40E_FLAG_TOTAL_PORT_SHUTDOWN
> +			  | I40E_FLAG_LINK_DOWN_ON_CLOSE_ENABLED);

FWIW this is the correct code style in the kernel:

flags = BLA |
        BLA2;

> +		dev_info(&pf->pdev->dev,
> +			 "Total Port Shutdown is enabled, link-down-on-close forced on\n");
> +	}
>  	mutex_init(&pf->switch_mutex);
>  
>  sw_init_done:
