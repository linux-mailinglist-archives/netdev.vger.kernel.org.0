Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A5C26763E
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgIKW5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:57:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:63178 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgIKW46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 18:56:58 -0400
IronPort-SDR: NkBMGDM6Qweh939qoeZ/XwmupoRnROp8eVcDkcJps7/GjPxfOhuA+PeSou3KrV0zubjeSjMDdA
 NJaASLOruYWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="159810496"
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="159810496"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 15:56:55 -0700
IronPort-SDR: hWOT/9HhDXW0/hYAN+teVEweprm9K60rSO4Rlf+ETLdF4WOzpvjzCXCWct4zLd31o7WPl2ZTri
 5JUXqZ6zXJrA==
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="329945307"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.122.57]) ([10.209.122.57])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 15:56:54 -0700
Subject: Re: [RFC PATCH net-next v1 08/11] drivers/net/ethernet: handle one
 warning explicitly
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
 <20200911012337.14015-9-jesse.brandeburg@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <401624a4-2fcf-53c9-fe8d-f4e5fb6d3fba@intel.com>
Date:   Fri, 11 Sep 2020 15:56:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200911012337.14015-9-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 6:23 PM, Jesse Brandeburg wrote:
> While fixing the W=1 builds, this warning came up because the
> developers used a very tricky way to get structures initialized
> to a non-zero value, but this causes GCC to warn about an
> override. In this case the override was intentional, so just
> disable the warning for this code with a #pragma.
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  drivers/net/ethernet/renesas/sh_eth.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
> index 586642c33d2b..659530f9c117 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -45,6 +45,13 @@
>  #define SH_ETH_OFFSET_DEFAULTS			\
>  	[0 ... SH_ETH_MAX_REGISTER_OFFSET - 1] = SH_ETH_OFFSET_INVALID
>  
> +/* use some intentionally tricky logic here to initialize the whole struct to
> + * 0xffff, but then override certain fields, requiring us to indicate that we
> + * "know" that there are overrides in this structure, and we'll need to disable
> + * that warning from W=1 builds
> + */
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Woverride-init"


This should probably use something like the __diag() macros instead of
GCC-specific code, e.g.

__diag_push()
__diag_ignore(GCC, <version>, "-Woverride-init")

...

__diag_pop()

Where <version> is the major GCC version that introduced this warning.

Thanks,
Jake

>  static const u16 sh_eth_offset_gigabit[SH_ETH_MAX_REGISTER_OFFSET] = {
>  	SH_ETH_OFFSET_DEFAULTS,
>  
> @@ -332,6 +339,7 @@ static const u16 sh_eth_offset_fast_sh3_sh2[SH_ETH_MAX_REGISTER_OFFSET] = {
>  
>  	[TSU_ADRH0]	= 0x0100,
>  };
> +#pragma GCC diagnostic pop
>  
>  static void sh_eth_rcv_snd_disable(struct net_device *ndev);
>  static struct net_device_stats *sh_eth_get_stats(struct net_device *ndev);
> 
