Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67614479E62
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhLRXy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:57 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25500 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbhLRXyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=QAh24Ex5HQMwz2LcHEFWDu0hjRaIliWenvyP2BPryNQ=;
        b=RihxgcCN7Rp8Skq01adkqBvOMORTUxGQHEzj0nnhO+qYCB4gwzn1n2npuBBAIlD5K+0A
        DFs90Fovz24xQE5DLDpVZwP6I4wOcWTbuNu0AzOLV0L0cOLe+cIqPWmH3oHb0uZc/Xo7gL
        dBmUcK5n30roGWdlMOK7GZKOVkH58opBaYQtAgsGlQZ/k+kIJbSqrvlBhgnYRPo77WjRO3
        DNSHkCwwiObZpiv4fZ+Ac9TXR1YfbJxnJA0ht31E23poKCCqC8bArqBK5rjwa1fz7STIdR
        Hht4S8gtMn69vJB/NhqhxMq1wXokSdqEvyy8F8cFNuPcxkSWXZtY2pLoC5kchrmA==
Received: by filterdrecv-656998cfdd-phncc with SMTP id filterdrecv-656998cfdd-phncc-1-61BE74A8-1D
        2021-12-18 23:54:16.838337232 +0000 UTC m=+7604818.024584014
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id MZ7uISucQJa4P7omMBWJmg
        Sat, 18 Dec 2021 23:54:16.696 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 99A23700F78; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 08/23] wilc1000: fix management packet type inconsistency
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-9-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvBgWXtrCB5OF5sDb1?=
 =?us-ascii?Q?M3PEtEXGAnFYO34+OEM+j2yxQqTLIGNhi5Sbe1v?=
 =?us-ascii?Q?3retJL1jACmWBuhInLXrqxzUtEf=2Fz7HdIU+T8f4?=
 =?us-ascii?Q?S+AvihUhTHi=2FwZd1t6c52wSZkaJPyUDya9W8Q+W?=
 =?us-ascii?Q?uUy3ffWOaGcoGre09jke6IBBFx5i=2Fz9GiJ3Kmt?=
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

The queue type for management packets was initialized to AC_BE_Q
(best-effort queue) but the packet was then actually added to the
AC_VO_Q queue (voice, or highest-priority queue).  This fixes the
inconsistency by setting the type to AC_VO_Q.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index b85ceda8409e6..c72eb4244508c 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -507,7 +507,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = tx_complete_fn;
 	tqe->priv = priv;
-	tqe->q_num = AC_BE_Q;
+	tqe->q_num = AC_VO_Q;
 	tqe->ack_idx = NOT_TCP_ACK;
 	tqe->vif = vif;
 	wilc_wlan_txq_add_to_tail(dev, AC_VO_Q, tqe);
-- 
2.25.1

