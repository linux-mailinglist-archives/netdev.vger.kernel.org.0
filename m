Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E3E47DCD5
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345990AbhLWBOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:23 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18144 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241977AbhLWBON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=m7/NHd70aW+5nMyYcygmge2MErZGaxPW2OeWbTdP2ZI=;
        b=UGhCfPVJLrG5fdt631HayU/HkgnPSBr/OW//HfPWFRPo8wlRWuHNDXBIj/E+KQ0c0yNb
        WyNfQkNuiU34RLLV5lZHygBSQQGJV9u2Z002n9RAUgixoiGtWvqPEMM5lsRAtBsDxO1l/J
        Dqm9hnN3r+xDBpb/21xy8t+Onzp6GGtgp75gkFy8HYakq+a1nsUJwETOhp032G2P1hZSj/
        7jO+Opn4hIVMUwuRvP8bYWO3qAYAbZiiCEHQ/1qk5s2OUvdoKFGWv5zeCWTdoY/tuUR+eB
        YF0Prxhr9hscKB9hb2Xpv/iO/7Yuv1WGm2vlExaUBR/KUc4o5CpoTfil89am6q7g==
Received: by filterdrecv-75ff7b5ffb-q2hvm with SMTP id filterdrecv-75ff7b5ffb-q2hvm-1-61C3CD5E-1A
        2021-12-23 01:14:06.383809858 +0000 UTC m=+9687230.227918554
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-canary-0 (SG)
        with ESMTP
        id odf-ZXRpRF20CW2pPp5AVQ
        Thu, 23 Dec 2021 01:14:06.223 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 0EB277010D8; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 12/50] wilc1000: refactor wilc_wlan_cfg_commit() a bit
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-13-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvCI5wdCf6k9nSTiV8?=
 =?us-ascii?Q?Y5orYAp30zrmhpmPpWiYcIZ7KjBx7mrhBRbhHE8?=
 =?us-ascii?Q?NiP1IDsjpJ8qs9=2F442dFh+0K0Pmp3hUiTawOAuu?=
 =?us-ascii?Q?JInHzDQWPjkPVRItVk6PDbKk9i5zefEO3V=2FK3e5?=
 =?us-ascii?Q?NYnYQIfSFhakOvzpXvwwJg344atnssW2Ue9mjv?=
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

This cleanup makes the switch to sk_buff queues easier.  There is no
functional change.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 26b7d219ecbbb..2e3dc04120832 100644
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

