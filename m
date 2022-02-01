Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9B74A588A
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 09:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbiBAIbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 03:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiBAIbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 03:31:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A161CC061714;
        Tue,  1 Feb 2022 00:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3FE7614D3;
        Tue,  1 Feb 2022 08:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBCAC340EB;
        Tue,  1 Feb 2022 08:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643704268;
        bh=kQ46Ld07qE+xeaABEjqRpOmPW7m7DLTp4Eeg620JFg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ttDKeXS87gVeGUzyVxh+e1q40/7TDlvJ4giqg5t1Y5dtyL5su2iiw1XNL2u37IjfS
         YTpH8qO3l855FQezeOWbr9a3PFXs/qjr3l+dEMFqU6T4OXZkIEVfR2XQ5mia/ZaGp+
         1wD2flgm6Jh/asHRvLEiLfZeNI/WcN4sJeWjO1x1f6/iyUTOw4pBoidZom65t/xCKg
         TVdPZP0vNfIv8USPmB8aIWBhUoV/0REb3P4DYjM7TyIoXN/P/rAW0iSUax52TkP1O+
         zle2FZ+0INL+pOOiFgIHxHW6Xs1P+HfHFLSETUgbdcG/Fo2mtHyg/oJm5A3FWmR6fK
         52zeriBnmxitQ==
Date:   Tue, 1 Feb 2022 10:31:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Dave Ertman <david.m.ertman@intel.com>
Subject: Re: [PATCH for-next 1/3] net/ice: add support for DSCP QoS for IIDC
Message-ID: <YfjvxwcoBKTRe1co@unreal>
References: <20220131194316.1528-1-shiraz.saleem@intel.com>
 <20220131194316.1528-2-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131194316.1528-2-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 01:43:14PM -0600, Shiraz Saleem wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The ice driver provides QoS information to auxiliary drivers through
> the exported function ice_get_qos_params. This function doesn't
> currently support L3 DSCP QoS.
> 
> Add the necessary defines, structure elements and code to support DSCP
> QoS through the IIDC functions.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_idc.c | 5 +++++
>  include/linux/net/intel/iidc.h           | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
> index fc35801..263a2e7 100644
> --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> @@ -227,6 +227,11 @@ void ice_get_qos_params(struct ice_pf *pf, struct iidc_qos_params *qos)
>  
>  	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
>  		qos->tc_info[i].rel_bw = dcbx_cfg->etscfg.tcbwtable[i];
> +
> +	qos->pfc_mode = dcbx_cfg->pfc_mode;
> +	if (qos->pfc_mode == IIDC_DSCP_PFC_MODE)
> +		for (i = 0; i < IIDC_MAX_DSCP_MAPPING; i++)
> +			qos->dscp_map[i] = dcbx_cfg->dscp_map[i];
>  }
>  EXPORT_SYMBOL_GPL(ice_get_qos_params);
>  
> diff --git a/include/linux/net/intel/iidc.h b/include/linux/net/intel/iidc.h
> index 1289593..fee9180 100644
> --- a/include/linux/net/intel/iidc.h
> +++ b/include/linux/net/intel/iidc.h
> @@ -32,6 +32,9 @@ enum iidc_rdma_protocol {
>  };
>  
>  #define IIDC_MAX_USER_PRIORITY		8
> +#define IIDC_MAX_DSCP_MAPPING          64
> +#define IIDC_VLAN_PFC_MODE             0x0

This define is not used in any of the patches in the series.

Thanks

> +#define IIDC_DSCP_PFC_MODE             0x1
>  
>  /* Struct to hold per RDMA Qset info */
>  struct iidc_rdma_qset_params {
> @@ -60,6 +63,8 @@ struct iidc_qos_params {
>  	u8 vport_relative_bw;
>  	u8 vport_priority_type;
>  	u8 num_tc;
> +	u8 pfc_mode;
> +	u8 dscp_map[IIDC_MAX_DSCP_MAPPING];
>  };
>  
>  struct iidc_event {
> -- 
> 1.8.3.1
> 
