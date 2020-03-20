Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E78818D891
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 20:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgCTTnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 15:43:22 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:40012 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgCTTnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 15:43:22 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhHiw027971;
        Fri, 20 Mar 2020 14:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584733397;
        bh=OwrvzD0aVDA6B1hUvxViFQH5xN1/WUuimg+JwH5BZPA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=aleudaF3H54Wy7r4731RDOrlaDJqRuUAWA/+A6oVCouTvtPCKwPmYLI1RNcUCQcc2
         HTuCZr5YZ0nPoqlZTklv6o3pxFn8R7dm/ln7WH6vxBy4hOszHSxvFZdLAZsPdaw+kL
         P2Qp/QT8AcE7QCNc8GpZ/eXBoV9ff6mnyddaBVAY=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhH4X010497;
        Fri, 20 Mar 2020 14:43:17 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 20
 Mar 2020 14:43:17 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 20 Mar 2020 14:43:17 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhGVM043117;
        Fri, 20 Mar 2020 14:43:16 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 05/11] net: ethernet: ti: cpts: optimize packet to event matching
Date:   Fri, 20 Mar 2020 21:42:38 +0200
Message-ID: <20200320194244.4703-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320194244.4703-1-grygorii.strashko@ti.com>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now the CPTS driver performs packet (skb) parsing every time when it needs
to match packet to CPTS event (including ptp_classify_raw() calls).

This patch optimizes matching process by parsing packet only once upon
arrival and stores PTP specific data in skb->cb using the same fromat as in
CPTS HW event. As result, all future matching reduces to comparing two u32
values.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 91 ++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 7e4c1de0d207..f7ce482ad09c 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -23,15 +23,13 @@
 #define CPTS_SKB_TX_WORK_TIMEOUT 1 /* jiffies */
 
 struct cpts_skb_cb_data {
+	u32 skb_mtype_seqid;
 	unsigned long tmo;
 };
 
 #define cpts_read32(c, r)	readl_relaxed(&c->reg->r)
 #define cpts_write32(c, v, r)	writel_relaxed(v, &c->reg->r)
 
