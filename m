Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20393307A5
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 06:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhCHFnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 00:43:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:23519 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234459AbhCHFnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 00:43:37 -0500
IronPort-SDR: KLv9ehSV3/gJ0l9Y2cROpynbJ75YsHDAp4QtuCg3mFl89Vi7dVBlj63kmWwqPI8Lv3IEbp7PkF
 zD19qsXBDtqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="175081843"
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="175081843"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 21:43:36 -0800
IronPort-SDR: NtrqViryP86Vw4W3pRl+OQyWQXdENR/3Jx1LkW4B3PmE9P/knbk5JWoec6miaBeoDoXpAjSsGX
 TVoNW287NJZA==
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="402696119"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.185.168.83]) ([10.185.168.83])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 21:43:34 -0800
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Fix error handling in
 e1000_set_d0_lplu_state_82571
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210228094424.7884-1-dinghao.liu@zju.edu.cn>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <57bae851-e735-d015-114b-aeacd602f623@intel.com>
Date:   Mon, 8 Mar 2021 07:43:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210228094424.7884-1-dinghao.liu@zju.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/2021 11:44, Dinghao Liu wrote:
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
Good for me.
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
