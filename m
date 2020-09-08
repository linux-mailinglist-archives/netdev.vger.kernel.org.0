Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA684260C43
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 09:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgIHHmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 03:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbgIHHmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 03:42:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C77C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 00:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NRtKzkbCSn8sAXnizSkfElwdclDkqq/GM44xD3NFnR4=; b=sRFRpCmCztGZbqIfkTkX28ZU+
        itk/ZI58N/OKzJHvSt5/cYdEBUlfTGU5ZKvgb73y/1xZ62EjHIlACvAmLFKOqz7vmKx7IfgKE00QE
        2AvlCMagehZgrWbO1rQuFmDvVYN0BBiEA7XdnbmISaa2VY7g9LdrTVmdqAlTmrUxInQV0IkLXqgJR
        8D9s9OuRTBuTAbwn26vmDBDpkOuM8ZHUL2FgeCKKaLk0Y1kTR8T8gTng0RwgVDhzOadPyW4an8XQZ
        7f3luL3Kr/cYvLG3t4cnlY6EIznXJz7OVZBcuAuRD+vljdKOYJvBgleDmpdo1afV4CUjlW67uU3pp
        PyiRCTY4Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32920)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kFYGP-0003Gj-VS; Tue, 08 Sep 2020 08:42:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kFYGM-0005L7-Dz; Tue, 08 Sep 2020 08:41:58 +0100
Date:   Tue, 8 Sep 2020 08:41:58 +0100
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
Message-ID: <20200908074158.GD1605@shell.armlinux.org.uk>
References: <20200904072828.GQ1551@shell.armlinux.org.uk>
 <E1kE6A3-00057k-8t@rmk-PC.armlinux.org.uk>
 <20200905170258.GA30943@hoboy>
 <20200906200402.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906200402.GX1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 06, 2020 at 09:04:02PM +0100, Russell King - ARM Linux admin wrote:
> > > +static void mvpp22_tai_set_tod(struct mvpp2_tai *tai)
> > > +{
> > > +	struct timespec64 now;
> > > +
> > > +	ktime_get_real_ts64(&now);
> > > +	mvpp22_tai_settime64(&tai->caps, &now);
> > > +}
> > > +
> > > +static void mvpp22_tai_init(struct mvpp2_tai *tai)
> > > +{
> > > +	void __iomem *base = tai->base;
> > > +
> > > +	mvpp22_tai_set_step(tai);
> > > +
> > > +	/* Release the TAI reset */
> > > +	mvpp2_tai_modify(base + MVPP22_TAI_CR0, CR0_SW_NRESET, CR0_SW_NRESET);
> > > +
> > > +	mvpp22_tai_set_tod(tai);
> > 
> > The consensus on the list seems to be that new PHCs should start
> > ticking from time zero (1970), although some older drivers do use
> > ktime.  For new clocks, I'd prefer using zero.
> 
> Ok.

Should we always set the TAI counter to zero every time the TAI is
initialised, or just leave it as is (the counter may already be set
by a previous kernel, for example when a kexec has happened).

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
