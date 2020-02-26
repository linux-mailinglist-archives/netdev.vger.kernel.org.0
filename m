Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B4D16FBF3
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 11:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBZKX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 05:23:27 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45462 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZKX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 05:23:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cFVpx4YRUVFzc+9DHqfdkORwO59OSsrN3NUBEs25DtI=; b=pBc940/xSMyVKmzc+jKnvBnrl
        U0PrcS7rlhplkv3ua7fp+bCV0vStLayt37T/PKMxJPPoZ9CC2FtbD1nf25Ahb6ijldlL1CD0vDT8+
        TaHPlirnfkOxk2echaMoL9laxtU9PiSQrlMYJa6LiZ3HT7AkLFTviTFBU3ICkLO3jvBnvkoWv+x7a
        ZM6SAiQs/qso4XpcxhUwbduE4BPXzf2w37J4xqZ5nqE5ip0mEEQvEsfH/gJamCAse4G6wuKz5S8Bu
        4uVHTZiKhnnSUjWRWV2MizhLooSt7wq/Fy46vqpBNI1EnfjEEGb3EoPs4T/QHtT8T4Y9v9Y5Hq8Sh
        Savpz9BDw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45464)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j6tqY-0006rK-CP; Wed, 26 Feb 2020 10:23:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j6tqS-0008KS-I1; Wed, 26 Feb 2020 10:23:12 +0000
Date:   Wed, 26 Feb 2020 10:23:12 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux-doc@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next v2 0/8] rework phylink interface for split MAC/PCS
 support
Message-ID: <20200226102312.GX25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following series changes the phylink interface to allow us to
better support split MAC / MAC PCS setups.  The fundamental change
required for this turns out to be quite simple.

Today, mac_config() is used for everything to do with setting the
parameters for the MAC, and mac_link_up() is used to inform the
MAC driver that the link is now up (and so to allow packet flow.)
mac_config() also has had a few implementation issues, with folk
who believe that members such as "speed" and "duplex" are always
valid, where "link" gets used inappropriately, etc.

With the proposed patches, all this changes subtly - but in a
backwards compatible way at this stage.

We pass the the full resolved link state (speed, duplex, pause) to
mac_link_up(), and it is now guaranteed that these parameters to
this function will always be valid (no more SPEED_UNKNOWN or
DUPLEX_UNKNOWN here - unless phylink is fed with such things.)

Drivers should convert over to using the state in mac_link_up()
rather than configuring the speed, duplex and pause in the
mac_config() method. The patch series includes a number of MAC
drivers which I've thought have been easy targets - I've left the
remainder as I think they need maintainer input. However, *all*
drivers will need conversion for future phylink development.

v2: add ocelot/felix and qca/ar9331 DSA drivers to patch 2, add
  received tested-by so far.

 Documentation/networking/sfp-phylink.rst          |  17 +++-
 drivers/net/dsa/b53/b53_common.c                  |   4 +-
 drivers/net/dsa/b53/b53_priv.h                    |   4 +-
 drivers/net/dsa/bcm_sf2.c                         |   4 +-
 drivers/net/dsa/lantiq_gswip.c                    |   4 +-
 drivers/net/dsa/mt7530.c                          |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                  |  79 +++++++++++++----
 drivers/net/dsa/ocelot/felix.c                    |   4 +-
 drivers/net/dsa/qca/ar9331.c                      |   4 +-
 drivers/net/dsa/sja1105/sja1105_main.c            |   4 +-
 drivers/net/ethernet/cadence/macb.h               |   1 -
 drivers/net/ethernet/cadence/macb_main.c          |  57 +++++++-----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  61 ++++++++-----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   1 +
 drivers/net/ethernet/marvell/mvneta.c             |  63 ++++++++-----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c   | 102 +++++++++++++---------
 drivers/net/ethernet/mediatek/mtk_eth_soc.c       |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  37 ++++----
 drivers/net/phy/phylink.c                         |   9 +-
 include/linux/phylink.h                           |  57 ++++++++----
 include/net/dsa.h                                 |   4 +-
 net/dsa/port.c                                    |   7 +-
 23 files changed, 358 insertions(+), 180 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
