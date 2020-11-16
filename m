Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6A02B3FA4
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbgKPJWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:22:33 -0500
Received: from mailout05.rmx.de ([94.199.90.90]:55885 "EHLO mailout05.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbgKPJWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 04:22:33 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout05.rmx.de (Postfix) with ESMTPS id 4CZNrj0zRpz9xCZ;
        Mon, 16 Nov 2020 10:22:29 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CZNrS3HBTz2TTNs;
        Mon, 16 Nov 2020 10:22:16 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.154) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 16 Nov
 2020 10:21:15 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Richard Cochran" <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 03/11] net: dsa: microchip: split ksz_common.h
Date:   Mon, 16 Nov 2020 10:21:14 +0100
Message-ID: <21145167.0O08aVLsga@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <5328227.AyQhSCNoNJ@n95hx1g2>
References: <20201112153537.22383-1-ceggers@arri.de> <20201112230254.v6bzsud3jlcmsjm2@skbuf> <5328227.AyQhSCNoNJ@n95hx1g2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.154]
X-RMX-ID: 20201116-102216-4CZNrS3HBTz2TTNs-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, 13 November 2020, 17:56:34 CET, Christian Eggers wrote:
> On Friday, 13 November 2020, 00:02:54 CET, Vladimir Oltean wrote:
> > On Thu, Nov 12, 2020 at 04:35:29PM +0100, Christian Eggers wrote:
> > > Parts of ksz_common.h (struct ksz_device) will be required in
> > > net/dsa/tag_ksz.c soon. So move the relevant parts into a new header
> > > file.
> > > 
> > > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > > ---
> > 
> > I had to skip ahead to see what you're going to use struct ksz_port and
> > 
> > struct ksz_device for. It looks like you need:
> > 	struct ksz_port::tstamp_rx_latency_ns
> > 	struct ksz_device::ptp_clock_lock
> > 	struct ksz_device::ptp_clock_time
> > 
> > Not more.
I have tried to put these members into separate structs:

include/linux/dsa/ksz_common.h:
struct ksz_port_ptp_shared {
	u16 tstamp_rx_latency_ns;   /* rx delay from wire to tstamp unit */
};

struct ksz_device_ptp_shared {
	spinlock_t ptp_clock_lock; /* for ptp_clock_time */
	/* approximated current time, read once per second from hardware */
	struct timespec64 ptp_clock_time;
};

drivers/net/dsa/microchip/ksz_common.h:
...
#include <linux/dsa/ksz_common.h>
...
struct ksz_port {
...
#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
	struct ksz_port_ptp_shared ptp_shared;	/* shared with tag_ksz.c */
	u16 tstamp_tx_latency_ns;	/* tx delay from tstamp unit to wire */
	struct hwtstamp_config tstamp_config;
	struct sk_buff *tstamp_tx_xdelay_skb;
	unsigned long tstamp_state;
#endif
};
...
struct ksz_device {
...
#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
	struct ptp_clock *ptp_clock;
	struct ptp_clock_info ptp_caps;
	struct mutex ptp_mutex;
	struct ksz_device_ptp_shared ptp_shared;   /* shared with tag_ksz.c */
#endif
};

The problem with such technique is, that I still need to dereference
struct ksz_device in tag_ksz.c:

static void ksz9477_rcv_timestamp(struct sk_buff *skb, u8 *tag,
				  struct net_device *dev, unsigned int port)
{
...
	struct dsa_switch *ds = dev->dsa_ptr->ds;
	struct ksz_device *ksz = ds->priv;
	struct ksz_port *prt = &ksz->ports[port];
...
}

As struct dsa_switch::priv is already occupied by the pointer to
struct ksz_device, I see no way accessing the ptp specific device/port
information in tag_ksz.c.

> > 
> > Why don't you go the other way around, i.e. exporting some functions
> > from your driver, and calling them from the tagger?
> 
> Good question... But as for as I can see, there are a single tagger and
> multiple device drivers (currently KSZ8795 and KSZ9477).
> 
> Moving the KSZ9477 specific stuff, which is required by the tagger, into the
> KSZ9477 device driver, would make the tagger dependent on the driver(s).
> Currently, no tagger seems to have this direction of dependency (at least I
> cannot find this in net/dsa/Kconfig).
> 
> If I shall change this anyway, I would use #ifdefs within the tag_ksz driver
> in order to avoid unnecessary dependencies to the KSZ9477 driver for the
> case only KSZ8795 is selected.
> 
> > You could even move
> > the entire ksz9477_tstamp_to_clock() into the driver as-is, as far as I
> > can see.

regards
Christian



