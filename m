Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5845BDF52D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfJUSgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:36:36 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35079 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUSgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:36:36 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iMcXb-0004yt-Pa; Mon, 21 Oct 2019 20:36:27 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iMcXZ-000580-DT; Mon, 21 Oct 2019 20:36:25 +0200
Date:   Mon, 21 Oct 2019 20:36:25 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 4/5] net: dsa: add support for Atheros AR9331 TAG
 format
Message-ID: <20191021183625.bmapf4bliaisluad@pengutronix.de>
References: <20191021053811.19818-1-o.rempel@pengutronix.de>
 <20191021053811.19818-5-o.rempel@pengutronix.de>
 <20191021154900.GF17002@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191021154900.GF17002@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:14:24 up 157 days, 32 min, 97 users,  load average: 0.00, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 05:49:00PM +0200, Andrew Lunn wrote:
> > +static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
> > +				      struct net_device *ndev,
> > +				      struct packet_type *pt)
> > +{
> > +	u8 ver, port;
> > +	u16 hdr;
> > +
> > +	if (unlikely(!pskb_may_pull(skb, AR9331_HDR_LEN)))
> > +		return NULL;
> > +
> > +	hdr = le16_to_cpu(*(__le16 *)skb_mac_header(skb));
> > +
> > +	ver = FIELD_GET(AR9331_HDR_VERSION_MASK, hdr);
> > +	if (unlikely(ver != AR9331_HDR_VERSION)) {
> > +		netdev_warn_once(ndev, "%s:%i wrong header version 0x%2x\n",
> > +				 __func__, __LINE__, hdr);
> > +		return NULL;
> > +	}
> > +
> > +	if (unlikely(hdr & AR9331_HDR_FROM_CPU)) {
> > +		netdev_warn_once(ndev, "%s:%i packet should not be from cpu 0x%2x\n",
> > +				 __func__, __LINE__, hdr);
> > +		return NULL;
> > +	}
> > +
> > +	skb_pull(skb, AR9331_HDR_LEN);
> > +	skb_set_mac_header(skb, -ETH_HLEN);
> 
> No other tag driver calls skb_set_mac_header().  Also, the -ETH_HLEN
> looks odd, give you have just pulled off AR9331_HDR_LEN?

Hm.. is it corrected somewhere else? Any way, B.T.M.A.N need a proper
value ant it seems to work correctly. So I remove it.

> What other tag drivers use is skb_pull_rcsum().

It is build in switch and internal Ethernet controller do not set csum. There is
nothing to recalculate... on other hand, it adds no overhead. So, I have
nothing against it. Are there other arguments?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
