Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481BA4A99BA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347768AbiBDNKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:10:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350855AbiBDNKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 08:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=m/MrXXUY+pm7JMmWqQaE3QjF0Fdquw4zZVFebHs+qNA=; b=K9FBiz1rW7KFXn2u1g2RmQPdk1
        mmGrXOgMpt90Ui02kl5EiT056Cs2a1UWVaiNDw95JAvNsQw/Yrkgtps4YmL+PQknW+2ZZc5R4WNRw
        CZDlnNncbZr7/Zad6s7D8FzlbaabjNmkAYXe2qBd7U/e+o8ZDd51yDl5BNP7Ce50IU8o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFyMC-004Gpv-W4; Fri, 04 Feb 2022 14:10:32 +0100
Date:   Fri, 4 Feb 2022 14:10:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel.Parkhomenko@baikalelectronics.ru
Cc:     michael@stapelberg.de, afleming@gmail.com, f.fainelli@gmail.com,
        Alexey.Malahov@baikalelectronics.ru,
        Sergey.Semin@baikalelectronics.ru, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Message-ID: <Yf0lyGi+2mEwmrEH@lunn.ch>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 05:29:11AM +0000, Pavel.Parkhomenko@baikalelectronics.ru wrote:
> It is mandatory for a software to issue a reset upon modifying RGMII
> Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
> Specific Control register 2 (page 2, register 21) otherwise the changes
> won't be perceived by the PHY (the same is applicable for a lot of other
> registers). Not setting the RGMII delays on the platforms that imply
> it's being done on the PHY side will consequently cause the traffic loss.
> We discovered that the denoted soft-reset is missing in the
> m88e1121_config_aneg() method for the case if the RGMII delays are
> modified but the MDIx polarity isn't changed or the auto-negotiation is
> left enabled, thus causing the traffic loss on our platform with Marvell
> Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
> delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
> method.

Hi Pavel

There appears to be another path which has the same issue.

m88e1118_config_aneg() calls marvell_set_polarity(), which also needs
a reset afterwards.

Could you fix this case as well?

Thanks
	Andrew
