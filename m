Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471CE3B4B8E
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 02:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFZAgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 20:36:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:48448 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhFZAgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 20:36:03 -0400
IronPort-SDR: HNuQT8kGKLcWrV+vzlLW6TkmXjm8VozuhB6SMTL/x7J7kTQL8VpY25mqsE+VaUbh2vnRu+Wv0r
 zwjPJHJBL9mQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="195054019"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="195054019"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:41 -0700
IronPort-SDR: HJfPt6Zxe0EexBOf+dDXT95xJNvYqUGb9b87MbYwnYALwon/s80hAaqU/1tXPt/yMFzXoD1Umv
 qt5A+khHS4lw==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="557008603"
Received: from aschmalt-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.160.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:41 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v4 03/12] core: Introduce netdev_tc_map_to_queue_mask()
Date:   Fri, 25 Jun 2021 17:33:05 -0700
Message-Id: <20210626003314.3159402-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210626003314.3159402-1-vinicius.gomes@intel.com>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Converts from a bitmask specifying traffic classes (bit 0 for traffic
class (TC) 0, bit 1 for TC 1, and so on) to a bitmask for queues. The
conversion is done using the netdev.tc_to_txq map.

netdev_tc_map_to_queue_mask() first users will be the mqprio and
taprio qdiscs.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index af5d4c5b0ad5..dcff0b9a55ab 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2279,6 +2279,7 @@ int netdev_txq_to_tc(struct net_device *dev, unsigned int txq);
 void netdev_reset_tc(struct net_device *dev);
 int netdev_set_tc_queue(struct net_device *dev, u8 tc, u16 count, u16 offset);
 int netdev_set_num_tc(struct net_device *dev, u8 num_tc);
+u32 netdev_tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask);
 
 static inline
 int netdev_get_num_tc(struct net_device *dev)
diff --git a/net/core/dev.c b/net/core/dev.c
index 991d09b67bd9..4b25dbd26243 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2956,6 +2956,26 @@ int netdev_set_num_tc(struct net_device *dev, u8 num_tc)
 }
 EXPORT_SYMBOL(netdev_set_num_tc);
 
+u32 netdev_tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
+{
+	u32 i, queue_mask = 0;
+
+	for (i = 0; i < dev->num_tc; i++) {
+		u32 offset, count;
+
+		if (!(tc_mask & BIT(i)))
+			continue;
+
+		offset = dev->tc_to_txq[i].offset;
+		count = dev->tc_to_txq[i].count;
+
+		queue_mask |= GENMASK(offset + count - 1, offset);
+	}
+
+	return queue_mask;
+}
+EXPORT_SYMBOL(netdev_tc_map_to_queue_mask);
+
 void netdev_unbind_sb_channel(struct net_device *dev,
 			      struct net_device *sb_dev)
 {
-- 
2.32.0

