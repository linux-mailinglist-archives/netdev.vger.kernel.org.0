Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F75F364634
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbhDSOfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhDSOfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 10:35:34 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B00C061763;
        Mon, 19 Apr 2021 07:35:03 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lYUzJ-0000xj-5d; Mon, 19 Apr 2021 17:34:57 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next 4/4] atl1c: enable rx csum offload on Mikrotik 10/25G NIC
Date:   Mon, 19 Apr 2021 17:34:49 +0300
Message-Id: <20210419143449.751852-5-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419143449.751852-1-gatis@mikrotik.com>
References: <20210419143449.751852-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mikrotik 10/25G NIC supports hw checksum verification on rx for
IP/IPv6 + TCP/UDP packets. HW checksum offload helps reduce host
cpu load.

This enables the csum offload specifically for Mikrotik 10/25G NIC
as other HW supported by the driver is known to have problems with it.

TCP iperf3 to Threadripper 3960X with NIC improved 16.5 -> 20.0 Gbps
with mtu=1500.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h      | 2 ++
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 3fda7eb3bd69..9d70cb7544f1 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -241,6 +241,8 @@ struct atl1c_tpd_ext_desc {
 #define RRS_PACKET_PROT_IS_IPV6_ONLY(word) \
 	((((word) >> RRS_PROT_ID_SHIFT) & RRS_PROT_ID_MASK) == 6)
 
+#define RRS_MT_PROT_ID_TCPUDP	BIT(19)
+
 struct atl1c_recv_ret_status {
 	__le32  word0;
 	__le32	rss_hash;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 920e408ce7b4..9795657d6f58 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1670,6 +1670,11 @@ static irqreturn_t atl1c_intr(int irq, void *data)
 static inline void atl1c_rx_checksum(struct atl1c_adapter *adapter,
 		  struct sk_buff *skb, struct atl1c_recv_ret_status *prrs)
 {
+	if (adapter->hw.nic_type == athr_mt) {
+		if (prrs->word3 & RRS_MT_PROT_ID_TCPUDP)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		return;
+	}
 	/*
 	 * The pid field in RRS in not correct sometimes, so we
 	 * cannot figure out if the packet is fragmented or not,
-- 
2.31.1

