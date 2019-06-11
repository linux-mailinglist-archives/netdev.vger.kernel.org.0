Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6633CB01
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388166AbfFKMTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 08:19:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44900 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728661AbfFKMTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 08:19:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xn4ci+pCJBqixbNpLqXKTiBYdkKkjdYuZZZ0Dtq0tFA=; b=qor1n4mQaAEeEmr6e3VEcy1Ija
        DbsP+fCP4bGVwTtLqvBO9YJZ1k5OuwXlx9P1aGCKnfZhkMOeXGgN3ad4LneQMPaSFzq6PYf/BdIkm
        MGgi6ayP7REdM7acOvsSXt2dlpicELV+ap23e+oQY794XYjGV0hgX/HxrUwXKktzLs2s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hafkY-0005Uc-Ez; Tue, 11 Jun 2019 14:19:38 +0200
Date:   Tue, 11 Jun 2019 14:19:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190611121938.GA20904@lunn.ch>
References: <20190605184724.GB19590@lunn.ch>
 <c27f2b9b-90d7-db63-f01c-2dfaef7a014b@eks-engel.de>
 <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
 <20190606133501.GC19590@lunn.ch>
 <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
 <20190606135903.GE19590@lunn.ch>
 <8903b07b-4ac5-019a-14a1-d2fc6a57c0bb@eks-engel.de>
 <20190607124750.GJ20899@lunn.ch>
 <635c884a-185d-5b3b-7f91-ce058d9726f4@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <635c884a-185d-5b3b-7f91-ce058d9726f4@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 09:36:16AM +0200, Benjamin Beckmeyer wrote:
> >> So all ports are now in forwarding mode (Switch port register 0x4 of all ports 
> >> are 0x7f), but I don't reach it over ping.
> > Hi
> >
> > The most common error for people new to DSA is forgetting to bring
> > the master interface up.
> >
> > The second thing to understand is that by default, all interfaces are
> > separated. So the switch won't bridge frames between ports, until you
> > add the ports to a Linux bridge. But you can give each interface its
> > own IP address.
> >
> >     Andrew
> 
> Hi Andrew,
> thanks for your help again. Sorry for the late reply we had a stats day yesterday. 
> What interface do you mean with master interface? I assume, you mean eth0 (cpu port)?

Yes. The master interface is the pipe between the host and the
switch. It is only used as a pipe. It needs to be up, but there is no
point having an IP address on it, since it cannot send packets itself.

lan1-4 are slave interfaces. They can have IP addresses.

> I deleted the IP address of this interface and tried to add it to the bridge:
> 
> brctl addif bridge0 eth0
> brctl: bridge bridge0: Invalid argument

Yes, you should not do this. Just have the master interface up, but
otherwise leave it alone. It also needs to be up before you bring the
slave interfaces up.

> I tried this with all lan1-4 interfaces and they just work and directly after
> I added them I got some information about the port:
> 
> brctl addif br0 lan4
> [  156.085842] br0: port 4(lan4) entered blocking state
> [  156.091022] br0: port 4(lan4) entered disabled state
> 
> After I brought up the bridge with:
> 
> ip link set br0 up
> [  445.313697] br0: port 4(lan4) entered blocking state
> [  445.318896] br0: port 4(lan4) entered forwarding state
> 
> So I gave my eth0 an IP address and started tcpdump on eth0:

No. If you have created a bridge, put the IP address on the bridge.
If you have a slave which is not part of the bridge, you can give it
an IP address. Just treat the interfaces as Linux interfaces. Run
dhclient on them, use ethtool, iproute2, an snmp agent, add them to a
bridge. They are just normal Linux interfaces, which can make use of
the switch hardware to accelerate some operations, like bridging
frames.

   Andrew
