Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95242EB784
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 02:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbhAFBRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 20:17:12 -0500
Received: from linux.microsoft.com ([13.77.154.182]:54220 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbhAFBRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 20:17:12 -0500
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 362A720B6C40; Tue,  5 Jan 2021 17:16:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 362A720B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1609895791;
        bh=J27Hds4U/M4ptj2TT0oSpKhTx9p3VcyEZL2xvX1ifrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O24FFHKEK6sKAgdhBHr67UGKExbVKQsvQU8Spjq7IbWyKO2gyfDe4YRUJrYYSm92/
         VbMoF+FI2WLNigHV4yg1kGw/+QhE8WE9BFSHvyhR5bPfUyU7PgZ4rOOrW8y0mCKyqu
         I/uGCLE/j5zJa8hiW4r+u6U7JBUKqtC42i4iJ5rM=
From:   Long Li <longli@linuxonhyperv.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 2/3] hv_netvsc: Wait for completion on request NVSP_MSG4_TYPE_SWITCH_DATA_PATH
Date:   Tue,  5 Jan 2021 17:15:52 -0800
Message-Id: <1609895753-30445-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609895753-30445-1-git-send-email-longli@linuxonhyperv.com>
References: <1609895753-30445-1-git-send-email-longli@linuxonhyperv.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

The completion indicates if NVSP_MSG4_TYPE_SWITCH_DATA_PATH has been
processed by the VSP. The traffic is steered to VF or synthetic after we
receive this completion.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/hyperv/netvsc.c     | 34 +++++++++++++++++++++++++++++++--
 drivers/net/hyperv/netvsc_drv.c |  1 -
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 2350342b961f..237e998d21d1 100644
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
@@ -756,6 +763,29 @@ static void netvsc_send_completion(struct net_device *ndev,
 {
 	const struct nvsp_message *nvsp_packet = hv_pkt_data(desc);
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
+		pkt_rqst = (struct nvsp_message *)cmd_rqst;
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

