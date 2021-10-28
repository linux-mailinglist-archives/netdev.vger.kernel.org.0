Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661AB43E106
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJ1MdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:33:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35644 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhJ1MdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xEBKoPrmRsIIkkMzN6IAirZdQjATcebsXUv59Brc72A=; b=hbPsAgRz/N44KSKUhIjWS+PnUf
        iyLzSIw6C41F3zhgF9Xk4QINEaFK6cEfV0riqMpxGHrjRzy3Spzyv8o788FQxLKu/MZfC8Bckydrk
        sMy+rwaoSFHRNTcuXwtvImOGmzkuRlT4riDlmTvZfkcTPQvK61OT8DPlO7D8x3nam7Kg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mg4YJ-00BzVI-Jh; Thu, 28 Oct 2021 14:30:39 +0200
Date:   Thu, 28 Oct 2021 14:30:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Subject: Re: [PATCH net 1/7] net: hns3: fix pause config problem after
 autoneg disabled
Message-ID: <YXqX7z2GljD6bxTr@lunn.ch>
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
 <20211027121149.45897-2-huangguangbin2@huawei.com>
 <YXmLA4AbY83UV00f@lunn.ch>
 <09eda9fe-196b-006b-6f01-f54e75715961@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09eda9fe-196b-006b-6f01-f54e75715961@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew, thanks very much for your guidance on how to use pause autoneg,
> it confuses me before because PHY registers actually have no separate setting
> bit of pause autoneg.
> 
> So, summarize what you mean:
> 1. If pause autoneg is on, driver should always use the autoneg result to program
>    the MAC. Eventhough general autoneg is off now and link state is no changed then
>    driver just needs to keep the last configuration for the MAC, if link state is
>    changed and phy goes down and up then driver needs to program the MAC according
>    to the autoneg result in the link_adjust callback.
> 2. If pause autoneg is off, driver should directly configure the MAC with tx pause
>    and rx pause. Eventhough general autoneg is on, driver should ignore the autoneg
>    result.
> 
> Do I understand right?

Yes, that fits my understanding of ethtool, etc.

phylink tried to clear up some of these problems by fully implementing
the call within phylink. All the MAC driver needs to provide is a
method to configure the MAC pause settings. Take a look at
phylink_ethtool_set_pauseparam() and the commit messages related to
that.

	Andrew
