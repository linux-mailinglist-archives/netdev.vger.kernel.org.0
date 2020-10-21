Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B864B2954DF
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 00:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506855AbgJUWnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 18:43:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:54378 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437959AbgJUWnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 18:43:53 -0400
IronPort-SDR: BoIL2V81CJRbN75q7Um2jvqNUaNHIxdWrS7foyPHTMX3xhANshD4gQkgNNHyisdTFyn0EyJvSJ
 xqZzcSDwrQFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="154396939"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="154396939"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 15:43:51 -0700
IronPort-SDR: aHgyraovD422DLCcODMvFY7vJ/mC86PBNeRpAEt984R3IBvoyR9p6iJPqI009IcjFPZrslVovP
 j/HB5ZYcEHlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="524057805"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 21 Oct 2020 15:43:50 -0700
Date:   Thu, 22 Oct 2020 00:34:25 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2] ibmvnic: fix ibmvnic_set_mac
Message-ID: <20201021223425.GA61349@ranger.igk.intel.com>
References: <20201021060712.48806-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021060712.48806-1-ljp@linux.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 01:07:12AM -0500, Lijun Pan wrote:
> Jakub Kicinski brought up a concern in ibmvnic_set_mac().
> ibmvnic_set_mac() does this:
> 
> 	ether_addr_copy(adapter->mac_addr, addr->sa_data);
> 	if (adapter->state != VNIC_PROBED)
> 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
> 
> So if state == VNIC_PROBED, the user can assign an invalid address to
> adapter->mac_addr, and ibmvnic_set_mac() will still return 0.
> 
> The fix is to add the handling for "adapter->state == VNIC_PROBED" case,
> which saves the old mac address back to adapter->mac_addr, and
> returns an error code.
> 
> Fixes: 62740e97881c ("net/ibmvnic: Update MAC address settings after adapter reset")
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
> v2: change the subject from v1's 
>     "ibmvnic: no need to update adapter->mac_addr before it completes"
>     handle adapter->state==VNIC_PROBED case in else statement.
> 
>  drivers/net/ethernet/ibm/ibmvnic.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 4dd3625a4fbc..0d78e1e3d44c 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1829,8 +1829,12 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
>  
>  	rc = 0;
>  	ether_addr_copy(adapter->mac_addr, addr->sa_data);
> -	if (adapter->state != VNIC_PROBED)
> +	if (adapter->state != VNIC_PROBED) {
>  		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
> +	} else {
> +		ether_addr_copy(adapter->mac_addr, netdev->dev_addr);
> +		rc = -EIO;

Why suddenly you want to change the behavior for case when ibmvnic_set_mac
is called for VNIC_PROBED state?

I went through the previous discussion and I have a feeling that Jakub
meant to simply call the is_valid_ether_addr() on addr->sa_data before the
first ether_addr_copy and then act accordingly based on the validity of
user supplied mac addr.

And instead of yet another write to adapter->mac_addr that you're
introducing you could just move the first ether_addr_copy (if
addr->sa_data is valid) onto the if (adapter->state != VNIC_PROBED)
condition. Right?

> +	}
>  
>  	return rc;
>  }
> -- 
> 2.23.0
> 
