Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C39248315
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHRKeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbgHRKdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:33:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E6BC061344
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:33:30 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597746808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ZMUxXva1UnonBim7HrR5QgZlIngVP4NNXBE870xYEA=;
        b=Husuy4WvaxK2ltYnwvS9TpY1W/hvIYEpOr3YggS9h7A3nW0NQc8jDi9utqh3MA+TxCHD1p
        zAbghTrnSVRvuX05bruBKs54eBU0DDX2+E3OQOCbuhYiZObHXN9mb2931ddWkVC0D/Rclo
        spmcriBuN6ugYzvgHr1g1o3oizXiv609Hk2x6gdNX0VOsDbRnUO1t5OC3GF1/xNE/EifGq
        Dr+trKgJvW08+I7kqUsdSWHMTlSEYhVUC/UM3PZajPfzbJ5SwoP+eXNwIVitisrfAD+4je
        k8uzpNzgEdZN7iMhuzExZa8vA/8b6BXRXGC2NJFJDnThis/q1yARGjwLEeGm5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597746808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ZMUxXva1UnonBim7HrR5QgZlIngVP4NNXBE870xYEA=;
        b=o/GDUadaJXvvLaznn+PS1Zcw2W8a5W9RpPTxsf7e5vgu3A4Iu8yU5XIZLhPfmUlWaMMPU6
        dwl7ef/sWlbGGyAA==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v4 6/9] ethernet: ti: cpts: Use generic helper function
Date:   Tue, 18 Aug 2020 12:32:48 +0200
Message-Id: <20200818103251.20421-7-kurt@linutronix.de>
In-Reply-To: <20200818103251.20421-1-kurt@linutronix.de>
References: <20200818103251.20421-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to reduce code duplication between ptp drivers, generic helper
functions were introduced. Use them.

Suggested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/ti/cpts.c | 42 ++++++++++++----------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 7c55d395de2c..ed91916acfcc 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -446,41 +446,22 @@ static const struct ptp_clock_info cpts_info = {
 static int cpts_skb_get_mtype_seqid(struct sk_buff *skb, u32 *mtype_seqid)
 {
 	unsigned int ptp_class = ptp_classify_raw(skb);
-	u8 *msgtype, *data = skb->data;
-	unsigned int offset = 0;
-	u16 *seqid;
+	struct ptp_header *hdr;
+	u8 msgtype;
+	u16 seqid;
 
 	if (ptp_class == PTP_CLASS_NONE)
 		return 0;
 
-	if (ptp_class & PTP_CLASS_VLAN)
-		offset += VLAN_HLEN;
-
-	switch (ptp_class & PTP_CLASS_PMASK) {
-	case PTP_CLASS_IPV4:
-		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
-		break;
-	case PTP_CLASS_IPV6:
-		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
-		break;
-	case PTP_CLASS_L2:
-		offset += ETH_HLEN;
-		break;
-	default:
-		return 0;
-	}
-
-	if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
 		return 0;
 
-	if (unlikely(ptp_class & PTP_CLASS_V1))
-		msgtype = data + offset + OFF_PTP_CONTROL;
-	else
-		msgtype = data + offset;
+	msgtype = ptp_get_msgtype(hdr, ptp_class);
+	seqid	= ntohs(hdr->sequence_id);
 
-	seqid = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
-	*mtype_seqid = (*msgtype & MESSAGE_TYPE_MASK) << MESSAGE_TYPE_SHIFT;
-	*mtype_seqid |= (ntohs(*seqid) & SEQUENCE_ID_MASK) << SEQUENCE_ID_SHIFT;
+	*mtype_seqid  = (msgtype & MESSAGE_TYPE_MASK) << MESSAGE_TYPE_SHIFT;
+	*mtype_seqid |= (seqid & SEQUENCE_ID_MASK) << SEQUENCE_ID_SHIFT;
 
 	return 1;
 }
@@ -528,7 +509,11 @@ void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 	int ret;
 	u64 ns;
 
+	/* cpts_rx_timestamp() is called before eth_type_trans(), so
+	 * skb MAC Hdr properties are not configured yet. Hence need to
+	 * reset skb MAC header here
+	 */
+	skb_reset_mac_header(skb);
 	ret = cpts_skb_get_mtype_seqid(skb, &skb_cb->skb_mtype_seqid);
 	if (!ret)
 		return;
-- 
2.20.1

