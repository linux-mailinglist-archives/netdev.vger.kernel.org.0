Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4B033CA70
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 01:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhCPAlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 20:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232024AbhCPAll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 20:41:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13E0B64F5D;
        Tue, 16 Mar 2021 00:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615855301;
        bh=VOYpVt5GwO6xxd7dzoJqdqBQftQfoa6f+tTn+g1OspY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D3D1NwUuG0CuABzkFTHXcEAW+S7iIYvnc+93RHujNFtyOqGnPORw93SC2PO8r5GxT
         lVPI4D4FhmO4FWooADcYUwTjmCrzDRDqOWo5htEtnoYMQlT7MkeucFC8etgProA2md
         ad9Xj1r3TvDxivfFzmvitvuV4GhlC0Z8kvFTqTtfHIzSNQkcv2+BULqz07q/38v9Ua
         NW6dUIrrsXuzhEIzRFrEJrXJAAsBugvAXWqDDOl9owixrrKRpX/9XtX3MkKksdiGjS
         vP5zxn1qoPU3QgIF9HRB6/dRTBB2emhNh/z9tDH1HDpnoAZCOQ1DR+bEjW4fLAKzPU
         L03jnisdxoGqQ==
Date:   Mon, 15 Mar 2021 17:41:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     mohammad.athari.ismail@intel.com
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, vee.khee.wong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: stmmac: EST interrupts handling and
 error reporting
Message-ID: <20210315174140.6abb0edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210315221409.3867-2-mohammad.athari.ismail@intel.com>
References: <20210315221409.3867-1-mohammad.athari.ismail@intel.com>
        <20210315221409.3867-2-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 06:14:08 +0800 mohammad.athari.ismail@intel.com
wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> Enabled EST related interrupts as below:
> 1) Constant Gate Control Error (CGCE)
> 2) Head-of-Line Blocking due to Scheduling (HLBS)
> 3) Head-of-Line Blocking due to Frame Size (HLBF).
> 4) Base Time Register error (BTRE)
> 5) Switch to S/W owned list Complete (SWLC)
> 
> For HLBS, the user will get the info of all the queues that shows this
> error. For HLBF, the user will get the info of all the queue with the
> latest frame size which causes the error. Frame size 0 indicates no
> error.
> 
> The ISR handling takes place when EST feature is enabled by user.
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Co-developed-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

> +	if (status & HLBS) {
> +		value = readl(ioaddr + MTL_EST_SCH_ERR);
> +		value &= txqcnt_mask;
> +
> +		/* Clear Interrupt */
> +		writel(value, ioaddr + MTL_EST_SCH_ERR);
> +
> +		/* Collecting info to shows all the queues that has HLBS
> +		 * issue. The only way to clear this is to clear the
> +		 * statistic
> +		 */
> +		if (net_ratelimit())
> +			netdev_err(dev, "EST: HLB(sched) Queue %u\n", value);

This is a mask so probably better display it as hex?

> +	}
> +
> +	if (status & HLBF) {
> +		value = readl(ioaddr + MTL_EST_FRM_SZ_ERR);
> +		feqn = value & txqcnt_mask;
> +
> +		value = readl(ioaddr + MTL_EST_FRM_SZ_CAP);
> +		hbfq = (value & SZ_CAP_HBFQ_MASK(txqcnt)) >> SZ_CAP_HBFQ_SHIFT;
> +		hbfs = value & SZ_CAP_HBFS_MASK;
> +
> +		/* Clear Interrupt */
> +		writel(feqn, ioaddr + MTL_EST_FRM_SZ_ERR);
> +
> +		if (net_ratelimit())
> +			netdev_err(dev, "EST: HLB(size) Queue %u Size %u\n",
> +				   hbfq, hbfs);
> +	}
> +
> +	if (status & BTRE) {
> +		btrl = (status & BTRL) >> BTRL_SHIFT;
> +
> +		if (net_ratelimit())
> +			netdev_info(dev, "EST: BTR Error Loop Count %u\n",
> +				    btrl);
> +
> +		writel(BTRE, ioaddr + MTL_EST_STATUS);
> +	}
> +
> +	if (status & SWLC) {
> +		writel(SWLC, ioaddr + MTL_EST_STATUS);
> +		netdev_info(dev, "EST: SWOL has been switched\n");
> +	}
> +
> +	return status;

Caller never checks the return value, it probably should if this driver
supports shared irqs? Otherwise you can make this function void.

> +}
