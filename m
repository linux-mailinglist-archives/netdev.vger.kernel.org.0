Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660011E093A
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389232AbgEYIr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388891AbgEYIr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:47:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB997C061A0E;
        Mon, 25 May 2020 01:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aEAVGocE9wZ3VarXBFE8qCciH8rwdSc1/pmEy3uHC80=; b=e3h7fzrT5Xm6knH2AwC0CixG6
        evgVpOCBUDtRLhr06qYru8M/o/tRuRpKzEs36RXfa3bT0u9UdLDEP+vERCwUbAW30jf+WUFw13SiD
        nBuDlJzQAG4HYezjiKbDFjsBmkduFWEZxdZ3dAUEDP6StNwcs5M7CTpJRtQSdod4fiWVvbHKmel2J
        k1K5vEmHvXNTxKiO0FrvsL4Gnn75dlX6EXTsT10197jJV5WuZU4etJ9Rm0YDYAvq9HV+rnU0aJ3wl
        fI7ckARX7ZG2PKbA30oQQ1UvU4mvD0TG3viToWCSO4v6FQwnbIilQtg17tHN0L65PTAKDuJi5K7Et
        CksZ4dLNg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36714)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jd8lU-0004kc-Qc; Mon, 25 May 2020 09:47:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jd8lT-0004Do-4u; Mon, 25 May 2020 09:47:19 +0100
Date:   Mon, 25 May 2020 09:47:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        antoine.tenart@bootlin.com, linux-kernel@vger.kernel.org,
        harini.katakam@xilinx.com,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/5] net: macb: fix wakeup test in runtime
 suspend/resume routines
Message-ID: <20200525084719.GJ1551@shell.armlinux.org.uk>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
 <dc30ff1d17cb5a75ddd10966eab001f67ac744ef.1588763703.git.nicolas.ferre@microchip.com>
 <20200506131843.22cf1dab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <347c9a4f-8a01-a931-c9d5-536339337f8a@microchip.com>
 <e43e7ed6-c78a-7995-3f46-0bdbf32f361c@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e43e7ed6-c78a-7995-3f46-0bdbf32f361c@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 10:18:16AM +0200, Nicolas Ferre wrote:
> On 07/05/2020 at 12:03, Nicolas Ferre wrote:
> > On 06/05/2020 at 22:18, Jakub Kicinski wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > > 
> > > On Wed, 6 May 2020 13:37:37 +0200 nicolas.ferre@microchip.com wrote:
> > > > From: Nicolas Ferre <nicolas.ferre@microchip.com>
> > > > 
> > > > Use the proper struct device pointer to check if the wakeup flag
> > > > and wakeup source are positioned.
> > > > Use the one passed by function call which is equivalent to
> > > > &bp->dev->dev.parent.
> > > > 
> > > > It's preventing the trigger of a spurious interrupt in case the
> > > > Wake-on-Lan feature is used.
> > > > 
> > > > Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
> > > 
> > >           Fixes tag: Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
> > >           Has these problem(s):
> > >                   - Target SHA1 does not exist
> > 
> > Indeed, it's:
> > Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
> > 
> > David: do I have to respin or you can modify it?
> 
> David, all, I'm about to resend this series (alternative to "ping"),
> however:
> 
> 1/ Now that it's late in the cycle, I'd like that you tell me if I rebase on
> net-next because it isn't not sensible to queue such (non urgeent) changes
> at rc7
> 
> 2/ I didn't get answers from Russell and can't tell if there's a better way
> of handling underlying phylink error of phylink_ethtool_set_wol() in patch
> 3/5

I think you could have answered your own questions there, but I seemed
easier to send an email.  I've just read the code, typed out an
appropriate description of the code's behaviour, and then derived the
answer to your questions without anything else.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
