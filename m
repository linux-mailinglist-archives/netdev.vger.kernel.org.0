Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD771DF440
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387618AbgEWCvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:37985 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387582AbgEWCvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:18 -0400
IronPort-SDR: e+xQTlrkZOeuUJ8t8T47bOOj3TV6SJ2JsixUpaeZLIuAk16DOt1Uj7qI/nvtHXk8cue5cYfRV7
 UfPYrbhoVRfA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:14 -0700
IronPort-SDR: 4/jJHhecE/3cyt5fjNtcUz7cE658vZ+LxnFK2/W+Dh8fvPf/o+AxpNtje9I63e1NTEe15ulcpU
 C7Me90Ttd/Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291129"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        stable <stable@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/17] igb: Report speed and duplex as unknown when device is runtime suspended
Date:   Fri, 22 May 2020 19:51:06 -0700
Message-Id: <20200523025109.3313635-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

igb device gets runtime suspended when there's no link partner. We can't
get correct speed under that state:
$ cat /sys/class/net/enp3s0/speed
1000

In addition to that, an error can also be spotted in dmesg:
[  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost

Since device can only be runtime suspended when there's no link partner,
we can skip reading register and let the following logic set speed and
duplex with correct status.

The more generic approach will be wrap get_link_ksettings() with begin()
and complete() callbacks. However, for this particular issue, begin()
calls igb_runtime_resume() , which tries to rtnl_lock() while the lock
is already hold by upper ethtool layer.

So let's take this approach until the igb_runtime_resume() no longer
needs to hold rtnl_lock.

CC: stable <stable@vger.kernel.org>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 39d3b76a6f5d..2cd003c5ad43 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -143,7 +143,8 @@ static int igb_get_link_ksettings(struct net_device *netdev,
 	u32 speed;
 	u32 supported, advertising;
 
-	status = rd32(E1000_STATUS);
+	status = pm_runtime_suspended(&adapter->pdev->dev) ?
+		 0 : rd32(E1000_STATUS);
 	if (hw->phy.media_type == e1000_media_type_copper) {
 
 		supported = (SUPPORTED_10baseT_Half |
-- 
2.26.2

