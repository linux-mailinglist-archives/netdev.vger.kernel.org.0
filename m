Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3139126FE5
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfLSVpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:45:47 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40224 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLSVpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:45:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NrrT83GvuR/JbUpashKGqACiwN6b9MbvU6upd5vrNds=; b=Aws8nI23KaED39lpo/Ba5jlne
        4qhOzotycZhir6S3gMJEhVdzPP0M8gOlL9Cv0Hz/9YSibrE6rteeuYTjYKbva9zrGVL9rUNih9DK9
        +TEiljHHWIO7Lg7nVK0dy05uPthIlQ2MtJDcOKrtDuZccGhYXM4Nih3KfYLv+mr8E/1fIti74r5pJ
        6VJaLVWmflVQSjrYT65H1vfplv1fd1AzEeCqTrQ8NzeriJJckfH8NjTKJjsRDztWIJjAc+UTmsEMV
        qXbdevTq5mNzO6gpdnrHH5jdJBtxOMx6pXiHQBk8sknpFcnwsK8uf4lRX3HHRBFk3KorGgKtASx2F
        ED6Daa/7Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43586)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ii3c3-0004wy-PY; Thu, 19 Dec 2019 21:45:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ii3c1-0005hQ-Ls; Thu, 19 Dec 2019 21:45:37 +0000
Date:   Thu, 19 Dec 2019 21:45:37 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
Message-ID: <20191219214537.GF25745@shell.armlinux.org.uk>
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <20191219.125010.1105219757379875134.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219.125010.1105219757379875134.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 12:50:10PM -0800, David Miller wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Date: Tue, 17 Dec 2019 12:53:05 +0000
> 
> > phy_error() is called from phy_interrupt() or phy_state_machine(), and
> > uses WARN_ON() to print a backtrace. The backtrace is not useful when
> > reporting a PHY error.
> > 
> > However, a system may contain multiple ethernet PHYs, and phy_error()
> > gives no clue which one caused the problem.
> > 
> > Replace WARN_ON() with a call to phydev_err() so that we can see which
> > PHY had an error, and also inform the user that we are halting the PHY.
> > 
> > Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> I think I agree with Heiner that it is valuable to know whether the
> error occurred from the interrupt handler or the state machine (and
> if the state machine, where that got called from).

Would you accept, then, passing a string to indicate where phy_error()
was called from, which would do the same job without tainting the
kernel for something that becomes a _normal_ event when removing a
SFP?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
