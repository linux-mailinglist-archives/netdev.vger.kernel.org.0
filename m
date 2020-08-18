Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2607F248314
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHRKeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgHRKda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:33:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CECC061343
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:33:29 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597746807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EPetnaulZaaPV6+ZYRxfC8jb3A5j7eprC44necUJINY=;
        b=cyC81eK9R/ad3Wuq81FCc4XXoE77h0CrswTUKy5UdzdvwXTfa2SjZRozhVXRWhtrlT36sw
        F9eLfK0vmeFOnTCJ13tUO6QAL4pW4R+kTjMSAf7hDsdgvj/FDeQWrpjV1DL8BwHKLr0r2g
        30gE+LhbS87R7ze5PO6D3sNO9CEwq6yG1qtKGxiiTEwWmOG5gy88wTNms7b2h+lBDlY345
        jSgiqGOuy87qHXMRkDFnOPm1yC1MNCsHhwl5Idb60QkHYrM1ynBp+yzfz3ujGw8j19rYZ2
        m0yGm4Ru/t4/OFdvfLg9jIGmP8of7iNiQueyBAu0GZCexK2GE2f+TAdRTb7Ylw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597746807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EPetnaulZaaPV6+ZYRxfC8jb3A5j7eprC44necUJINY=;
        b=JDeXLPquqVe0K94aW0PkG9IbfoQwmd+pg+wqJaLhnPabw7XPrbvU1bkdtcHpLsP2+jd1eh
        97AMqaiCLdBs0+AQ==
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
Subject: [PATCH v4 5/9] ethernet: ti: am65-cpts: Use generic helper function
Date:   Tue, 18 Aug 2020 12:32:47 +0200
Message-Id: <20200818103251.20421-6-kurt@linutronix.de>
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

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/ti/am65-cpts.c | 37 +++++++----------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index c59a289e428c..365b5b9c6897 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -748,42 +748,23 @@ EXPORT_SYMBOL_GPL(am65_cpts_rx_enable);
 static int am65_skb_get_mtype_seqid(struct sk_buff *skb, u32 *mtype_seqid)
 {
 	unsigned int ptp_class = ptp_classify_raw(skb);
-	u8 *msgtype, *data = skb->data;
-	unsigned int offset = 0;
-	__be16 *seqid;
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
 
-	seqid = (__be16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
-	*mtype_seqid = (*msgtype << AM65_CPTS_EVENT_1_MESSAGE_TYPE_SHIFT) &
+	*mtype_seqid  = (msgtype << AM65_CPTS_EVENT_1_MESSAGE_TYPE_SHIFT) &
 			AM65_CPTS_EVENT_1_MESSAGE_TYPE_MASK;
-	*mtype_seqid |= (ntohs(*seqid) & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK);
+	*mtype_seqid |= (seqid & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK);
 
 	return 1;
 }
-- 
2.20.1

