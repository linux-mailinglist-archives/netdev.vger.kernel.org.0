Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DD538D929
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 07:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhEWFtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 01:49:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:10302 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhEWFtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 01:49:00 -0400
IronPort-SDR: GFTovgJJH//BQ9PN30soE1sziNg98j/GadNBT6vtTB3aAM7memuoIaAUH6IeJHGxLeiZX5aHmE
 pf/JiogmxW2Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9992"; a="222871171"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="222871171"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2021 22:47:34 -0700
IronPort-SDR: GC0ZpBmkqFP7xLRiZ1xXyEnpSGojc1KmPElF1Gpipdi4uaeMHrYJwfP5aZAhzlhT8JpsZjWunz
 hOVmrcSu7lEw==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="475298038"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.214.192.226]) ([10.214.192.226])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2021 22:47:30 -0700
Subject: Re: [PATCH] igc: change default return of igc_read_phy_reg()
To:     trix@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Fuxbrumer, DvoraX" <dvorax.fuxbrumer@intel.com>
References: <20210521195019.2078661-1-trix@redhat.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <85d1b413-3ab3-6cee-4197-785b0c099340@intel.com>
Date:   Sun, 23 May 2021 08:47:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210521195019.2078661-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/2021 22:50, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Static analysis reports this problem
> 
> igc_main.c:4944:20: warning: The left operand of '&'
>    is a garbage value
>      if (!(phy_data & SR_1000T_REMOTE_RX_STATUS) &&
>            ~~~~~~~~ ^
Tom, thanks for this patch. I believe the same static analysis problem 
should be with the 'igb_read_phy_reg' method:
https://elixir.bootlin.com/linux/v5.13-rc1/source/drivers/net/ethernet/intel/igb/igb.h#L769
> 
> pyy_data is set by the call to igc_read_phy_reg() only if
%s/pyy_data/phy_data/gc (typo)
> there is a read_reg() op, else it is unset and a 0 is
> returned.  Change the return to -EOPNOTSUPP.
> 
> Fixes: 208983f099d9 ("igc: Add watchdog")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   drivers/net/ethernet/intel/igc/igc.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
> index b6d3277c6f520..71100ee7afbee 100644
> --- a/drivers/net/ethernet/intel/igc/igc.h
> +++ b/drivers/net/ethernet/intel/igc/igc.h
> @@ -577,7 +577,7 @@ static inline s32 igc_read_phy_reg(struct igc_hw *hw, u32 offset, u16 *data)
>   	if (hw->phy.ops.read_reg)
>   		return hw->phy.ops.read_reg(hw, offset, data);
>   
> -	return 0;
> +	return -EOPNOTSUPP;
>   }
>   
>   void igc_reinit_locked(struct igc_adapter *);
> 
Thanks,
Sasha
