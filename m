Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47D714A6EC
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgA0PHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:07:55 -0500
Received: from inva021.nxp.com ([92.121.34.21]:40780 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgA0PHz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 10:07:55 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5615A2177D8;
        Mon, 27 Jan 2020 16:07:54 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4949921779C;
        Mon, 27 Jan 2020 16:07:54 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EF8AD205A3;
        Mon, 27 Jan 2020 16:07:53 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH v2 0/2] net: phy: aquantia: indicate rate adaptation
Date:   Mon, 27 Jan 2020 17:07:49 +0200
Message-Id: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v1:
  rewrote commit messages to evidentiate that this is a PHY
  generic feature, not a particular feature of the Aquantia
  PHYs and added more details on how the 1G link issue this
  is circumventing came about.

This patch-set introduces a bit into the phy_device
structure to indicate the PHYs ability to do rate
adaptation between the system and line interfaces and
sets this bit for the Aquantia PHYs that have this feature.

By taking into account the presence of the said bit, address
an issue with the LS1046ARDB board 10G interface no longer
working with an 1G link partner after autonegotiation support
was added for the Aquantia PHY on board in

commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")

Before this commit the values advertised by the PHY were not
influenced by the dpaa_eth driver removal of system-side unsupported
modes as the aqr_config_aneg() was basically a no-op. After this
commit, the modes removed by the dpaa_eth driver were no longer
advertised thus autonegotiation with 1G link partners failed.

Madalin Bucur (2):
  net: phy: aquantia: add rate_adaptation indication
  dpaa_eth: support all modes with rate adapting PHYs

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 +++++++---
 drivers/net/phy/aquantia_main.c                |  3 +++
 include/linux/phy.h                            |  3 +++
 3 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.1.0

