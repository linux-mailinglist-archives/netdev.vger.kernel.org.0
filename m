Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A0747DD28
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346758AbhLWBQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:14 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27242 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346232AbhLWBOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=f9xzkdOgmpl7Kp4IqvxccUyOsVwln+nUuQ3GXq4ZqFs=;
        b=ppHdJXk/AG+5xPHnjDps7NgVXLNfN05WI955waa9m12R5zEWDTXDH1dmFrExgZCir0Du
        Cb1J0XotgzBo8MDC/A0NxgAhJcGk/dLmMEJ1DkkS5CYahcbwq2WhSGn9REnASMdBC6MHLW
        vvXXDSOnMd4zYH6YiZP85cc8BxjTav9VZRJyuT343UPcKnmBRibGqyZh+3xJz9uNUxR1PZ
        Y1Vo5aWOg2L2RKdVMK/yh7I8EwNOjQ8gR1Uh9awypLmgajX2iJsH9KVAWaQH16HDPt3AZV
        D9tivbIVPuwxhvSmSwVtiPRXCNKSVPbjQPoR/DDoDJDYgHPqv16+uMDGiW2Qs8tg==
Received: by filterdrecv-7bf5c69d5-w55fp with SMTP id filterdrecv-7bf5c69d5-w55fp-1-61C3CD5E-34
        2021-12-23 01:14:06.708063961 +0000 UTC m=+9687231.867084891
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-0 (SG)
        with ESMTP
        id KTvvbw4FRUKHwSCk21U2EQ
        Thu, 23 Dec 2021 01:14:06.577 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 85DB07014A9; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 29/50] wilc1000: factor header length calculation into a
 new function
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-30-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvM=2F6RLlPQwh+26vUz?=
 =?us-ascii?Q?xaeDWE8+d=2Fa7XnYxrlWl0eXZNjUWX3Z2JuNdED8?=
 =?us-ascii?Q?I4ROcRQK=2F8Fck6bIRHcj+2h31fZd5siB1hO9pQH?=
 =?us-ascii?Q?5PGCbhyIIKwyfGZ6k=2F8kyjCpvbllQbpsiz5jqsO?=
 =?us-ascii?Q?Xdh4zg7jvl7bfA62LeB3iDr3zZrm2348swh9fb?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper function to calculate header length instead of using the
same open code twice.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 43 +++++++++++++------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 033979cc85b43..1cd9a7761343a 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -602,6 +602,33 @@ void host_sleep_notify(struct wilc *wilc)
 }
 EXPORT_SYMBOL_GPL(host_sleep_notify);
 
+/**
+ * tx_hdr_len() - calculate tx packet header length
+ * @type: The packet type for which to return the header length.
+ *
+ * Calculate the total header size for a given packet type.  This size
+ * includes the 4 bytes required to hold the VMM header.
+ *
+ * Return: The total size of the header in bytes.
+ */
+static u32 tx_hdr_len(u8 type)
+{
+	switch (type) {
+	case WILC_NET_PKT:
+		return ETH_ETHERNET_HDR_OFFSET;
+
+	case WILC_CFG_PKT:
+		return ETH_CONFIG_PKT_HDR_OFFSET;
+
+	case WILC_MGMT_PKT:
+		return HOST_HDR_OFFSET;
+
+	default:
+		pr_err("%s: Invalid packet type %d.", __func__, type);
+		return 4;
+	}
+}
+
 /**
  * fill_vmm_table() - Fill VMM table with packets to be sent
  * @wilc: Pointer to the wilc structure.
@@ -658,13 +685,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 					goto out;
 
 				tx_cb = WILC_SKB_TX_CB(tqe_q[ac]);
-				if (tx_cb->type == WILC_CFG_PKT)
-					vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
-				else if (tx_cb->type == WILC_NET_PKT)
-					vmm_sz = ETH_ETHERNET_HDR_OFFSET;
-				else
-					vmm_sz = HOST_HDR_OFFSET;
-
+				vmm_sz = tx_hdr_len(tx_cb->type);
 				vmm_sz += tqe_q[ac]->len;
 				vmm_sz = ALIGN(vmm_sz, 4);
 
@@ -834,17 +855,13 @@ static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
 
 		cpu_to_le32s(&header);
 		memcpy(&txb[offset], &header, 4);
-		if (tx_cb->type == WILC_CFG_PKT) {
-			buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
-		} else if (tx_cb->type == WILC_NET_PKT) {
+		buffer_offset = tx_hdr_len(tx_cb->type);
+		if (tx_cb->type == WILC_NET_PKT) {
 			int prio = tx_cb->q_num;
 
 			bssid = vif->bssid;
-			buffer_offset = ETH_ETHERNET_HDR_OFFSET;
 			memcpy(&txb[offset + 4], &prio, sizeof(prio));
 			memcpy(&txb[offset + 8], bssid, 6);
-		} else {
-			buffer_offset = HOST_HDR_OFFSET;
 		}
 
 		memcpy(&txb[offset + buffer_offset], tqe->data, tqe->len);
-- 
2.25.1

