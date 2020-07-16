Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4CC221CE9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 09:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgGPHAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 03:00:13 -0400
Received: from mail.intenta.de ([178.249.25.132]:43644 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgGPHAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 03:00:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=R8ZNY6kpiRutZDWxdtA7xvK0zflavsSfejaghVd/wvE=;
        b=QX7TJVt0dQwhgkObelZ/LTXJeDOV2Qkzzut6jQI3T2E4KlzVZgY7juSaDoekWLvTPyXSAolqXpv535ZHRqiYtNoNOoO+7fzQmH4gLvLSp7vegtZ7jk7EEKOIMazZwVtJTZMjYza0fERzGDwhmvUQBhgrYKcnBKMKYJlq4Pq/Y9OydYUSmQoyXg3a6UGK7yg8sxF1toxtKY000sJmfTX0U4kUzssKX3ZlBNW8frhrS4tRuEOmdSGsku9K+k9iy4SfZThcMqJQWvTMzgGnBmqTafPC3MJmmP0xi3RjGOet31mBFm+F+g0X//l29VoHKYdj49/MJr+qz7uB2tlGSDfhpg==;
Date:   Thu, 16 Jul 2020 09:00:00 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200716070000.GA27587@laureti-dev>
References: <20200617082235.GA1523@laureti-dev>
 <20200714120827.GA7939@laureti-dev>
 <20200714222716.GP1078057@lunn.ch>
 <20200715073112.GA25047@laureti-dev>
 <20200715130046.GB1211629@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200715130046.GB1211629@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 03:00:46PM +0200, Andrew Lunn wrote:
> On Wed, Jul 15, 2020 at 09:31:12AM +0200, Helmut Grohne wrote:
> > You seem to be in favour of more deeply encoding the "there can be only
> > one CPU port" assumption. Based on that assumption, the rest of what you
> > write makes very much sense to me. Is that the direction to go?
> 
> From what i understand, there is only one port which can do RGMII. It

This is not universally true. It does hold for a number of smaller chips
including KSZ9893, but it does not hold for e.g. KSZ9897R as explained
in my previous mail on this matter.

I think that this is the sole point of disagreement here. If we assume
that there only ever is one CPU (or user) port, then I agree with the
rest of what you wrote. However, my understanding is that this premise
is violated by larger devices that are partially supported by this
driver.

> does not really matter if that is the CPU port, or a user
> port. Ideally, whatever port it is, should have the phy-mode property
> in its port node.
> 
> How you store that information until you need it is up to the
> driver. But KISS is generally best, reuse what you have, unless there
> is a good reason to change it. If you see this code being reused when
> more than one port supports RGMII, then adding a per port members
> makes sense. But if that is unlikely, keep with the global.

I've prepared a patch based one the one-CPU-port assumption. It really
becomes way simpler that way. I'd like to give it a little more testing
before sending it.

Given the point of discussion I think that the assumption is a
reasonable trade-off, because you can support larger devices with
multiple RGMII-capable ports with this driver as long as you only use
one of them as CPU port. If someone ever wants to use multiple CPU ports
(not me), more significant changes are needed anyway. Partially
supporting this runs afoul KISS as you say.

Helmut
