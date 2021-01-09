Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3CE2EFC85
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbhAIAyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:54:45 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41718 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbhAIAyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:54:44 -0500
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 7D30320B6C41; Fri,  8 Jan 2021 16:54:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D30320B6C41
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1610153643;
        bh=vZkq6MpowKOdehKy3jo7aQKtiNSLx1pW92qGJ62sx5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzQ4MOFlgLqYIk0wOYU6cntbpzVNSNFxZQmBCdCt4RNGMyo5MpbT3gXQ9N7mstaaA
         MgQ8gk3M9RlFWpZwk2HP8NVUkz0Ctk49Qnu2zQIfZSWCGhgSSHlAZEvvBXVcSTnsQK
         w95AxUEPxfHWFMQZxuKmA0Pcu79kL8NxT9i8tmR0=
From:   Long Li <longli@linuxonhyperv.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH v2 2/3] hv_netvsc: Wait for completion on request SWITCH_DATA_PATH
Date:   Fri,  8 Jan 2021 16:53:42 -0800
Message-Id: <1610153623-17500-3-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
References: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

The completion indicates if NVSP_MSG4_TYPE_SWITCH_DATA_PATH has been
processed by the VSP. The traffic is steered to VF or synthetic after we
receive this completion.

Signed-off-by: Long Li <longli@microsoft.com>
Reported-by: kernel test robot <lkp@intel.com>
---
Change from v1:
Fixed warnings from kernel test robot.

 drivers/net/hyperv/netvsc.c     | 37 ++++++++++++++++++++++++++++++---
 drivers/net/hyperv/netvsc_drv.c |  1 -
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 2350342b961f..3a3db2f0134d 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -37,6 +37,10 @@ void netvsc_switch_datapath(struct net_device *ndev, bool vf)
 	struct netvsc_device *nv_dev = rtnl_dereference(net_device_ctx->nvdev);
 	struct nvsp_message *init_pkt = &nv_dev->channel_init_pkt;
 
+	/* Block sending traffic to VF if it's about to be gone */
+	if (!vf)
+		net_device_ctx->data_path_is_vf = vf;
+
 	memset(init_pkt, 0, sizeof(struct nvsp_message));
 	init_pkt->hdr.msg_type = NVSP_MSG4_TYPE_SWITCH_DATA_PATH;
 	if (vf)
@@ -50,8 +54,11 @@ void netvsc_switch_datapath(struct net_device *ndev, bool vf)
 
 	vmbus_sendpacket(dev->channel, init_pkt,
 			       sizeof(struct nvsp_message),
-			       VMBUS_RQST_ID_NO_RESPONSE,
-			       VM_PKT_DATA_INBAND, 0);
+			       (unsigned long)init_pkt,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+	wait_for_completion(&nv_dev->channel_init_wait);
+	net_device_ctx->data_path_is_vf = vf;
 }
 
 /* Worker to setup sub channels on initial setup
@@ -754,8 +761,31 @@ static void netvsc_send_completion(struct net_device *ndev,
 				   const struct vmpacket_descriptor *desc,
 				   int budget)
 {
-	const struct nvsp_message *nvsp_packet = hv_pkt_data(desc);
+	const struct nvsp_message *nvsp_packet;
 	u32 msglen = hv_pkt_datalen(desc);
+	struct nvsp_message *pkt_rqst;
+	u64 cmd_rqst;
+
+	/* First check if this is a VMBUS completion without data payload */
+	if (!msglen) {
+		cmd_rqst = vmbus_request_addr(&incoming_channel->requestor,
+					      (u64)desc->trans_id);
+		if (cmd_rqst == VMBUS_RQST_ERROR) {
+			netdev_err(ndev, "Invalid transaction id\n");
+			return;
+		}
+
+		pkt_rqst = (struct nvsp_message *)(uintptr_t)cmd_rqst;
+		switch (pkt_rqst->hdr.msg_type) {
+		case NVSP_MSG4_TYPE_SWITCH_DATA_PATH:
+			complete(&net_device->channel_init_wait);
+			break;
+
+		default:
+			netdev_err(ndev, "Unexpected VMBUS completion!!\n");
+		}
+		return;
+	}
 
 	/* Ensure packet is big enough to read header fields */
 	if (msglen < sizeof(struct nvsp_message_header)) {
@@ -763,6 +793,7 @@ static void netvsc_send_completion(struct net_device *ndev,
 		return;
 	}
 
+	nvsp_packet = hv_pkt_data(desc);
 	switch (nvsp_packet->hdr.msg_type) {
 	case NVSP_MSG_TYPE_INIT_COMPLETE:
 		if (msglen < sizeof(struct nvsp_message_header) +
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 5dd4f37afa3d..64ae5f4e974e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2400,7 +2400,6 @@ static int netvsc_vf_changed(struct net_device *vf_netdev)
 
 	if (net_device_ctx->data_path_is_vf == vf_is_up)
 		return NOTIFY_OK;
-	net_device_ctx->data_path_is_vf = vf_is_up;
 
 	netvsc_switch_datapath(ndev, vf_is_up);
 	netdev_info(ndev, "Data path switched %s VF: %s\n",
-- 
2.27.0

