Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB261376CEA
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhEGWrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhEGWr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 18:47:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B417160FDC;
        Fri,  7 May 2021 22:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620427586;
        bh=iNUlywIIsXPvy+R138QnRgbKwIc6HeLDnARtMppsCdk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pLh2r/wqJuH7V3hmGogEgzgnDMPA0DYm9AewC0QhoOyPJL1m2h3Ld9+dTEf7Q6Zah
         mdUBjvcuAZ5jGuULiHw4bD60pv/AV6Fw1OMWogEz2lOCrCl7wyLWBWmTeKMq2nraYs
         uEgNA7v5Jb3J3FlMIC+ASqeXbZpuwplMZCXULKrLzsio+Q8uQ4DT01pKyxlLD/JBLg
         ISH9mSG8Qqe8FHh6SG5lrzyZpC4MOvt7Cp43EXtMpdumVze2cU6EoMoJzAHNky7hhv
         SGberu7+Po/sxyk5jmQwCfUrmTfYMKa7aMwUJ7pyk31Dh/bDMkdkM/LAmaDT39STnj
         JqfyUCGkOumEQ==
Date:   Fri, 7 May 2021 15:46:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V4 net] net: stmmac: Fix MAC WoL not working if PHY does
 not support WoL
Message-ID: <20210507154624.31186614@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB6795107C0B25B2E199FE0A0EE6579@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210506050658.9624-1-qiangqing.zhang@nxp.com>
        <20210506175522.49a2ad5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6795107C0B25B2E199FE0A0EE6579@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 May 2021 10:59:12 +0000 Joakim Zhang wrote:
> > On Thu,  6 May 2021 13:06:58 +0800 Joakim Zhang wrote:  
> > > Both get and set WoL will check device_can_wakeup(), if MAC supports
> > > PMT, it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
> > > stmmac: Support WOL with phy"), device wakeup capability will be
> > > overwrite in stmmac_init_phy() according to phy's Wol feature. If phy
> > > doesn't support WoL, then MAC will lose wakeup capability.  
> > 
> > Let's take a step back. Can we get a minimal fix for losing the config in
> > stmmac_init_phy(), and then extend the support for WoL for devices which do
> > support wake up themselves?  
> 
> Sure, please review the V1, I think this is a minimal fix, then we
> can extend this as a new feature.
> https://www.spinics.net/lists/netdev/msg733531.html

Something like that, yes (you can pull the get_wol call into the same
if block).

Andrew, would that be acceptable to you? As limited as the either/or
approach is it should not break any existing users, and the fix needs
to go to longterm 5.10. We could make the improvements in net-next?

> > >  static int stmmac_set_wol(struct net_device *dev, struct
> > > ethtool_wolinfo *wol)  {
> > > +	u32 support = WAKE_MAGIC | WAKE_UCAST | WAKE_MAGICSECURE |
> > > +WAKE_BCAST;  
> > 
> > Why this list?  
> 
> Please see comments from Andrew: https://lore.kernel.org/netdev/YIgBJQi1H+f2VGWf@lunn.ch/T/#m00f11a84c1c43b3b4047dffcdfce57d534565a96
> "What PHYs do implement is WAKE_MAGIC, WAKE_MAGICSEC, WAKE_UCAST, and WAKE_BCAST. So there is a clear overlap with what the MAC can do."
> 
> So this list is cover all the WoL sources both PHY and STMMAC.

I don't think that's what Andrew meant, although again, I'm not 100%
sure of expected WoL semantics.


