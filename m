Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560BB433A7A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhJSPeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:34:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhJSPeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=z8BL/0+dJumsZiNiOfF9e5CmSkrMWw8g5VfhkDAHdKg=; b=1jpucm7pWi3VLrT8O2rwvoTjNy
        nVJYwmLyzWjJqyjDhR9Ue9f74ODqhjPhy34Erlwcrw0wQ5Io/NlRKSoLWgCx0pWO1gZJYrClirNfi
        bL7Vz6PbySthe2OgUDqRJog+sIsFGuBaHzqiKwyS/zFB0wD2KJL+M3/fhJQMKjsACIBg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcr5k-00B5cd-4F; Tue, 19 Oct 2021 17:31:52 +0200
Date:   Tue, 19 Oct 2021 17:31:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
Message-ID: <YW7k6JVh5LxMNP98@lunn.ch>
References: <20211018183709.124744-1-erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018183709.124744-1-erik@kryo.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 08:37:08PM +0200, Erik Ekman wrote:
> These modes were added to ethtool.h in 5711a98221443 ("net: ethtool: add support
> for 1000BaseX and missing 10G link modes") back in 2016.
> 
> Only setting CR mode for 10G, similar to how 25/40/50/100G modes are set up.
> 
> Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 SFP module.

Did you test with a Copper SFP modules? 

> +++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
> @@ -133,9 +133,9 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
>  	case MC_CMD_MEDIA_QSFP_PLUS:
>  		SET_BIT(FIBRE);
>  		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
> -			SET_BIT(1000baseT_Full);
> +			SET_BIT(1000baseX_Full);

I'm wondering if you should have both? The MAC is doing 1000BaseX. But
it could then be connected to a copper PHY which then does
1000baseT_Full? At 1G, it is however more likely to be using SGMII,
not 1000BaseX.

    Andrew
