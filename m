Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5A32D32A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbhCDMdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:47210 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240610AbhCDMdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:14 -0500
IronPort-SDR: ZKUP/vwU/cGdmCULgoiGcCyrRmMoS5msXYiOLD9SQ0SYO8tXPGOowP1Rab9gmu+cOEUhnEoUV2
 844eRLXd3KyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="251444241"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="251444241"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:28 -0800
IronPort-SDR: B1t1Ob8O4NRatqazlh+huIjXuO9RiwGw4fKjrYUGgAuL7EtWTs+nq3ot62AYRRg7zRxL93lTcN
 cepTXxN7nkfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="368170038"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 04 Mar 2021 04:31:26 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 2E2931F1; Thu,  4 Mar 2021 14:31:25 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 00/18] thunderbolt: Align with USB4 inter-domain and DROM specs
Date:   Thu,  4 Mar 2021 15:31:07 +0300
Message-Id: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

The latest USB4 spec [1] also includes inter-domain (peer-to-peer, XDomain)
and DROM (per-device ROM) specs. There are sligth differences between what
the driver is doing now and what the spec say so this series tries to align
the driver(s) with that. We also improve the "service" stack so that it is
possible to run multiple DMA tunnels over a single XDomain connection, and
update the two existing service drivers accordingly.

We also decrease the control channel timeout when software based connection
manager is used.

The USB4 DROM spec adds a new product descriptor that includes the device
and IDs instead of the generic entries in the Thunderbotl 1-3 DROMs. This
series updates the driver to parse this descriptor too.

[1] https://www.usb.org/document-library/usb4tm-specification

Mika Westerberg (18):
  thunderbolt: Disable retry logic for intra-domain control packets
  thunderbolt: Do not pass timeout for tb_cfg_reset()
  thunderbolt: Decrease control channel timeout for software connection manager
  Documentation / thunderbolt: Drop speed/lanes entries for XDomain
  thunderbolt: Add more logging to XDomain connections
  thunderbolt: Do not re-establish XDomain DMA paths automatically
  thunderbolt: Use pseudo-random number as initial property block generation
  thunderbolt: Align XDomain protocol timeouts with the spec
  thunderbolt: Add tb_property_copy_dir()
  thunderbolt: Add support for maxhopid XDomain property
  thunderbolt: Use dedicated flow control for DMA tunnels
  thunderbolt: Drop unused tb_port_set_initial_credits()
  thunderbolt: Allow multiple DMA tunnels over a single XDomain connection
  net: thunderbolt: Align the driver to the USB4 networking spec
  thunderbolt: Add KUnit tests for XDomain properties
  thunderbolt: Add KUnit tests for DMA tunnels
  thunderbolt: Check quirks in tb_switch_add()
  thunderbolt: Add support for USB4 DROM

 .../ABI/testing/sysfs-bus-thunderbolt         |  35 +-
 drivers/net/thunderbolt.c                     |  56 +-
 drivers/thunderbolt/ctl.c                     |  21 +-
 drivers/thunderbolt/ctl.h                     |   8 +-
 drivers/thunderbolt/dma_test.c                |  35 +-
 drivers/thunderbolt/domain.c                  |  90 ++--
 drivers/thunderbolt/eeprom.c                  | 105 +++-
 drivers/thunderbolt/icm.c                     |  34 +-
 drivers/thunderbolt/property.c                |  71 +++
 drivers/thunderbolt/switch.c                  |  26 +-
 drivers/thunderbolt/tb.c                      |  52 +-
 drivers/thunderbolt/tb.h                      |  19 +-
 drivers/thunderbolt/test.c                    | 492 ++++++++++++++++++
 drivers/thunderbolt/tunnel.c                  | 102 +++-
 drivers/thunderbolt/tunnel.h                  |   8 +-
 drivers/thunderbolt/xdomain.c                 | 416 +++++++++------
 include/linux/thunderbolt.h                   |  54 +-
 17 files changed, 1220 insertions(+), 404 deletions(-)

-- 
2.30.1

