Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A4E47D008
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 11:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240027AbhLVKdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 05:33:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235010AbhLVKdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 05:33:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xYtVTpFLANuyEreGcyCThYd0/DjFBaWJOZv528qxb/s=; b=MQ/IjFXjizC+w3Qd9Xq2XjriqR
        lRT5hexcBVId0bRna/6UZLKV8RIyJDijpCwq07E0+Hfr0pq9ysnWy1ahU7lJOz44nj6gCBJZOq9pt
        CWxoZQkPu16ZxZLJWb0tgtznaSMldRlBozDcUGULBAXYDSGwkIuM8Ch6VSyiadPZzYDE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzyw9-00HDnP-FI; Wed, 22 Dec 2021 11:33:33 +0100
Date:   Wed, 22 Dec 2021 11:33:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Kegl Rohit <keglrohit@gmail.com>, netdev <netdev@vger.kernel.org>
Subject: Re: net: fec: memory corruption caused by err_enet_mii_probe error
 path
Message-ID: <YcL+/V9ce46fZwyS@lunn.ch>
References: <CAMeyCbj93LvTu9RjVXD+NcT0JYoA42BC7pSHumtNJfniSobAqA@mail.gmail.com>
 <DB8PR04MB679571AF60C377BB1242D26BE67D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB679571AF60C377BB1242D26BE67D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > err_enet_mii_probe:
> > fec_enet_free_buffers(ndev);
> > err_enet_alloc:
> > fec_enet_clk_enable(ndev, false);
> > clk_enable:
> > pm_runtime_mark_last_busy(&fep->pdev->dev);
> > pm_runtime_put_autosuspend(&fep->pdev->dev);
> > pinctrl_pm_select_sleep_state(&fep->pdev->dev);
> > return ret;
> > 
> > This error path frees the DMA buffers, BUT as far I could see it does not stop
> > the DMA engines.
> > => open() fails => frees buffers => DMA still active => MAC receives network
> > packet => DMA starts => random memory corruption (use after
> > free) => random kernel panics

> A question here, why receive path still active? MAC has not
> connected to PHY when this failure happened, should not see network
> activities.

Not every system has a PHY. There are plenty of boards with the FEC
directly connected to an Ethernet switch. So packets could be flowing.

	 Andrew
