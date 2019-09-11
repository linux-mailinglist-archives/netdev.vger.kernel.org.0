Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0245B05D1
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfIKW6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:58:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbfIKW6r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 18:58:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bvxvXjzjLd5LLjsg8oouWPltfRv1itXFS43TNK9ObEo=; b=jFlqBi5BtWxDE3cqHraE1h3Zyp
        kDOZxz3cn3k+U7n8Q1xhVF1SOOZjBG/6wJLlEked8/6nusXEIsK062ihj88Tmk6OzOI3LTfYB30vG
        UZUvoA8LtRwcbExNJg9Hk8lbapt9wQp/Q0VJ2LKeXjXGlAP80T5j1vhGHDtEUFo/klNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i8BZR-0001gD-BA; Thu, 12 Sep 2019 00:58:41 +0200
Date:   Thu, 12 Sep 2019 00:58:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Message-ID: <20190911225841.GB5710@lunn.ch>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
 <20190911112134.GA20574@splinter>
 <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We have a setup as follows:
> 
> Marvell 88E6240 switch chip, accepting traffic from 4 ports. Port 1
> (P1) is critical priority, no dropped packets allowed, all others can
> be best effort.
> 
> CPU port of swtich chip is connected via phy to phy of intel i210 (igb
> driver).
> 
> i210 is connected via pcie switch to imx6.
> 
> When too many small packets attempt to be delivered to CPU port (e.g.
> during broadcast flood) we saw dropped packets.
> 
> The packets were being received by i210 in to rx descriptor buffer
> fine, but the CPU could not keep up with the load. We saw
> rx_fifo_errors increasing rapidly and ksoftirqd at ~100% CPU.
> 
> 
> With this in mind, I am wondering whether any amount of tc traffic
> shaping would help?

Hi Robert

The model in linux is that you start with a software TC filter, and
then offload it to the hardware. So the user configures TC just as
normal, and then that is used to program the hardware to do the same
thing as what would happen in software. This is exactly the same as we
do with bridging. You create a software bridge and add interfaces to
the bridge. This then gets offloaded to the hardware and it does the
bridging for you.

So think about how your can model the Marvell switch capabilities
using TC, and implement offload support for it.

    Andrew
