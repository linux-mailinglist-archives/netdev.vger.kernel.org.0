Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A7A47DCED
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346177AbhLWBPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:11 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27262 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346218AbhLWBOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=xzFPhXZu131S24WhCZubllRraK0h+X09hgsH4auEmW4=;
        b=djZrXPvzTA+tenvtDns76GrrGFaM7cWDR9tozlDMHoxIqe9+LXIVtdvJsz1hf4d0k6Ic
        YJ6lIA4aCMpnalQrDHzf5+6jM9osn6cMu+Gz49FiGyOyEroePgKxdMK/M8za14oNvOTPzI
        35C4sU2LeBk0my/7AP1m6dUEoZnufrbbvAjf8oLshnggyRuZWuJDCz0GmOzzzMaKs1clDX
        xXCbvW5H3RgfFVwRshdqYrEPEGjx5OtBCLhYVCdRgo0My2C/yVfCEHz3lO9I2EQfyqjFRw
        p2rTJSiFtpD7FDpAr+39knzavoySljUyGYoNRq+z2ehO8gPB2QpHPS+/nOfxJ9Hw==
Received: by filterdrecv-64fcb979b9-tjknx with SMTP id filterdrecv-64fcb979b9-tjknx-1-61C3CD5E-38
        2021-12-23 01:14:06.990457231 +0000 UTC m=+8644589.793975669
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-1 (SG)
        with ESMTP
        id FG5k7M4MSAKXB0gV8TRNhQ
        Thu, 23 Dec 2021 01:14:06.823 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id B4878700604; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 35/50] wilc1000: introduce copy_and_send_packets() helper
 function
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-36-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvBiV+jvdVngOyqcOk?=
 =?us-ascii?Q?0VU2J+4m=2FBmK9woiA=2Fsth2gm5SOmvaIqU3Ea+Es?=
 =?us-ascii?Q?=2F+ATfy2JI9lP0biBgmaDlwfMwwY0thbj+24I+DP?=
 =?us-ascii?Q?gkb9jwrDt2wnr+KK3uNxnrj8j9D66yD4oxmkCze?=
 =?us-ascii?Q?FTrLxx7iQtis4c1mrFYRVIk6ab3=2FUK0MM9mEMt?=
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

Continuing the quest of simplifying the txq handler, factor the code
to copy and send packets into its own function.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 803d35b18d2e0..18b1e7fad4d71 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -906,6 +906,22 @@ static int send_packets(struct wilc *wilc, int len)
 	return func->hif_block_tx_ext(wilc, 0, wilc->tx_buffer, len);
 }
 
+static int copy_and_send_packets(struct wilc *wilc, int entries,
+				 u32 vmm_table[WILC_VMM_TBL_SIZE],
+				 u8 vmm_entries_ac[WILC_VMM_TBL_SIZE])
+{
+	int len, ret;
+
+	len = copy_packets(wilc, entries, vmm_table, vmm_entries_ac);
+	if (len <= 0)
+		return len;
+
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
+	ret = send_packets(wilc, len);
+	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
+	return ret;
+}
+
 int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 {
 	int vmm_table_len, entries;
@@ -940,12 +956,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	if (entries <= 0) {
 		ret = entries;
 	} else {
-		ret = copy_packets(wilc, entries, vmm_table, vmm_entries_ac);
-		if (ret > 0) {
-			acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
-			ret = send_packets(wilc, ret);
-			release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
-		}
+		ret = copy_and_send_packets(wilc, entries, vmm_table, vmm_entries_ac);
 	}
 	if (ret >= 0 && entries < vmm_table_len)
 		ret = WILC_VMM_ENTRY_FULL_RETRY;
-- 
2.25.1

