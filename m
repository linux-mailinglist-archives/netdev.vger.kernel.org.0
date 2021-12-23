Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D07E47DCC9
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345877AbhLWBON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:13 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18074 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241508AbhLWBOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=+7AWGxcrq5YzxQh8YZpRRrdRupC/5aJM8GvitkVOgJc=;
        b=sgnljYTeOYohG3acZKV0iK0B/fvJScPcF/noXswvlzrshoSVIfHYus7hQF1N20wQ8OLi
        M+xlQUrF0Hh5pmmtHQwkpNj38pXSy6IBo+JrSKphjO/5Uc7u2mhZpyXXmzFlsPpARYwWyt
        7cTNgnB1F91PHzjP2tHIDCBzL48Udq6LdKVQaqhlqO7t6no7RWB1I6KJAKYq+jrvnimXNU
        dqCKzgfnLUey0mZlNF9kVC5MLsh1wF+E5OqBkJLxb8+nki/EwDx1ltomVqHSuOqp+LWSNw
        8XA7j4v+7jq8J9DPw5wN2Epwejb70xOhXt3gpWAJl98MB5YF7dSQCAelZuzsgxcQ==
Received: by filterdrecv-75ff7b5ffb-7ssmw with SMTP id filterdrecv-75ff7b5ffb-7ssmw-1-61C3CD5E-11
        2021-12-23 01:14:06.196346041 +0000 UTC m=+9687225.265879185
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-0 (SG)
        with ESMTP
        id 6x-HI6p1SLWMDmAwRcjxkg
        Thu, 23 Dec 2021 01:14:06.029 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id EA6AC700D4D; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 07/50] wilc1000: increment tx_dropped stat counter on tx
 packet drop
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-8-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvDKrArIMv0ekRFhsm?=
 =?us-ascii?Q?fMLkKZAX5foC3EIyVvusbxrwy0G4rOImm0QqeNx?=
 =?us-ascii?Q?D5K9LJ+WXaZDsNQsAFlQRJjojhhxrTwFlnApG1e?=
 =?us-ascii?Q?bJU4cJMaRh78AU7PST1pCqHi2hLsX+PnVVScYBt?=
 =?us-ascii?Q?OFngUmR30rNQa=2FWDhJTLBCUPSlWwUhhpnTfHdZ?=
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

Packet drops are important events so we should remember to count them.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index e4342631aae93..4e59d4c707ea5 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -202,7 +202,10 @@ static void wilc_wlan_tx_packet_done(struct txq_entry_t *tqe, int status)
 
 static void wilc_wlan_txq_drop_net_pkt(struct txq_entry_t *tqe)
 {
-	struct wilc *wilc = tqe->vif->wilc;
+	struct wilc_vif *vif = tqe->vif;
+	struct wilc *wilc = vif->wilc;
+
+	vif->ndev->stats.tx_dropped++;
 
 	wilc_wlan_txq_remove(wilc, tqe->q_num, tqe);
 	wilc_wlan_tx_packet_done(tqe, 1);
-- 
2.25.1

