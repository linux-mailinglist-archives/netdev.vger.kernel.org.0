Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B651C2B30B0
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgKNUpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKNUpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 15:45:08 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E31922245;
        Sat, 14 Nov 2020 20:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605386708;
        bh=55zxoyo1mw5dFVi7p+0C1p3Xc0RC5j9O+Cjwpd28/ws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ckAxn0Pt2y0h2Lt0+FbrNqdH6Du3v4N1NoglM7MmQ3sJfy5ol4xd2jl2BHcP8sA4w
         xYvXpui1Y4e6m6f5ofe+Dqwv9Kgy1Tb0f4wmI1lnsfE4lt8DfSAGR8lMRK8FR0h7Ul
         fLU/rFawQBFiJRPnQ7K/QDpubI/U2bqdjnqt8ot8=
Date:   Sat, 14 Nov 2020 12:45:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Christophe ROULLIER <christophe.roullier@st.com>
Subject: Re: [PATCH net 1/1] net: stmmac: Use rtnl_lock/unlock on
 netif_set_real_num_rx_queues() call
Message-ID: <20201114124506.13847db4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112144948.3042-1-vee.khee.wong@intel.com>
References: <20201112144948.3042-1-vee.khee.wong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 22:49:48 +0800 Wong Vee Khee wrote:
> Fix an issue where dump stack is printed on suspend resume flow due to
> netif_set_real_num_rx_queues() is not called with rtnl_lock held().
> 
> Fixes: 686cff3d7022 ("net: stmmac: Fix incorrect location to set real_num_rx|tx_queues")
> Reported-by: Christophe ROULLIER <christophe.roullier@st.com>
> Tested-by: Christophe ROULLIER <christophe.roullier@st.com>
> Cc: Alexandre TORGUE <alexandre.torgue@st.com>
> Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index ba855465a2db..33e280040000 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5278,7 +5278,10 @@ int stmmac_resume(struct device *dev)
>  
>  	stmmac_clear_descriptors(priv);
>  
> +	rtnl_lock();
>  	stmmac_hw_setup(ndev, false);
> +	rtnl_unlock();
> +
>  	stmmac_init_coalesce(priv);
>  	stmmac_set_rx_mode(ndev);
>  

Doesn't look quite right. This is under the priv->lock which is
sometimes taken under rtnl_lock. So theoretically there could be
a deadlock.

You should probably take rtnl_lock() before priv->lock and release 
it after. It's pretty common for drivers to hold rtnl_lock around 
most of the resume method.

With larger context:
 

        mutex_lock(&priv->lock);
 
        stmmac_reset_queues_param(priv);
 
        stmmac_clear_descriptors(priv);
 
+       rtnl_lock();
        stmmac_hw_setup(ndev, false);
+       rtnl_unlock();
+
        stmmac_init_coalesce(priv);
        stmmac_set_rx_mode(ndev);
 
        stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
 
        stmmac_enable_all_queues(priv);
 
        mutex_unlock(&priv->lock);
 
