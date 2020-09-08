Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4FE2623BC
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIHXuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIHXu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:50:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B79C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 16:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tzxQCfQw6MkjyMwzvGXs3WKgWbihaUJBAEkJ7OiTrKM=; b=DuM/6I+dod6y3Hne6zr0LKiUT
        93HwCke1Itt2JvJpL0JNeqHeEEuH6fl6idvekSfHIpM1JZZXhG0GODqvabHqHB2CjeFrv5CthfAkm
        b9Kze00J3EmsnbJHESy7gEVvk9KOlsHpNIjDkZjVFm7DjWbQIkIRaxiydcWWRgRSwaJaQzqoSYHzQ
        KpmG9KhB1/g8rbRxlugEZ7xCnF8oV/vbfIQwnUWLC6Z93pJlRgLH0FOnuQGo5ncRxM8YFFTz+QMeh
        wnHMAP0uKsMdEQGeJ0Rue01YMnbod4oME9N7cbdRCZBZzdBScpMj1yx1sk93tWE9C3PcLmq3WdJKi
        revVWlTBw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32938)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kFnNV-0004Hj-3b; Wed, 09 Sep 2020 00:50:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kFnNQ-0005rx-RR; Wed, 09 Sep 2020 00:50:16 +0100
Date:   Wed, 9 Sep 2020 00:50:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 7/7] net: mvpp2: ptp: add support for
 transmit timestamping
Message-ID: <20200908235016.GA1551@shell.armlinux.org.uk>
References: <20200908214727.GZ1551@shell.armlinux.org.uk>
 <E1kFlfN-0006di-Pu@rmk-PC.armlinux.org.uk>
 <20200908234052.GA11215@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908234052.GA11215@hoboy>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 04:40:52PM -0700, Richard Cochran wrote:
> On Tue, Sep 08, 2020 at 11:00:41PM +0100, Russell King wrote:
> 
> > @@ -2984,13 +2985,19 @@ static irqreturn_t mvpp2_isr(int irq, void *dev_id)
> >  
> >  static void mvpp2_isr_handle_ptp_queue(struct mvpp2_port *port, int nq)
> >  {
> > +	struct skb_shared_hwtstamps shhwtstamps;
> > +	struct mvpp2_hwtstamp_queue *queue;
> > +	struct sk_buff *skb;
> >  	void __iomem *ptp_q;
> > +	unsigned int id;
> >  	u32 r0, r1, r2;
> >  
> >  	ptp_q = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
> >  	if (nq)
> >  		ptp_q += MVPP22_PTP_TX_Q1_R0 - MVPP22_PTP_TX_Q0_R0;
> >  
> > +	queue = &port->tx_hwtstamp_queue[nq];
> > +
> >  	while (1) {
> >  		r0 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R0) & 0xffff;
> >  		if (!r0)
> > @@ -2998,6 +3005,19 @@ static void mvpp2_isr_handle_ptp_queue(struct mvpp2_port *port, int nq)
> >  
> >  		r1 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R1) & 0xffff;
> >  		r2 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R2) & 0xffff;
> > +
> > +		id = (r0 >> 1) & 31;
> > +
> > +		skb = queue->skb[id];
> > +		queue->skb[id] = NULL;
> > +		if (skb) {
> > +			u32 ts = r2 << 19 | r1 << 3 | r0 >> 13;
> > +
> > +			netdev_info(port->dev, "tx stamp 0x%08x\n", ts);
> 
> This probably should be _debug instead.

It shouldn't be there; one of the problems of juggling patches between
trees is that things sometimes get fixed in one tree but not in the
"main" tree... will fix.  This also should've been combined with patch
6.

Anything else on any of the patches, so we don't have to continue doing
this one comment at a time?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
