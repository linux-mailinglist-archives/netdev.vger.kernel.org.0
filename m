Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3CCC1136
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 17:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfI1PUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 11:20:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfI1PUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 11:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=64cpgqmI0/jat4r2Y64Ugdv5uTki3eckHoNpVFoaBIo=; b=0Ec/sfzQVYql3TBxfDwhplr3+e
        fZfD5mkLKbZzLUtHE3scwqDIBRKo5ZOr4wjoF7SxIytounEwAixu67oWu8Rty7lPqdOlkakv/zae/
        sHNcPtrtw/QlYAOeFVV/9hnG12TutPcSLZfazNX1EhbeeM/4RFHLVcDG2U816VTvZYEI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iEEWE-0000M4-8h; Sat, 28 Sep 2019 17:20:22 +0200
Date:   Sat, 28 Sep 2019 17:20:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA driver kernel extension for dsa mv88e6190 switch
Message-ID: <20190928152022.GE25474@lunn.ch>
References: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
 <20190923191713.GB28770@lunn.ch>
 <CAGAf8LyQpi_R-A2Zx72bJhSBqnFo-r=KCnfVCTD9N8cNNtbhrQ@mail.gmail.com>
 <20190926133810.GD20927@lunn.ch>
 <CAGAf8LxAbDK7AUueCv-2kcEG8NZApNjQ+WQ1XO89+5C-SLAbPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGAf8LxAbDK7AUueCv-2kcEG8NZApNjQ+WQ1XO89+5C-SLAbPw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 28, 2019 at 01:00:43AM +0200, Zoran Stojsavljevic wrote:
> Hello Andrew,
> 
> > You should not need any kernel patches for switch side RGMII
> > delays. rgmii-id in the DT for the switch CPU port should be enough.
> > Some of the vf610-zii platforms use it.
> 
> It should, but it does NOT work. IT is clearly stated in port.c, in f-n:
> static int mv88e6xxx_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
>                                           phy_interface_t mode)
> 
> The logic analyser shows MDIO write to register 0x01, which is 0x6003.
> Seems the correct value.
> 
> But, at the very end, ethtool shows that this clock skew is NOT
> inserted.

How do you see this with ethtool?

> I see on RX side CRC errors. Every ethernet frame while
> pinging.

But TX works? Maybe the FEC is doing some sort of delay, even if it
has a hardware bug.
 
> I see another interesting fact, the dmesg, which you could see here:
> https://pastebin.com/igXS6eXe
> 
> [    1.182273] DEBUG INFO! <- addr: 0x00 reg: 0x03 val: 0x1901
> [    1.187888] mv88e6085 2188000.ethernet-1:00: switch 0x1900
> detected: Marvell 88E6190, revision 1
> [    1.219804] random: fast init done
> [    1.225334] libphy: mv88e6xxx SMI: probed
> [    1.232709] fec 2188000.ethernet eth0: registered PHC device 0
> 
> [    1.547946] DEBUG INFO! <- addr: 0x00 reg: 0x03 val: 0x1901
> [    1.553542] mv88e6085 2188000.ethernet-1:00: switch 0x1900
> detected: Marvell 88E6190, revision 1
> [    1.555432]  mmcblk1: p1
> [    1.598106] libphy: mv88e6xxx SMI: probed
> [    1.740362] DSA: tree 0 setup
> 
> There are two distinct accesses while driver configures the switch. Why???

This happens when the driver is missing a resource during probe.  It
returns the error -EPROBE_DEFER, and the linux driver core will try
the probe again later. Probably the second time all the resources it
needs will be present and the probe will be successful.

I will probably have a some patches during the next kernel merge cycle
to make this a bit more efficient.

> I was not able to explain this to me... Or find explanation using google?!
> 
> > gpios = <&gpio1 29 GPIO_ACTIVE_HIGH>; is wrong. It probably
> > should be reset-gpios. The rest looks O.K.
> 
> I will follow the advise, but I do not think this is an obstacle.

No, it is not an obstacle, but it is still wrong.

> 
> > Please show me the configuration steps you are doing? How are you
> > configuring the FEC and the switch interfaces?
> 
> Forgive me for my ignorance, but I have no idea what you have asked me for?

ip link set eth0 up
ip link set lan0 up
ip link set lan1 up
ip link name br0 type bridge
ip link set br0 up
ip link lan0 master br0
ip link lan1 master br0

   Andrew
