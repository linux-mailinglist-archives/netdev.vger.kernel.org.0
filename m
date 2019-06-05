Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94FC35FDF
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfFEPHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbfFEPHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 11:07:12 -0400
Received: from localhost.localdomain (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70967206B8;
        Wed,  5 Jun 2019 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559747232;
        bh=jTuxwfiyzlsodkekfsVqkS5weGze46oKt3QO2PxxZY0=;
        h=From:To:Cc:Subject:Date:From;
        b=PX4xbXsX040MmeYF2bNX6uKAbUwyW/fcFzjfX18GtHrjE3G/dtHw1tl+tAS1KWqCj
         RIhxHVe4vCoiCC0HBtPF1BshJbbXZYn6TQNsSmnn2F/Iv+uuHYWo99yXSGtLYvgkOS
         1+wDLozxca9hC4MUZeUVtQ8qR4V1hYkHMZbfYpuA=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     netdev@vger.kernel.org
Cc:     dinguyen@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        davem@davemloft.net, dalon.westergreen@intel.com
Subject: [PATCH 1/2] dt-bindings: socfpga-dwmac: add "altr,socfpga-stmmac-a10-s10" binding
Date:   Wed,  5 Jun 2019 10:05:50 -0500
Message-Id: <20190605150551.12791-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the "altr,socfpga-stmmac-a10-s10" binding for Arria10/Agilex/Stratix10
implementation of the stmmac ethernet controller.

On the Arria10, Agilex, and Stratix10 SoCs, there are a few differences from
the Cyclone5 and Arria5:
     - The emac PHY setup bits are in separate registers.
     - The PTP reference clock select mask is different.
     - The register to enable the emac signal from FPGA is different.

Because of these differences, the dwmac-socfpga glue logic driver will
use this new binding to set the appropriate bits for PHY, PTP reference
clock, and signal from FPGA.

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 .../devicetree/bindings/net/socfpga-dwmac.txt          | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/socfpga-dwmac.txt b/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
index 17d6819669c8..612a8e8abc88 100644
--- a/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
@@ -6,11 +6,17 @@ present in Documentation/devicetree/bindings/net/stmmac.txt.
 The device node has additional properties:
 
 Required properties:
- - compatible	: Should contain "altr,socfpga-stmmac" along with
-		  "snps,dwmac" and any applicable more detailed
+ - compatible	: For Cyclone5/Arria5 SoCs it should contain
+		  "altr,socfpga-stmmac". For Arria10/Agilex/Stratix10 SoCs
+		  "altr,socfpga-stmmac-a10-s10".
+		  Along with "snps,dwmac" and any applicable more detailed
 		  designware version numbers documented in stmmac.txt
  - altr,sysmgr-syscon : Should be the phandle to the system manager node that
    encompasses the glue register, the register offset, and the register shift.
+   On Cyclone5/Arria5, the register shift represents the PHY mode bits, while
+   on the Arria10/Stratix10/Agilex platforms, the register shift represents
+   bit for each emac to enable/disable signals from the FPGA fabric to the
+   EMAC modules.
  - altr,f2h_ptp_ref_clk use f2h_ptp_ref_clk instead of default eosc1 clock
    for ptp ref clk. This affects all emacs as the clock is common.
 
-- 
2.20.0

