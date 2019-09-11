Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6AA4B05C9
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfIKWw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:52:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbfIKWw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 18:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4aVgtI53MkdfEImlYuOkvkEfXNGliuEFpft7wPzwa64=; b=1KeepMQawvtTMpT8q2FWOFribO
        e5hLVp0W5AkYyh998EujdKRBEEuP4j18Nrdf71FJSDeK8x9nseAlpHFsbFBWofD2xAwaKtZ+4aNJM
        9T1RZ24vEpTW15wtvCk2kHP+0JZ6hsgvfcyddCLe32yajx9YLSTUTNxi6ZaQITjFLDhs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i8BTo-0001dm-TG; Thu, 12 Sep 2019 00:52:52 +0200
Date:   Thu, 12 Sep 2019 00:52:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/7] net/dsa: configure autoneg for CPU port
Message-ID: <20190911225252.GA5710@lunn.ch>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-2-bob.beckett@collabora.com>
 <20190910182635.GA9761@lunn.ch>
 <aa0459e0-64ee-de84-fc38-3c9364301275@gmail.com>
 <ad302835a98ca5abc7ac88b3caad64867e33ee70.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad302835a98ca5abc7ac88b3caad64867e33ee70.camel@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It is not just for broadcast storm protection. The original issue that
> made me look in to all of this turned out to be rx descritor ring
> buffer exhaustion due to the CPU not being able to keep up with packet
> reception.

Pause frames does not really solve this problem. The switch will at
some point fill its buffers, and start throwing packets away. Or it
needs to send pause packets it its peers. And then your whole switch
throughput goes down. Packets will always get thrown away, so you need
QoS in your network to give the network hints about which frames is
should throw away first.

..

> Fundamentally, with a phy to phy CPU connection, the CPU MAC may well
> wish to enable pause frames for various reasons, so we should strive to
> handle that I think.

It actually has nothing to do with PHY to PHY connections. You can use
pause frames with direct MAC to MAC connections. PHY auto-negotiation
is one way to indicate both ends support it, but there are also other
ways. e.g.

ethtool -A|--pause devname [autoneg on|off] [rx on|off] [tx on|off]

on the SoC you could do

ethtool --pause eth0 autoneg off rx on tx on

to force the SoC to send and process pause frames. Ideally i would
prefer a solution like this, since it is not a change of behaviour for
everybody else.

   Andrew
