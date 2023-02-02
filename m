Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F97687A7D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjBBKoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBBKoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:44:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2F8B772;
        Thu,  2 Feb 2023 02:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334661; x=1706870661;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K8wVM1cMa8IR9e2Ua/lVlZG9gJBktVk3YV6jXWvcn3U=;
  b=STGXpUq5Rj9FLfF8sr7JyFv5k57tdp28duUhcsl6pM5dZSfLIWfsnHKM
   5NvXb102BlyJKZFX9Sskb7Ly1v0PIaCwetbcGXc0O+UVPSd41Kfr6O7Te
   BX45kNnxekgvAFmHoLy6Fe27tG8hU1IDzZgfqrQ3gj75eaooOlTsUFUj3
   we/gvFagKRJ9iZkm5Z5es0CjLjXdnnpX1sQq/LnmwjDF2NEaETSOR28/B
   LJ/TPGucdW7WT/CunBq2YmUnId7nx6QHjwvOLlbEMpkx5BUCmksuXUoqB
   iljtVlzJUsDIPmzSLjhgC6DvFzIb/qwC6P02c7POF5S0ZtOfGCBGx039a
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="199297135"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:19 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:15 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <richardcochran@gmail.com>, <casper.casan@gmail.com>,
        <horatiu.vultur@microchip.com>, <shangxiaojing@huawei.com>,
        <rmk+kernel@armlinux.org.uk>, <nhuck@google.com>,
        <error27@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 00/10] Add support for PSFP in Sparx5
Date:   Thu, 2 Feb 2023 11:43:45 +0100
Message-ID: <20230202104355.1612823-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

================================================================================
Add support for Per-Stream Filtering and Policing (802.1Q-2018, 8.6.5.1).
================================================================================

The VCAP CLM (VCAP IS0 ingress classifier) classifies streams,
identified by ISDX (Ingress Service Index, frame metadata), and maps
ISDX to streams.

Flow meters are also classified by ISDX, and implemented using service
policers (Service Dual Leacky Buckets, SDLB). Leacky buckets are linked
together in a leak chain of a leak group. Leak groups a preconfigured to serve
buckets within a certain rate interval.

Stream gates are time-based policers used by PSFP. Frames are dropped
based on the gate state (OPEN/ CLOSE), whose state will be altered based
on the Gate Control List (GCL) and current PTP time. Apart from
time-based policing, stream gates can alter egress queue selection for
the frames that pass through the Gate. This is done through Internal
Priority Selector (IPS). Stream gates are mapped from stream filters.

Support for tc actions gate and police, have been added to the VCAP IS0 set of
supported actions.

Examples:

// tc filter with gate action
$ tc filter add dev eth1 ingress chain 1100000 prio 1 handle 1001 protocol \
802.1q flower skip_sw vlan_id 100 action gate base-time 0 sched-entry open \
700000 7 8m sched-entry close 300000 action goto chain 1200000

// tc filter with police action
$ tc filter add dev eth1 ingress chain 1100000 prio 1 handle 1002 protocol \
802.1q flower skip_sw vlan_id 100 action police rate 1gbit burst 8096      \
conform-exceed drop action goto chain 1200000

================================================================================
Patches
================================================================================
Patch #1:  Adds new register needed for PSFP.
Patch #2:  Adds resource pools to control PSFP needed chip resources.
Patch #3:  Adds support for SDLB's needed for flow-meters.
Patch #4:  Adds support for service policers.
Patch #5:  Adds support for PSFP flow-meters, using service policers.
Patch #6:  Adds a new function to calculate basetime, required by flow-meters.
Patch #7:  Adds support for PSFP stream gates.
Patch #8:  Adds support for PSFP stream filters.
Patch #9:  Adds a function to initialize flow-meters, stream gates and stream
           filters.
Patch #10: Adds the required flower code to configure PSFP using the tc command.

Daniel Machon (10):
  net: microchip: add registers needed for PSFP
  net: microchip: sparx5: add resource pools
  net: microchip: sparx5: add support for Service Dual Leacky Buckets
  net: microchip: sparx5: add support for service policers
  net: microchip: sparx5: add support for PSFP flow-meters
  net: microchip: sparx5: add function for calculating PTP basetime
  net: microchip: sparx5: add support for PSFP stream gates
  net: microchip: sparx5: add support for PSFP stream filters
  net: microchip: sparx5: initialize PSFP
  sparx5: add support for configuring PSFP via tc

 .../net/ethernet/microchip/sparx5/Makefile    |   3 +-
 .../ethernet/microchip/sparx5/sparx5_main.c   |   5 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   | 125 ++++
 .../microchip/sparx5/sparx5_main_regs.h       | 581 +++++++++++++++++-
 .../ethernet/microchip/sparx5/sparx5_police.c |  53 ++
 .../ethernet/microchip/sparx5/sparx5_pool.c   |  81 +++
 .../ethernet/microchip/sparx5/sparx5_psfp.c   | 332 ++++++++++
 .../ethernet/microchip/sparx5/sparx5_ptp.c    |   3 +-
 .../ethernet/microchip/sparx5/sparx5_qos.c    |  59 ++
 .../ethernet/microchip/sparx5/sparx5_sdlb.c   | 335 ++++++++++
 .../microchip/sparx5/sparx5_tc_flower.c       | 238 ++++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    |   3 +-
 .../ethernet/microchip/vcap/vcap_api_client.h |   3 +
 13 files changed, 1808 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_police.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_pool.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c

--
2.34.1

