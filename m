Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0203CCE7
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 15:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbfFKN1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 09:27:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45176 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfFKN1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 09:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BVwrsGPFJFrD09FYZ2WX7Gh/a0P8PtV9rVWiZV89tTM=; b=CVcvUcTJkknBeOT0snnz8Ppc0S
        RdFqBUUDsVml66ITn6spE6yKtFrhgZP5O5/kQpRVc4GzRIc0estT3RZpxIw6KbNxKetHTcJU2G5xu
        SQz75CwkfvDfr8qmw1L11Hq+HLKDGKoXZHKkID3byxQEawWHxw98oudLE6Fa9MJoEU1g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hagoU-0005yW-4o; Tue, 11 Jun 2019 15:27:46 +0200
Date:   Tue, 11 Jun 2019 15:27:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190611132746.GA22832@lunn.ch>
References: <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
 <20190606133501.GC19590@lunn.ch>
 <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
 <20190606135903.GE19590@lunn.ch>
 <8903b07b-4ac5-019a-14a1-d2fc6a57c0bb@eks-engel.de>
 <20190607124750.GJ20899@lunn.ch>
 <635c884a-185d-5b3b-7f91-ce058d9726f4@eks-engel.de>
 <20190611121938.GA20904@lunn.ch>
 <68671792-a720-6fa5-0a6e-0cd9f57c67eb@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68671792-a720-6fa5-0a6e-0cd9f57c67eb@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I captured a ping from my device to my computer to look if outgoing is working
> (captured on both devices). Here is the output from my device where i started the:
> 
> 00:24:24.752057 ARP, Request who-has 192.168.10.2 tell 192.168.10.1, length 28
> 	0x0000:  0001 0800 0604 0001 6a2a ad79 def5 c0a8  ........j*.y....
> 	0x0010:  0a01 0000 0000 0000 c0a8 0a02            ............
> 
> and here the output of the receiver:
> 
> 14:49:06.725940 MEDSA 0.2:0: ARP, Request who-has benjamin-HP tell 192.168.10.1, length 42
> 	0x0000:  0000 4010 0000 0806 0001 0800 0604 0001  ..@.............
> 	0x0010:  6a2a ad79 def5 c0a8 0a01 0000 0000 0000  j*.y............
> 	0x0020:  c0a8 0a02 0000 0000 0000 0000 0000 0000  ................
> 	0x0030:  0000
> 
> I'm really stuck at the moment because I don't know what to do further. I think, 
> I did everything what is needed.
> And I know when I configure the switch manually via MDIO the connection is working.
> When I'm looking for traffic in ifconfig on all ports there is everywhere 0 bytes 
> except for eth0.
> Do you have any ideas?

I would start simple and build up. Don't use a bridge. Just put the IP
address 192.168.10.1 on the slave interface for port 2.

So something like:

ip link set eth0 up
ip addr add 192.168.10.1/24 dev lan2
ip link set lan2 up

then you can try ping 192.168.10.2.

Then trace the packet along the path. Does the ARP request make it to
192.168.10.2? Is a reply sent? ethtool -S lan2 will show you the
packet counts. Do the counters show the ARP going out and the reply
coming back?

       Andrew
