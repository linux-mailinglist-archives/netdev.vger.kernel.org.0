Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791FE49B2E2
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382204AbiAYL0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:26:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:1939 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382187AbiAYLZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 06:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643109910; x=1674645910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+QEDba3uxX3WN/hSrnEQXGbRY4/0xMWBNHzT5CMR/O0=;
  b=jnoiRY7PQmy1A7wQ+nLFJUJT8IOBg195aPESHRaVsj4IlX/ueyllf+9D
   WnTPax+ilHcfpVbqJSxhI36wjmA++JrpqPqds3tliJdL2yDARkdfQUciB
   FdmnvzG99Hk1cAbfmDEKmeM9oJC3OH0dAwc2N2/0g7VgX5VfNGsTz7gVW
   y9XLJnD3HQhR7nNWFx3OosxRcgZYvLb4k+RyVVNhfMWKSPPwZxDRJ4DUX
   3/kQ1vM8yoUgnsd9olP7dmc/srEdTAuqUw8lIJZqIhbUBT3JyvuS2ak8Z
   k2gMtL3akCWJNoBbLC1biRK0vtmCM7LJ4oTn2YhoJOIQJW0b83Pd4cmGJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226950256"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="226950256"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 03:25:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="769005503"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jan 2022 03:25:02 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20PBP1Kr017449;
        Tue, 25 Jan 2022 11:25:01 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next v4 2/8] ice: xsk: force rings to be sized to power of 2
Date:   Tue, 25 Jan 2022 12:23:06 +0100
Message-Id: <20220125112306.746139-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124165547.74412-3-maciej.fijalkowski@intel.com>
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com> <20220124165547.74412-3-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Mon, 24 Jan 2022 17:55:41 +0100

> With the upcoming introduction of batching to XSK data path,
> performance wise it will be the best to have the ring descriptor count
> to be aligned to power of 2.
> 
> Check if rings sizes that user is going to attach the XSK socket fulfill
> the condition above. For Tx side, although check is being done against
> the Tx queue and in the end the socket will be attached to the XDP
> queue, it is fine since XDP queues get the ring->count setting from Tx
> queues.
> 
> Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 2388837d6d6c..0350f9c22c62 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -327,6 +327,14 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
>  	bool if_running, pool_present = !!pool;
>  	int ret = 0, pool_failure = 0;
>  
> +	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
> +	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
> +		netdev_err(vsi->netdev,
> +			   "Please align ring sizes at idx %d to power of 2\n", qid);

Ideally I'd pass xdp->extack from ice_xdp() to print this message
directly in userspace (note that NL_SET_ERR_MSG{,_MOD}() don't
support string formatting, but the user already knows QID at this
point).

> +		pool_failure = -EINVAL;
> +		goto failure;
> +	}
> +
>  	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
>  
>  	if (if_running) {
> @@ -349,6 +357,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
>  			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
>  	}
>  
> +failure:
>  	if (pool_failure) {
>  		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
>  			   pool_present ? "en" : "dis", pool_failure);
> -- 
> 2.33.1

Thanks,
Al
