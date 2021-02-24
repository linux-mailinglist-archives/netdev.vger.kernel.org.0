Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9632357F
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhBXBz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhBXBz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 20:55:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57AD564E79;
        Wed, 24 Feb 2021 01:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614131685;
        bh=G8VdbnYG7aAJnzxjHn38Nz6vM58fbXrCYWbN+jURd4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o67u0voLEY41COBFpFg0/4fOilCHPPhlZeCTvu6EAMxngTmIPYI8tc3cDZ5AfiAJd
         UCw/UZOJ1A1Kcp9ojeuu2JBRW/5q85bQzfTGDf7Fo0HKfBGHPogZ1QclBuVF/COcwo
         xuLQ19n8c0PoBukWedrvntezbKgswBbGH//Rxd8kMqd5wYsx9+j/y5D2I3nzXanSVa
         lhNDH8yrHAnaramSn+F3GOWqe90zgOQFZM4KpqRBO0wkq6XCs8wOKz5aCTKBhJcK0s
         f97CpKC/KjLEK7Up1UpHCmHA3+SlTcdvEmGOny4EzpIJJx1+E9mYVWOMngTNkZ1+Md
         /tkXp2AZ9k2Bg==
Date:   Tue, 23 Feb 2021 17:54:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Message-ID: <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
        <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 01:45:40 +0000 Joakim Zhang wrote:
> > I'm not an expert on this stuff, but is there a reason you're not integrating this
> > functionality with the power management subsystem?  
> 
> Do you mean that implement runtime power management for driver? If
> yes, I think that is another feature, we can support later.

Runtime is a strong word, IIUC you can just implement the PM callbacks,
and always resume in .open and always suspend in .close. Pretty much
what you have already.

> > I don't think it'd change the functionality, but it'd feel more idiomatic to fit in
> > the standard Linux framework.  
> 
> Yes, there is no functionality change, this patch set just adds clocks management.
> In the driver now, we manage clocks at two point side:
> 1. enable clocks when probe driver, disable clocks when remove driver.
> 2. disable clocks when system suspend, enable clocks when system resume back.
> 
> This should not be enough, such as, even we close the NIC, the clocks still enabled. So this patch improve below:
> Keep clocks disabled after driver probe, enable clocks when NIC up, and then disable clocks when NIC down.
> The aim is to enable clocks when it needs, others keep clocks disabled.

Understood. Please double check ethtool callbacks work fine. People
often forget about those when disabling clocks in .close.
