Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F763D6849
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhGZUJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:09:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46244 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhGZUJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 16:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rtibfudRO0hjjDrmT4vuOpKTLXLMMclz0vvJ18yEoQE=; b=b0ibxKJnxw5CkMwmWpgCaoDQS0
        orDlmxifEw7f3A5GlYybKrxoj7r7IWa0FS/vXZ/FNF7mTK8vK5AWl3kUDJKKoNo8o1ot+OSmFrzdm
        rivPyloXX0fvpavpRUxFnDHPUleOIATfbUnKIuND/u23XvzLApbt+izYXgCIHb97Pxf4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m87Xu-00Eujn-If; Mon, 26 Jul 2021 22:49:54 +0200
Date:   Mon, 26 Jul 2021 22:49:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] tsnep: Add TSN endpoint Ethernet MAC driver
Message-ID: <YP8f8lXieL+Ld1eW@lunn.ch>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726194603.14671-5-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gerhard

> +int tsnep_read_md(struct tsnep_adapter *adapter, int phy, int reg, u16 *data)
> +{
> +	u32 md;
> +	int retval = 0;
> +
> +	if (mutex_lock_interruptible(&adapter->md_lock) != 0)
> +		return -ERESTARTSYS;

This probably means you have something wrong with your architecture.
The core mdio layer will serialise access to the mdio bus. So you
should not need such locks.

> +int tsnep_enable_loopback(struct tsnep_adapter *adapter, int speed)
> +{
> +	int phy_address = adapter->phydev->mdio.addr;
> +	u16 val;
> +	int retval;
> +
> +	adapter->loopback = true;
> +	adapter->loopback_speed = speed;
> +
> +	retval = tsnep_read_md(adapter, phy_address, MII_BMCR, &val);

And this might be why you have these locks?

A MAC driver should never directly touch the PHY hardware. Use the
phy_loopback(phydev) call.

	Andrew
