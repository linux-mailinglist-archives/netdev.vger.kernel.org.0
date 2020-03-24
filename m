Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65044190353
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCXBaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:30:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgCXBaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZQkqlmlfZE1RpGe3iGDC+9gadkPvO2+JvsgsVdqc7fs=; b=EnYPsIK5+338uuzams2xr0udxJ
        7UGFVzfiAH03+szFJpZr5JJI3F96hRFNvm3Lxy7wqJ0hu11Etyb7WSZ43M3TPPYIkAmpPV56QTD2+
        vT2oEGEQBQnQTzuCpG9dECYqlZFDHofwsjApZxQG6LcIZGa4iXK19D8tf8aQjZULCOSo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGYOy-0005VS-8b; Tue, 24 Mar 2020 02:30:44 +0100
Date:   Tue, 24 Mar 2020 02:30:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 06/14] net: ks8851: Remove ks8851_rdreg32()
Message-ID: <20200324013044.GM3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-7-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-7-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -527,9 +507,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>  	 */
>  
>  	for (; rxfc != 0; rxfc--) {
> -		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
> -		rxstat = rxh & 0xffff;
> -		rxlen = (rxh >> 16) & 0xfff;
> +		rxstat = ks8851_rdreg16(ks, KS_RXFHSR);
> +		rxlen = ks8851_rdreg16(ks, KS_RXFHBCR) & RXFHBCR_CNT_MASK;

Hi Marek

Is there anything in the datasheet about these registers? Does reading
them clear an interrupt etc? A 32bit read is i assume one SPI
transaction, where as this is now two transactions, so no longer
atomic.

	Andrew
