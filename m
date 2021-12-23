Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5FB47DCC6
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345874AbhLWBOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:11 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18032 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241379AbhLWBOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=xW1715MXgBwHsK1A3U4v+kbFvvAbBFG76BgdlmNpRzE=;
        b=oswUulyiyzoQbmbFBk645iztnQ8z5NVCEdmI/iUIoX9EK+3J5KpoUS+m3JK4ff1oVUC8
        Dm7qP5PdcEzFW/UPDYgmXu3GDND3mdMdIS/2bPcAJ+EEEhO2fyVoEtMWZ+pJEW8psdN8Zx
        WF+jVb0dETjAin2X8LNp6M4rItuaZLw5Ue8K+xiaF1tDKyDsHpyM5YXJV2gnGQP1VP3QYR
        JP/mAITLcYzO3+1aUPpyJzFNvod0a10OnLSGLOEdI6+5cUXPyr+TemOclQZd9CL2nZo7bm
        YcSXk0RLoyt4wYRiHpWqP6Uj8Amfdb4lT89qB+58cVQRDw2VynyJyjB5x3zTZ03g==
Received: by filterdrecv-7bf5c69d5-88tll with SMTP id filterdrecv-7bf5c69d5-88tll-1-61C3CD5E-E
        2021-12-23 01:14:06.177821663 +0000 UTC m=+9687225.027774416
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-0 (SG)
        with ESMTP
        id MsGsOEceTr-VDilM5VIsgw
        Thu, 23 Dec 2021 01:14:06.049 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 14FDC701151; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 13/50] wilc1000: sanitize config packet sequence number
 management a bit
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-14-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvGypGrhqGxl=2FEY3id?=
 =?us-ascii?Q?+trAVDjgRqjwx0dK6tKpD39ADl8w+Ha58BsfUJS?=
 =?us-ascii?Q?RdeVHdNMmSbtm+kB4TnuFscnap7cx5Nsd2QsBkI?=
 =?us-ascii?Q?P1l=2FJAJQKECT+TcPiuzB4iKxO0yacn4d38t4HTa?=
 =?us-ascii?Q?7evU8nfcTCWMCP2UijtnpqPc+fyLL0acIQ0wTR?=
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

Always keep the config packet sequence number in the valid range from
0..255.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 2e3dc04120832..979615914d420 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1275,10 +1275,9 @@ static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
 
 	hdr = &cfg->hdr;
 	hdr->cmd_type = (type == WILC_CFG_SET) ? 'W' : 'Q';
-	hdr->seq_no = wilc->cfg_seq_no % 256;
+	hdr->seq_no = wilc->cfg_seq_no;
 	hdr->total_len = cpu_to_le16(t_len);
 	hdr->driver_handler = cpu_to_le32(drv_handler);
-	wilc->cfg_seq_no = cfg->hdr.seq_no;
 
 	if (!wilc_wlan_txq_add_cfg_pkt(vif, (u8 *)&cfg->hdr, t_len))
 		return -1;
@@ -1347,7 +1346,7 @@ static int wilc_wlan_cfg_apply_wid(struct wilc_vif *vif, int start, u16 wid,
 	}
 
 	wilc->cfg_frame_offset = 0;
-	wilc->cfg_seq_no += 1;
+	wilc->cfg_seq_no = (wilc->cfg_seq_no + 1) % 256;
 	mutex_unlock(&wilc->cfg_cmd_lock);
 
 	return ret_size;
-- 
2.25.1

