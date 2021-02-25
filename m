Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4CF3259D3
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 23:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhBYWxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 17:53:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhBYWxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 17:53:06 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFPUZ-008TfO-PY; Thu, 25 Feb 2021 23:52:19 +0100
Date:   Thu, 25 Feb 2021 23:52:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 3/6] net: enetc: take the MDIO lock only once per
 NAPI poll cycle
Message-ID: <YDgqI8eGDpJKxiLY@lunn.ch>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225121835.3864036-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 02:18:32PM +0200, Vladimir Oltean wrote:
> @@ -327,8 +329,8 @@ static void enetc_get_tx_tstamp(struct enetc_hw *hw, union enetc_tx_bd *txbd,
>  {
>  	u32 lo, hi, tstamp_lo;
>  
> -	lo = enetc_rd(hw, ENETC_SICTR0);
> -	hi = enetc_rd(hw, ENETC_SICTR1);
> +	lo = enetc_rd_hot(hw, ENETC_SICTR0);
> +	hi = enetc_rd_hot(hw, ENETC_SICTR1);
>  	tstamp_lo = le32_to_cpu(txbd->wb.tstamp);
>  	if (lo <= tstamp_lo)
>  		hi -= 1;

Hi Vladimir

This change is not obvious, and there is no mention of it in the
commit message. Please could you explain it. I guess it is to do with
enetc_get_tx_tstamp() being called with the MDIO lock held now, when
it was not before?

Thanks
	Andrew
