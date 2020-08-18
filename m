Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB39248E5B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgHRS7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:59:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:15613 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgHRS7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:59:03 -0400
IronPort-SDR: J2HMOc6BRQu3U7vC8RQ9SBMbbd5Bxf1/kQf2B12Al/gkoTUK5pOpz/zyRV8myk97nZhYyotSmW
 gbRLPgjJO2LQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="135056784"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="135056784"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:58:58 -0700
IronPort-SDR: xkt5ijKqTdO/rikCt34PLl6yMmwOu+6l8gZyxxaEE5+tKA2iasRtuyh633pS4/CZxUITCTs60B
 zYIipr3Vw8Yw==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="471920997"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:58:58 -0700
Date:   Tue, 18 Aug 2020 11:58:57 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net 3/4] sfc: null out channel->rps_flow_id after
 freeing it
Message-ID: <20200818115857.000078e5@intel.com>
In-Reply-To: <ea34ed03-23e8-568f-ec50-1f238bc0a350@solarflare.com>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
        <ea34ed03-23e8-568f-ec50-1f238bc0a350@solarflare.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote:

> If an ef100_net_open() fails, ef100_net_stop() may be called without
>  channel->rps_flow_id having been written; thus it may hold the address
>  freed by a previous ef100_net_stop()'s call to efx_remove_filters().
>  This then causes a double-free when efx_remove_filters() is called
>  again, leading to a panic.
> To prevent this, after freeing it, overwrite it with NULL.
> 
> Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/rx_common.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> index ef9bca92b0b7..5e29284c89c9 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -849,6 +849,7 @@ void efx_remove_filters(struct efx_nic *efx)
>  	efx_for_each_channel(channel, efx) {
>  		cancel_delayed_work_sync(&channel->filter_work);
>  		kfree(channel->rps_flow_id);
> +		channel->rps_flow_id = NULL;
>  	}
>  #endif
>  	down_write(&efx->filter_sem);
> 


