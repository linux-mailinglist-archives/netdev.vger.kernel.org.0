Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0600C22E866
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgG0JGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53760 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgG0JGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:18 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bViW/fwyNVYpaLBkhNhKImtxPFkf0fQzR+cUGcCym+4=;
        b=sDNgB2R5k9MvN/pW40+ZAY4gIP8MoET/O1NbwaAKew1xBudc9HnQHErwZ3eJU8MuKGeNsn
        B2MtXmeDaefsuOal5zW9x8s874fSb+T1Fc/AIwd0k4o+ezhowBcRpdl7vDENa9QxPbonly
        e2h9hqrl1i93a3vg1l5NVA0l4kdXgkv3lKOsRfXuALTCwkeAdZcZhBGU0zzfBWMrUSIJvM
        w6x5SS2TGUrvBtC9nkSybGXg0aL5S4eUjd0yNgNUNz5U9dCBxnNrWyudAU90JMf79VcYmo
        ofLQ1LqhlmQjUpUp/CC5okSx9XsHT8SaWPZ+Lxw18WQRzDTKsm9RB6JVExoTBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bViW/fwyNVYpaLBkhNhKImtxPFkf0fQzR+cUGcCym+4=;
        b=LfowtaJ1RFU6/x9WYVcJ1/pM3KikQXjczFKNH+dRrBDsmf2ih1sixXAj/S68AIYl3oWNWn
        HmbUMqDt61uOv4Bg==
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
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 5/9] ethernet: ti: am65-cpts: Use generic helper function
Date:   Mon, 27 Jul 2020 11:05:57 +0200
Message-Id: <20200727090601.6500-6-kurt@linutronix.de>
In-Reply-To: <20200727090601.6500-1-kurt@linutronix.de>
References: <20200727090601.6500-1-kurt@linutronix.de>
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
index c59a289e428c..2548324afa42 100644
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
+	seqid	= be16_to_cpu(hdr->sequence_id);
 
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

