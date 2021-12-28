Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D8A480D21
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhL1VEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhL1VEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:04:06 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0114FC061574;
        Tue, 28 Dec 2021 13:04:05 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n2JdX-0004I1-0i; Tue, 28 Dec 2021 22:03:59 +0100
Date:   Tue, 28 Dec 2021 21:03:44 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Lee <igvtee@gmail.com>
Subject: [PATCH v8 0/3] net: ethernet: mtk_eth_soc: refactoring and Clause 45
Message-ID: <Yct7Qje5faphdRBW@makrotopia.org>
References: <Ycr5Cna76eg2B0An@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ycr5Cna76eg2B0An@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it turned out some clean-up would be needed, first address return
value and type of mdio read and write functions in mtk_eth_soc and
generally clean up and unify both functions.
Also refactor IAC register definitions to use bitfield helper macros
to get rid of constants previously used as mask or shift values.
Then add support to access Clause 45 phy registers, using the newly
introcuced helper macros suggested by Russell King to access the
Clause 45 device and register address encoded in the 32-bit parameter.

This series is tested on MediaTek MT7622AV based Bananapi BPi-R64 board
having MediaTek MT7531BE DSA gigE switch using Clause 22 MDIO and
MediaTek MT7622BV based Ubiquiti UniFi 6 LR access point having
Aquantia AQR112C PHY using Clause 45 MDIO.

v8: add patch from Russel King, switch to bitfield helper macros
v7: remove unneeded variables and order OR-ed call parameters
v6: further clean up functions and more cleanly separate patches
v5: fix wrong variable name in first patch covered by follow-up patch
v4: clean-up return values and types, split into two commits
v3: return -1 instead of 0xffff on error in _mtk_mdio_write
v2: use MII_DEVADDR_C45_SHIFT and MII_REGADDR_C45_MASK to extract
    device id and register address. Unify read and write functions to
    have identical types and parameter names where possible as we are
    anyway already replacing both function bodies.

Daniel Golle (2):
  net: ethernet: mtk_eth_soc: fix return value and refactor MDIO ops
  net: ethernet: mtk_eth_soc: implement Clause 45 MDIO access

Russell King (Oracle) (1):
  net: mdio: add helpers to extract clause 45 regad and devad fields

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 73 ++++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 19 ++++--
 include/linux/mdio.h                        | 12 ++++
 3 files changed, 77 insertions(+), 27 deletions(-)

-- 
2.34.1

