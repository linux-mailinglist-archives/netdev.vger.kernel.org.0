Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636661D249D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgENBUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:20:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59330 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgENBUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2LZY55O6zVcp3oG05Y3uMwkk+MYsChTkwRYC0/wutG4=; b=WTGqB+RAk2U8k+ONdDcMfjDpmL
        hHvM43wa8a+VactWb2Q2kwz5Q7cotVFlxoM1b2MnJrDbrZ3qDSqIU2zQT+4LTriWX0HrwDEVqyXeC
        t+GGiQct2mlcFfm8wSO1WY6iOTuJOYEnW1Yl/TiPH6HWUJCa+29cxDm6ltfbjcw836OU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ2XV-002Elp-Mr; Thu, 14 May 2020 03:19:57 +0200
Date:   Thu, 14 May 2020 03:19:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 10/19] net: ks8851: Factor out bus lock handling
Message-ID: <20200514011957.GF527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-11-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-11-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:38AM +0200, Marek Vasut wrote:
> Pull out bus access locking code into separate functions, this is done
> in preparation for unifying the driver with the parallel bus one. The
> parallel bus driver does not need heavy mutex locking of the bus and
> works better with spinlocks, hence prepare these locking functions to
> be overridden then.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

  
> +/**
> + * ks8851_lock - register access lock
> + * @ks: The chip state
> + * @flags: Spinlock flags
> + *
> + * Claim chip register access lock
> + */
> +static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
> +{
> +	mutex_lock(&ks->lock);
> +}

Do you actually need flags? It is for spin_lock_irqsave().  Which you
use when you have a critical section inside an interrupt handler. But
a mutex cannot protect against an interrupt handler. So there should
be no need to use spin_lock_irqsave(), spin_lock() should be enough,
and that does not need flags.

   Andrew
