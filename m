Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1C89EC63
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbfH0PXi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 11:23:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:18033 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729836AbfH0PXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 11:23:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 08:23:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="355800525"
Received: from pgsmsx114.gar.corp.intel.com ([10.108.55.203])
  by orsmga005.jf.intel.com with ESMTP; 27 Aug 2019 08:23:35 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.25]) by
 pgsmsx114.gar.corp.intel.com ([169.254.4.237]) with mapi id 14.03.0439.000;
 Tue, 27 Aug 2019 23:23:35 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Thread-Topic: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Thread-Index: AQHVXDc1t4vgWavJu0GuD73CQMEeB6cNOWeAgAAHYgCAAdKi8A==
Date:   Tue, 27 Aug 2019 15:23:34 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814758ED8@PGSMSX103.gar.corp.intel.com>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
 <e9ece5ad-a669-6d6b-d050-c633cad15476@gmail.com>
 <20190826185418.GG2168@lunn.ch>
In-Reply-To: <20190826185418.GG2168@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Make mdiobus_scan() to try harder to look for any PHY that only
> talks C45.
> > If you are not using Device Tree or ACPI, and you are letting the MDIO
> > bus be scanned, it sounds like there should be a way for you to
> > provide a hint as to which addresses should be scanned (that's
> > mii_bus::phy_mask) and possibly enhance that with a mask of possible
> > C45 devices?
> 
> Yes, i don't like this unconditional c45 scanning. A lot of MDIO bus
> drivers don't look for the MII_ADDR_C45. They are going to do a C22
> transfer, and maybe not mask out the MII_ADDR_C45 from reg, causing an
> invalid register write. Bad things can then happen.
> 
> With DT and ACPI, we have an explicit indication that C45 should be used,
> so we know on this platform C45 is safe to use. We need something
> similar when not using DT or ACPI.
> 
> 	  Andrew

Florian and Andrew,
The mdio c22 is using the start-of-frame ST=01 while mdio c45 is using ST=00
as identifier. So mdio c22 device will not response to mdio c45 protocol.
As in IEEE 802.1ae-2002 Annex 45A.3 mention that:
" Even though the Clause 45 MDIO frames using the ST=00 frame code
will also be driven on to the Clause 22 MII Management interface,
the Clause 22 PHYs will ignore the frames. "

Hence, I am not seeing any concern that the c45 scanning will mess up with 
c22 devices.

Weifeng 


