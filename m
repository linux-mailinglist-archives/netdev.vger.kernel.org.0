Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7978847D3E5
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 15:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbhLVOq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 09:46:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:2079 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343540AbhLVOq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 09:46:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640184388; x=1671720388;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pXXvBBejEF5X/NbaqsX7lZ7IENAcC8X7kUlHPaIcZZ8=;
  b=M+/Mw+ct0I6avzNw6yeVHNuvY6tJRaYIqsPYGgxNo3J1oDg/7L5q31tG
   NvMkr5ZAWqabV7YxmaMyWy1pq3lxMqRNzNQhH4mgE9mym3sPNxQAluU57
   5rxH7QDGMdHbUYQd39LunJ/G+1MROKu6+anlTXitTFCfpdlzjvQvt7xTv
   ukrU5ULCaXG3Se5/+jCwvgIUjU0J2EoRCcu686vrCeIcE4lUshmgzHiBt
   NReEbJTzpuxB27jZDshko8nuLjKmo+aujB0MkHoX3og/sAYxdoResJqkm
   UgsP6NUqLQt2F+g2xv4LMVzkX3GrKFQzFFkspeATegeURjbkJv5HXFjjo
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240435314"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="240435314"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 06:46:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="522120921"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga007.fm.intel.com with ESMTP; 22 Dec 2021 06:46:24 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 0/1] net: stmmac: add EthType Rx Frame steering
Date:   Wed, 22 Dec 2021 22:43:09 +0800
Message-Id: <20211222144310.2761661-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Now that VLAN priority RX steering issue patch [1] is merged, this is
the remaining patch from the original series to add LLDP and IEEE1588
EtherType RX frame steering in tc flower.

As before, below are the test steps for checking out the newly added
features (LLDP and PTP) together with VLAN priority:-

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

v1->v2 change:
 - change from __be16 to u16 etype
 - change ETHER_TYPE_FULL_MASK to use cpu_to_be16() macro

Thanks,
BL

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=aeb7c75cb77478fdbf821628e9c95c4baa9adc63

Ong Boon Leong (1):
  net: stmmac: add tc flower filter for EtherType matching

 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   3 +
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 121 ++++++++++++++++++
 2 files changed, 124 insertions(+)

-- 
2.25.1

