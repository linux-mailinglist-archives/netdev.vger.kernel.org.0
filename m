Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8399631B4D
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFAKpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:45:54 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:43768 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFAKpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:45:53 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x51Aji7w017184;
        Sat, 1 Jun 2019 05:45:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559385944;
        bh=oc83/WPZAKxZ5gQImeSIybMZHlJVM8DNCMv1sFjd1hU=;
        h=From:To:CC:Subject:Date;
        b=Mi8XPKWvDzQ3mg2ey+x3AjQiZbi86miCck1paLJvmkU821YROEZSu87Vfexfoo9EW
         1/2EVIU0dIzrhHJdFHUnNEO60C04a4Gi+S9bd3XGuBBNe1gvZud97vZ9jZIMGRQZ16
         L7xjaODp4d6xQoH0T7flv0qgaRjQOL7g9oPfWOps=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x51Aji0A022616
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 1 Jun 2019 05:45:44 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 1 Jun
 2019 05:45:44 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Sat, 1 Jun 2019 05:45:44 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x51AjgxX076536;
        Sat, 1 Jun 2019 05:45:43 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 00/10] net: ethernet: ti: netcp: update and enable cpts support
Date:   Sat, 1 Jun 2019 13:45:24 +0300
Message-ID: <20190601104534.25790-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

The Keystone 2 66AK2HK/E/L 1G Ethernet Switch Subsystems contains The
Common Platform Time Sync (CPTS) module which is in general compatible with
CPTS module found on TI AM3/4/5 SoCs. So, the basic support for
Keystone 2 CPTS is available by default, but not documented and has never been
enabled inconfig files.

The Keystone 2 CPTS module supports also some additional features like time
sync reference (RFTCLK) clock selection through CPTS_RFTCLK_SEL register
(offset: x08) in CPTS module, which can modelled as multiplexer clock
(this was discussed some time ago [1]).

This series adds missed binding documentation for Keystone 2 66AK2HK/E/L
CPTS module and enables CPTS for TI Keystone 2 66AK2HK/E/L SoCs with possiblity
to select CPTS reference clock.

Patch 1: adds the CPTS binding documentation. CPTS bindings are defined in the
way that allows CPTS properties to be grouped under "cpts" sub-node.
It also defines "cpts-refclk-mux" clock for CPTS RFTCLK selection.
Patches 2-3: implement CPTS properties grouping under "cpts" sub-node with
backward compatibility support.
Patch 4: adds support for time sync reference (RFTCLK) clock selection from DT
by adding support for "cpts-refclk-mux" multiplexer clock.
Patches 5-9: DT CPTS nodes update for TI Keystone 2 66AK2HK/E/L SoCs.
Patch 10: enables CPTS for TI Keystone 2 66AK2HK/E/L SoCs.

I grouped all patches in one series for better illustration of the changes,
but in general Pateches 1-4 are netdev matarieal (first) and other patches
are platform specific.

Series can be found at:
 git@git.ti.com:~gragst/ti-linux-kernel/gragsts-ti-linux-kernel.git
branch:
 net-next-k2e-cpts-refclk

[1] https://www.spinics.net/lists/netdev/msg408931.html

Grygorii Strashko (10):
  dt-bindings: doc: net: keystone-netcp: document cpts
  net: ethernet: ti: cpts: use devm_get_clk_from_child
  net: ethernet: ti: netcp_ethss: add support for child cpts node
  net: ethernet: ti: cpts: add support for ext rftclk selection
  ARM: dts: keystone-clocks: add input fixed clocks
  ARM: dts: k2e-clocks: add input ext. fixed clocks tsipclka/b
  ARM: dts: k2e-netcp: add cpts refclk_mux node
  ARM: dts: k2hk-netcp: add cpts refclk_mux node
  ARM: dts: k2l-netcp: add cpts refclk_mux node
  ARM: configs: keystone: enable cpts

 .../bindings/net/keystone-netcp.txt           | 44 ++++++++++
 arch/arm/boot/dts/keystone-clocks.dtsi        | 27 ++++++
 arch/arm/boot/dts/keystone-k2e-clocks.dtsi    | 20 +++++
 arch/arm/boot/dts/keystone-k2e-netcp.dtsi     | 21 ++++-
 arch/arm/boot/dts/keystone-k2hk-netcp.dtsi    | 20 ++++-
 arch/arm/boot/dts/keystone-k2l-netcp.dtsi     | 20 ++++-
 arch/arm/configs/keystone_defconfig           |  1 +
 drivers/net/ethernet/ti/cpts.c                | 88 ++++++++++++++++++-
 drivers/net/ethernet/ti/cpts.h                |  2 +-
 drivers/net/ethernet/ti/netcp_ethss.c         |  9 +-
 10 files changed, 240 insertions(+), 12 deletions(-)

-- 
2.17.1

