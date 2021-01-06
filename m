Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22A92EC5EC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbhAFV4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:56:40 -0500
Received: from mga07.intel.com ([134.134.136.100]:52550 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbhAFV4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 16:56:39 -0500
IronPort-SDR: MVP959Z5OXXL+3SGf+cxtD3zsZ1R/YWQeeCE1QyQJAXQmoTX2xF/v9Pfmt3ZMK4WXT8/LXsY0/
 ucNElwiGukIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="241418414"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="241418414"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:55:58 -0800
IronPort-SDR: iem+FgQHkwLLrKMCOXWtuhxpbVjRshZkHtM83Pm6a/eN9bzCwr0WB/r4klloZWBY0CEttHrV0e
 FIqBFOgSP9Tw==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="361734663"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:55:58 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next v1 1/2] net: core: count drops from GRO
Date:   Wed,  6 Jan 2021 13:55:38 -0800
Message-Id: <20210106215539.2103688-2-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When drivers call the various receive upcalls to receive an skb
to the stack, sometimes that stack can drop the packet. The good
news is that the return code is given to all the drivers of
NET_RX_DROP or GRO_DROP. The bad news is that no drivers except
the one "ice" driver that I changed, check the stat and increment
the dropped count. This is currently leading to packets that
arrive at the edge interface and are fully handled by the driver
and then mysteriously disappear.

Rather than fix all drivers to increment the drop stat when
handling the return code, emulate the already existing statistic
update for NET_RX_DROP events for the two GRO_DROP locations, and
increment the dev->rx_dropped associated with the skb.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8fa739259041..ef34043a9550 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6071,6 +6071,7 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
 		break;
 
 	case GRO_DROP:
+		atomic_long_inc(&skb->dev->rx_dropped);
 		kfree_skb(skb);
 		break;
 
@@ -6159,6 +6160,7 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
 		break;
 
 	case GRO_DROP:
+		atomic_long_inc(&skb->dev->rx_dropped);
 		napi_reuse_skb(napi, skb);
 		break;
 
-- 
2.29.2

