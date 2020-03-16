Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB763186A8D
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbgCPMGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:06:03 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54698 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730907AbgCPMGD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 08:06:03 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 74E602009D1;
        Mon, 16 Mar 2020 13:06:01 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 65C012009D0;
        Mon, 16 Mar 2020 13:06:01 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0802920414;
        Mon, 16 Mar 2020 13:06:00 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, shawnguo@kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net v2 0/3] QorIQ DPAA ARM RDBs need internal delay on RGMII
Date:   Mon, 16 Mar 2020 14:05:55 +0200
Message-Id: <1584360358-8092-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: used phy_interface_mode_is_rgmii() to identify RGMII

The QorIQ DPAA 1 based RDB boards require internal delay on
both Tx and Rx to be set. The patch set ensures all RGMII
modes are treated correctly by the FMan driver and sets the
phy-connection-type to "rgmii-id" to restore functionality.
Previously Rx internal delay was set by board pull-ups and
was left untouched by the PHY driver. Since commit
1b3047b5208a80 ("net: phy: realtek: add support for
configuring the RX delay on RTL8211F") the Realtek 8211F PHY
driver has control over the RGMII RX delay and it is
disabling it for other modes than RGMII_RXID and RGMII_ID.

Please note that u-boot in particular performs a fix-up of
the PHY connection type and will overwrite the values from
the Linux device tree. Another patch set was sent for u-boot
and one needs to apply that [1] to the boot loader, to ensure
this fix is complete, unless a different bootloader is used.

Madalin Bucur (3):
  net: fsl/fman: treat all RGMII modes in memac_adjust_link()
  arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id
  arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts | 4 ++--
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 4 ++--
 drivers/net/ethernet/freescale/fman/fman_memac.c  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.1.0

