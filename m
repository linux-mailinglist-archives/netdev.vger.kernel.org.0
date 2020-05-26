Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793DE1E32F9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391734AbgEZWvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390388AbgEZWvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:51:13 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532ABC061A0F;
        Tue, 26 May 2020 15:51:13 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4BBB52304C;
        Wed, 27 May 2020 00:51:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590533471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AhPiYjAu0nngaams1opch4LrZG/bNldjM7CNAO3Dyqc=;
        b=MfIOl0yrxRPEJTv5pNElXPlP2Az8rndkXB26zsouASCQdlUAzGDcI48F04REOoUN4bpWLe
        pV2zSHCb72ZQ11A4XE7geH67rcDvn7MeZLU8M1nXDz+FzwI6PQw7eRJFtfo/FzmJfG0SEe
        zTNUIulJrbNSbtWklS9tlOBw/YgLivQ=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next v2 0/2] net: enetc: remove bootloader dependency
Date:   Wed, 27 May 2020 00:50:48 +0200
Message-Id: <20200526225050.5997-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches were picked from the following series:
https://lore.kernel.org/netdev/1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com/
They have never been resent. I've picked them up, addressed Andrews
comments, fixed some more bugs and asked Claudiu if I can keep their SOB
tags; he agreed. I've tested this on our board which happens to have a
bootloader which doesn't do the enetc setup in all cases.

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

Claudiu Manoil (1):
  net: enetc: Initialize SerDes for SGMII and SXGMII protocols

 .../net/ethernet/freescale/enetc/enetc_hw.h   |  17 ++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 151 +++++++++++++++---
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   4 +
 3 files changed, 148 insertions(+), 24 deletions(-)

-- 
2.20.1

