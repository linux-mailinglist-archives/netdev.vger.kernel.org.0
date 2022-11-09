Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF5623055
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiKIQko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiKIQkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:40:35 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1985B23167
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668012035; x=1699548035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wm08npWAS5nySF+I/zfAyVI9YBlNqn8hyMTdMmbY0+Y=;
  b=LQ+ZISTTe76M3Z/5t1G8aaVFpmvWZOtywPLnTtlYre4nZHmcvy2XuZlB
   +LeY9BmvwUHhGcfoz7MtVhMuwK5arPypvvePISJ2aZ1/Db8hAiYW5YFob
   Q+Ibx5GZozHczSaBF/25HMr1sRqYZfuPhm9O92xETd7xd3y/Cb+66444f
   1yYABpkY/EXW8meze4gwyuyJ3+CsebBEApex7y/7qq1WAdzRQppDqnmd+
   VWNRhIE/EA7x68vRdbWwjzuAmEthzngG9FCgN3ebVy/79JhnZDQWq+gWh
   mr9UNsU5Hi3osdiNJUpCfefyPHpPiez84zwIXsn/6dhNLqCk0dWlaGEob
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="298550677"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="298550677"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 08:40:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="639254506"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="639254506"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 09 Nov 2022 08:40:30 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A9GeT9u003111;
        Wed, 9 Nov 2022 16:40:29 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Tony Nguyen <anthony.l.nguyen@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/3] ice: use int for n_per_out loop
Date:   Wed,  9 Nov 2022 17:37:12 +0100
Message-Id: <20221109163712.1154266-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108235116.3522941-3-anthony.l.nguyen@intel.com>
References: <20221108235116.3522941-1-anthony.l.nguyen@intel.com> <20221108235116.3522941-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Tue,  8 Nov 2022 15:51:15 -0800

> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> In ice_ptp_enable_all_clkout and ice_ptp_disable_all_clkout we use a uint
> for a for loop iterating over the n_per_out value from the struct
> ptp_clock_info. The struct member is a signed int, and the use of uint
> generates a -Wsign-compare warning:
> 
>   drivers/net/ethernet/intel/ice/ice_ptp.c: In function ‘ice_ptp_enable_all_clkout’:
>   drivers/net/ethernet/intel/ice/ice_ptp.c:1710:23: error: comparison of integer expressions of different signedness: ‘uint’ {aka ‘unsigned int’} and ‘int’ [-Werror=sign-compare]
>    1710 |         for (i = 0; i < pf->ptp.info.n_per_out; i++)
>         |                       ^
>   cc1: all warnings being treated as errors
> 
> While we don't generally compile with -Wsign-compare, its still a good idea

-Wsign-compare is disabled even on W=2.

> not to mix types. Fix the two functions to use a plain signed integer.

It's still a good idea to not use ints when values below zero are
not used. Here both @i's are used as iterators from zero and above.
The change is just pointless. I would even understand if you casted
::n_per_out to `u32` in the loop condition and -Wsign-compare was
enabled on W=1 or 2, but not this.

> 
> Fixes: 9ee313433c48 ("ice: restart periodic outputs around time changes")

...even more pointless to send it to net, not net-next, it doesn't
fix anything. If you manually enable the warning via KCFLAGS, you'll
see thousands of them.

> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
> index 011b727ab190..be147fb641ae 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> @@ -1688,7 +1688,7 @@ static int ice_ptp_cfg_clkout(struct ice_pf *pf, unsigned int chan,
>   */
>  static void ice_ptp_disable_all_clkout(struct ice_pf *pf)
>  {
> -	uint i;
> +	int i;
>  
>  	for (i = 0; i < pf->ptp.info.n_per_out; i++)
>  		if (pf->ptp.perout_channels[i].ena)
> @@ -1705,7 +1705,7 @@ static void ice_ptp_disable_all_clkout(struct ice_pf *pf)
>   */
>  static void ice_ptp_enable_all_clkout(struct ice_pf *pf)
>  {
> -	uint i;
> +	int i;
>  
>  	for (i = 0; i < pf->ptp.info.n_per_out; i++)
>  		if (pf->ptp.perout_channels[i].ena)
> -- 
> 2.35.1

Thanks,
Olek
