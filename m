Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E71479E5F
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbhLRXyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:55 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25514 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbhLRXyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=7Hm3AquiIUdJpoJNmQhIPdf9H6zGdNGjNitvQcp4Vl0=;
        b=ddhf6b2F3RJn2Yy14Q6Dw8PQ9gtWMXLY8IZbWymw15cu5JVGDgf1I3ZEy9b9CRG653oU
        VRxbhlEe6GBVHVHcb1NOi/MaEwb0J9CeSU+ipaewOqV3o0RpCCMWeBi0LqtA9lPn1AX8Wi
        zqRSanNOwvwsC1lfsBAuAgBBfI4+f07Oi3J3KMSn7UOHAuge7TwGoyX4cWpEBwnv082fWi
        BqcFes1EyYKgR04fgapAF4cYYRyT7P8CHFgYdewB4Qe/x7WUkiZU1lIc20r0FlkLWqqFRU
        Z29HLdMGEGfWCTaTTXUTYWvnom+U3GTwvQRUuTWdtUtnC4SDsGJHkeYC6/56kFKg==
Received: by filterdrecv-64fcb979b9-5m6bg with SMTP id filterdrecv-64fcb979b9-5m6bg-1-61BE74A8-2F
        2021-12-18 23:54:16.939374845 +0000 UTC m=+8294248.906437584
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-0 (SG)
        with ESMTP
        id 4Ej3bdy0SEWVNGLRE4ciEw
        Sat, 18 Dec 2021 23:54:16.765 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id AA5217011B9; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 13/23] wilc1000: sanitize config packet sequence number
 management a bit
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-14-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvDr8Y3qBfvE6zFPF5?=
 =?us-ascii?Q?khqlKFLZiUwzYO3DHUibB8X0HYh+GG7Armgdxbk?=
 =?us-ascii?Q?XEpYA2o6RQVm88pm2K11mbywCAqW2OmxAo8R=2Ft2?=
 =?us-ascii?Q?L7weK62kJUXeZTDQ0XAnZNZ6tYInnXxAi2G5LaK?=
 =?us-ascii?Q?NyWK8xKAvS3r=2FU1Xy9S8uz3Bmj2yfKIAxWuDRa?=
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

Always keep the config packet sequence number in the valid range from
0..255.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 8cd2ede8d2775..6484e4ab8e159 100644
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
@@ -1333,7 +1332,7 @@ static int wilc_wlan_cfg_apply_wid(struct wilc_vif *vif, int start, u16 wid,
 	}
 
 	wilc->cfg_frame_offset = 0;
-	wilc->cfg_seq_no += 1;
+	wilc->cfg_seq_no = (wilc->cfg_seq_no + 1) % 256;
 	mutex_unlock(&wilc->cfg_cmd_lock);
 
 	return ret_size;
-- 
2.25.1

