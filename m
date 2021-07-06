Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E7B3BCD6B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhGFLVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhGFLUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F2A61C79;
        Tue,  6 Jul 2021 11:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570241;
        bh=wOVrGgzmc5xXjjsu0Ye3UynUuRmj4nk7BBzK9QZuw7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2bTvqpSpi1JbwvgsS3NoTs+u1LWpAN6n3a2ZJ/jL+2cqt3u/Vx6Cz/P/M4rneIHD
         CvfCR+uBhIxZahdii6T1NJ6dBCOwgEIOTQQ9KyOFPcGbat5YOBaDbGogafq1wg2rFh
         TxjqVGl2CLjW9+kGbIs7zav20O0JaWxK4QZECwMXCzIsTk0n2tUGJWEjeV3pcaCd6e
         9zL7JKgXTaCX3+1ECOsqC7DQsV2AjYi0IM7e5RHbyS6R9/kL1m9mbi0lUu+KGye6co
         RzW78o5ZkrwL7IP64M+tFIJGiUFdNXxivBA2vKy+XFGMMnVP14aBjrWVlRnKKwTv/T
         RQZIzMorhlXfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 142/189] net: fec: add ndo_select_queue to fix TX bandwidth fluctuations
Date:   Tue,  6 Jul 2021 07:13:22 -0400
Message-Id: <20210706111409.2058071-142-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 52c4a1a85f4b346c39c896c0168f4a843b3385ff ]

As we know that AVB is enabled by default, and the ENET IP design is
queue 0 for best effort, queue 1&2 for AVB Class A&B. Bandwidth of each
queue 1&2 set in driver is 50%, TX bandwidth fluctuated when selecting
tx queues randomly with FEC_QUIRK_HAS_AVB quirk available.

This patch adds ndo_select_queue callback to select queues for
transmitting to fix this issue. It will always return queue 0 if this is
not a vlan packet, and return queue 1 or 2 based on priority of vlan
packet.

You may complain that in fact we only use single queue for trasmitting
if we are not targeted to VLAN. Yes, but seems we have no choice, since
AVB is enabled when the driver probed, we can't switch this feature
dynamicly. After compare multiple queues to single queue, TX throughput
almost no improvement.

One way we can implemet is to configure the driver to multiple queues
with Round-robin scheme by default. Then add ndo_setup_tc callback to
enable/disable AVB feature for users. Unfortunately, ENET AVB IP seems
not follow the standard 802.1Qav spec. We only can program
DMAnCFG[IDLE_SLOPE] field to calculate bandwidth fraction. And idle
slope is restricted to certain valus (a total of 19). It's far away from
CBS QDisc implemented in Linux TC framework. If you strongly suggest to do
this, I think we only can support limited numbers of bandwidth and reject
others, but it's really urgly and wried.

With this patch, VLAN tagged packets route to queue 0/1/2 based on vlan
priority; VLAN untagged packets route to queue 0.

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 98cd38379275..8aea707a65a7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -76,6 +76,8 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
+static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
+
 /* Pause frame feild and FIFO threshold */
 #define FEC_ENET_FCE	(1 << 5)
 #define FEC_ENET_RSEM_V	0x84
@@ -3240,10 +3242,40 @@ static int fec_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static u16 fec_enet_get_raw_vlan_tci(struct sk_buff *skb)
+{
+	struct vlan_ethhdr *vhdr;
+	unsigned short vlan_TCI = 0;
+
+	if (skb->protocol == htons(ETH_P_ALL)) {
+		vhdr = (struct vlan_ethhdr *)(skb->data);
+		vlan_TCI = ntohs(vhdr->h_vlan_TCI);
+	}
+
+	return vlan_TCI;
+}
+
+static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
+				 struct net_device *sb_dev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	u16 vlan_tag;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
+		return netdev_pick_tx(ndev, skb, NULL);
+
+	vlan_tag = fec_enet_get_raw_vlan_tci(skb);
+	if (!vlan_tag)
+		return vlan_tag;
+
+	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
+}
+
 static const struct net_device_ops fec_netdev_ops = {
 	.ndo_open		= fec_enet_open,
 	.ndo_stop		= fec_enet_close,
 	.ndo_start_xmit		= fec_enet_start_xmit,
+	.ndo_select_queue       = fec_enet_select_queue,
 	.ndo_set_rx_mode	= set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= fec_timeout,
-- 
2.30.2

