Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B50E356E66
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344399AbhDGOVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:21:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231183AbhDGOVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 10:21:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lU93N-00FJmV-5Z; Wed, 07 Apr 2021 16:21:09 +0200
Date:   Wed, 7 Apr 2021 16:21:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: stmmac: Add support for external
 trigger timestamping
Message-ID: <YG2/1fbNNIsbafZp@lunn.ch>
References: <20210407141537.2129-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407141537.2129-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 10:15:37PM +0800, Wong Vee Khee wrote:
> From: Tan Tee Min <tee.min.tan@intel.com>
> 
> The Synopsis MAC controller supports auxiliary snapshot feature that
> allows user to store a snapshot of the system time based on an external
> event.
> 
> This patch add supports to the above mentioned feature. Users will be
> able to triggered capturing the time snapshot from user-space using
> application such as testptp or any other applications that uses the
> PTP_EXTTS_REQUEST ioctl request.

You forgot to Cc: the PTP maintainer.

> @@ -159,6 +163,37 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
>  					     priv->systime_flags);
>  		spin_unlock_irqrestore(&priv->ptp_lock, flags);
>  		break;
> +	case PTP_CLK_REQ_EXTTS:
> +		priv->plat->ext_snapshot_en = on;
> +		mutex_lock(&priv->aux_ts_lock);
> +		acr_value = readl(ptpaddr + PTP_ACR);
> +		acr_value &= ~PTP_ACR_MASK;
> +		if (on) {
> +			/* Enable External snapshot trigger */
> +			acr_value |= priv->plat->ext_snapshot_num;
> +			acr_value |= PTP_ACR_ATSFC;
> +			pr_info("Auxiliary Snapshot %d enabled.\n",
> +				priv->plat->ext_snapshot_num >>
> +				PTP_ACR_ATSEN_SHIFT);

dev_dbg()?

> +			/* Enable Timestamp Interrupt */
> +			intr_value = readl(ioaddr + GMAC_INT_EN);
> +			intr_value |= GMAC_INT_TSIE;
> +			writel(intr_value, ioaddr + GMAC_INT_EN);
> +
> +		} else {
> +			pr_info("Auxiliary Snapshot %d disabled.\n",
> +				priv->plat->ext_snapshot_num >>
> +				PTP_ACR_ATSEN_SHIFT);

dev_dbg()?

Do you really want to spam the kernel log with this?

