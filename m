Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E67D222846
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgGPQ3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:29:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:35621 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728845AbgGPQ3I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 12:29:08 -0400
IronPort-SDR: JmVOYr2Ka0wOxCC1OClse1Vp4g1mr8dIvNevBrot2EHibBa5KQa+ZtU5QfgL1TcNaJGYHmfONM
 vrm4M+uAc9pA==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="234285576"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="234285576"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 09:29:07 -0700
IronPort-SDR: jVayiEFqbp2750im/htz5hT5AFKhoNCXs9RNDhLQ0oKLziiHP1ztfXWKy4FWsWUDyjU51Mt+qx
 /r4ub4vJDnLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="326574290"
Received: from hmehl-mobl2.ger.corp.intel.com (HELO [10.254.156.209]) ([10.254.156.209])
  by orsmga007.jf.intel.com with ESMTP; 16 Jul 2020 09:29:04 -0700
Subject: Re: [Intel-wired-lan] [PATCH] igc: Do not use link uninitialized in
 igc_check_for_copper_link
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20200716044934.152364-1-natechancellor@gmail.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <cdfec63a-e51f-e1a6-aa60-6ca949338306@intel.com>
Date:   Thu, 16 Jul 2020 19:29:03 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716044934.152364-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/2020 07:49, Nathan Chancellor wrote:
> Clang warns:
> 
Hello Nathan,
Thanks for tracking our code.Please, look at 
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200709073416.14126-1-sasha.neftin@intel.com/ 
- I hope this patch already address this Clang warns - please, let me know.
> drivers/net/ethernet/intel/igc/igc_mac.c:374:6: warning: variable 'link'
> is used uninitialized whenever 'if' condition is true
> [-Wsometimes-uninitialized]
>          if (!mac->get_link_status) {
>              ^~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/intel/igc/igc_mac.c:424:33: note: uninitialized use
> occurs here
>          ret_val = igc_set_ltr_i225(hw, link);
>                                         ^~~~
> drivers/net/ethernet/intel/igc/igc_mac.c:374:2: note: remove the 'if' if
> its condition is always false
>          if (!mac->get_link_status) {
>          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/intel/igc/igc_mac.c:367:11: note: initialize the
> variable 'link' to silence this warning
>          bool link;
>                   ^
>                    = 0
> 1 warning generated.
> 
> It is not wrong, link is only uninitialized after this through
> igc_phy_has_link. Presumably, if we skip the majority of this function
> when get_link_status is false, we should skip calling igc_set_ltr_i225
> as well. Just directly return 0 in this case, rather than bothering with
> adding another label or initializing link in the if statement.
> 
> Fixes: 707abf069548 ("igc: Add initial LTR support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1095
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_mac.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
> index b47e7b0a6398..26e3c56a4a8b 100644
> --- a/drivers/net/ethernet/intel/igc/igc_mac.c
> +++ b/drivers/net/ethernet/intel/igc/igc_mac.c
> @@ -371,10 +371,8 @@ s32 igc_check_for_copper_link(struct igc_hw *hw)
>   	 * get_link_status flag is set upon receiving a Link Status
>   	 * Change or Rx Sequence Error interrupt.
>   	 */
> -	if (!mac->get_link_status) {
> -		ret_val = 0;
> -		goto out;
> -	}
> +	if (!mac->get_link_status)
> +		return 0;
>   
>   	/* First we want to see if the MII Status Register reports
>   	 * link.  If so, then we want to get the current speed/duplex
> 
> base-commit: ca0e494af5edb59002665bf12871e94b4163a257
> 
Thanks,
Sasha
