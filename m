Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B647DCEA
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346085AbhLWBPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:07 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27176 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346211AbhLWBOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=EbITibNsBXzvKKlU+piJIV+uEtgNRqVMqmU3tYGIQcU=;
        b=xzHrFlKjQzAtjaW8yiDPgKpwVk301omL4rrVVi8w8Wn5+ps/av+vh+5OfXPZEERTPYPt
        /W99RjK/+Ra1HWGnMvN4BkuLRimUWd3HUT5joH31sv2h9xq+esNyqdoHCAOvTFy+FJRevZ
        ekxP5YtIX8x9iYHauJ9tEFmtAlvociUKCh8SKNsnABibWrDzZZbzoM3m1O+utHpr7+s4yM
        ZW6SUsBW8M5pZLX+Ee+75eOiQc3+NsnylO+gY7a3n9fIlt317EgfxB64fageRmVHUsGhMJ
        pT37rWDgO0SGrLHKUVJ+CiSLRoI/7n9vh78VXlW7zNOnWWG11+xLFDlnj3lm1DvQ==
Received: by filterdrecv-64fcb979b9-dthbb with SMTP id filterdrecv-64fcb979b9-dthbb-1-61C3CD5E-2A
        2021-12-23 01:14:06.798901564 +0000 UTC m=+8644642.033288874
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-0 (SG)
        with ESMTP
        id EaVvzUYwQcujwsJtTuNFnQ
        Thu, 23 Dec 2021 01:14:06.651 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id A1A667014DF; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 32/50] wilc1000: introduce vmm_table_entry() helper
 function
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-33-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvLgTn20zR8huEqDJ0?=
 =?us-ascii?Q?MxRBKbzqZl9pgBv8ieFLgCozwXIMY+YaD2HCv+S?=
 =?us-ascii?Q?nV6T96yvIyZ5Zej8MBI9aX5ZsbvXSxYv1Cwy1xL?=
 =?us-ascii?Q?YrW86fYiTsJMx0RDqh7jSGUcQiUbxnvy2AmOVLJ?=
 =?us-ascii?Q?xU=2F=2Fl7PTk6DfWtQq7nHxENsq8juPjw96f=2F6i3j?=
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

This simplifies fill_vmm_table() a bit more and will become even more
useful with the following patches.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index cff70f7d38c89..5939ed5b2db68 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -629,6 +629,17 @@ static u32 tx_hdr_len(u8 type)
 	}
 }
 
+static u32 vmm_table_entry(struct sk_buff *tqe, u32 vmm_sz)
+{
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
+	u32 entry;
+
+	entry = vmm_sz / 4;
+	if (tx_cb->type == WILC_CFG_PKT)
+		entry |= WILC_VMM_CFG_PKT;
+	return cpu_to_le32(entry);
+}
+
 /**
  * fill_vmm_table() - Fill VMM table with packets to be sent
  * @wilc: Pointer to the wilc structure.
@@ -691,11 +702,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 
 				if (sum + vmm_sz > WILC_TX_BUFF_SIZE)
 					goto out;
-				vmm_table[i] = vmm_sz / 4;
-				if (tx_cb->type == WILC_CFG_PKT)
-					vmm_table[i] |= WILC_VMM_CFG_PKT;
-
-				cpu_to_le32s(&vmm_table[i]);
+				vmm_table[i] = vmm_table_entry(tqe_q[ac], vmm_sz);
 				vmm_entries_ac[i] = ac;
 
 				i++;
-- 
2.25.1

