Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A7D50314B
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354897AbiDOVni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356195AbiDOVna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:43:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844FF42A3F;
        Fri, 15 Apr 2022 14:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650058859; x=1681594859;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D+EtR25o6TgsLEAQY93ZWajgB/+OLtNNhIpII8Uyeks=;
  b=J3NJ2Jp/yNJsDB+nyegVPy2Zfz0dGoiKYRsWIRuuk+Ts3oY/9dv/phJ8
   m/Nw4PeAnACterylQtv7B8vTwommLSQk2jbV1nLvWA2H+9UVs8dUYzYEn
   14/ZnoXbEwDuZH7RZiuCQEydzJtYW9zwhbOJbrzYTC6OyR2c9ZBbLEvye
   r8SDgr0szB7b5ZQ1T/rVkeqFN2Cb0JWcdN8iI0fL+S5KoufYJT2jVD+vr
   IE2qtvPLfYyy0tYhrN9ORxcSNhUmq7BK/29s4ysXn7uq9vjjd9sPzzwKA
   sePgw5NLhihmufbRaXV7WNYW69ckemgt4ltgCttgCH2r32bZNMXUGuySk
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="262695357"
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="262695357"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 14:40:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="560709031"
Received: from aelhiber-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.78.254])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 14:40:58 -0700
Date:   Fri, 15 Apr 2022 14:40:58 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     outreachy@lists.linux.dev, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel: igb: igb_ethtool.c: Convert kmap() to
 kmap_local_page()
Message-ID: <Ylnmaji5bHHp8t3p@iweiny-desk3>
References: <20220415205307.675650-1-eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415205307.675650-1-eng.alaamohamedsoliman.am@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 10:53:07PM +0200, Alaa Mohamed wrote:
> The use of kmap() is being deprecated in favor of kmap_local_page()
> where it is feasible.
> 
> With kmap_local_page(), the mapping is per thread, CPU local and not
> globally visible.
> 
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 2a5782063f4c..ba93aa4ae6a0 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
>  
>  	frame_size >>= 1;
>  
> -	data = kmap(rx_buffer->page);
> +	data = kmap_local_page(rx_buffer->page);
>  
>  	if (data[3] != 0xFF ||
>  	    data[frame_size + 10] != 0xBE ||
>  	    data[frame_size + 12] != 0xAF)
>  		match = false;
>  
> -	kunmap(rx_buffer->page);
> +	kunmap_local(rx_buffer->page);

kunmap_local() is different from kunmap().  It takes an address within the
mapped page.  From the kdoc:

/**
 * kunmap_local - Unmap a page mapped via kmap_local_page().
 * @__addr: An address within the page mapped
 *
 * @__addr can be any address within the mapped page.  Commonly it is the
 * address return from kmap_local_page(), but it can also include offsets.
 *
 * Unmapping should be done in the reverse order of the mapping.  See
 * kmap_local_page() for details.
 */
#define kunmap_local(__addr)                                    \
...


Ira

>  
>  	return match;
>  }
> -- 
> 2.35.2
> 
