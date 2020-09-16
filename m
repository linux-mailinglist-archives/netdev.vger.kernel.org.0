Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7FB26CEB7
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgIPWZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIPWZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:25:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B04BC061221;
        Wed, 16 Sep 2020 15:25:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25F8713624E0E;
        Wed, 16 Sep 2020 15:09:04 -0700 (PDT)
Date:   Wed, 16 Sep 2020 15:25:50 -0700 (PDT)
Message-Id: <20200916.152550.1833517348137875378.davem@davemloft.net>
To:     vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        yoong.siang.song@intel.com, sadhishkhanna.vijaya.balan@intel.com,
        chen.yong.seow@intel.com
Subject: Re: [PATCH net-next] net: stmmac: Add support to Ethtool get/set
 ring parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916074020.25491-1-vee.khee.wong@intel.com>
References: <20200916074020.25491-1-vee.khee.wong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 15:09:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>
Date: Wed, 16 Sep 2020 15:40:20 +0800

> +int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size)
> +{
> +	struct stmmac_priv *priv = netdev_priv(dev);
> +	int ret = 0;
> +
> +	if (netif_running(dev))
> +		stmmac_release(dev);
 ...
> +	if (netif_running(dev))
> +		ret = stmmac_open(dev);
> +

I've applied this patch but this approach is so fragile, but everyone
does it initially because it is so easy.

The problem here is that for so many reasons the stmmac_open() can
fail, and instead of just the ringparam() operation failing, the
interface becomes down and unusable.

Can you please eventually implement this properly?  Allocate the new
ring resources, and only commit the new configuration if it is
guaranteed to succeed.  Otherwise, backout the ringparam change
and keep the old configuration.

This way the device stays up regardless of whether the resources
(memory, DMA mappings, etc.) can be allocated fully.

Right now, if you do a ringparam under hard memory pressure, this will
take the inteface down as stmmac_open() fails.
