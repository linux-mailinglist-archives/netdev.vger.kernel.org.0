Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A42116E1C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfLINnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:43:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfLINnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 08:43:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pk0KyT5G1CnUyogiQaj5MmGP9BYTp+qHde9CkGvk/qM=; b=VqGpcks2P2oOh3/URMEKxJpz6f
        kQwdrTmJxPeUF8qe33lCRhuNflyH4pLpXARxFPobr3Y9BJVMgp0ia8gkzm0KstDxm8fE9Vxl+WaJw
        +gUqWD8OWNM0cMd12m2/AklKb86tqK1G2jH+yTMOwRuuwJyZwRCT2DlPtGdMIr3Ju3AI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieJK4-0005Pi-Tb; Mon, 09 Dec 2019 14:43:36 +0100
Date:   Mon, 9 Dec 2019 14:43:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?J=FCrgen?= Lambrecht <j.lambrecht@televic.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
Message-ID: <20191209134336.GC9099@lunn.ch>
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
 <20191204153804.GD21904@lunn.ch>
 <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
 <20191204171336.GF21904@lunn.ch>
 <5851b137-2a3f-f8b3-cd0a-6efc2b7df67d@televic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5851b137-2a3f-f8b3-cd0a-6efc2b7df67d@televic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> A strange thing to me however is why - in my dts and in
> vf610-zii-ssmb-spu3.dts - there is 2 times a 'fixed-link'
> declaration? Moreover, when I omit the first declaration, the kernel
> crashes (oops).

The FEC driver expect there to be a PHY connected to the MAC, and the
PHY should indicate what speed the link is running at. However, the
FEC is directly connected to the switch, there is no PHY involved. To
keep the FEC happy, and to tell it what speed to use, a fixed-link PHY
is used. It uses the same API as a real PHY, and indicates the link is
using the speed as defined in DT. So the FEC runs at 100Mbps.

The DSA driver defaults to configuring the CPU port at its maximum
speed. For this chip, that is 1Gbps. However, the Vybrid FEC can only
support 100Mbps. So we need to force the CPU port to the slower
speed. Hence the fixed link in the CPU node.

       Andrew
