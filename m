Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D183E059B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhHDQNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:13:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:7251 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232604AbhHDQNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 12:13:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="193547342"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="193547342"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 09:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="569083368"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2021 09:11:18 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 4/4] net: wwan: iosm: fix recursive lock acquire in unregister
Date:   Wed,  4 Aug 2021 21:39:52 +0530
Message-Id: <20210804160952.70254-5-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
References: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling unregister_netdevice() inside wwan del link is trying to
acquire the held lock in ndo_stop_cb(). Instead, queue net dev to
be unregistered later.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index b2357ad5d517..b571d9cedba4 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -228,7 +228,7 @@ static void ipc_wwan_dellink(void *ctxt, struct net_device *dev,
 
 	RCU_INIT_POINTER(ipc_wwan->sub_netlist[if_id], NULL);
 	/* unregistering includes synchronize_net() */
-	unregister_netdevice(dev);
+	unregister_netdevice_queue(dev, head);
 
 unlock:
 	mutex_unlock(&ipc_wwan->if_mutex);
-- 
2.25.1

