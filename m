Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94FB2F59CD
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbhANELq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbhANELp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:11:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02CEB238E2;
        Thu, 14 Jan 2021 04:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610597465;
        bh=EcXltmbDH7agC/QQ9g8sTB1INtLzRk5tXb2WEeddGSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vHl0CcQMjqieB74YQO0YRnLVCwZ/FExUmZrO2tImyB39Bj3QKNmKbll2FU+k3jwFF
         L5fe/HoRqpdvgASi4GKeuQsTwmGbu71xC/9uMe966LttBjzQ62oh5O7sguM7HrKG3Z
         CU1hQufVTsU/8qLG/y7JnYXfm1SH4wIKJdRh9s8s2Crh7ICE/Qd7VbcbbOI/cJGyfY
         VVVnctUTfGZyj83VwPuSloLivsLGwvrqlvs88E9TsjsNgZjNMC8Ena0K1McRscLQMS
         Lt/HG0MLxtSUqWvd3DLsDlt8dpN7wZP7HoxlnZDWP7sILGmhdkdUHyMHw1W2cInGMl
         QtLP1IylmXPgg==
Date:   Wed, 13 Jan 2021 20:11:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Wu <david.wu@rock-chips.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, joabreu@synopsys.com,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Fixed mtu channged by cache aligned
Message-ID: <20210113201103.721a80b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113034109.27865-1-david.wu@rock-chips.com>
References: <20210113034109.27865-1-david.wu@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 11:41:09 +0800 David Wu wrote:
> Since the original mtu is not used when the mtu is updated,
> the mtu is aligned with cache, this will get an incorrect.
> For example, if you want to configure the mtu to be 1500,
> but mtu 1536 is configured in fact.
> 
> Fixed: eaf4fac478077 ("net: stmmac: Do not accept invalid MTU values")
> Signed-off-by: David Wu <david.wu@rock-chips.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 5b1c12ff98c0..e8640123db76 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4025,7 +4025,7 @@ static void stmmac_set_rx_mode(struct net_device *dev)
>  static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
> -	int txfifosz = priv->plat->tx_fifo_size;
> +	int txfifosz = priv->plat->tx_fifo_size, mtu = new_mtu;

Adjusted the code a little here to keep the variable declaration lines
ordered longest to shortest, and applied. 

Thanks!
