Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A84747DCE6
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346047AbhLWBPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:04 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27198 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346216AbhLWBOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=yVIQwUE9JRNbIa/ZfSEZSItfnS3OUxif3uKX0p0Ts4Q=;
        b=rImcg9Iom5wm2dvirQ5mQuphAMZvnGxdeOhd39ze3yjq4jLPi/gxhVf0fOgBnqVwiR2N
        Qos7mDvDdO1g0HDa6zLKJTwsRBVjLHtZzfdlnDr6lYcP7NZ1ly11vtTxmFsNPyvoWbFHKA
        vfAdL9L1lUTbIPmJOkyJ0o2Ctt57qfaWDiBMXRxjJcjS7KbhyfbKXxUljMbpDfNV8nd3Zo
        RIzpiJgXE2zsjf0i/VuLQCOngjIDnhdRhz6SzXHbybtvnxmSmYTRt+Apx0zq8vLhJg7ToJ
        x8p4hZLjgs9mJpHzl5N1rvFtTSH22JBUsWT40BraJy1Cw0CIQvROShStiVgt1E0w==
Received: by filterdrecv-75ff7b5ffb-bcbbj with SMTP id filterdrecv-75ff7b5ffb-bcbbj-1-61C3CD5E-1A
        2021-12-23 01:14:06.714544574 +0000 UTC m=+9687191.029415880
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-0 (SG)
        with ESMTP
        id 2tIlyEXETV22Sdh0w6UE5A
        Thu, 23 Dec 2021 01:14:06.581 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 7CD5B7014A3; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 28/50] wilc1000: improve send_packets() a bit
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-29-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvH7VqQfef+8M9fWl+?=
 =?us-ascii?Q?BgjYTNO1iE732BTkQPVhTFQ+A1qQ3TSiRj3VpHa?=
 =?us-ascii?Q?EhNKjRi77SgeRSGIId18kL=2FiLTtApC4Ky6i9WRI?=
 =?us-ascii?Q?wNptcYi5IdLvf5U7uj4OHTAqjxOBO9a40umDoIm?=
 =?us-ascii?Q?dp5+9p7bcVhMU=2FhKft5pO0Rx+7BlHuRlaS=2FzaK?=
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

Improve the documentation and simplify the code a bit.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 287c0843ba152..033979cc85b43 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -858,29 +858,26 @@ static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
 }
 
 /**
- * send_packets() - Send packets to the chip
+ * send_packets() - send the transmit buffer to the chip
  * @wilc: Pointer to the wilc structure.
- * @len: The length of the buffer containing the packets to be sent to
- *	the chip.
+ * @len: The length of the buffer containing the packets to be to the chip.
  *
- * Send the packets in the VMM table to the chip.
+ * Send the packets in the transmit buffer to the chip.
  *
  * Context: The bus must have been acquired.
  *
- * Return:
- *	Negative number on error, 0 on success.
+ * Return: Negative number on error, 0 on success.
  */
 static int send_packets(struct wilc *wilc, int len)
 {
 	const struct wilc_hif_func *func = wilc->hif_func;
 	int ret;
-	u8 *txb = wilc->tx_buffer;
 
 	ret = func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
 	if (ret)
 		return ret;
 
-	return func->hif_block_tx_ext(wilc, 0, txb, len);
+	return func->hif_block_tx_ext(wilc, 0, wilc->tx_buffer, len);
 }
 
 int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
-- 
2.25.1

