Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE074EF669
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350689AbiDAPeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345166AbiDAPRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 11:17:48 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0BB1B9881
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 08:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648825254; x=1680361254;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZRXaOn2jWbKpXeNbzuRQna4zQhf11QVXubsI9+3NyPE=;
  b=AJQvYoiOtb/MmTT8G0MYqrWtCWjnd4EQDOD3KcvpGewFhHGCzwlkacaQ
   7mwbd+7k0Bd4e27YY8hq+gZf29BK4th7okTZfa6QwoljgHBsOnt3gQYu1
   lrWgL9P5KI0ETjWgvUARs4K7qeaWvJe3oQZOj7xFiDwUJdux6mx22U/Uy
   rrSfGjTVqJIk1yPPRk0iQrD63O1cY6uCgFUJukcm/QVWVwAE/DQQUMbTy
   kTS0hhw90CDVbs29EfE/cZC2xjKtbZLkX6Qlcx8wj5ibRbKRzpUVge0MH
   oO6hJGzm+a8Ga+JSsFQm0QnMWfTUEsc8UitT0tJPh1TOLZ5wN4mmB19Fd
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240746260"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="240746260"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 08:00:54 -0700
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="547825824"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 08:00:52 -0700
Date:   Fri, 1 Apr 2022 08:02:29 -0400
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com
Subject: Re: [Intel-wired-lan] [PATCH intel-net] ice: allow creating VFs for
 !CONFIG_NET_SWITCHDEV
Message-ID: <Ykbp1W3uBgcCtIYv@localhost.localdomain>
References: <20220401125438.292649-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401125438.292649-1-maciej.fijalkowski@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 02:54:38PM +0200, Maciej Fijalkowski wrote:
> Currently for !CONFIG_NET_SWITCHDEV kernel builds it is not possible to
> create VFs properly as call to ice_eswitch_configure() returns
> -EOPNOTSUPP for us. This is because CONFIG_ICE_SWITCHDEV depends on
> CONFIG_NET_SWITCHDEV.
> 
> Change the ice_eswitch_configure() implementation for
> !CONFIG_ICE_SWITCHDEV to return 0 instead -EOPNOTSUPP and let
> ice_ena_vfs() finish its work properly.
> 
> CC: Grzegorz Nitka <grzegorz.nitka@intel.com>
> Fixes: 1a1c40df2e80 ("ice: set and release switchdev environment")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.h b/drivers/net/ethernet/intel/ice/ice_eswitch.h
> index bd58d9d2e565..6a413331572b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch.h
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch.h
> @@ -52,7 +52,7 @@ static inline void ice_eswitch_update_repr(struct ice_vsi *vsi) { }
>  
>  static inline int ice_eswitch_configure(struct ice_pf *pf)
>  {
> -	return -EOPNOTSUPP;
> +	return 0;
>  }
>  
>  static inline int ice_eswitch_rebuild(struct ice_pf *pf)
> -- 
> 2.27.0
> 
Thanks for this fix!

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
