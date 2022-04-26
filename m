Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0811510C55
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 00:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244944AbiDZXAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 19:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiDZXAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 19:00:50 -0400
X-Greylist: delayed 256 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 15:57:40 PDT
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89F530540;
        Tue, 26 Apr 2022 15:57:40 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 23QMqZP6815178;
        Wed, 27 Apr 2022 00:52:35 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 23QMqZP6815178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1651013555;
        bh=1A0SRXuIJ+MkXw+cW6tYHcX5DI4mJt6N/DBb9KvzSC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NRtJF3wqEfKOQjfWHq7zaGMZ3Se7mX4oyHAPUS4AeqepGshELU9tJcvh6hcntdoId
         W8wHt8lec+/bIhXeMwyD2IK/er1De+/OZyfHHprXJLXSoAtolROoAjayrQ3+960KzX
         k9U2TgY1ori0qy40kHXNo51gQC0tdMeOBCaOtKYQ=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 23QMqY0W815176;
        Wed, 27 Apr 2022 00:52:34 +0200
Date:   Wed, 27 Apr 2022 00:52:34 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com, wells.lu@sunplus.com
Subject: Re: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <Ymh3si+MTg5i0Bnl@electric-eye.fr.zoreil.com>
References: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
 <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wells Lu <wellslutw@gmail.com> :
[...]
> +int spl2sw_rx_poll(struct napi_struct *napi, int budget)
> +{
[...]
> +	wmb();	/* make sure settings are effective. */
> +	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +	mask &= ~MAC_INT_RX;
> +	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +
> +	napi_complete(napi);
> +	return 0;
> +}
> +
> +int spl2sw_tx_poll(struct napi_struct *napi, int budget)
> +{
[...]
> +	wmb();			/* make sure settings are effective. */
> +	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +	mask &= ~MAC_INT_TX;
> +	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +
> +	napi_complete(napi);
> +	return 0;
> +}
> +
> +irqreturn_t spl2sw_ethernet_interrupt(int irq, void *dev_id)
> +{
[...]
> +	if (status & MAC_INT_RX) {
> +		/* Disable RX interrupts. */
> +		mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +		mask |= MAC_INT_RX;
> +		writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
[...]
> +		napi_schedule(&comm->rx_napi);
> +	}
> +
> +	if (status & MAC_INT_TX) {
> +		/* Disable TX interrupts. */
> +		mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +		mask |= MAC_INT_TX;
> +		writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +
> +		if (unlikely(status & MAC_INT_TX_DES_ERR)) {
[...]
> +		} else {
> +			napi_schedule(&comm->tx_napi);
> +		}
> +	}

The readl/writel sequence in rx_poll (or tx_poll) races with the irq
handler performing MAC_INT_TX (or MAC_INT_RX) work. If the readl
returns the same value to both callers, one of the writel will be
overwritten.

-- 
Ueimor
