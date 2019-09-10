Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB63AF2E1
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 00:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfIJWTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 18:19:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:11794 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfIJWTO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 18:19:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 15:19:13 -0700
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="189483519"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 15:19:13 -0700
Message-ID: <91551885b0731a9e6121a3afe2c9a6cc912f61d5.camel@linux.intel.com>
Subject: Re: [net-next 11/14] ixgbe: Prevent u8 wrapping of ITR value to
 something less than 10us
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Gregg Leventhal <gleventhal@janestreet.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Tue, 10 Sep 2019 15:19:13 -0700
In-Reply-To: <20190910163434.2449-12-jeffrey.t.kirsher@intel.com>
References: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
         <20190910163434.2449-12-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-09-10 at 09:34 -0700, Jeff Kirsher wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> There were a couple cases where the ITR value generated via the adaptive
> ITR scheme could exceed 126. This resulted in the value becoming either 0
> or something less than 10. Switching back and forth between a value less
> than 10 and a value greater than 10 can cause issues as certain hardware
> features such as RSC to not function well when the ITR value has dropped
> that low.

One quick thing we can add on here is:
Fixes: b4ded8327fea ("ixgbe: Update adaptive ITR algorithm")

This is likely something that we may want to backport to stable.

> Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index dc034f4e8cf6..a5398b691aa8 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -2623,7 +2623,7 @@ static void ixgbe_update_itr(struct ixgbe_q_vector *q_vector,
>  		/* 16K ints/sec to 9.2K ints/sec */
>  		avg_wire_size *= 15;
>  		avg_wire_size += 11452;
> -	} else if (avg_wire_size <= 1980) {
> +	} else if (avg_wire_size < 1968) {
>  		/* 9.2K ints/sec to 8K ints/sec */
>  		avg_wire_size *= 5;
>  		avg_wire_size += 22420;
> @@ -2656,6 +2656,8 @@ static void ixgbe_update_itr(struct ixgbe_q_vector *q_vector,
>  	case IXGBE_LINK_SPEED_2_5GB_FULL:
>  	case IXGBE_LINK_SPEED_1GB_FULL:
>  	case IXGBE_LINK_SPEED_10_FULL:
> +		if (avg_wire_size > 8064)
> +			avg_wire_size = 8064;
>  		itr += DIV_ROUND_UP(avg_wire_size,
>  				    IXGBE_ITR_ADAPTIVE_MIN_INC * 64) *
>  		       IXGBE_ITR_ADAPTIVE_MIN_INC;


