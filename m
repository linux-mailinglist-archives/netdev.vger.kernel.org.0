Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB452B4E5E
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbgKPRpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:45:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731712AbgKPRpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 12:45:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10D6B20B80;
        Mon, 16 Nov 2020 17:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605548739;
        bh=tQW67WaRqbqEetQTxYCnJ/yXmPFnNQVNmYTNVKmKS+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N5Cp/cvZZupZ8JgSE3HETbGgmW35MK+6KDFsi3a2eckV5fEql5j7G55cdbs6hzqIV
         RQ7XfIH+ki7GHSSCfruj9XO72u0UKzv6B7Qn6RgHW4uZOhpu5AMLWTEJC/4ScJsjcu
         y0dIL0aaJr9kfIbMDF4DNMJ6hXjwmWeezW+mXEtU=
Date:   Mon, 16 Nov 2020 09:45:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: smsc: add missed clk_disable_unprepare in
 smsc_phy_probe()
Message-ID: <20201116094538.47937d15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116092607.psaelzuga3kcrryu@pengutronix.de>
References: <1605180239-1792-1-git-send-email-zhangchangzhong@huawei.com>
        <20201114112625.440b52f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fc03d4de-14d2-1b61-ac9b-40ea26e6fa9a@gmail.com>
        <20201116092607.psaelzuga3kcrryu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 10:26:07 +0100 Marco Felsch wrote:
> > > The code right above looks highly questionable as well:
> > > 
> > >         priv->refclk = clk_get_optional(dev, NULL);
> > >         if (IS_ERR(priv->refclk))
> > >                 dev_err_probe(dev, PTR_ERR(priv->refclk), "Failed to request clock\n");
> > >  
> > >         ret = clk_prepare_enable(priv->refclk);
> > >         if (ret)
> > >                 return ret;
> > > 
> > > I don't think clk_prepare_enable() will be too happy to see an error
> > > pointer. This should probably be:
> > > 
> > >         priv->refclk = clk_get_optional(dev, NULL);
> > >         if (IS_ERR(priv->refclk))
> > >                 return dev_err_probe(dev, PTR_ERR(priv->refclk), 
> > > 				      "Failed to request clock\n");  
> > 
> > Right, especially if EPROBE_DEFER must be returned because the clock
> > provider is not ready yet, we should have a chance to do that.  
> 
> damn.. I missed the return here. Thanks for covering that. Should I send
> a fix or did you do that already?

Please do, I don't see any fix for this issue in patchwork right now.
