Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4A05AE5D5
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 12:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbiIFKr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 06:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239833AbiIFKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 06:46:33 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8F275CCA;
        Tue,  6 Sep 2022 03:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662461126; x=1693997126;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nAdc8Rr843R6WJOu79NKjIig8n6+aOXK81VmIUMIj3g=;
  b=M0Vy69RMHMHQN2GsgOb9w/bZh5RFY5aBqudnM0EftW5rHxW2VfFDPDWo
   QVNCoPMi38tOEu2uTlCGU1Ip23q3FZ5ZyhM03w05No8lyTJwCm9UuTBwX
   z+TON5R+hmumaEVvvjEmWBkgMk+XBAhe+WBh3LsxuE9J+UJ4clhyhGCfY
   pIe6KohlRXipDDN8KbTrEEBdI458x//SH8rrgaV7dgLcg/QwZViqaIEjY
   uBd0qFCYJXnp6xyaYhb+Y5pqHIk4JZBXeL1dXB2dm7L4FYwqi4HP+7bNJ
   QGoh/eP67X1l+hS/6YGvAoruJBhk9RZI1EQSOtAeew1EtyWm7Beq4XrUZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="358277620"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="358277620"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 03:45:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="644121884"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 03:45:09 -0700
Date:   Tue, 6 Sep 2022 12:45:00 +0200
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH] ice: switch: Simplify memory allocation
Message-ID: <YxckrI4ZWgBybPK5@localhost.localdomain>
References: <55ff1825aee6e655c41cb6770ca44f0fbdbfec00.1662301068.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55ff1825aee6e655c41cb6770ca44f0fbdbfec00.1662301068.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 04:18:02PM +0200, Christophe JAILLET wrote:
> 'rbuf' is locale to the ice_get_initial_sw_cfg() function.
> There is no point in using devm_kzalloc()/devm_kfree().
> 
> use kzalloc()/kfree() instead.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> As a side effect, it also require less memory. devm_kzalloc() has a small
> memory overhead, and requesting ICE_SW_CFG_MAX_BUF_LEN (i.e. 2048) bytes,
> 4096 are really allocated.
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
> index 697feb89188c..eb6e19deb70d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> @@ -2274,9 +2274,7 @@ int ice_get_initial_sw_cfg(struct ice_hw *hw)
>  	int status;
>  	u16 i;
>  
> -	rbuf = devm_kzalloc(ice_hw_to_dev(hw), ICE_SW_CFG_MAX_BUF_LEN,
> -			    GFP_KERNEL);
> -
> +	rbuf = kzalloc(ICE_SW_CFG_MAX_BUF_LEN, GFP_KERNEL);
>  	if (!rbuf)
>  		return -ENOMEM;
>  
> @@ -2324,7 +2322,7 @@ int ice_get_initial_sw_cfg(struct ice_hw *hw)
>  		}
>  	} while (req_desc && !status);
>  
> -	devm_kfree(ice_hw_to_dev(hw), rbuf);
> +	kfree(rbuf);
>  	return status;
>  }
>  
> -- 
> 2.34.1
> 

Thanks for catching that
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
