Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C0D47DCE4
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345912AbhLWBPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:03 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18026 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbhLWBOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=XUnrrGniQ2mn68UkAYnDzma+xGBy6FTx8ryJIfAGnQo=;
        b=VcBFnY2muLpFkQ1893uov1TVafXAcHDZDkHJB690ydWybbP6RK+v19Y3c2i9f1kPHGF0
        ZFC2xEXM0oET8DD5ca3q2yYeV1DFWmB9tObGhcR373tikpnfceftTH7lZkDgzwHZfNutQw
        NV8KXIrKPW/eNFXW2H70JgUIzgIVIftpjKXw3v5sO2yXTnzzQTtvoM348N4CDCY5TU1RBO
        IgshvXMhDkUxJ3DZvGUoL3QDFBS2f/nMxQt6nXxG9eQ32YD0xSN58iBOi+wrA2bFr4inBE
        dTe5e5MP/LEF79kC8pEC+erqAHlL73U8C0FYkRsCpsb0645Z3W92aii3wz2UbOeg==
Received: by filterdrecv-64fcb979b9-7lnp4 with SMTP id filterdrecv-64fcb979b9-7lnp4-1-61C3CD5E-10
        2021-12-23 01:14:06.269481321 +0000 UTC m=+8644593.200041699
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id LNQyyxPoSt-QvKfE-Cejvg
        Thu, 23 Dec 2021 01:14:06.045 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id F1607700F78; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 09/50] wilc1000: prepare wilc_wlan_tx_packet_done() for
 sk_buff changes
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-10-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvCb1xlyXRSrVqQqxd?=
 =?us-ascii?Q?c6y8Gj6yOsjIp2cOckDjzQ6eQStIL96U5Dw3ROd?=
 =?us-ascii?Q?QNJIrQjv46xS5QYahfsOrfwiSRwctE9FVHhghNz?=
 =?us-ascii?Q?OQm+COo0Zt6ZUO1iFwjUBTYF2IdJWT43fNXtK5+?=
 =?us-ascii?Q?2CYMNMWBuK4xYPyITe9lfoPSbS=2FkFuLZ7yZreg?=
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

This patch just adds some helper variables.  I suppose they improve
readability, but the real reason for this patch is to make the
forthcoming sk_buff rework patch shorter and more obvious.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 1156498e66b81..77dd91c23faad 100644
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

