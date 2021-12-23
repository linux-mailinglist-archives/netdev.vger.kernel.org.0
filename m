Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C747DCE9
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345727AbhLWBPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:05 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27238 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346214AbhLWBOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=6N7dj4qJUKtMM/lJa8tbpsQXTpV3hh508uNFMCeLTmw=;
        b=vr+cyHY2pvPEH42hDN8WIQdKRBy7fQiQTie0z7EgQ7iJcIbs1LSTZYR7mEUfwFqWDZDh
        5eh39xKSQJsPmXg0qm9SZecMP4+N2M3Dsp4XOZI2ureZ36yZWB1L4zPYkQBy/FIabKx85L
        WhAbvaYhcxqjFoUA6Ig/vFhMhvANjYyAoNnQjaqctzadT252UF1LaXebuRIj3dtOt3jU4y
        sTPETVrmyUPUDm2UDsUewXIa4bqSiZoVm/LnZcQiqsfCiIGH4mydq+a9v6GhInK6h8K6dA
        oGM7H7iq6m9YlvrN9ndnefOeUCQExmMlHsHa0kGZvOn4g0oWBiFMo3zSggd5ZCTg==
Received: by filterdrecv-64fcb979b9-4vrtk with SMTP id filterdrecv-64fcb979b9-4vrtk-1-61C3CD5E-33
        2021-12-23 01:14:06.639603191 +0000 UTC m=+8644640.706394453
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-1 (SG)
        with ESMTP
        id XtinkhGEQb2hIYycvpVgXQ
        Thu, 23 Dec 2021 01:14:06.505 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 6AE00701474; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 26/50] wilc1000: reduce amount of time ack_filter_lock is
 held
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-27-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvGGquUt9ycIje3WqF?=
 =?us-ascii?Q?lCafr+1TG2O9DDHkxjFYdcB99nE90QGpbToWeya?=
 =?us-ascii?Q?nt9YrHssVEPslyq=2FMdXIm7BTKB7tj7ZG1=2FB+zLm?=
 =?us-ascii?Q?XBeklScss=2FUVy=2Fn3+qcqKqzMQzpYZYdaHZx8edF?=
 =?us-ascii?Q?CXBhuiDrMeXoamh0JD4Q6NNJKDEKIX3oEt1kEY?=
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

In tcp_process(), only hold the ack_filter_lock while accessing the
ack_filter state.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 81180b2f9f4e1..5ea9129b36925 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -130,15 +130,13 @@ static inline void tcp_process(struct net_device *dev, struct sk_buff *tqe)
 	const struct tcphdr *tcp_hdr_ptr;
 	u32 ihl, total_length, data_offset;
 
-	mutex_lock(&vif->ack_filter_lock);
-
 	if (eth_hdr_ptr->h_proto != htons(ETH_P_IP))
-		goto out;
+		return;
 
 	ip_hdr_ptr = buffer + ETH_HLEN;
 
 	if (ip_hdr_ptr->protocol != IPPROTO_TCP)
-		goto out;
+		return;
 
 	ihl = ip_hdr_ptr->ihl << 2;
 	tcp_hdr_ptr = buffer + ETH_HLEN + ihl;
@@ -150,6 +148,9 @@ static inline void tcp_process(struct net_device *dev, struct sk_buff *tqe)
 
 		seq_no = ntohl(tcp_hdr_ptr->seq);
 		ack_no = ntohl(tcp_hdr_ptr->ack_seq);
+
+		mutex_lock(&vif->ack_filter_lock);
+
 		for (i = 0; i < f->tcp_session; i++) {
 			u32 j = f->ack_session_info[i].seq_num;
 
@@ -163,10 +164,9 @@ static inline void tcp_process(struct net_device *dev, struct sk_buff *tqe)
 			add_tcp_session(vif, 0, 0, seq_no);
 
 		add_tcp_pending_ack(vif, ack_no, i, tqe);
-	}
 
-out:
-	mutex_unlock(&vif->ack_filter_lock);
+		mutex_unlock(&vif->ack_filter_lock);
+	}
 }
 
 static void wilc_wlan_tx_packet_done(struct sk_buff *tqe, int status)
-- 
2.25.1

