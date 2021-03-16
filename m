Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CA533E084
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhCPVaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhCPV3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E20E64F90;
        Tue, 16 Mar 2021 21:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615930182;
        bh=6RWKiVSp1/qWdoI29E3FxmJ1FLp/tfgmDY/WQwvvLS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BV+6JSsh0pUiBBkUaq94EITX1815VL2FAcI0CYxmiHLEw7StGKU3R73tbHiCfCZBb
         9a0o3/wOcxnLw+hQv6yqpigxO6LDDXhU79NzC83ZBP+wGC5DRu/HJQYbNsjul2EhCf
         TMsSblZyWUVHllmCBGdfn0JDAj8wJbmcTU9UDTxpoim5AZRyIbY1q6phTvJfDy+4fq
         wfS7M9cro5LCPzKD37lTKVsS//BvQ46M1ojS2o32Cu841A90nUK3dPfc5U2iTOnHjl
         PanDksj4OzL4uyHbKRIzA9Lz579a5hrUZetG8scu2/JaOVEQ0diEZ7pMpttXJ/MvPq
         pX+1BrXqsahwA==
Date:   Tue, 16 Mar 2021 14:29:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: Re: [RESEND v1 net-next 3/5] net: stmmac: introduce MSI Interrupt
 routines for mac, safety, RX & TX
Message-ID: <20210316142941.3ea1e24d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316121823.18659-4-weifeng.voon@intel.com>
References: <20210316121823.18659-1-weifeng.voon@intel.com>
        <20210316121823.18659-4-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 20:18:21 +0800 Voon Weifeng wrote:
> From: Ong Boon Leong <boon.leong.ong@intel.com>
> 
> Now we introduce MSI interrupt service routines and hook these routines
> up if stmmac_open() sees valid irq line being requested:-
> 
> stmmac_mac_interrupt()    :- MAC (dev->irq), WOL (wol_irq), LPI (lpi_irq)
> stmmac_safety_interrupt() :- Safety Feat Correctible Error (sfty_ce_irq)
>                              & Uncorrectible Error (sfty_ue_irq)
> stmmac_msi_intr_rx()      :- For all RX MSI irq (rx_irq)
> stmmac_msi_intr_tx()      :- For all TX MSI irq (tx_irq)

Do you split RX and TX irqs out on purpose? Most commonly one queue
pair maps to one CPU, so using single IRQ for Rx and Tx results in
fewer IRQs being triggered and better system performance.

> Each of IRQs will have its unique name so that we can differentiate
> them easily under /proc/interrupts.
> 
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

> +static int stmmac_request_irq(struct net_device *dev)

This function is a one huge if statement, please factor out both sides
into separate subfunctions.

> +	netdev_info(priv->dev, "PASS: requesting IRQs\n");

Does the user really need to know interrupts were requested on every
probe?

> +	return ret;

return 0; ?

> +irq_error:
> +	stmmac_free_irq(dev, irq_err, irq_idx);
> +	return ret;
> +}
