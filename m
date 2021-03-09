Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F41331FA1
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 08:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCIHC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 02:02:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:58320 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhCIHCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 02:02:42 -0500
IronPort-SDR: n4RHtzw9ziA2rLytKpVL9iJvAQoWnH870yEdDBkBuHQF3zJ07KQOrpIrtd/G5BFnGWPPAArZhL
 uzNlmW3efegQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184812910"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="184812910"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 23:02:41 -0800
IronPort-SDR: JHEmdMJYUedd158qqihbepR68st3ISlKrQwr8diLlS0dBIW2MmBNolHTWFA+l7cycQjoheWlOz
 44gZfxyvJvHw==
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="409617657"
Received: from dfuxbrux-desk.ger.corp.intel.com (HELO [10.12.48.255]) ([10.12.48.255])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 23:02:39 -0800
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Fix error handling in
 e1000_set_d0_lplu_state_82571
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210228094424.7884-1-dinghao.liu@zju.edu.cn>
From:   Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Message-ID: <3cc37aec-bd27-235a-7c37-e8f1113c6a3c@linux.intel.com>
Date:   Tue, 9 Mar 2021 09:02:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210228094424.7884-1-dinghao.liu@zju.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/02/2021 11:44, Dinghao Liu wrote:
> There is one e1e_wphy() call in e1000_set_d0_lplu_state_82571
> that we have caught its return value but lack further handling.
> Check and terminate the execution flow just like other e1e_wphy()
> in this function.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>   drivers/net/ethernet/intel/e1000e/82571.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
> index 88faf05e23ba..0b1e890dd583 100644
> --- a/drivers/net/ethernet/intel/e1000e/82571.c
> +++ b/drivers/net/ethernet/intel/e1000e/82571.c
> @@ -899,6 +899,8 @@ static s32 e1000_set_d0_lplu_state_82571(struct e1000_hw *hw, bool active)
>   	} else {
>   		data &= ~IGP02E1000_PM_D0_LPLU;
>   		ret_val = e1e_wphy(hw, IGP02E1000_PHY_POWER_MGMT, data);
> +		if (ret_val)
> +			return ret_val;
>   		/* LPLU and SmartSpeed are mutually exclusive.  LPLU is used
>   		 * during Dx states where the power conservation is most
>   		 * important.  During driver activity we should enable
> 
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
