Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402134F406A
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386626AbiDEOYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384287AbiDEM1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 08:27:19 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB4AF61C3;
        Tue,  5 Apr 2022 04:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649158590; x=1680694590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BJZHFJEsJ2jxL/WFtVfApanTF40ujA8Q6+mOmwp15wA=;
  b=AcPlwnvXUWlYp1WIVBBpibxYVnNrM95LObEqAd7iSO6ojKk820CsmoS1
   LqVZkURao3uNupHNLAj8fWZ2IxsdC2o+60K2d8xItU+qkLJX2NCNy0Y+H
   JRFDfuFW4vpms+S90auuADvdlxOrG4gFE492xmClt8PJlBunMQQM0zAB2
   GwhE2tMy0FAzU/re2Jv8ZTWAqRlplXtA4feEiX5ejxYtfKVVhD3Gc2UKP
   FE4+s0ag0D+Q0f2RMtbvr9mVo0UC6TDGpcKtCxBSUcHgvjjP/hohnJc+y
   hvCkx/4dDlna3RaowP4XKbWb77B+Dg2dELyFRd1j+LEjREGPl/HiRfq6L
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260424379"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="260424379"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:36:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="587901208"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 05 Apr 2022 04:36:27 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 235BaPZg030433;
        Tue, 5 Apr 2022 12:36:25 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com
Subject: Re: [PATCH bpf-next 03/10] ice: xsk: terminate NAPI when XSK Rx queue gets full
Date:   Tue,  5 Apr 2022 13:34:03 +0200
Message-Id: <20220405113403.3528655-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405110631.404427-4-maciej.fijalkowski@intel.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com> <20220405110631.404427-4-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Tue, 5 Apr 2022 13:06:24 +0200

> Correlate -ENOBUFS that was returned from xdp_do_redirect() with a XSK
> Rx queue being full. In such case, terminate the softirq processing and
> let the user space to consume descriptors from XSK Rx queue so that
> there is room that driver can use later on.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.h |  1 +
>  drivers/net/ethernet/intel/ice/ice_xsk.c  | 25 +++++++++++++++--------
>  2 files changed, 17 insertions(+), 9 deletions(-)

--- 8< ---

> @@ -551,15 +552,15 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
>  		if (result == ICE_XDP_CONSUMED)
>  			goto out_failure;
>  		break;
> +	case XDP_DROP:
> +		result = ICE_XDP_CONSUMED;
> +		break;
>  	default:
>  		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
>  		fallthrough;
>  	case XDP_ABORTED:
>  out_failure:
>  		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
> -		fallthrough;
> -	case XDP_DROP:
> -		result = ICE_XDP_CONSUMED;
>  		break;

So the result for %XDP_ABORTED will be %ICE_XDP_PASS now? Or I'm
missing something :s

>  	}
>  
> @@ -628,10 +629,16 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)

--- 8< ---

> -- 
> 2.33.1

Thanks,
Al
