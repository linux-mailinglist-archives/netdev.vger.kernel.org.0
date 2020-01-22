Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0707C145618
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbgAVNUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:20:47 -0500
Received: from inva020.nxp.com ([92.121.34.13]:41664 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbgAVNUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:46 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F4091A3D33;
        Wed, 22 Jan 2020 14:20:44 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 735911A294D;
        Wed, 22 Jan 2020 14:20:44 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2DD5420364;
        Wed, 22 Jan 2020 14:20:44 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net 0/3] net: fsl/fman: address erratum A011043
Date:   Wed, 22 Jan 2020 15:20:26 +0200
Message-Id: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses a HW erratum on some QorIQ DPAA devices.

MDIO reads to internal PCS registers may result in having
the MDIO_CFG[MDIO_RD_ER] bit set, even when there is no
error and read data (MDIO_DATA[MDIO_DATA]) is correct.
Software may get false read error when reading internal
PCS registers through MDIO. As a workaround, all internal
MDIO accesses should ignore the MDIO_CFG[MDIO_RD_ER] bit.
When the issue was present, one could see such errors
during boot:

  mdio_bus ffe4e5000: Error while reading PHY0 reg at 3.3

Madalin Bucur (3):
  dt-bindings: net: add fsl,erratum-a011043
  powerpc/fsl/dts: add fsl,erratum-a011043
  net/fsl: treat fsl,erratum-a011043

 Documentation/devicetree/bindings/net/fsl-fman.txt          | 13 +++++++++++++
 .../boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi       |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi          |  1 +
 .../boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi       |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi          |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi          |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi          |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi           |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi           |  1 +
 drivers/net/ethernet/freescale/xgmac_mdio.c                 |  7 ++++++-
 20 files changed, 37 insertions(+), 1 deletion(-)

-- 
2.1.0

