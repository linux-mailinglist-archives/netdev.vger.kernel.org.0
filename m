Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCEA47DD4D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345653AbhLWBQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:53 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18118 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241423AbhLWBOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=HPVfzeTUe/WGAcSpYNV1LTwnd+/+fQEScpSKKNE3ps4=;
        b=QDUr0aYc9OioLKyNx+0BG1Uqf26kyvOez1Ui6KpBWlpsy1ZtE1rxgHvZzDq6bhInYrcO
        IyxDL0ArZVJLR7mG9GEZgzxSgOyE+f4wpsUoBeRop5Qvn6cEIk+pSa0WVWhYnCk4CEw0J1
        2ctCg0B9XjauGb5l3FLGMAcTCl5++f1EJhsUt3iIbBHuwCvY3oqnS8uTL9UHy6ybZiE9Ui
        qn8EBCOe9/B1V+FkvHW3auk89Jr0qFXNsG5qGTd4kfWwF/e/h5Y1ymN5dZayPYGiu8GcUn
        rFlTh/zGs/ZJyeodY7g94VYvhevljpRXEgXwcIi0zF74qMFo97qkoMDUADgsXYhQ==
Received: by filterdrecv-656998cfdd-rqq5v with SMTP id filterdrecv-656998cfdd-rqq5v-1-61C3CD5E-19
        2021-12-23 01:14:06.403185438 +0000 UTC m=+7955207.157107831
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-1 (SG)
        with ESMTP
        id eeiDkwZeSRyUJpU1jcnWxA
        Thu, 23 Dec 2021 01:14:06.203 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id E7022700C16; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 06/50] wilc1000: move tx packet drop code into its own
 function
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-7-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvDVRIOLZX=2Fuaqgwge?=
 =?us-ascii?Q?pdd=2FOprcOg8eS0wCEoSluFg9GT2EE9PHLrMK+sW?=
 =?us-ascii?Q?kumqROGfcg1jVIacE+3XCYucS1+AoWcYQZ2PUzY?=
 =?us-ascii?Q?uo9dfgAVBifD7P1qGZPbXFcxz4PCMQXrWa+BN2s?=
 =?us-ascii?Q?KcglitGTRO5IYssu58XHXeTIE=2F7BVXforWMPLt?=
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

This is just to improve code clarity.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 7b7ee6ee9f849..e4342631aae93 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -200,6 +200,14 @@ static void wilc_wlan_tx_packet_done(struct txq_entry_t *tqe, int status)
 	kfree(tqe);
 }
 
+static void wilc_wlan_txq_drop_net_pkt(struct txq_entry_t *tqe)
+{
+	struct wilc *wilc = tqe->vif->wilc;
+
+	wilc_wlan_txq_remove(wilc, tqe->q_num, tqe);
+	wilc_wlan_tx_packet_done(tqe, 1);
+}
+
 static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
 	struct wilc_vif *vif = netdev_priv(dev);
@@ -228,10 +236,8 @@ static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 			struct txq_entry_t *tqe;
 
 			tqe = f->pending_acks[i].txqe;
-			if (tqe) {
-				wilc_wlan_txq_remove(wilc, tqe->q_num, tqe);
-				wilc_wlan_tx_packet_done(tqe, 1);
-			}
+			if (tqe)
+				wilc_wlan_txq_drop_net_pkt(tqe);
 		}
 	}
 	f->pending_acks_idx = 0;
-- 
2.25.1

