Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02D9203781
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgFVNJM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 09:09:12 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:51871 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgFVNJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:09:09 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 2DAA324001A;
        Mon, 22 Jun 2020 13:09:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200620150045.GA2054@localhost>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com> <20200619122300.2510533-7-antoine.tenart@bootlin.com> <20200620150045.GA2054@localhost>
Subject: Re: [PATCH net-next v3 6/8] net: phy: mscc: timestamping and PHC support
To:     Richard Cochran <richardcochran@gmail.com>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Message-ID: <159283134527.1456598.6263985916427354928@kwain>
Date:   Mon, 22 Jun 2020 15:09:05 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Richard,

Quoting Richard Cochran (2020-06-20 17:00:45)
> On Fri, Jun 19, 2020 at 02:22:58PM +0200, Antoine Tenart wrote:
> 
> > +static void vsc85xx_dequeue_skb(struct vsc85xx_ptp *ptp)
> > +{
> > +     struct skb_shared_hwtstamps shhwtstamps;
> > +     struct vsc85xx_ts_fifo fifo;
> > +     struct sk_buff *skb;
> > +     u8 skb_sig[16], *p;
> > +     int i, len;
> > +     u32 reg;
> > +
> > +     memset(&fifo, 0, sizeof(fifo));
> > +     p = (u8 *)&fifo;
> > +
> > +     reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> > +                               MSCC_PHY_PTP_EGR_TS_FIFO(0));
> > +     if (reg & PTP_EGR_TS_FIFO_EMPTY)
> > +             return;
> > +
> > +     *p++ = reg & 0xff;
> > +     *p++ = (reg >> 8) & 0xff;
> > +
> > +     /* Read the current FIFO item. Reading FIFO6 pops the next one. */
> > +     for (i = 1; i < 7; i++) {
> > +             reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> > +                                       MSCC_PHY_PTP_EGR_TS_FIFO(i));
> > +             *p++ = reg & 0xff;
> > +             *p++ = (reg >> 8) & 0xff;
> > +             *p++ = (reg >> 16) & 0xff;
> > +             *p++ = (reg >> 24) & 0xff;
> > +     }
> > +
> > +     len = skb_queue_len(&ptp->tx_queue);
> > +     if (len < 1)
> > +             return;
> > +
> > +     while (len--) {
> > +             skb = __skb_dequeue(&ptp->tx_queue);
> > +             if (!skb)
> > +                     return;
> > +
> > +             /* Can't get the signature of the packet, won't ever
> > +              * be able to have one so let's dequeue the packet.
> > +              */
> > +             if (get_sig(skb, skb_sig) < 0)
> > +                     continue;
> 
> This leaks the skb.

That's right, thanks for pointing this out! I'll fix it.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
