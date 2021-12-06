Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4546968B
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 14:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbhLFNRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 08:17:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243988AbhLFNRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 08:17:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9uO4KL5pTTCIDm+2vC0BTtiLZ3XiNiMgVQSPhd/4Zmo=; b=t1d2mR18EGquGIuoO4KVbL3tWb
        vwncLUqPAW+GDfaiufQL/cNWIpUQsL3koghuHWzRShGiQalyg2xXFS4RRO1xMoUfacYSfeEPRjQLE
        LikUhEAXSOKoE8ASs+/OjzQIyXlPZB1z+nDTfjpMNNJ6q2WHXxm/kJe/KPDwHYCBLSYs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muDoH-00Ff6Z-DF; Mon, 06 Dec 2021 14:13:37 +0100
Date:   Mon, 6 Dec 2021 14:13:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] net: fec: make fec_reset_phy not only usable once
Message-ID: <Ya4MgQA7lqiSrWoX@lunn.ch>
References: <20211206101326.1022527-1-philippe.schenker@toradex.com>
 <20211206101326.1022527-2-philippe.schenker@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206101326.1022527-2-philippe.schenker@toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  #ifdef CONFIG_OF
> -static int fec_reset_phy(struct platform_device *pdev)
> +static int fec_reset_phy_probe(struct platform_device *pdev,
> +			       struct net_device *ndev)
>  {
> -	int err, phy_reset;
> -	bool active_high = false;
> -	int msec = 1, phy_post_delay = 0;
>  	struct device_node *np = pdev->dev.of_node;
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +	int tmp, ret;
>  
>  	if (!np)
>  		return 0;
>  
> -	err = of_property_read_u32(np, "phy-reset-duration", &msec);
> +	tmp = 1;
> +	ret = of_property_read_u32(np, "phy-reset-duration", &tmp);
>  	/* A sane reset duration should not be longer than 1s */
> -	if (!err && msec > 1000)
> -		msec = 1;
> +	if (!ret && tmp > 1000)
> +		tmp = 1;
> +
> +	fep->phy_reset_duration = tmp;

If you don't change the names msec and ret, this code would be
unchanged. It then becomes a lot easier to see you have not changed,
the code, only moved it around.

    Andrew
