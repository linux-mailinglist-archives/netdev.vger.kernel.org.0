Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574AF1DD562
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgEUR7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:59:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:24539 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgEUR7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:59:10 -0400
IronPort-SDR: cDoyhMz7SSkSAdW9mkv1QeVUa9UsKJ3D6QQf+tfinivpglRhVeYKQGJDbBZKnKBvKR40ERHEhJ
 FYM3J1mEpJxw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 10:59:09 -0700
IronPort-SDR: sZn8coVk+aGRy6cR7nKyBcK9tldIrd57JjTZ0zG9Tkm1tCPvh5em5kKCCCrKUbC8dxHt+bwZhG
 4+djOVlI0+qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,418,1583222400"; 
   d="scan'208";a="440543290"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga005.jf.intel.com with ESMTP; 21 May 2020 10:59:06 -0700
From:   Chen Yu <yu.c.chen@intel.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Auke Kok <auke-jan.h.kok@intel.com>,
        Jeff Garzik <jeff@garzik.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        Chen Yu <yu.c.chen@intel.com>, Stable@vger.kernel.org
Subject: [PATCH 2/2] e1000e: Make WOL info in ethtool consistent with device wake up ability
Date:   Fri, 22 May 2020 01:59:13 +0800
Message-Id: <725bad2f3ce7f7b7f1667d53b6527dc059f9e419.1590081982.git.yu.c.chen@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1590081982.git.yu.c.chen@intel.com>
References: <cover.1590081982.git.yu.c.chen@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the ethtool shows that WOL(Wake On Lan) is enabled
even if the device wakeup ability has been disabled via sysfs:
  cat /sys/devices/pci0000:00/0000:00:1f.6/power/wakeup
   disabled

  ethtool eno1
  ...
  Wake-on: g

Fix this in ethtool to check if the user has explicitly disabled the
wake up ability for this device.

Fixes: 6ff68026f475 ("e1000e: Use device_set_wakeup_enable")
Reported-by: Len Brown <len.brown@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 1d47e2503072..0cccd823ff24 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -1891,7 +1891,7 @@ static void e1000_get_wol(struct net_device *netdev,
 	wol->wolopts = 0;
 
 	if (!(adapter->flags & FLAG_HAS_WOL) ||
-	    !device_can_wakeup(&adapter->pdev->dev))
+	    !device_may_wakeup(&adapter->pdev->dev))
 		return;
 
 	wol->supported = WAKE_UCAST | WAKE_MCAST |
-- 
2.17.1

