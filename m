Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC55D126E7A
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLSULX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:11:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41480 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfLSULX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 15:11:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3EA1153A024B;
        Thu, 19 Dec 2019 12:11:19 -0800 (PST)
Date:   Thu, 19 Dec 2019 12:11:17 -0800 (PST)
Message-Id: <20191219.121117.1826219046339114907.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v4 08/15] net: phy: mscc: macsec initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191219105515.78400-9-antoine.tenart@bootlin.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
        <20191219105515.78400-9-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 12:11:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Thu, 19 Dec 2019 11:55:08 +0100

> +static u32 __vsc8584_macsec_phy_read(struct phy_device *phydev,
> +				     enum macsec_bank bank, u32 reg, bool init)
> +{
> +	u32 val, val_l = 0, val_h = 0;
> +	unsigned long deadline;
> +	int rc;
> +
> +	if (!init) {
> +		rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
> +		if (rc < 0)
> +			goto failed;
> +	} else {
> +		__phy_write_page(phydev, MSCC_PHY_PAGE_MACSEC);
> +	}

Having to export __phy_write_page() in the previous patch looked like
a huge red flag to me, and indeed on top of it you're using it to do
conditional locking here.

I'm going to unfortunately have to push back on this, please sanitize
the locking here so that you can use the existing exports properly.
