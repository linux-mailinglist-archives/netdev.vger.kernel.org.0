Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAAA1C42D7
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgEDRcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:32:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45601 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbgEDRca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:32:30 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jVex5-0007yZ-Bd; Mon, 04 May 2020 17:32:23 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jeffrey.t.kirsher@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] igb: Report speed and duplex as unknown when device is runtime suspended
Date:   Tue,  5 May 2020 01:32:18 +0800
Message-Id: <20200504173218.1724-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

igb device gets runtime suspended when there's no link partner. We can't
get correct speed under that state:
$ cat /sys/class/net/enp3s0/speed
1000

In addition to that, an error can also be spotted in dmesg:
[  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost

Since device can only be runtime suspended when there's no link partner,
we can directly report the speed and duplex as unknown.

The more generic approach will be wrap get_link_ksettings() with begin()
and complete() callbacks. However, for this particular issue, begin()
calls igb_runtime_resume() , which tries to rtnl_lock() while the lock
is already hold by upper ethtool layer.

So let's take this approach until the igb_runtime_resume() no longer
needs to hold rtnl_lock.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 39d3b76a6f5d..b429bca4aa6a 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -143,6 +143,12 @@ static int igb_get_link_ksettings(struct net_device *netdev,
 	u32 speed;
 	u32 supported, advertising;
 
+	if (pm_runtime_suspended(&adapter->pdev->dev)) {
+		cmd->base.duplex = DUPLEX_UNKNOWN;
+		cmd->base.speed = SPEED_UNKNOWN;
+		return 0;
+	}
+
 	status = rd32(E1000_STATUS);
 	if (hw->phy.media_type == e1000_media_type_copper) {
 
-- 
2.17.1

