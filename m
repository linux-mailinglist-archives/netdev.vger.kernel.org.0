Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C3E27B96F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgI2Bam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbgI2Bal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DABE2075A;
        Tue, 29 Sep 2020 01:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343040;
        bh=SkAevMX0AQ16E9HWC5gR5DJK2U4ukXo/alNGHNGHc5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9/yeHwKSbey6pMHrmwKju2WwWoeLnTUZMltKkoJVplFWB0vZBO5o4pWciLRtSdIX
         HiPLJ3aFzGWSsltBPLE+CY2FLWkaGxUqeWUn3agbQhBi29jyblUwf3Cx/RG8tkkJJP
         d2MhIGS660ATatp1WfHL2RJdwVpUJ9WKO8g8sJZc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 09/29] hv_netvsc: Cache the current data path to avoid duplicate call and message
Date:   Mon, 28 Sep 2020 21:30:06 -0400
Message-Id: <20200929013027.2406344-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit da26658c3d7005aa67a706dceff7b2807b59e123 ]

The previous change "hv_netvsc: Switch the data path at the right time
during hibernation" adds the call of netvsc_vf_changed() upon
NETDEV_CHANGE, so it's necessary to avoid the duplicate call and message
when the VF is brought UP or DOWN.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/hyperv_net.h |  3 +++
 drivers/net/hyperv/netvsc_drv.c | 21 ++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index abda736e7c7dc..a4d2dd2637e26 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -973,6 +973,9 @@ struct net_device_context {
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
 
+	/* Is the current data path through the VF NIC? */
+	bool  data_path_is_vf;
+
 	/* Used to temporarily save the config info across hibernation */
 	struct netvsc_device_info *saved_netvsc_dev_info;
 };
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8309194b351a9..329eff3250b23 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2323,7 +2323,16 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	return NOTIFY_OK;
 }
 
-/* VF up/down change detected, schedule to change data path */
+/* Change the data path when VF UP/DOWN/CHANGE are detected.
+ *
+ * Typically a UP or DOWN event is followed by a CHANGE event, so
+ * net_device_ctx->data_path_is_vf is used to cache the current data path
+ * to avoid the duplicate call of netvsc_switch_datapath() and the duplicate
+ * message.
+ *
+ * During hibernation, if a VF NIC driver (e.g. mlx5) preserves the network
+ * interface, there is only the CHANGE event and no UP or DOWN event.
+ */
 static int netvsc_vf_changed(struct net_device *vf_netdev)
 {
 	struct net_device_context *net_device_ctx;
@@ -2340,6 +2349,10 @@ static int netvsc_vf_changed(struct net_device *vf_netdev)
 	if (!netvsc_dev)
 		return NOTIFY_DONE;
 
+	if (net_device_ctx->data_path_is_vf == vf_is_up)
+		return NOTIFY_OK;
+	net_device_ctx->data_path_is_vf = vf_is_up;
+
 	netvsc_switch_datapath(ndev, vf_is_up);
 	netdev_info(ndev, "Data path switched %s VF: %s\n",
 		    vf_is_up ? "to" : "from", vf_netdev->name);
@@ -2582,6 +2595,12 @@ static int netvsc_resume(struct hv_device *dev)
 	rtnl_lock();
 
 	net_device_ctx = netdev_priv(net);
+
+	/* Reset the data path to the netvsc NIC before re-opening the vmbus
+	 * channel. Later netvsc_netdev_event() will switch the data path to
+	 * the VF upon the UP or CHANGE event.
+	 */
+	net_device_ctx->data_path_is_vf = false;
 	device_info = net_device_ctx->saved_netvsc_dev_info;
 
 	ret = netvsc_attach(net, device_info);
-- 
2.25.1

