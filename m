Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8142E46EB01
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhLIPYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:24:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:60802 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234646AbhLIPYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 10:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639063244; x=1670599244;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5y3Z4EkW334cjNowzU2gLjSyCO8Fgi+Y+RpaLAHWjAw=;
  b=b9JMY/lJyKLV+JRZPzCwLiPmxexXhj1Q2KgLn/CflG4R+87JMLp6nEWl
   ZoUaAtW0xi8VfhQdZMq3ox/mL+4EAIK2DteRSG8lAAWDgZoOXJPuHwMl1
   xxDk1GROxG5nC3dFDN+oF/0hfTCF/vnAI+G68TeJZsbDUCDqpCQroVIex
   tRZQE8fC6kr49Ev7w7MCwvsOJ8//Blif0kQd8NgQLpNEINc8UgddHBSAP
   4EYFydO3GhddfqSX4g6hmotyIn+PdTUkQmOgbCi/Eug30SnCj54DaEZHj
   byXqIx9v8YgHIKalGkxuckDJQHYp1Ogc9v7LICi6lfsUryKA6UXNV9/W+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="235631453"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="235631453"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 07:20:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="601585418"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Dec 2021 07:20:31 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 0/2] net: stmmac: add EthType Rx Frame steering
Date:   Thu,  9 Dec 2021 23:16:29 +0800
Message-Id: <20211209151631.138326-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Patch 1/2: Fixes issue in tc filter delete flower for VLAN priority
           steering. Patch has been sent to 'net' ML. Link as follow:

https://patchwork.kernel.org/project/netdevbpf/patch/20211209130335.81114-1-boon.leong.ong@intel.com/

Patch 2/2: Patch to add LLDP and IEEE1588 EtherType RX frame steering
           in tc flower that is implemented on-top of patch 1/2.

Below are the test steps for checking out the newly added feature:-

# Setup traffic class and ingress filter
$ IFDEVNAME=eth0
$ tc qdisc add dev $IFDEVNAME ingress
$ tc qdisc add dev $IFDEVNAME root mqprio num_tc 8 \
     map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
     queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0

# Add two VLAN priority based RX Frame Steering
$ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
     flower vlan_prio 1 hw_tc 1
$ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
     flower vlan_prio 2 hw_tc 2

# For LLDP
$ tc filter add dev $IFDEVNAME parent ffff: protocol 0x88cc \
     flower hw_tc 5

# For PTP
$ tc filter add dev $IFDEVNAME parent ffff: protocol 0x88f7 \
     flower hw_tc 6

# Show the ingress tc filters
$ tc filter show dev $IFDEVNAME ingress

filter parent ffff: protocol ptp pref 49149 flower chain 0
filter parent ffff: protocol ptp pref 49149 flower chain 0 handle 0x1 hw_tc 6
  eth_type 88f7
  in_hw in_hw_count 1
filter parent ffff: protocol LLDP pref 49150 flower chain 0
filter parent ffff: protocol LLDP pref 49150 flower chain 0 handle 0x1 hw_tc 5
  eth_type 88cc
  in_hw in_hw_count 1
filter parent ffff: protocol 802.1Q pref 49151 flower chain 0
filter parent ffff: protocol 802.1Q pref 49151 flower chain 0 handle 0x1 hw_tc 2
  vlan_prio 2
  in_hw in_hw_count 1
filter parent ffff: protocol 802.1Q pref 49152 flower chain 0
filter parent ffff: protocol 802.1Q pref 49152 flower chain 0 handle 0x1 hw_tc 1
  vlan_prio 1
  in_hw in_hw_count 1

# Delete tc filters
$ tc filter del dev $IFDEVNAME parent ffff: pref 49149
$ tc filter del dev $IFDEVNAME parent ffff: pref 49150
$ tc filter del dev $IFDEVNAME parent ffff: pref 49151
$ tc filter del dev $IFDEVNAME parent ffff: pref 49152

Thanks,
BL

Ong Boon Leong (2):
  net: stmmac: fix tc flower deletion for VLAN priority Rx steering
  net: stmmac: add tc flower filter for EtherType matching

 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  20 ++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 189 +++++++++++++++++-
 2 files changed, 205 insertions(+), 4 deletions(-)

-- 
2.25.1

