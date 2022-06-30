Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BF7561755
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiF3KK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiF3KK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:10:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B182D273;
        Thu, 30 Jun 2022 03:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656583827; x=1688119827;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XzV8lb39RqU/gtzU+hmSRVGu76gzswS57eUcYcMU+Qs=;
  b=HOGc3X8xeVZh6WkdnPNtYMDqFZ+uKYO34O77F0/UFVnVpPctzdsj0OVX
   /ZJ4UymAqvO2zDiGSUNOH19ZGYWzdRxH8KtHU1GzhmzZWECOSbVfYGRgC
   wFGwL4CnOI7TsRUESlF0CbATIwfeV13stui9dqRihtcwsEqZbx2Y8Kp0D
   jIacfifir3O1avIrQ8Dneiriv3p/XM+pqfKk77yS7+l/SLwQMP5dto4bZ
   azYv8Ph6zwGmGKIR+GNTkQKW9qbsE96+OoN4aJzBmqn7qiEAVtOJCNbWx
   upBuH4r7i5xfsIYI4hSXFsSFAxar1WRKMxooY/0aCuYRtwEWGka5WmscM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="265342094"
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="265342094"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 03:10:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="680918936"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Jun 2022 03:10:23 -0700
Date:   Thu, 30 Jun 2022 12:10:22 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Ira Weiny <ira.weiny@intel.com>, alexanderduyck@fb.com
Subject: Re: [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
Message-ID: <Yr12jl1nEqqVI3TT@boxer>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629085836.18042-1-fmdefrancesco@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 10:58:36AM +0200, Fabio M. De Francesco wrote:
> The use of kmap() is being deprecated in favor of kmap_local_page().
> 
> With kmap_local_page(), the mapping is per thread, CPU local and not
> globally visible. Furthermore, the mapping can be acquired from any context
> (including interrupts).
> 
> Therefore, use kmap_local_page() in ixgbe_check_lbtest_frame() because
> this mapping is per thread, CPU local, and not globally visible.

Hi,

I'd like to ask why kmap was there in the first place and not plain
page_address() ?

Alex?

> 
> Suggested-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> index 628d0eb0599f..e64d40482bfd 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> @@ -1966,14 +1966,14 @@ static bool ixgbe_check_lbtest_frame(struct ixgbe_rx_buffer *rx_buffer,
>  
>  	frame_size >>= 1;
>  
> -	data = kmap(rx_buffer->page) + rx_buffer->page_offset;
> +	data = kmap_local_page(rx_buffer->page) + rx_buffer->page_offset;
>  
>  	if (data[3] != 0xFF ||
>  	    data[frame_size + 10] != 0xBE ||
>  	    data[frame_size + 12] != 0xAF)
>  		match = false;
>  
> -	kunmap(rx_buffer->page);
> +	kunmap_local(data);
>  
>  	return match;
>  }
> -- 
> 2.36.1
> 
