Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA774FB5B7
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 17:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbfKMQxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 11:53:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727884AbfKMQxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 11:53:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yCXZla7cURmATzZR/Qk3NkV7z0YtqKHWClMENP0GBF8=; b=svoW/HYYZRf9zIKdX7vtMSoq8a
        cki6wHfxwetvOhPcGxAxp0V3Aouv+1iw/9TG2TsG91PEfF2W/rWHHKaO8+YNS17JxqO0MhnYp8cyg
        qmC5xP4Vg0ZOnzt8gayFO6APtV92GweBf+EzygMrVVSeWdOmP4r7TSm0D74NH5mcnEI0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUvt6-00083a-S6; Wed, 13 Nov 2019 17:53:00 +0100
Date:   Wed, 13 Nov 2019 17:53:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Offloading DSA taggers to hardware
Message-ID: <20191113165300.GC27785@lunn.ch>
References: <CA+h21hqte1sOefqVXKvSQ6N7WoTU3BH7qKpq3C7pieaqSB6AFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqte1sOefqVXKvSQ6N7WoTU3BH7qKpq3C7pieaqSB6AFg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir

I've not seen any hardware that can do this. There is an
Atheros/Qualcom integrated SoC/Switch where the 'header' is actually
just a field in the transmit/receive descriptor. There is an out of
tree driver for it, and the tag driver is very minimal. But clearly
this only works for integrated systems.

The other 'smart' features i've seen in NICs with respect to DSA is
being able to do hardware checksums. Freescale FEC for example cannot
figure out where the IP header is, because of the DSA header, and so
cannot calculate IP/TCP/UDP checksums. Marvell, and i expect some
other vendors of both MAC and switch devices, know about these
headers, and can do checksumming.

I'm not even sure there are any NICs which can do GSO or LRO when
there is a DSA header involved.

In the direction CPU to switch, i think many of the QoS issues are
higher up the stack. By the time the tagger is involved, all the queue
discipline stuff has been done, and it really is time to send the
frame. In the 'post buffer bloat world', the NICs hardware queue
should be small, so QoS is not so relevant once you reach the TX
queue. The real QoS issue i guess is that the slave interfaces have no
idea they are sharing resources at the lowest level. So a high
priority frames from slave 1 are not differentiated from best effort
frames from slave 2. If we were serious about improving QoS, we need a
meta scheduler across the slaves feeding the master interface in a QoS
aware way.

In the other direction, how much is the NIC really looking at QoS
information on the receive path? Are you thinking RPS? I'm not sure
any of the NICs commonly used today with DSA are actually multi-queue
and do RPS.

Another aspect here might be, what Linux is doing with DSA is probably
well past the silicon vendors expected use cases. None of the 'vendor
crap' drivers i've seen for these SOHO class switches have the level
of integration we have in Linux. We are pushing the limits of the
host/switch interfaces much more then vendors do, and so silicon
vendors are not so aware of the limits in these areas? But DSA is
being successful, vendors are taking more notice of it, and maybe with
time, the host/switch interface will improve. NICs might start
supporting GSO/LRO when there is a DSA header involved? Multi-queue
NICs become more popular in this class of hardware and RPS knows how
to handle DSA headers. But my guess would be, it will be for a Marvell
NIC paired with a Marvell Switch, Broadcom NIC paired with a Broadcom
switch, etc. I doubt there will be cross vendor support.

	Andrew
