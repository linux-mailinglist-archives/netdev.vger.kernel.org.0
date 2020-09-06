Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39BD25F06E
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 22:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgIFUEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 16:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgIFUEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 16:04:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41055C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 13:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NWjVhEYJHR6eXZGyNbZ12mYT/aWcCGDpg3Gt/+f9OYE=; b=c2fqv1NKTqI1QKgVv/+CL5r58
        EEYoK6R/6gNEI3DNXK04T8hxDgAEIHhH4AHnur1YSJv9zYwg6e7905zINbDnQAVEl8cmqSk8QtMBm
        3GUH4d8aYTfzfTZBBfnJQnA68TweaM31Oiq5MDMsG59fxQdCfoer9kzrMwQx4b4mXhxezRYAIhi1d
        iUwXcZVd15giG29Vb3szLgIIkoD+51O6SZ1cezyxToN9eIG+4ltzZax8hHN2qZod4eHjTuQHWuulo
        DctkXs8ULvxPtg2TN20w1U4nMXNmIQ/DwJlMKUu5c2VC/DHQrLWYKpaWqf0I7GS0CQ3nh3Mf2YB6g
        BbRKb6DEA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32862)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kF0tT-0001UF-TU; Sun, 06 Sep 2020 21:04:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kF0tO-0003t1-NO; Sun, 06 Sep 2020 21:04:02 +0100
Date:   Sun, 6 Sep 2020 21:04:02 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/6] net: mvpp2: ptp: add TAI support
Message-ID: <20200906200402.GX1551@shell.armlinux.org.uk>
References: <20200904072828.GQ1551@shell.armlinux.org.uk>
 <E1kE6A3-00057k-8t@rmk-PC.armlinux.org.uk>
 <20200905170258.GA30943@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905170258.GA30943@hoboy>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 10:02:58AM -0700, Richard Cochran wrote:
> On Fri, Sep 04, 2020 at 08:29:27AM +0100, Russell King wrote:
> > Add support for the TAI block in the mvpp2.2 hardware.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> 
> A few minor questions/comments follow...
> 
> > diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> > index ef4f35ba077d..a599e44a36a8 100644
> > --- a/drivers/net/ethernet/marvell/Kconfig
> > +++ b/drivers/net/ethernet/marvell/Kconfig
> > @@ -92,6 +92,12 @@ config MVPP2
> >  	  This driver supports the network interface units in the
> >  	  Marvell ARMADA 375, 7K and 8K SoCs.
> >  
> > +config MVPP2_PTP
> > +	bool "Marvell Armada 8K Enable PTP support"
> > +	depends on NETWORK_PHY_TIMESTAMPING
> > +	depends on (PTP_1588_CLOCK = y && MVPP2 = y) || \
> > +		   (PTP_1588_CLOCK && MVPP2 = m)
> 
> So I guess this incantation obviates the need for checking whether
> ptp_clock_register() returns null?

There's no point offering the option if the result isn't going to be
functional.

> > +static long mvpp22_tai_aux_work(struct ptp_clock_info *ptp)
> > +{
> > +	return 0;
> > +}
> 
> Since this is a noop, you can leave 
> 	tai->caps.do_aux_work = mvpp22_tai_aux_work;
> as null.

Ok.

> > +static void mvpp22_tai_set_step(struct mvpp2_tai *tai)
> > +{
> > +	void __iomem *base = tai->base;
> > +	u32 nano, frac;
> > +
> > +	nano = upper_32_bits(tai->period);
> > +	frac = lower_32_bits(tai->period);
> > +
> > +	/* As the fractional nanosecond is a signed offset, if the MSB (sign)
> > +	 * bit is set, we have to increment the whole nanoseconds.
> > +	 */
> > +	if (frac >= 0x80000000)
> > +		nano += 1;
> > +
> > +	mvpp2_tai_write(nano, base + MVPP22_TAI_TOD_STEP_NANO_CR);
> > +	mvpp2_tai_write(frac >> 16, base + MVPP22_TAI_TOD_STEP_FRAC_HIGH);
> > +	mvpp2_tai_write(frac, base + MVPP22_TAI_TOD_STEP_FRAC_LOW);
> > +}
> > +
> > +static void mvpp22_tai_set_tod(struct mvpp2_tai *tai)
> > +{
> > +	struct timespec64 now;
> > +
> > +	ktime_get_real_ts64(&now);
> > +	mvpp22_tai_settime64(&tai->caps, &now);
> > +}
> > +
> > +static void mvpp22_tai_init(struct mvpp2_tai *tai)
> > +{
> > +	void __iomem *base = tai->base;
> > +
> > +	mvpp22_tai_set_step(tai);
> > +
> > +	/* Release the TAI reset */
> > +	mvpp2_tai_modify(base + MVPP22_TAI_CR0, CR0_SW_NRESET, CR0_SW_NRESET);
> > +
> > +	mvpp22_tai_set_tod(tai);
> 
> The consensus on the list seems to be that new PHCs should start
> ticking from time zero (1970), although some older drivers do use
> ktime.  For new clocks, I'd prefer using zero.

Ok.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
