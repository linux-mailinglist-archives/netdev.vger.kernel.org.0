Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7B222E86B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgG0JGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53776 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgG0JGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:19 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JAnPHtSUc1fs2SVKqS8jKOoMEWVQ9SYEz1LHwQt13cI=;
        b=fa58dvSxsyTv6XMEcjOXhEKFxtzCzH8O1cZN3rZWvVjGyGccvyYiN4q+fLjI4D/RDmaNje
        28znmyBZcyvAn//0t2TRdK2TPiVFupEsqY3Xdp6N0XurdeVmrPqZ4C3spm0sAHuCetgNCs
        vB8r2XlHcsqRJ5qaldNLEgAf2UA1ZMOGABhXfXQvY9kZhcpwrOuIa8LCAmt+27AGqwreJ8
        7m0SlyVLenEKibDnxf3bnQya2PnEXvkkFTbIvu3RdGED8fgvIXk8FU7ft6QiDednlttMp2
        X6Pq/Nevle/WWI9XTRY3vnh3WkUcDZQ1m1vPm5YgqbkStmAG7jBoj3FheDmqWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JAnPHtSUc1fs2SVKqS8jKOoMEWVQ9SYEz1LHwQt13cI=;
        b=bYEQCvpuKP18wuin/xbKve4v7fC9F7bbc9/sJnrgJPh1bRt0y6dkltYykylK46dEZOpJa5
        Pr46HgjqAz9UmpBg==
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
Subject: [PATCH v2 6/9] ethernet: ti: cpts: Use generic helper function
Date:   Mon, 27 Jul 2020 11:05:58 +0200
Message-Id: <20200727090601.6500-7-kurt@linutronix.de>
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
 drivers/net/ethernet/ti/cpts.c | 37 +++++++++-------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 7c55d395de2c..2c5c05620e6e 100644
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
+	seqid	= be16_to_cpu(hdr->sequence_id);
 
-	seqid = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
-	*mtype_seqid = (*msgtype & MESSAGE_TYPE_MASK) << MESSAGE_TYPE_SHIFT;
-	*mtype_seqid |= (ntohs(*seqid) & SEQUENCE_ID_MASK) << SEQUENCE_ID_SHIFT;
+	*mtype_seqid  = (msgtype & MESSAGE_TYPE_MASK) << MESSAGE_TYPE_SHIFT;
+	*mtype_seqid |= (seqid & SEQUENCE_ID_MASK) << SEQUENCE_ID_SHIFT;
 
 	return 1;
 }
-- 
2.20.1

