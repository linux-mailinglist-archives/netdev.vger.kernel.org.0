Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE404479603
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 22:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbhLQVKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 16:10:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:5166 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhLQVKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 16:10:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639775425; x=1671311425;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=O12f+TMQKWnolv99gwa8aZJFVkB1WHaQSFmZwVbVwVg=;
  b=PtX/xNnnAEn9EYuZVv7MdzG9BuDJ8ul3vGpJrpuBCaPrsPYj6scByE8a
   rOFuRf2AwobxQz79cGzg4hKeBmNF9F/YQPqB8Aen1u5WiKiFRabAfUrbm
   xLbavNu2/4cqz7aKf8JkJ01YuJjBPDtUSrhmfMVE6sf2wm8r7bi8wJRSO
   jDp+U4Tic4PqLjw//gUAIX/qhY0EZ9S0mM5x5r0Tdn2YgFyf71jF5nHMs
   PRXToRnJ1jJXc8sWBfi/6E4Dd0/xGM1qLYQ0L9BYI/7TIxSr+ZUEJ2Gqw
   4YBghHR3xk7zTLBOJs4LjCJwwYSflo/HcyLzmjWxxjChEc4+SyHQdebT4
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="303212284"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="303212284"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 13:10:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="612255459"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 13:10:24 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     James McLaughlin <james.mclaughlin@qsc.com>, davem@davemloft.net,
        kuba@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James McLaughlin <james.mclaughlin@qsc.com>
Subject: Re: [PATCH] igc: updated TX timestamp support for non-MSI-X platforms
In-Reply-To: <20211217205209.723782-1-james.mclaughlin@qsc.com>
References: <20211217205209.723782-1-james.mclaughlin@qsc.com>
Date:   Fri, 17 Dec 2021 13:10:23 -0800
Message-ID: <87mtkzym2o.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi James,

James McLaughlin <james.mclaughlin@qsc.com> writes:

> Time synchronization was not properly enabled on non-MSI-X platforms.
>
> Signed-off-by: James McLaughlin <james.mclaughlin@qsc.com>
> Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

A couple of things that I should have pointed out earlier.

The subject line would be better if it was: "PATCH net" (to indicate
that the patch should be considered for the "net" tree, not "net-next").

Also, it could be made clearer that it's a fix, so the full subject line
could be like this:

      "[PATCH net] igc: Fix TX timestamp support for non-MSI platforms"

Adding a "fixes" tag to the commit message would help, something like this:

       Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")

> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 8e448288ee26..d28a80a00953 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -5467,6 +5467,9 @@ static irqreturn_t igc_intr_msi(int irq, void *data)
>  			mod_timer(&adapter->watchdog_timer, jiffies + 1);
>  	}
>  
> +	if (icr & IGC_ICR_TS)
> +		igc_tsync_interrupt(adapter);
> +
>  	napi_schedule(&q_vector->napi);
>  
>  	return IRQ_HANDLED;
> @@ -5510,6 +5513,9 @@ static irqreturn_t igc_intr(int irq, void *data)
>  			mod_timer(&adapter->watchdog_timer, jiffies + 1);
>  	}
>  
> +	if (icr & IGC_ICR_TS)
> +		igc_tsync_interrupt(adapter);
> +
>  	napi_schedule(&q_vector->napi);
>  
>  	return IRQ_HANDLED;
> -- 
> 2.25.1
>

Cheers,
-- 
Vinicius
