Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB47479E72
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbhLRXzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:55:22 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25590 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhLRXyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=IYmT6TTHPC/39vBU9dvhhZgPOg2hMoZjIu47+sZZ8/Y=;
        b=DrIkitBRj6SIJRBZaSVKO9ueK2xD5t8aW7naXhXX6fqRceeFVFdBfO6qms1f6TUJOZ0B
        5q4UakY+CURZgJIzZSviRUm2dno4ILOZGAs0RxPaHPUZBNyevCy0Q6za1l1F9Dku7T+N1e
        qvpKMiL0Ra9OWv3UZevI5XfqyDKPkdAvFmeQvCehCxKzJw8UEo2JsZ+FMcaUOY4j6JUMOw
        IUG5YQaN4Yo7R++GSkOvO4WdsJYZflrvoNRr25SFiatTY0qO9uyEZq1lSgANYyhHVdqMZ0
        kh9zehXwCJBRcIPH7GYujpQR5rmuOtwpQtqoiRwoBsA8vypIoYX3pzJDB/OWRZeA==
Received: by filterdrecv-7bf5c69d5-rfl26 with SMTP id filterdrecv-7bf5c69d5-rfl26-1-61BE74A8-21
        2021-12-18 23:54:16.88665959 +0000 UTC m=+9336805.628309366
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-1 (SG)
        with ESMTP
        id ha9uPykwTiKK9-3KpfG97g
        Sat, 18 Dec 2021 23:54:16.774 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id A620E701151; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 12/23] wilc1000: refactor wilc_wlan_cfg_commit() a bit
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-13-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvKs3SfP4=2FLmsE6Ln6?=
 =?us-ascii?Q?mpnK0MOyjtcUUykcOLofxHKn7Tfu4mZexV0qSUe?=
 =?us-ascii?Q?yJEITbq7Dtupz=2FczzZWZvHFrBH6gMI=2FpM2fD7un?=
 =?us-ascii?Q?zg8O6nRv4=2Fp2bnMpGpV0oN5S3803X2RyC5Oiz+i?=
 =?us-ascii?Q?u=2FfYmmL+s1RBjBYQuixlkB=2Ff8yHM6TAqnyUwSn?=
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

This cleanup makes the switch to sk_buff queues easier.  There is no
functional change.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 8435e1abdd515..8cd2ede8d2775 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1271,15 +1271,13 @@ static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
 	struct wilc *wilc = vif->wilc;
 	struct wilc_cfg_frame *cfg = &wilc->cfg_frame;
 	int t_len = wilc->cfg_frame_offset + sizeof(struct wilc_cfg_cmd_hdr);
+	struct wilc_cfg_cmd_hdr *hdr;
 
-	if (type == WILC_CFG_SET)
-		cfg->hdr.cmd_type = 'W';
-	else
-		cfg->hdr.cmd_type = 'Q';
-
-	cfg->hdr.seq_no = wilc->cfg_seq_no % 256;
-	cfg->hdr.total_len = cpu_to_le16(t_len);
-	cfg->hdr.driver_handler = cpu_to_le32(drv_handler);
+	hdr = &cfg->hdr;
+	hdr->cmd_type = (type == WILC_CFG_SET) ? 'W' : 'Q';
+	hdr->seq_no = wilc->cfg_seq_no % 256;
+	hdr->total_len = cpu_to_le16(t_len);
+	hdr->driver_handler = cpu_to_le32(drv_handler);
 	wilc->cfg_seq_no = cfg->hdr.seq_no;
 
 	if (!wilc_wlan_txq_add_cfg_pkt(vif, (u8 *)&cfg->hdr, t_len))
-- 
2.25.1

