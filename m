Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEA86BCD4F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCPKyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPKyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:54:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B958259D4;
        Thu, 16 Mar 2023 03:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678964074; x=1710500074;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Kar89oa4TtmgB8tJOm0wfcbawpENCG6Q2dF38jFfXc=;
  b=Z1fdmGdlg+2+8y7qkSLQp0sgKuaGsDVT2SuFsbsWvvxj6laRix6efGgi
   vZf6yowcwtH4pNgkAtZzi17Fo+0xSsS6wMkoDWeR+N9LcQ3EC2KaS6gAl
   QoKcox9RawFavnRAdbRT390xMelhRBNxNISn+1MlvcV/+qmGzsqKJIDcr
   NkL73sdGyXxg1J1ghgQXi5ifkSX6BgU8ZHRKISzROqFwhEwAS1pDTnBi0
   FK1VfzdBrsbzksr4Y8KqkfJIE643T4Hdtm5JJMIFZ+01+DbPjiCS91IHy
   Z5uWZ4E/vQOISVtyDOLMqHVCtXfkypoKxrH+tLtKWEfuJwLy25OQbj8vr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="321791035"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="321791035"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:54:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="682268627"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="682268627"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:54:31 -0700
Date:   Thu, 16 Mar 2023 11:54:23 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@amd.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH net-next] net: macb: Reset TX when TX halt times out
Message-ID: <ZBL1X1U3BJEAEIrX@localhost.localdomain>
References: <20230316083554.2432-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083554.2432-1-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 02:05:54PM +0530, Harini Katakam wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Reset TX when halt times out i.e. disable TX, clean up TX BDs,
> interrupts (already done) and enable TX.
> This addresses the issue observed when iperf is run at 10Mps Half
> duplex where, after multiple collisions and retries, TX halts.
> 
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 96fd2aa9ee90..473c2d0174ad 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1021,6 +1021,7 @@ static void macb_tx_error_task(struct work_struct *work)
>  	struct sk_buff		*skb;
>  	unsigned int		tail;
>  	unsigned long		flags;
> +	bool			halt_timeout = false;
RCT

Otherwise looks fine
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[...]

> -- 
> 2.17.1
> 
