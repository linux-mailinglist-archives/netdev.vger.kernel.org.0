Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100AC1E65F0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404376AbgE1PYA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 May 2020 11:24:00 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:38381 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404237AbgE1PX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 11:23:58 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9F4601BF207;
        Thu, 28 May 2020 15:23:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200528143440.GB14844@localhost>
References: <20200527164158.313025-1-antoine.tenart@bootlin.com> <20200527164158.313025-7-antoine.tenart@bootlin.com> <20200528143440.GB14844@localhost>
To:     Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 6/8] net: phy: mscc: timestamping and PHC support
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Message-ID: <159067943270.870467.1676119924358159280@kwain>
Date:   Thu, 28 May 2020 17:23:52 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Richard,

Quoting Richard Cochran (2020-05-28 16:34:40)
> On Wed, May 27, 2020 at 06:41:56PM +0200, Antoine Tenart wrote:
> 
> > +static struct vsc85xx_ptphdr *get_ptp_header(struct sk_buff *skb)
> > +{
> > +     struct ethhdr *ethhdr = eth_hdr(skb);
> > +     struct iphdr *iphdr = ip_hdr(skb);
> > +     struct udphdr *udphdr;
> > +     __u8 proto;
> > +
> > +     if (ethhdr->h_proto == htons(ETH_P_1588))
> > +             return (struct vsc85xx_ptphdr *)(((unsigned char *)ethhdr) +
> > +                                      skb_mac_header_len(skb));
> > +
> > +     if (ethhdr->h_proto != htons(ETH_P_IP))
> > +             return NULL;
> > +
> > +     proto = iphdr->protocol;
> > +     if (proto != IPPROTO_UDP)
> > +             return NULL;
> > +
> > +     udphdr = udp_hdr(skb);
> > +
> > +     if (udphdr->source != ntohs(PTP_EV_PORT) ||
> > +         udphdr->dest != ntohs(PTP_EV_PORT))
> > +             return NULL;
> > +
> > +     return (struct vsc85xx_ptphdr *)(((unsigned char *)udphdr) + UDP_HLEN);
> > +}
> 
> This looks a lot like get_ptp_header_rx() below.  Are you sure you
> need two almost identical methods?

That's right, good catch. I'll look into merging the two.

> > +static void vsc85xx_get_tx_ts(struct vsc85xx_ptp *ptp)
> > +{
> > +     struct skb_shared_hwtstamps shhwtstamps;
> > +     struct sk_buff *skb, *first_skb = NULL;
> > +     struct vsc85xx_ts_fifo fifo;
> > +     u8 i, skb_sig[16], *p;
> > +     unsigned long ns;
> > +     s64 secs;
> > +     u32 reg;
> > +
> > +next_in_fifo:
> > +     memset(&fifo, 0, sizeof(fifo));
> > +     p = (u8 *)&fifo;
> > +
> > +     reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> > +                               MSCC_PHY_PTP_EGR_TS_FIFO(0));
> > +     if (reg & PTP_EGR_TS_FIFO_EMPTY)
> > +             goto out;
> > +
> > +     *p++ = reg & 0xff;
> > +     *p++ = (reg >> 8) & 0xff;
> > +
> > +     /* Reading FIFO6 pops the FIFO item */
> > +     for (i = 1; i < 7; i++) {
> > +             reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> > +                                       MSCC_PHY_PTP_EGR_TS_FIFO(i));
> > +             *p++ = reg & 0xff;
> > +             *p++ = (reg >> 8) & 0xff;
> > +             *p++ = (reg >> 16) & 0xff;
> > +             *p++ = (reg >> 24) & 0xff;
> > +     }
> > +
> > +next_in_queue:
> > +     skb = skb_dequeue(&ptp->tx_queue);
> > +     if (!skb || skb == first_skb)
> > +             goto out;
> > +
> > +     /* Keep the first skb to avoid looping over it again. */
> > +     if (!first_skb)
> > +             first_skb = skb;
> > +
> > +     /* Can't get the signature of the packet, won't ever
> > +      * be able to have one so let's dequeue the packet.
> > +      */
> > +     if (get_sig(skb, skb_sig) < 0)
> > +             goto next_in_queue;
> > +
> > +     /* Valid signature but does not match the one of the
> > +      * packet in the FIFO right now, reschedule it for later
> > +      * packets.
> > +      */
> > +     if (memcmp(skb_sig, fifo.sig, sizeof(fifo.sig))) {
> > +             skb_queue_tail(&ptp->tx_queue, skb);
> > +             goto next_in_queue;
> > +     }
> > +
> > +     ns = fifo.ns;
> > +     secs = fifo.secs;
> > +
> > +     memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> > +     shhwtstamps.hwtstamp = ktime_set(secs, ns);
> > +     skb_complete_tx_timestamp(skb, &shhwtstamps);
> > +
> > +out:
> > +     /* If other timestamps are available in the FIFO, process them. */
> > +     reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> > +                               MSCC_PHY_PTP_EGR_TS_FIFO_CTRL);
> > +     if (PTP_EGR_FIFO_LEVEL_LAST_READ(reg) > 1)
> > +             goto next_in_fifo;
> > +}
> 
> AFAICT, there is no need for labels and jumps here.  Two nested 'for'
> loops will do nicely.  The inner skb loop can be in a helper function
> for clarity.  Be sure to use the "safe" iterator over the skbs.

Using helper functions for clarity, I could move to using loops. I'll
try that and if it improves readability I'll change this for v2.

> > +static void vsc85xx_txtstamp(struct mii_timestamper *mii_ts,
> > +                          struct sk_buff *skb, int type)
> > +{
> > +     struct vsc8531_private *vsc8531 =
> > +             container_of(mii_ts, struct vsc8531_private, mii_ts);
> > +
> > +     if (!skb || !vsc8531->ptp->configured)
> 
> The skb cannot be NULL here.  See net/core/timestamping.c
> 
> > +             return;
> > +
> > +     if (vsc8531->ptp->tx_type == HWTSTAMP_TX_OFF) {
> > +             kfree_skb(skb);
> > +             return;
> > +     }
> > +
> > +     skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> > +     skb_queue_tail(&vsc8531->ptp->tx_queue, skb);
> > +     /* Scheduling the work for the TS FIFO is handled by the IRQ routine */
> > +}
> > +
> > +static bool vsc85xx_rxtstamp(struct mii_timestamper *mii_ts,
> > +                          struct sk_buff *skb, int type)
> > +{
> > +     struct vsc8531_private *vsc8531 =
> > +             container_of(mii_ts, struct vsc8531_private, mii_ts);
> > +     struct skb_shared_hwtstamps *shhwtstamps = NULL;
> > +     struct vsc85xx_ptphdr *ptphdr;
> > +     struct timespec64 ts;
> > +     unsigned long ns;
> > +
> > +     if (!skb || !vsc8531->ptp->configured)
> 
> Again, skb can't be null.

Right, I'll fix the two.

Thanks for the review!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
