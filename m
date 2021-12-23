Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6E047DCD8
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346057AbhLWBO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:28 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18420 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345806AbhLWBOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=VdSmr7LcH0rW8kHWmZpoh/Ig1LSGlhHmXHB0t3cqZGc=;
        b=AGJAB9NF2r1y61gG1NFibLyjYqebZYsKzYQcyhYBEKFYqqWwu8BuwSFhK0VCpq+UoUxt
        Fgfp5X8r6vQtUrMwJp0elicdllDHKLvt1X7EGdEuT0VRQYDHOdRYmpuZHKGWYytmh7nhrg
        hRMcbf+nteyrDWlChGGdXIyMLM+oYUTGSYy7nDrqIf7DW74x8qEoHJs9AHz+jFRha8lz2A
        tsJj6HzeIfuluuFGT+CUAwMxLaKtxLJRVkxU7ukN9K2xEdsvXTr/g6so2joTiiveH9o4/F
        8sawsJ7aa84oUE3iqZkpuMvkg5C79l8hC6IEfUGQsD0exT3joAie/Pq2I2WiDbFw==
Received: by filterdrecv-64fcb979b9-6vbpf with SMTP id filterdrecv-64fcb979b9-6vbpf-1-61C3CD5E-35
        2021-12-23 01:14:06.683709228 +0000 UTC m=+8644637.687945467
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id OwzaDxMVSaWpyCRXrQezBA
        Thu, 23 Dec 2021 01:14:06.542 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 73DAF701488; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 27/50] wilc1000: simplify ac_balance() a bit
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-28-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFH5jXK85cQtbtZt7?=
 =?us-ascii?Q?SL3jCjJD5yamKyyCopUd3NzO3D=2FhuQ5uOd=2Fdefx?=
 =?us-ascii?Q?Rnh5BvGJtoyo9c8YpecROwyRILZQe2KyhrLaSoH?=
 =?us-ascii?Q?iIFYB0rWwNcSYZezVDMcPV425VYVAjNYg5TQye4?=
 =?us-ascii?Q?ctBjHI0WQqiYGl5WfCFqyP3gRPmCuBvKRWAyk4?=
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

ac_balance() is never going to fail ("ratio" is always non-NULL), so
there is no reason to pretend otherwise.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 5ea9129b36925..287c0843ba152 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -345,21 +345,23 @@ static inline u8 ac_classify(struct wilc *wilc, struct sk_buff *skb)
 	return q_num;
 }
 
-static inline int ac_balance(struct wilc *wl, u8 *ratio)
+/**
+ * ac_balance() - balance queues by favoring ones with fewer packets pending
+ * @wl: Pointer to the wilc structure.
+ * @ratio: Pointer to array of length NQUEUES in which this function
+ *	returns the number of packets that may be scheduled for each
+ *	access category.
+ */
+static inline void ac_balance(const struct wilc *wl, u8 *ratio)
 {
 	u8 i, max_count = 0;
 
-	if (!ratio)
-		return -EINVAL;
-
 	for (i = 0; i < NQUEUES; i++)
 		if (wl->fw[i].count > max_count)
 			max_count = wl->fw[i].count;
 
 	for (i = 0; i < NQUEUES; i++)
 		ratio[i] = max_count - wl->fw[i].count;
-
-	return 0;
 }
 
 static inline void ac_update_fw_ac_pkt_info(struct wilc *wl, u32 reg)
@@ -894,8 +896,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	if (wilc->quit)
 		goto out_update_cnt;
 
-	if (ac_balance(wilc, ac_desired_ratio))
-		return -EINVAL;
+	ac_balance(wilc, ac_desired_ratio);
 
 	mutex_lock(&wilc->txq_add_to_head_cs);
 
-- 
2.25.1

