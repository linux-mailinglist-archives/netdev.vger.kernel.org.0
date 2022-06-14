Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FD354BC75
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354135AbiFNVDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiFNVDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:03:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C26D5046D;
        Tue, 14 Jun 2022 14:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9i5oVNLWCIu7Z+2EFkxAynfF1PQo1Qm1b9TFHuqHzHo=; b=aDFvbb+3RfPsTpIAv6vbi8yH/3
        HFxzDCfXbw7gWiarJPggiidlvBJX37d+KNTR8M5Th+zq3jVhpRwPcXUjRyNM9+ECL94F8mnoBwTv7
        aQB64vMg0LslUF/Gtu01BNG06vOnPtOZijRafMO/sfrGUkXLRbiZ7VDZsKAHXGxz4EU4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1DhK-006viX-C9; Tue, 14 Jun 2022 23:03:38 +0200
Date:   Tue, 14 Jun 2022 23:03:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        lxu@maxlinear.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 3/5] net: lan743x: Add support to SGMII block
 access functions
Message-ID: <Yqj3qpq5Ew+JT+28@lunn.ch>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
 <20220614103424.58971-4-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614103424.58971-4-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 04:04:22PM +0530, Raju Lakkaraju wrote:
> Add SGMII access read and write functions
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 69 +++++++++++++++++++
>  drivers/net/ethernet/microchip/lan743x_main.h | 12 ++++
>  2 files changed, 81 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 6352cba19691..e496769efb54 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -909,6 +909,74 @@ static int lan743x_mdiobus_c45_write(struct mii_bus *bus,
>  	return ret;
>  }
>  
> +static int lan743x_sgmii_wait_till_not_busy(struct lan743x_adapter *adapter)
> +{
> +	u32 data;
> +	int ret;
> +
> +	ret = readx_poll_timeout(LAN743X_CSR_READ_OP, SGMII_ACC, data,
> +				 !(data & SGMII_ACC_SGMII_BZY_), 100, 1000000);
> +	if (unlikely(ret < 0))

unlikely() seems pointless here. You have just done a blocking poll,
so you don't care about high performance, this is not the fast path.

   Andrew
