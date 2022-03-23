Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282174E5798
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343633AbiCWRg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiCWRgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:36:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F53A44A2D;
        Wed, 23 Mar 2022 10:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648056895; x=1679592895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sQLlik2JBKgjvTm6fLFQVl8wTqJf3BIKx0o9VBPfxEY=;
  b=lAAFEMQbl84QIBvB3dS5mlI9IBa5FkTqog9nk8ZRssKHox/nY2qGJTC0
   QxFNd3gZEjkUGZ+xAjyJ5gjJygV5QwgEsYsoZPktIpmk71NYX3KGoUoV0
   MzYVsJcHo+Km05Hnvau/J73LDvqAlf0Asrv1BNp+8ixzhOMwM3sTRlRg+
   /DkFe8uAXrIHfM0AbdXTRVOrNUL92lx1Xhw6cQGwL++CnQd1dkYVFuj9R
   vvCVpBATZM4CGaFQqWI8hWwnBGsPqfgFNwW5hMgO0b4pQWCDL6MRzNdrj
   tP69WHPt3iu0GhCDsitDEvcDrW2v4lpukeHplYArWwMRaRxOE/WKtODUH
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="257005681"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="257005681"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 10:22:04 -0700
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="544287811"
Received: from kplh.igk.intel.com ([10.102.21.224])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 10:22:01 -0700
Date:   Wed, 23 Mar 2022 20:10:10 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] ice: Fix MAC address setting
Message-ID: <20220323190519.GA23730@kplh.igk.intel.com>
References: <20220323135829.4015645-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323135829.4015645-1-ivecera@redhat.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 02:58:29PM +0100, Ivan Vecera wrote:
> Commit 2ccc1c1ccc671b ("ice: Remove excess error variables") merged
> the usage of 'status' and 'err' variables into single one in
> function ice_set_mac_address(). Unfortunately this causes
> a regression when call of ice_fltr_add_mac() returns -EEXIST because
> this return value does not indicate an error in this case but
> value of 'err' value remains to be -EEXIST till the end of
> the function and is returned to caller.
> 
> Prior this commit this does not happen because return value of
> ice_fltr_add_mac() was stored to 'status' variable first and
> if it was -EEXIST then 'err' remains to be zero.
> 
> The patch fixes the problem by reset 'err' to zero when
> ice_fltr_add_mac() returns -EEXIST.
> 
> Fixes: 2ccc1c1ccc671b ("ice: Remove excess error variables")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 168a41ea37b8..420558d1cd21 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -5474,14 +5474,15 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
>  
>  	/* Add filter for new MAC. If filter exists, return success */
>  	err = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
> -	if (err == -EEXIST)
> +	if (err == -EEXIST) {
>  		/* Although this MAC filter is already present in hardware it's
>  		 * possible in some cases (e.g. bonding) that dev_addr was
>  		 * modified outside of the driver and needs to be restored back
>  		 * to this value.
>  		 */
>  		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
> -	else if (err)
> +		err = 0;

Thanks Ivan, This looks fine. It is a regression as I checked since
driver used to return success in such case. It seems that the only
way to have EEXIST here is when the same MAC is requested, I'd also
consider just return 0 here to skip later firwmare write which seems
redundant here.

Piotr

> +	} else if (err)
>  		/* error if the new filter addition failed */
>  		err = -EADDRNOTAVAIL;
>  
> -- 
> 2.34.1
> 
