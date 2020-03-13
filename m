Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A031C184668
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 13:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgCMMEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 08:04:32 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51924 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgCMMEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 08:04:31 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 849271A1419;
        Fri, 13 Mar 2020 13:04:29 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 781461A13E3;
        Fri, 13 Mar 2020 13:04:29 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 111ED203CE;
        Fri, 13 Mar 2020 13:04:29 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, shawnguo@kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net 0/3] QorIQ DPAA ARM RDBs need internal delay on RGMII
Date:   Fri, 13 Mar 2020 14:04:22 +0200
Message-Id: <1584101065-3482-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

[1] u-boot patches, Madalin Bucur (3):
  net: fman: add support for all RGMII delay modes
  armv8/ls1043ardb: RGMII ports require internal delay
  armv8/ls1046ardb: RGMII ports require internal delay

Madalin Bucur (3):
  net: fsl/fman: treat all RGMII modes in memac_adjust_link()
  arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id
  arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts | 4 ++--
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 4 ++--
 drivers/net/ethernet/freescale/fman/fman_memac.c  | 5 ++++-
 3 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.1.0

