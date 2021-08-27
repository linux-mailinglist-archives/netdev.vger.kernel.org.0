Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9483F9EE3
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhH0Sf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:35:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229949AbhH0SfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 14:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p9+0uA7QW2TjwTeykHO0vXZiEPbw+wlJg2jCq+WlrEU=; b=SsZxscbbbBZCnZ+FRzC35heNvf
        nwcgmPLtRGPOL7xPh9gUmD8MszC1X8aWpIF5TRXGmqe6/rZplmSFXqmWwK158fmbLYQUicdYkK1Ez
        kOTjOWszBNFbnkmo2ghA09/KCowNN+0ioiHQVsQa4jOKXiIUnKd5bxGARi6w358OhBOs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJggT-0049kq-Rr; Fri, 27 Aug 2021 20:34:33 +0200
Date:   Fri, 27 Aug 2021 20:34:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: stop calling
 irq_domain_add_simple with the reg_lock held
Message-ID: <YSkwOWoynVOs5i8n@lunn.ch>
References: <20210827180101.2330929-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827180101.2330929-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 09:01:01PM +0300, Vladimir Oltean wrote:
> The mv88e6xxx IRQ setup code has some pretty horrible locking patterns,
> and wrong.

I agree about the patterns. But it has been lockdep clean, i spent a
while testing it, failed probes, unloads etc, and adding comments.

I suspect it is now wrong because of core changes.

> Only hardware access should need the register lock, and this in itself
> is for the mv88e6xxx_smi_indirect_ops to work properly and nothing more,
> unless I'm misunderstanding something

Historically, reg_lock has been used to serialize all access to the
hardware across entries points into the driver. Not everything takes
rtnl lock. Clearly, interrupts don't. I don't know if PTP takes it. In
the past there was been hwmon code, etc. The reg_lock is used to
serialize all this. The patterns of all entry points into the driver
taking the lock has in general worked well. Just interrupt code is a
pain.

> Fixes: dc30c35be720 ("net: dsa: mv88e6xxx: Implement interrupt support.")

As i said, i suspect this is the wrong commit. You need to look at
changes to the interrupt core. There is even a danger that if this
gets backported too far, it could add deadlocks.

	Andrew
