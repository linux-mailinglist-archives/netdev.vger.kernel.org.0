Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78523F146C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhHSHk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:40:27 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:28431 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbhHSHk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1629358792; x=1660894792;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=885MxSHelX5rvkgIZxlOgJCLdDgWmPQvxD6ASda6ECU=;
  b=afii0h+RQAf4zJ5bCtjZfurQ2X2zu1DUApAZbN56K1DA2pstBGogUzvi
   KIL/r+zFgUi7zH9kqwxnj0oN5bpB27xZRNKh0P2dlcdcixsMSkEN1hzaE
   bDQ88gWFEJASJcY64DoMBWhu5mA5Qyorb25NoBCyVCo83bXGXRmWgt4dF
   tRqdA0dmxwr3tt7LVfQtaXvPgUjOXwCVPZnSqgRbzYwUrFg/9WXOJaZSH
   HNOW0y2+ywOmD1SSTAdaTVxaBT0zT+/MUJB2A+fTaDctiLM3E7Mzin9do
   2l7CSjflkanhsWpWKcm37NIRiU4B2aIrvH1h1MxVU9DXZkaXybhS8hNSg
   Q==;
IronPort-SDR: NWEtWH4zsgK4Mz+fXa0FrlvbpavxFqPrK00OrxFNEuamwDTKe54dZ9/9sgMLFTfE3u3W/Fe4NX
 2zEiXAwRtoEdRwDUgLv6034G+KS4hylDwnMX99GHcihdSWMT+GgM/PLu1PAUOM46EdyxTlJQ7+
 ftT7qLGOmYwY9PLIlb1nNt3GyCd3RzUDxc4HHGe0jSrlDg7HXb94OxOTex8hXAreUup4VBCZq+
 kalA0jvIOw79czpIEyTgOedIyU40VhbfcMYAbE5w+D2ZTGmwxbMx2CgOMcqkUeE8F/wbJ52bnL
 Uza26TanFGLOoTY4TrkSLgus
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="132845405"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Aug 2021 00:39:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 19 Aug 2021 00:39:49 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 19 Aug 2021 00:39:47 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH net-next v2 0/2] Adding Frame DMA functionality to Sparx5
Date:   Thu, 19 Aug 2021 09:39:38 +0200
Message-ID: <20210819073940.1589383-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
    Removed an unused variable (proc_ctrl) from sparx5_fdma_start.

This add frame DMA functionality to the Sparx5 platform.

Until now the Sparx5 SwitchDev driver has been using register based
injection and extraction when sending frames to/from the host CPU.

With this series the Frame DMA functionality now added.

The Frame DMA is only used if the Frame DMA interrupt is configured in the
device tree; otherwise the existing register based injection and extraction
is used.

The Sparx5 has two ports that can be used for sending and receiving frames,
but there are 8 channels that can be configured: 6 for injection and 2 for
extraction.

The additional channels can be used for more advanced scenarios e.g. where
virtual cores are used, but currently the driver only uses port 0 and
channel 0 and 6 respectively.

DCB (data control block) structures are passed to the Frame DMA with
suitable information about frame start/end etc, as well as pointers to DB
(data blocks) buffers.

The Frame DMA engine can use interrupts to signal back when the frames have
been injected or extracted.

There is a limitation on the DB alignment also for injection: Block must
start on 16byte boundaries, and this is why the driver currently copies the
data to into separate buffers.

The Sparx5 switch core needs a IFH (Internal Frame Header) to pass
information from the port to the switch core, and this header is added
before injection and stripped after extraction.

Steen Hegelund (2):
  net: sparx5: switchdev: adding frame DMA functionality
  arm64: dts: sparx5: Add the Sparx5 switch frame DMA support

 arch/arm64/boot/dts/microchip/sparx5.dtsi     |   5 +-
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_fdma.c   | 593 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  23 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  69 ++
 .../ethernet/microchip/sparx5/sparx5_packet.c |  13 +-
 .../ethernet/microchip/sparx5/sparx5_port.c   |   2 +-
 .../ethernet/microchip/sparx5/sparx5_port.h   |   1 +
 8 files changed, 696 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c

-- 
2.32.0

