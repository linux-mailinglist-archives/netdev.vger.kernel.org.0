Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECF143CF9B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbhJ0RZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:25:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232329AbhJ0RZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 13:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xYqWqnNTYblorxJSKWICYNXuprkqD63Vt4PUk5Lzeb8=; b=AMVbIQmqzSTQvatVfYwNEWu09n
        Jgp2AnaAirNSQIxo0sjtKDPHBFV2osLPss77sgQjhAoJFrnqEWz/dTMDxIp/MYP+8adCg5ezAygNY
        ff2rfKXC04DoiVdD7pnT7V8Uy7CZAb7OeAUHMpL8+nR0GJYDvrwa00lX/0lRUCTQnNpI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfmdv-00Bv5N-EP; Wed, 27 Oct 2021 19:23:15 +0200
Date:   Wed, 27 Oct 2021 19:23:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Subject: Re: [PATCH net 1/7] net: hns3: fix pause config problem after
 autoneg disabled
Message-ID: <YXmLA4AbY83UV00f@lunn.ch>
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
 <20211027121149.45897-2-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027121149.45897-2-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 08:11:43PM +0800, Guangbin Huang wrote:

The semantics are not too well defined here, the ethtool documentation
is not too clear. Here is how i interpret it.

> If a TP port is configured by follow steps:
> 1.ethtool -s ethx autoneg off speed 100 duplex full

So you turn general autoneg off

> 2.ethtool -A ethx rx on tx on

You did not use autoneg off here. Pause autoneg is separate to general
autoneg. So pause autoneg is still enabled at this point. That means
you should not directly configure the MAC with the pause
configuration, you only do that when pause autoneg is off. You can
consider this as setting how you want pause to be negotiated once
general autoneg is re-enabled.

> 3.ethtool -s ethx autoneg on(rx&tx negotiated pause results are off)

So you reenable general autoneg. As part of that general autoneg,
pause will re-renegotiated, and it should you the preferences you set
in 2, that rx and tx pause can be used. What is actually used depends
on the link peer. The link_adjust callback from phylib tells you how
to program the MAC.

> 4.ethtool -s ethx autoneg off speed 100 duplex full

So you turn general autoneg off again. It is unclear how you are
supposed to program the MAC, but i guess most systems keep with the
result from the last autoneg.

Looking at your patch, there are suspicious calls to phy_syspend and
phy_resume. They don't look correct at all, and i'm not aware of any
other MAC driver doing this. Now, i know the behaviour is not well
defined here, but i'm not sure your interpretation is valid and how
others interpret it.

       Andrew
