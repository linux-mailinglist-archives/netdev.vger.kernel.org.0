Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A51513E70D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390694AbgAPRNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:13:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390680AbgAPRNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5975246A3;
        Thu, 16 Jan 2020 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194794;
        bh=P1G9auVIUmaWNza7wK89ziQf//pzJfFobjzADmIi774=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ax557HWArn4VSmeDulL8G9NP0f7DbJB5js3D2Dn/nvLkGaThrj+RLPWM+5l7dJp9r
         a8qEHz6A56tH9WiGIUwrUix3KfN4e3P9s2Y9+LFasQYhS3i9A5Mk1ISFKRCh71c7qT
         qlKBxpvc3IvGUr8ANVxauewsFnD6dxBy5iuNF4iM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 607/671] hv_netvsc: Fix send_table offset in case of a host bug
Date:   Thu, 16 Jan 2020 12:04:05 -0500
Message-Id: <20200116170509.12787-344-sashal@kernel.org>
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

[ Upstream commit 171c1fd98df3d5948d9a9eb755274850fa5e59c6 ]

If negotiated NVSP version <= NVSP_PROTOCOL_VERSION_6, the offset may
be wrong (too small) due to a host bug. This can cause missing the
end of the send indirection table, and add multiple zero entries from
leading zeros before the data region. This bug adds extra burden on
channel 0.

So fix the offset by computing it from the data structure sizes. This
will ensure netvsc driver runs normally on unfixed hosts, and future
fixed hosts.

Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scaling (vRSS)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 68c23a64e565..dbfd3a0c97d3 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1182,6 +1182,7 @@ static int netvsc_receive(struct net_device *ndev,
 }
 
 static void netvsc_send_table(struct net_device *ndev,
+			      struct netvsc_device *nvscdev,
 			      const struct nvsp_message *nvmsg,
 			      u32 msglen)
 {
@@ -1197,6 +1198,16 @@ static void netvsc_send_table(struct net_device *ndev,
 		return;
 	}
 
+	/* If negotiated version <= NVSP_PROTOCOL_VERSION_6, the offset may be
+	 * wrong due to a host bug. So fix the offset here.
+	 */
+	if (nvscdev->nvsp_version <= NVSP_PROTOCOL_VERSION_6 &&
+	    msglen >= sizeof(struct nvsp_message_header) +
+	    sizeof(union nvsp_6_message_uber) + count * sizeof(u32))
+		offset = sizeof(struct nvsp_message_header) +
+			 sizeof(union nvsp_6_message_uber);
+
+	/* Boundary check for all versions */
 	if (offset > msglen - count * sizeof(u32)) {
 		netdev_err(ndev, "Received send-table offset too big:%u\n",
 			   offset);
@@ -1222,12 +1233,13 @@ static void netvsc_send_vf(struct net_device *ndev,
 }
 
 static void netvsc_receive_inband(struct net_device *ndev,
+				  struct netvsc_device *nvscdev,
 				  const struct nvsp_message *nvmsg,
 				  u32 msglen)
 {
 	switch (nvmsg->hdr.msg_type) {
 	case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
-		netvsc_send_table(ndev, nvmsg, msglen);
+		netvsc_send_table(ndev, nvscdev, nvmsg, msglen);
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
@@ -1260,7 +1272,7 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 		break;
 
 	case VM_PKT_DATA_INBAND:
-		netvsc_receive_inband(ndev, nvmsg, msglen);
+		netvsc_receive_inband(ndev, net_device, nvmsg, msglen);
 		break;
 
 	default:
-- 
2.20.1