-static int cpts_match(struct sk_buff *skb, unsigned int ptp_class,
-		      u16 ts_seqid, u8 ts_msgtype);
-
 static int event_expired(struct cpts_event *event)
 {
 	return time_after(jiffies, event->tmo);
@@ -97,29 +95,29 @@ static void cpts_purge_txq(struct cpts *cpts)
 static bool cpts_match_tx_ts(struct cpts *cpts, struct cpts_event *event)
 {
 	struct sk_buff *skb, *tmp;
-	u16 seqid;
-	u8 mtype;
 	bool found = false;
+	u32 mtype_seqid;
 
-	mtype = (event->high >> MESSAGE_TYPE_SHIFT) & MESSAGE_TYPE_MASK;
-	seqid = (event->high >> SEQUENCE_ID_SHIFT) & SEQUENCE_ID_MASK;
+	mtype_seqid = event->high &
+		      ((MESSAGE_TYPE_MASK << MESSAGE_TYPE_SHIFT) |
+		       (SEQUENCE_ID_MASK << SEQUENCE_ID_SHIFT) |
+		       (EVENT_TYPE_MASK << EVENT_TYPE_SHIFT));
 
 	/* no need to grab txq.lock as access is always done under cpts->lock */
 	skb_queue_walk_safe(&cpts->txq, skb, tmp) {
 		struct skb_shared_hwtstamps ssh;
-		unsigned int class = ptp_classify_raw(skb);
 		struct cpts_skb_cb_data *skb_cb =
 					(struct cpts_skb_cb_data *)skb->cb;
 
-		if (cpts_match(skb, class, seqid, mtype)) {
+		if (mtype_seqid == skb_cb->skb_mtype_seqid) {
 			memset(&ssh, 0, sizeof(ssh));
 			ssh.hwtstamp = ns_to_ktime(event->timestamp);
 			skb_tstamp_tx(skb, &ssh);
 			found = true;
 			__skb_unlink(skb, &cpts->txq);
 			dev_consume_skb_any(skb);
-			dev_dbg(cpts->dev, "match tx timestamp mtype %u seqid %04x\n",
-				mtype, seqid);
+			dev_dbg(cpts->dev, "match tx timestamp mtype_seqid %08x\n",
+				mtype_seqid);
 			break;
 		}
 
@@ -338,12 +336,15 @@ static const struct ptp_clock_info cpts_info = {
 	.do_aux_work	= cpts_overflow_check,
 };
 
-static int cpts_match(struct sk_buff *skb, unsigned int ptp_class,
-		      u16 ts_seqid, u8 ts_msgtype)
+static int cpts_skb_get_mtype_seqid(struct sk_buff *skb, u32 *mtype_seqid)
 {
-	u16 *seqid;
-	unsigned int offset = 0;
+	unsigned int ptp_class = ptp_classify_raw(skb);
 	u8 *msgtype, *data = skb->data;
+	unsigned int offset = 0;
+	u16 *seqid;
+
+	if (ptp_class == PTP_CLASS_NONE)
+		return 0;
 
 	if (ptp_class & PTP_CLASS_VLAN)
 		offset += VLAN_HLEN;
@@ -371,22 +372,20 @@ static int cpts_match(struct sk_buff *skb, unsigned int ptp_class,
 		msgtype = data + offset;
 
 	seqid = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+	*mtype_seqid = (*msgtype & MESSAGE_TYPE_MASK) << MESSAGE_TYPE_SHIFT;
+	*mtype_seqid |= (ntohs(*seqid) & SEQUENCE_ID_MASK) << SEQUENCE_ID_SHIFT;
 
-	return (ts_msgtype == (*msgtype & 0xf) && ts_seqid == ntohs(*seqid));
+	return 1;
 }
 
-static u64 cpts_find_ts(struct cpts *cpts, struct sk_buff *skb, int ev_type)
+static u64 cpts_find_ts(struct cpts *cpts, struct sk_buff *skb,
+			int ev_type, u32 skb_mtype_seqid)
 {
-	u64 ns = 0;
-	struct cpts_event *event;
 	struct list_head *this, *next;
-	unsigned int class = ptp_classify_raw(skb);
+	struct cpts_event *event;
 	unsigned long flags;
-	u16 seqid;
-	u8 mtype;
-
-	if (class == PTP_CLASS_NONE)
-		return 0;
+	u32 mtype_seqid;
+	u64 ns = 0;
 
 	spin_lock_irqsave(&cpts->lock, flags);
 	cpts_fifo_read(cpts, -1);
@@ -397,10 +396,13 @@ static u64 cpts_find_ts(struct cpts *cpts, struct sk_buff *skb, int ev_type)
 			list_add(&event->list, &cpts->pool);
 			continue;
 		}
-		mtype = (event->high >> MESSAGE_TYPE_SHIFT) & MESSAGE_TYPE_MASK;
-		seqid = (event->high >> SEQUENCE_ID_SHIFT) & SEQUENCE_ID_MASK;
-		if (ev_type == event_type(event) &&
-		    cpts_match(skb, class, seqid, mtype)) {
+
+		mtype_seqid = event->high &
+			      ((MESSAGE_TYPE_MASK << MESSAGE_TYPE_SHIFT) |
+			       (SEQUENCE_ID_MASK << SEQUENCE_ID_SHIFT) |
+			       (EVENT_TYPE_MASK << EVENT_TYPE_SHIFT));
+
+		if (mtype_seqid == skb_mtype_seqid) {
 			ns = event->timestamp;
 			list_del_init(&event->list);
 			list_add(&event->list, &cpts->pool);
@@ -427,10 +429,21 @@ static u64 cpts_find_ts(struct cpts *cpts, struct sk_buff *skb, int ev_type)
 
 void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
-	u64 ns;
+	struct cpts_skb_cb_data *skb_cb = (struct cpts_skb_cb_data *)skb->cb;
 	struct skb_shared_hwtstamps *ssh;
+	int ret;
+	u64 ns;
+
+	ret = cpts_skb_get_mtype_seqid(skb, &skb_cb->skb_mtype_seqid);
+	if (!ret)
+		return;
+
+	skb_cb->skb_mtype_seqid |= (CPTS_EV_RX << EVENT_TYPE_SHIFT);
 
-	ns = cpts_find_ts(cpts, skb, CPTS_EV_RX);
+	dev_dbg(cpts->dev, "%s mtype seqid %08x\n",
+		__func__, skb_cb->skb_mtype_seqid);
+
+	ns = cpts_find_ts(cpts, skb, CPTS_EV_RX, skb_cb->skb_mtype_seqid);
 	if (!ns)
 		return;
 	ssh = skb_hwtstamps(skb);
@@ -441,12 +454,24 @@ EXPORT_SYMBOL_GPL(cpts_rx_timestamp);
 
 void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
-	u64 ns;
+	struct cpts_skb_cb_data *skb_cb = (struct cpts_skb_cb_data *)skb->cb;
 	struct skb_shared_hwtstamps ssh;
+	int ret;
+	u64 ns;
 
 	if (!(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
 		return;
-	ns = cpts_find_ts(cpts, skb, CPTS_EV_TX);
+
+	ret = cpts_skb_get_mtype_seqid(skb, &skb_cb->skb_mtype_seqid);
+	if (!ret)
+		return;
+
+	skb_cb->skb_mtype_seqid |= (CPTS_EV_TX << EVENT_TYPE_SHIFT);
+
+	dev_dbg(cpts->dev, "%s mtype seqid %08x\n",
+		__func__, skb_cb->skb_mtype_seqid);
+
+	ns = cpts_find_ts(cpts, skb, CPTS_EV_TX, skb_cb->skb_mtype_seqid);
 	if (!ns)
 		return;
 	memset(&ssh, 0, sizeof(ssh));
-- 
2.17.1

