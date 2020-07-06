Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19C321613C
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 00:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgGFWDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 18:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGFWDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 18:03:09 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C8AC061755;
        Mon,  6 Jul 2020 15:03:09 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BF08523E3E;
        Tue,  7 Jul 2020 00:03:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1594072986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GTdOZRgCtsBerAcEPDsCl3omcCzvJLp+94eXhttMWxc=;
        b=IFyETOCSgTdQXnjjBTGKqjNN0riYsHUNIlC3ydn/lEpuO10YrbGQAneJ4XHbO9QWG6RHdx
        mOBXHk2Uba2AyFzkl99iQx1sSbyWarAZuO80cwa54rLGR684dx54uCN00Akflsm6v+GNnE
        4L/0s3aoadD8InmMnGHpT+NXNHvGytI=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: [PATCH net-next v4 0/3] net: enetc: remove bootloader dependency
Date:   Tue,  7 Jul 2020 00:02:52 +0200
Message-Id: <20200706220255.14738-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a resend [now a new v4] of the series because the conversion to the
phylink interface will likely take longer:
https://lore.kernel.org/netdev/CA+h21hpBodyY8CtNH2ktRdc2FqPi=Fjp94=VVZvzSVbnvnfKVg@mail.gmail.com/
Also the discussion in the v3 resend doesn't look like it will be resolved
soon :/
https://lore.kernel.org/netdev/20200701213433.9217-1-michael@walle.cc/

Unfortunately, we have boards in the wild with a bootloader which doesn't
set the PCS up correctly. Thus I'd really see this patches picked up as an
intermediate step until the phylink conversion is ready. Vladimir Oltean
already offered to convert enetc to phylink when he converts the felix to
phylink. After this series the PCS setup of the enetc looks almost the same
as the current felix setup. Thus conversion should be easy.

These patches were picked from the following series:
https://lore.kernel.org/netdev/1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com/
They have never been resent. I've picked them up, addressed Andrews
comments, fixed some more bugs and asked Claudiu if I can keep their SOB
tags; he agreed. I've tested this on our board which happens to have a
bootloader which doesn't do the enetc setup in all cases. Though, only
SGMII mode was tested.

changes since v3:
 - rebased to latest net-next where devm_mdiobus_free() was removed.
   replace it by mdiobus_free(). The internal MDIO bus is optional, if
   there is any error, we try to run with the bootloader default PCS
   settings, thus in the error case, we need to free the mdiobus.

changes since v2:
 - removed SOBs from "net: enetc: Initialize SerDes for SGMII and USXGMII
   protocols" because almost everything has changed.
 - get a phy_device for the internal PCS PHY so we can use the phy_
   functions instead of raw mdiobus writes
 - reuse macros already defined in fsl_mdio.h, move missing bits from
   felix to fsl_mdio.h, because they share the same PCS PHY building
   block
 - added 2500BaseX mode (based on felix init routine)
 - changed xgmii mode to usxgmii mode, because it is actually USXGMII and
   felix does the same.
 - fixed devad, which is 0x1f (MMD_VEND2)

changes since v1:
 - mdiobus id is '"imdio-%s", dev_name(dev)' because the plain dev_name()
   is used by the emdio.
 - use mdiobus_write() instead of imdio->write(imdio, ..), since this is
   already a full featured mdiobus
 - set phy_mask to ~0 to avoid scanning the bus
 - use phy_interface_mode_is_rgmii(phy_mode) to also include the RGMII
   modes with pad delays.
 - move enetc_imdio_init() to enetc_pf.c, there shouldn't be any other
   users, should it?
 - renamed serdes to SerDes
 - printing the error code of mdiobus_register() in the error path
 - call mdiobus_unregister() on _remove()
 - call devm_mdiobus_free() if mdiobus_register() fails, since an
   error is not fatal

Alex Marginean (1):
  net: enetc: Use DT protocol information to set up the ports

Michael Walle (2):
  net: dsa: felix: move USXGMII defines to common place
  net: enetc: Initialize SerDes for SGMII and USXGMII protocols

 drivers/net/dsa/ocelot/felix_vsc9959.c        |  21 --
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   3 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 190 +++++++++++++++---
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   5 +
 include/linux/fsl/enetc_mdio.h                |  19 ++
 5 files changed, 193 insertions(+), 45 deletions(-)

-- 
2.20.1

