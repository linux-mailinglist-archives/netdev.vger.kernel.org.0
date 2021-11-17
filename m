Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A034C453F2F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhKQEAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:00:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:22858 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhKQEAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:00:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="221090397"
X-IronPort-AV: E=Sophos;i="5.87,240,1631602800"; 
   d="scan'208";a="221090397"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 19:57:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,240,1631602800"; 
   d="scan'208";a="472577787"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 16 Nov 2021 19:57:28 -0800
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 30747580039;
        Tue, 16 Nov 2021 19:57:25 -0800 (PST)
Date:   Wed, 17 Nov 2021 11:57:23 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [PATCH] net: stmmac: Fix signed/unsigned wreckage
Message-ID: <20211117035722.GA10711@linux.intel.com>
References: <87mtm578cs.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtm578cs.ffs@tglx>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 04:21:23PM +0100, Thomas Gleixner wrote:
> The recent addition of timestamp correction to compensate the CDC error
> introduced a subtle signed/unsigned bug in stmmac_get_tx_hwtstamp() while
> it managed for some obscure reason to avoid that in stmmac_get_rx_hwtstamp().
> 
> The issue is:
> 
>     s64 adjust = 0;
>     u64 ns;
> 
>     adjust += -(2 * (NSEC_PER_SEC / priv->plat->clk_ptp_rate));
>     ns += adjust;
> 
> works by chance on 64bit, but falls apart on 32bit because the compiler
> knows that adjust fits into 32bit and then treats the addition as a u64 +
> u32 resulting in an off by ~2 seconds failure.
> 
> The RX variant uses an u64 for adjust and does the adjustment via
> 
>     ns -= adjust;
> 
> because consistency is obviously overrated.
> 
> Get rid of the pointless zero initialized adjust variable and do:
> 
> 	ns -= (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;
> 
> which is obviously correct and spares the adjust obfuscation. Aside of that
> it yields a more accurate result because the multiplication takes place
> before the integer divide truncation and not afterwards.
> 
> Stick the calculation into an inline so it can't be accidentaly
> disimproved. Return an u32 from that inline as the result is guaranteed
> to fit which lets the compiler optimize the substraction.
> 
> Fixes: 3600be5f58c1 ("net: stmmac: add timestamp correction to rid CDC sync error")
> Reported-by: Benedikt Spranger <b.spranger@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Benedikt Spranger <b.spranger@linutronix.de>
> Cc: stable@vger.kernel.org
> Tested-by: Kurt Kanzenbach <kurt@linutronix.de> # Intel EHL

Thanks for the fix!

Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel ADL

