Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C633AA772
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 01:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhFPXaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 19:30:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:30915 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhFPXaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 19:30:03 -0400
IronPort-SDR: 9Fl8ijXuZvj1oEDZcUZ+JKxEr5QmhhgIVu9MjzrjBWBbzjTQDlIvmAr0lSZmZrgUCXgNgD0Jh5
 XB9iCLay9VcA==
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="267420483"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="267420483"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 16:27:53 -0700
IronPort-SDR: c/uhERQyM+sCgOUqZHbGxAylMWWwjSLqhn+8dqVDprMkHlPe6u7GA6VFA4cVP64YtyRNR/QyBq
 +DtCdxpl9d1A==
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="479269628"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.42.204]) ([10.209.42.204])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 16:27:52 -0700
Subject: Re: [PATCH][next] ice: remove redundant continue statement in a
 for-loop
To:     Colin King <colin.king@canonical.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615142847.60161-1-colin.king@canonical.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2a347503-9879-0a13-555b-a007acfdec3c@intel.com>
Date:   Wed, 16 Jun 2021 16:27:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210615142847.60161-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/15/2021 7:28 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The continue statement in the for-loop is redundant. Re-work the hw_lock
> check to remove it.
> 
> Addresses-Coverity: ("Continue has no effect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Yep, that logic makes more sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
> index 267312fad59a..3eca0e4eab0b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
> @@ -410,13 +410,11 @@ bool ice_ptp_lock(struct ice_hw *hw)
>  	for (i = 0; i < MAX_TRIES; i++) {
>  		hw_lock = rd32(hw, PFTSYN_SEM + (PFTSYN_SEM_BYTES * hw->pf_id));
>  		hw_lock = hw_lock & PFTSYN_SEM_BUSY_M;
> -		if (hw_lock) {
> -			/* Somebody is holding the lock */
> -			usleep_range(10000, 20000);
> -			continue;
> -		} else {
> +		if (!hw_lock)
>  			break;
> -		}
> +
> +		/* Somebody is holding the lock */
> +		usleep_range(10000, 20000);
>  	}
>  
>  	return !hw_lock;
> 
