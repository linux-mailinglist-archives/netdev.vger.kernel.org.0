Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E45375DC
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfFFN7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:59:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbfFFN7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 09:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ej8UnejtUMXf4SfK0lzW5P64aProjSfh2CeWNwLjoJw=; b=ZqwwQziJri+wTe34QJPoEE8HRA
        SjfgRpRjCkzw55V+vAwq2EhhfHKmPWRioo4sxKON1KZqLJsfxlpMWlj7QUuF4jAgoY3hHIKA5pNZK
        cnXiwYN5PU/15d2eNt6Y0KOqFXRq8VJ9JehpdDoe7iV0GBdlEHOT9wAYnd4BAqcMCUUQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYsv1-0006b0-Qw; Thu, 06 Jun 2019 15:59:03 +0200
Date:   Thu, 6 Jun 2019 15:59:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190606135903.GE19590@lunn.ch>
References: <20190605122404.GH16951@lunn.ch>
 <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
 <20190605133102.GF19627@lunn.ch>
 <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
 <20190605184724.GB19590@lunn.ch>
 <c27f2b9b-90d7-db63-f01c-2dfaef7a014b@eks-engel.de>
 <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
 <20190606133501.GC19590@lunn.ch>
 <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 03:47:06PM +0200, Benjamin Beckmeyer wrote:
> 
> On 06.06.19 15:35, Andrew Lunn wrote:
> >> >From our hardware developer I know now that we are using a "mini" SFF 
> >> which has no i2c eeprom. 
> > O.K. Does this mini SFF have LOS, TX-Disable, etc? Are these connected
> > to GPIOs? I assume the SFF is fibre? And it needs the SERDES to speak
> > 1000BaseX, not SGMII?
> 
> Nope, no LOS no tx-disable etc. Yeah, the SFF is fibre. Exactly, it needs 
> SERDES to speak 1000BaseX.

O.K. Then try something like what ZII devel B does:

                                       port@3 {
                                                reg = <3>;
                                                label = "optical3";

                                                fixed-link {
                                                        speed = <1000>;
                                                        full-duplex;
                                                };


What this does not give you is any link monitoring. I don't have the
datasheet of this device, but i assume it has two banks of registers
for the SERDES? And you can get the sync status? Similar to how the
6352 works. But with a fixed link this will be ignored.

> >> Switch				|	external
> >> Port 0 - internal serdes 0x0c --|-------Mini SFF 1x8 Transceiver
> >> 				|
> >> Port 0 - internal serdes 0x0d --|-------Mini SFF 1x8 Transceiver
> >> 				|
> >> Port 2 ----------RGMII----------|-------KSZ9031 PHY 0x02(strap)--Transceiver
> >> 				|
> >> Port 3 - internal PHY 0x03 -----|-------Transceiver
> >> 				|
> >> Port 3 - internal PHY 0x04 -----|-------Transceiver
> >> 				|			
> >> Port 5 - CPU-Port RMII ---------|-------CPU
> >> 				|
> >> Port 6 ----------RGMII----------|-------KSZ9031 PHY 0x06(strap)--Transceiver
> > So the current state is that just the SFF ports are not working? All
> > the copper PHYs are O.K.
> >
> >     Andrew
> >
> The external copper PHYs are still not working properly, but if I set them to
> fixed-link, I see data coming in with I start tcpdump on my device. Just with
> some odd header but I'm not that far with DSA-tags and these stuff.

If you build libpcap & tcpdump from the latest sources, it will
understand these headers.

	Andrew
