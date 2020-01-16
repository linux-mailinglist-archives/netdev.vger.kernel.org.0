Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F54713E719
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391631AbgAPRXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:23:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390675AbgAPRNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE71246A1;
        Thu, 16 Jan 2020 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194793;
        bh=ehDilNBaQ7ioHNWBkQv3nZNPqi7lYIsdtoEDGrrd5zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Orw2f7ut7xGDz/K/YPyEJaEZMF5U0ws59itN0Aj15PMziDmKw9PYzbAJg2SvnPOEc
         lhfvAU63Kw2+GNyIjlMqu30iTYjZyDb6+P61Nx+7+cKKLwXWfloKd+7ZijA4HUPKeF
         g2WeXkDY/4N6wygyIlVKYKWY4V8n9lX9TeKqiqB4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 606/671] hv_netvsc: Fix offset usage in netvsc_send_table()
Date:   Thu, 16 Jan 2020 12:04:04 -0500
Message-Id: <20200116170509.12787-343-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 71f21959dd5516031db4f011e15e9a9508b93a7d ]

To reach the data region, the existing code adds offset in struct
nvsp_5_send_indirect_table on the beginning of this struct. But the
offset should be based on the beginning of its container,
struct nvsp_message. This bug causes the first table entry missing,
and adds an extra zero from the zero pad after the data region.
This can put extra burden on the channel 0.

So, correct the offset usage. Also add a boundary check to ensure
not reading beyond data region.

Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scaling (vRSS)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/hyperv_net.h |  3 ++-
 drivers/net/hyperv/netvsc.c     | 26 ++++++++++++++++++--------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 50709c76b672..dfa801315da6 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -616,7 +616,8 @@ struct nvsp_5_send_indirect_table {
 	/* The number of entries in the send indirection table */
 	u32 count;
 
-	/* The offset of the send indirection table from top of this struct.
+	/* The offset of the send indirection table from the beginning of
+	 * struct nvsp_message.
 	 * The send indirection table tells which channel to put the send
 	 * traffic on. Each entry is a channel number.
 	 */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 35413041dcf8..68c23a64e565 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1182,20 +1182,28 @@ static int netvsc_receive(struct net_device *ndev,
 }
 
 static void netvsc_send_table(struct net_device *ndev,
-			      const struct nvsp_message *nvmsg)
+			      const struct nvsp_message *nvmsg,
+			      u32 msglen)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(ndev);
-	u32 count, *tab;
+	u32 count, offset, *tab;
 	int i;
 
 	count = nvmsg->msg.v5_msg.send_table.count;
+	offset = nvmsg->msg.v5_msg.send_table.offset;
+
 	if (count != VRSS_SEND_TAB_SIZE) {
 		netdev_err(ndev, "Received wrong send-table size:%u\n", count);
 		return;
 	}
 
-	tab = (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
-		      nvmsg->msg.v5_msg.send_table.offset);
+	if (offset > msglen - count * sizeof(u32)) {
+		netdev_err(ndev, "Received send-table offset too big:%u\n",
+			   offset);
+		return;
+	}
+
+	tab = (void *)nvmsg + offset;
 
 	for (i = 0; i < count; i++)
 		net_device_ctx->tx_table[i] = tab[i];
@@ -1213,12 +1221,13 @@ static void netvsc_send_vf(struct net_device *ndev,
 		    net_device_ctx->vf_alloc ? "added" : "removed");
 }
 
-static  void netvsc_receive_inband(struct net_device *ndev,
-				   const struct nvsp_message *nvmsg)
+static void netvsc_receive_inband(struct net_device *ndev,
+				  const struct nvsp_message *nvmsg,
+				  u32 msglen)
 {
 	switch (nvmsg->hdr.msg_type) {
 	case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
-		netvsc_send_table(ndev, nvmsg);
+		netvsc_send_table(ndev, nvmsg, msglen);
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
@@ -1235,6 +1244,7 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 				  int budget)
 {
 	const struct nvsp_message *nvmsg = hv_pkt_data(desc);
+	u32 msglen = hv_pkt_datalen(desc);
 
 	trace_nvsp_recv(ndev, channel, nvmsg);
 
@@ -1250,7 +1260,7 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 		break;
 
 	case VM_PKT_DATA_INBAND:
-		netvsc_receive_inband(ndev, nvmsg);
+		netvsc_receive_inband(ndev, nvmsg, msglen);
 		break;
 
 	default:
-- 
2.20.1

