Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9D4479E37
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhLRXyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:22 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25392 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbhLRXyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=xruF0/wdRiftakYKJKiX4VcckLBgAfUgvUqV7IHx2E4=;
        b=dvStbokSfDMpTQUXRJu+YAjUI9UwxMp2MHMiyY/9ALhBCn1Y2Peu1dDN5dADoF07cGGA
        DFqgjXTfrqNRIIlFGTHClbyjiQpTLlqt3o5ciPLWhYIR5PwfymNblYUN4DMdbVdMDFOfoY
        iSfRY/qTu/mZ1bjS9zysqfptkdjVDLXrQaaymQYk19rzyUAisp87w39OCNGy9QHi+cwPw4
        z+bR5sIytIlsRVlW5S64VBkomFmB3fprqVpBJY5Gl2Us8JxiyJbYuXYbzSa8EFkpgfZ05f
        38epAeVY373jOHwYvQdhrXQHk7MJypEu4fPA6RM5LxwYWW4bEm0eLTjO3g4FQg6w==
Received: by filterdrecv-656998cfdd-gwqfx with SMTP id filterdrecv-656998cfdd-gwqfx-1-61BE74A8-1D
        2021-12-18 23:54:16.730054846 +0000 UTC m=+7604790.136767512
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id cnPWmkt0R9uhsSnxU4r7cQ
        Sat, 18 Dec 2021 23:54:16.575 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 93A9B700A10; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 06/23] wilc1000: move tx packet drop code into its own
 function
Date:   Sat, 18 Dec 2021 23:54:16 +0000 (UTC)
Message-Id: <20211218235404.3963475-7-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvHMIlWy+OoiMKxiCz?=
 =?us-ascii?Q?vO9KY39A4krq0DN1w2fLd3tpplREjmFMJN8N3lh?=
 =?us-ascii?Q?1YratNtlBhMv13mzJqt8RyMczEzAcbUp2QlipzP?=
 =?us-ascii?Q?NUi+vInC43A1ugR1EqBNAEQflJ0eQ97laAx78OG?=
 =?us-ascii?Q?dLgztT3FRLqLwU+01SF9YgZVhvBxePmXTp=2FkQy?=
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

This is just to improve code clarity.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index caaa03c8e5df8..a9bfd71b0e667 100644
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

