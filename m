Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90A12992A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403834AbfEXNoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:44:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391124AbfEXNoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NXhrt9pEKadEEIbbXle9xK39f4cdcNeGcn2+kAlso1k=; b=yOjCjNIKKxuVXGIB2CrZa5er7G
        kCQL8hsyzTYC6GBgfsjAv5L4M2FmcJKjhVPlwh6kaUnNebIL0SSXJ8vmH1u3uZBQwaQhjb6KpmVS5
        /hu2A4v5oxO1JOJ/tq09GuYlh7o4U76udpD1c2ZxZ+A1X3MAJuEhVCZZAXe9ocqJdxRA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUAUW-00017M-1g; Fri, 24 May 2019 15:44:12 +0200
Date:   Fri, 24 May 2019 15:44:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg Ungerer <gerg@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Set correct interface mode for
 CPU/DSA ports
Message-ID: <20190524134412.GE2979@lunn.ch>
References: <e27eeebb-44fb-ae42-d43d-b42b47510f76@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e27eeebb-44fb-ae42-d43d-b42b47510f76@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 11:25:03AM +1000, Greg Ungerer wrote:
> Hi Andrew,
> 
> I have a problem with a Marvell 6390 switch that I have bisected
> back to commit 7cbbee050c95, "[PATCH] net: dsa: mv88e6xxx: Set correct
> interface mode for CPU/DSA ports".
> 
> I have a Marvell 380 SoC based platform with a Marvell 6390 10 port
> switch, everything works with kernel 5.0 and older. As of 5.1 the
> switch ports no longer work - no packets are ever received and
> none get sent out.
> 
> The ports are probed and all discovered ok, they just don't work.
> 
>   mv88e6085 f1072004.mdio-mii:10: switch 0x3900 detected: Marvell 88E6390, revision 1
>   libphy: mv88e6xxx SMI: probed
>   mv88e6085 f1072004.mdio-mii:10 lan1 (uninitialized): PHY [mv88e6xxx-1:01] driver [Marvell 88E6390]
>   mv88e6085 f1072004.mdio-mii:10 lan2 (uninitialized): PHY [mv88e6xxx-1:02] driver [Marvell 88E6390]
>   mv88e6085 f1072004.mdio-mii:10 lan3 (uninitialized): PHY [mv88e6xxx-1:03] driver [Marvell 88E6390]
>   mv88e6085 f1072004.mdio-mii:10 lan4 (uninitialized): PHY [mv88e6xxx-1:04] driver [Marvell 88E6390]
>   mv88e6085 f1072004.mdio-mii:10 lan5 (uninitialized): PHY [mv88e6xxx-1:05] driver [Marvell 88E6390]
>   mv88e6085 f1072004.mdio-mii:10 lan6 (uninitialized): PHY [mv88e6xxx-1:06] driver [Marvell 88E6390]
>   mv88e6085 f1072004.mdio-mii:10 lan7 (uninitialized): PHY [mv88e6xxx-1:07] driver [Marvell 88E6390]
>   mv88e6085 f1072004.mdio-mii:10 lan8 (uninitialized): PHY [mv88e6xxx-1:08] driver [Marvell 88E6390]
>   DSA: tree 0 setup
> 
> Things like ethtool on the ports seem to work ok, reports link correctly.
> Configuring ports as part of a bridge or individually gets the same result.

Hi Greg

DSA by default should configure the CPU port and DSA ports to there
maximum speed. For port 10, that is 10Gbps. Your 380 cannot do that
speed. So you need to tell the switch driver to slow down. Add a fixed
link node to port ten, with speed 1000. You might also need to set the
phy-mode to rgmii.

Can the 380 do 2500BaseX? There is work in progress to support this
speed, so maybe next cycle you can change to that.

     Andrew
