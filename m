Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4446F96DFC
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfHUACF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:02:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfHUACF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 20:02:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FXqq5agnMhybNrO23ARWsSKRNVHc8uwYX6TeUD3ACrU=; b=v7xXKbSE/kXKAj3899T00ra+G0
        3VdR9y6xjSny+QEGRAy1XnJCpBF3GrRKsNGQotR6CdLMKE6TxpX0CfMQmn35lcCL242wZqt+RQYMO
        REqcatuA7o1ySYt0k+vwRo+SuJRL96CsqsM8qpZXFu86ghZ0VmQwRYAlKsucZxG9zuZs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0E4Z-0001Ct-3i; Wed, 21 Aug 2019 02:01:55 +0200
Date:   Wed, 21 Aug 2019 02:01:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190821000155.GA4285@lunn.ch>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190816132959.GC8697@bistromath.localdomain>
 <20190820100140.GA3292@kwain>
 <20190820144119.GA28714@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820144119.GA28714@bistromath.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you look at IPsec offloading, the networking stack builds up the
> ESP header, and passes the unencrypted data down to the driver. I'm
> wondering if the same would be possible with MACsec offloading: the
> macsec virtual interface adds the header (and maybe a dummy ICV), and
> then the HW does the encryption. In case of HW that needs to add the
> sectag itself, the driver would first strip the headers that the stack
> created. On receive, the driver would recreate a sectag and the macsec
> interface would just skip all verification (decrypt, PN).

Hi Sabrina

I assume the software implementation cannot make use of TSO or GSO,
letting the hardware segment a big buffer up into Ethernet frames?
When using hardware MACSEC, is it possible to enable these? By the
time the frames have reach the PHY GSO has been done. So it sees a
stream of frames it needs to encode/decode.

But if you are suggesting the extra headers are added by the virtual
interface, i don't think GSO can be used? My guess would be, we get a
performance boost from using hardware MAC sec, but there will also be
a performance boost if GSO can be enabled when it was disabled before.

      Andrew
