Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE3F3E8B57
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 09:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbhHKH7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 03:59:41 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23867 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhHKH7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 03:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628668756; x=1660204756;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2I1sFJ0ys3mr6bWHkMjdng2WW6R5jCm5BM/OgXNsVnw=;
  b=pP06RRp8XtZSU/xjrrQoFIBgmvG5v/+Li67rNi5VdVIrzjGRiA36a4bg
   jocdqzY9EO4AvZepwjW9NP1WXTHTqUyjQIqjPKsAp+fPJE7FEv9UTo58O
   YNvCaxX48O2hrjBlGZG8glPICjzH0ocerop6ZoX8r4mEwgYwyv1rAf8JK
   Cs2dZ0XZQL6uoQBcEPuinJm+nwtwTwSjn16UJP1bXkYeR0y9ma0B8yadu
   wVBnA2UTYYnKNeLQ2VG5BfdSqE5dEBmXOcgK9ZF2xoVTphLOog2b5cYlQ
   JlTHAvzxvh3mv5C+qggqKv9j9qggWnpoOcJ7Kf+VTH+QYGEeEUMDFsmOR
   Q==;
IronPort-SDR: vJPKiH+0NSDVhf5P0Sb8BtpYgf6gRvqndpavqL3ImdjWG0ffORhcippPGHoPNI2mMTmCk0Mt7s
 SlFK9bTqhNqn3M95DoCiWA1zVSfw0KiY91uHOX8B6mRyF+6A+yw05rGKSbn4OJdLL86UAoXtPo
 7dPf2AMWYWinoSDQtVcQnSSV/j6QfrR1Y6xg7qd5ka5MjmKZ6EOnMygmegsUa5BjHLK5BIcqWm
 Cqy45xQ40UY4c8ziSfyOamDYYggvE3PSQ1P0CvXH64uI5Py2y2dSdmpo3B8ZAdDhXF/axIAVLj
 hTqnGhsciXaClJ9q0I4YQuQB
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="125381699"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Aug 2021 00:59:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 11 Aug 2021 00:59:15 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 11 Aug 2021 00:59:13 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH net-next 0/2] Adding Frame DMA functionality to Sparx5
Date:   Wed, 11 Aug 2021 09:59:07 +0200
Message-ID: <20210811075909.543633-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 .../ethernet/microchip/sparx5/sparx5_fdma.c   | 595 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  23 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  69 ++
 .../ethernet/microchip/sparx5/sparx5_packet.c |  13 +-
 .../ethernet/microchip/sparx5/sparx5_port.c   |   2 +-
 .../ethernet/microchip/sparx5/sparx5_port.h   |   1 +
 8 files changed, 698 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c

--
2.32.0

