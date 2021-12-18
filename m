Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1E7479E3F
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhLRXy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:27 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25524 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbhLRXyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=O3QMGZ1TvKipgmU3yhr6SELaovZiIL63KEeJdy55Z1k=;
        b=OY4XOiqWy4g4NuCxzxUWsIERVRqtbR/Vsmg4r36Sf+uM67W98s5AHbI/LWZY+p1Vaibm
        v2EZ5rNeFqe4C7ZKFeM4cWOLdbfIJn0ABqIWetPBr87iRzlUCxZn0KlamvzS8jEUqJKscn
        k1IVkIpW6h6pJ1Fur1zZR802l8dBPcPoMsI3gQ9axYqgj6PqamX6h9ETwGvlgvRoYUGzY7
        0aV2ed+QW7lUiIf8qWfWjCX6VpSkkxtBwmIOqOzhTPtXXjaKNrlvp2DcJtJbfC8dKdvy8o
        wLh8wWL8L5vTAtGAuSO6JAlOjkb2eTuzKCzaLtYNvx8kpaA/cQhzGr3z7A26BLbw==
Received: by filterdrecv-64fcb979b9-stcmh with SMTP id filterdrecv-64fcb979b9-stcmh-1-61BE74A8-22
        2021-12-18 23:54:16.88213613 +0000 UTC m=+8294196.226541698
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id iu8-LAMbQYqFOg-98uBZbw
        Sat, 18 Dec 2021 23:54:16.713 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 9C64B701006; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 09/23] wilc1000: prepare wilc_wlan_tx_packet_done() for
 sk_buff changes
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-10-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvAfbdWDGErp6E4oqX?=
 =?us-ascii?Q?VKd+cceFveB6IDBKFu3rp69X9F2FiZ9fQfAqOO1?=
 =?us-ascii?Q?RbtdIA4+0CcRNBr4n6XptBkjISGTceqkMMf=2FLUH?=
 =?us-ascii?Q?WnIafmoyQkP5WH=2FTbeiNy9FElNb2BxKCmU+hhuG?=
 =?us-ascii?Q?b=2FlccGEXQbzXliup86g7zvoxEWroIhaxGYLtJ9?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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

This patch just adds some helper variables.  I suppose they improve
readability, but the real reason for this patch is to make the
forthcoming sk_buff rework patch shorter and more obvious.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index c72eb4244508c..eeb9961adfa34 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -192,11 +192,14 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 static void wilc_wlan_tx_packet_done(struct txq_entry_t *tqe, int status)
 {
+	struct wilc_vif *vif = tqe->vif;
+	int ack_idx = tqe->ack_idx;
+
 	tqe->status = status;
 	if (tqe->tx_complete_func)
 		tqe->tx_complete_func(tqe->priv, tqe->status);
-	if (tqe->ack_idx != NOT_TCP_ACK && tqe->ack_idx < MAX_PENDING_ACKS)
-		tqe->vif->ack_filter.pending_acks[tqe->ack_idx].txqe = NULL;
+	if (ack_idx != NOT_TCP_ACK && ack_idx < MAX_PENDING_ACKS)
+		vif->ack_filter.pending_acks[ack_idx].txqe = NULL;
 	kfree(tqe);
 }
 
-- 
2.25.1

