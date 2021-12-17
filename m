Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09B247884A
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 10:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbhLQJ5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 04:57:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234606AbhLQJ5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 04:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=P8vu941TiN6tCdSvqJMJibtGaeU1S6bCMZuljNcTpxc=; b=oN
        w+wdRoSTS7/3PHNQUGLSzzqPpCEIBqzgUqa+RsZMggRVqg3EOGGwdXw5CS0auUzgCmvKBitNs3b6v
        +ny8HYkBRwPEvHQVlPqZA4rWFp2qMefwGXjZCD79UdUbrvhLsQ+4YrawSqy63yzjVCVAiomSnHKEh
        if1qJBaH9FPN0bY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1my9zW-00GoqG-6D; Fri, 17 Dec 2021 10:57:30 +0100
Date:   Fri, 17 Dec 2021 10:57:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     KARL_TSOU =?utf-8?B?KOmEkuejiik=?= <KARL_TSOU@ubiqconn.com>
Cc:     "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: microchip: Add supported ksz9897 port6
Message-ID: <YbxfCkstuBOVI2e0@lunn.ch>
References: <HK2PR03MB43070C126204965988B2299DE0779@HK2PR03MB4307.apcprd03.prod.outlook.com>
 <YbsSHSmxrZZ4jhvD@lunn.ch>
 <HK2PR03MB430766D15AD96E3F0E52A3D3E0789@HK2PR03MB4307.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <HK2PR03MB430766D15AD96E3F0E52A3D3E0789@HK2PR03MB4307.apcprd03.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 02:53:15AM +0000, KARL_TSOU (鄒磊) wrote:
> The Microchip switch ksz9897 support 7 physical port, port 0/1/2/3/4 connect to standard RJ45, port5 connect to PHY via MII to CPU and port6 connect to PHY via RMII (PHY ksz8081) on my custom board.

Please don't top post. Also, wrap your emails so lines around 70
characters.

> I am facing a problem that I am not able to verify port6 via ping command even though the link is up, port 0/1/2/3/4 are all works fine by verifying with ping command expect port6
> 
> When I go through port initialization code, a "if condition" below that aren't included port6 initialization.

This initialization is for the internal PHYs. They have to
exist. External PHYs the switch driver should not assume exist. You
normally connect to the CPU directly, not via back to back PHYs. Any
there could be boards which use port 6 direct to the CPU without a
PHY. So this change as is, is wrong.

You should be using a phy-handle in DT for port6, or port5, to
indicate if a PHY is connected to the port. Do you have this property?

	 Andrew
