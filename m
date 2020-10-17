Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7FB291468
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 22:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439101AbgJQU5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 16:57:18 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:43707 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439080AbgJQU5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 16:57:17 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4CDFh92mp3z9tD4;
        Sat, 17 Oct 2020 22:57:13 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CDFgt3PVjz2xGF;
        Sat, 17 Oct 2020 22:56:58 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Sat, 17 Oct
 2020 22:56:25 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: dsa: don't pass cloned skb's to drivers xmit function
Date:   Sat, 17 Oct 2020 22:56:24 +0200
Message-ID: <1735006.IpzxAEH60n@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201017191247.ohslc77wkhbhffym@skbuf>
References: <20201016200226.23994-1-ceggers@arri.de> <2130539.dlFve3NVyK@n95hx1g2> <20201017191247.ohslc77wkhbhffym@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201017-225704-4CDFgt3PVjz2xGF-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, 17 October 2020, 21:12:47 CEST, Vladimir Oltean wrote:
> On Sat, Oct 17, 2020 at 08:53:19PM +0200, Christian Eggers wrote:
> > > Does 1588 work for you using this change, or you haven't finished
> > > implementing it yet? If you haven't, I would suggest finishing that
> > > part first.
> > 
> > Yes it does. Just after finishing this topic, I would to sent the patches
> > for PTP. Maybe I'll do it in parallel, anything but the combination of
> > L2/E2E/SLOB seems to work.
> 
> 2 aspects:
> - net-next is closed for this week and the next one, due to the merge
>   window. You'll have to wait until it reopens.
The status page seems to be out of date:
http://vger.kernel.org/~davem/net-next.html

The FAQ says: "Do not send new net-next content to netdev...". So there is no
possibility for code review, is it?

> - Actually I was asking you this because sja1105 PTP no longer works
>   after this change, due to the change of txflags.
The tail taggers seem to be immune against this change.

> > I don't like to touch the non-tail taggers, this is too much out of the
> > scope of my current work.
> 
> Do you want me to try and send a version using pskb_expand_head and you
> can test if it works for your tail-tagging switch?
I already wanted to ask... My 2nd try (checking for !skb_cloned()) was already
sufficient (for me). Hacking linux-net is very interesting, but I have many 
other items open... Testing would be no problem.

> > > Also, if the result is going to be longer than ~20 lines of code, I
> > > strongly suggest moving the reallocation to a separate function so you
> > > don't clutter dsa_slave_xmit.
> > 
> > As Florian requested I'll likely put the code into a separate function in
> > slave.c and call it from the individual tail-taggers in order not to put
> > extra conditionals in dsa_slave_xmit.
> 
> I think it would be best to use the unlikely(tail_tag) approach though.
> The reallocation function should still be in the common code path. Even
> for a non-1588 switch, there are other code paths that clone packets on
> TX. For example, the bridge does that, when flooding packets. 
You already mentioned that you don't want to pass cloned packets to the tag 
drivers xmit() functions. I've no experience with the problems caused by 
cloned packets, but would cloned packets work anyway? Or must cloned packets 
not be changed (e.g. by tail-tagging)? Is there any value in first cloning in 
dsa_skb_tx_timestamp() and then unsharing in dsa_slave_xmit a few lines later? 
The issue I currently have only affects a very minor number of packets (cloned 
AND < ETH_ZLEN AND CONFIG_SLOB), so only these packets would need a copying.

> Currently, DSA ensures that the header area is writable by calling 
> skb_cow_head, as far as I can see. But the point is, maybe we can do TX 
> reallocation centrally.

regards
Christian



