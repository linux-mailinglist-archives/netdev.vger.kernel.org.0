Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DAE45AA8
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfFNKjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:39:12 -0400
Received: from inva021.nxp.com ([92.121.34.21]:35992 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfFNKjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 06:39:12 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 31CED200E7D;
        Fri, 14 Jun 2019 12:39:10 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A81A12003DA;
        Fri, 14 Jun 2019 12:39:05 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 386C7402CA;
        Fri, 14 Jun 2019 18:39:00 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 0/6] Reuse ptp_qoriq driver for dpaa2-ptp
Date:   Fri, 14 Jun 2019 18:40:49 +0800
Message-Id: <20190614104055.43998-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although dpaa2-ptp.c driver is a fsl_mc_driver which
is using MC APIs for register accessing, it's same IP
block with eTSEC/DPAA/ENETC 1588 timer.
This patch-set is to convert to reuse ptp_qoriq driver by
using register ioremap and dropping related MC APIs.
However the interrupts could only be handled by MC which
fires MSIs to ARM cores. So the interrupt enabling and
handling still rely on MC APIs. MC APIs for interrupt
and PPS event support are also added by this patch-set.

---
Changes for v2:
	- Allowed to compile with COMPILE_TEST.

Yangbo Lu (6):
  ptp: add QorIQ PTP support for DPAA2
  dpaa2-ptp: reuse ptp_qoriq driver
  dt-binding: ptp_qoriq: support DPAA2 PTP compatible
  arm64: dts: fsl: add ptp timer node for dpaa2 platforms
  dpaa2-ptp: add interrupt support
  MAINTAINERS: maintain DPAA2 PTP driver in QorIQ PTP entry

 .../devicetree/bindings/ptp/ptp-qoriq.txt          |   3 +-
 MAINTAINERS                                        |   9 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |   8 +
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |   8 +
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |   8 +
 drivers/net/ethernet/freescale/dpaa2/Kconfig       |   3 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   | 242 +++++++++++----------
 drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h   |  48 +++-
 drivers/net/ethernet/freescale/dpaa2/dprtc.c       | 191 ++++++++++++----
 drivers/net/ethernet/freescale/dpaa2/dprtc.h       |  62 ++++--
 drivers/ptp/Kconfig                                |   2 +-
 11 files changed, 386 insertions(+), 198 deletions(-)

-- 
2.7.4

