Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163F99E90B
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfH0NTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:19:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34274 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbfH0NS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=opy2LGo8EiMuXbwuiWz62GkRvsGmq1zFVRcUmTfeyis=; b=0iYNetQTXrlSwCH6KOhIteuxSo
        0oCJj5MunUT7NBQ86QHygqqF96PeA5dubjKssDfukyNYPVpVaRmDvFLX8Inb1WYoIPFkjgYrxxJzE
        BB9eqt3xUPUl8Ir4eG/E56qc8ABNjp6sd9Txv9vDv0EjArWwgGRdn1iQtj4sP/2Etf/0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2bMe-0003GO-Vi; Tue, 27 Aug 2019 15:18:24 +0200
Date:   Tue, 27 Aug 2019 15:18:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/3] Add NETIF_F_HW_BR_CAP feature
Message-ID: <20190827131824.GC11471@lunn.ch>
References: <1566807075-775-1-git-send-email-horatiu.vultur@microchip.com>
 <20190826123811.GA13411@lunn.ch>
 <20190827101033.g2cb6j2j4kuyzh2a@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827101033.g2cb6j2j4kuyzh2a@soft-dev3.microsemi.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> That sounds like a great idea. I was expecting to add this logic in the
> set_rx_mode function of the driver. But unfortunetly, I got the calls to
> this function before the dev->promiscuity is updated or not to get the
> call at all. For example in case the port is member of a bridge and I try
> to enable the promisc mode.

Hi Horatiu

What about the notifier? Is it called in all the conditions you need
to know about?

Or, you could consider adding a new switchdev call to pass this
information to any switchdev driver which is interested in the
information.

At the moment, the DSA driver core does not pass onto the driver it
should put a port into promisc mode. So pcap etc, will only see
traffic directed to the CPU, not all the traffic ingressing the
interface. If you put the needed core infrastructure into place, we
could plumb it down from the DSA core to DSA drivers.

Having said that, i don't actually know if the Marvell switches
support this. Forward using the ATU and send a copy to the CPU?  What
switches tend to support is port mirroring, sending all the traffic
out another port. A couple of DSA drivers support that, via TC.

	Andrew
