Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7547DD51
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbhLWBQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:56 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27152 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346208AbhLWBOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=/EyEEryj91qJLUiXheTiSQXnfpShGhTXZyiF3Fj6NOE=;
        b=q/ktgvMgsfoIZL1oIY5FDcoHRa952fgBF/tSQCzetaW6A6iSaECMJBZjNeNkj2K3OeMP
        nEW33KEzv4pfCdNxtFl7i+KCLMPH2usx8VFOH7uGiFc8MOMwVNJRqlOpSMgSljRda9t5fF
        ulq7AzGlvmrw75pKEuGZTRhlxn+//l3Ay0JbDTQ2O+hDJCDgNMKIOsgLTQpj/Tc2IKOTEV
        oZyYAt/d/fL7x61CNKA8SAFggJJ8pjcyDcImy1wO91cMO+pBd+kkzmjlds1WxsxCsUFfv9
        Lqn0BQ+8JRP15/3fokjqzAmKPrTIJ01RWskrvTm9Ycdj6tATTfz8Hl+83X6xAKXQ==
Received: by filterdrecv-64fcb979b9-zwvj5 with SMTP id filterdrecv-64fcb979b9-zwvj5-1-61C3CD5E-30
        2021-12-23 01:14:06.829827724 +0000 UTC m=+8644582.987173852
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id NjOZgUDzQ4eb6TiIrCXIPw
        Thu, 23 Dec 2021 01:14:06.686 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id B08E5700394; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 34/50] wilc1000: restructure wilc-wlan_handle_txq() for
 clarity
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-35-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvPrUup0j1uxIpwHi0?=
 =?us-ascii?Q?Qdt824iAYJZBYYzjLIm4TfOHHZ+R40nsdoqq+2g?=
 =?us-ascii?Q?FdQlY5Su9zFVWJ0l69QnER98Ee0W5AyUbgh=2F49E?=
 =?us-ascii?Q?pcAH7cx4A1+yUbAit86JEPRgrsDJGokBB6RUJIC?=
 =?us-ascii?Q?T24sN=2FgvPE70sCcWJF31wPU97OkuQXEadIFX3g?=
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

This restructures the function to make it much clearer how the bus
hand-off works.  The patch is unfortunately a bit difficult to read,
but the final code is clearer and eliminates some gotos.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 43 ++++++++-----------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 64497754a36b1..803d35b18d2e0 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -818,8 +818,8 @@ static int send_vmm_table(struct wilc *wilc,
  * Context: The txq_add_to_head_cs mutex must still be held when
  * calling this function.
  *
- * Return:
- *	Negative number on error, 0 on success.
+ * Return: Number of bytes copied to the transmit buffer (always
+ *	non-negative).
  */
 static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
 			u8 *vmm_entries_ac)
@@ -908,7 +908,7 @@ static int send_packets(struct wilc *wilc, int len)
 
 int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 {
-	int vmm_table_len, entries, len;
+	int vmm_table_len, entries;
 	u8 vmm_entries_ac[WILC_VMM_TBL_SIZE];
 	int ret = 0;
 	u32 vmm_table[WILC_VMM_TBL_SIZE];
@@ -931,29 +931,24 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 
 	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 
-	ret = send_vmm_table(wilc, vmm_table_len, vmm_table);
-	if (ret <= 0) {
-		if (ret == 0)
-			/* No VMM space available in firmware.  Inform
-			 * caller to retry later.
-			 */
-			ret = WILC_VMM_ENTRY_FULL_RETRY;
-		goto out_release_bus;
-	}
-
-	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
-
-	entries = ret;
-	len = copy_packets(wilc, entries, vmm_table, vmm_entries_ac);
-	if (len <= 0)
-		goto out_unlock;
-
-	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
+	entries = send_vmm_table(wilc, vmm_table_len, vmm_table);
 
-	ret = send_packets(wilc, len);
+	release_bus(wilc, (entries > 0 ?
+			   WILC_BUS_RELEASE_ONLY :
+			   WILC_BUS_RELEASE_ALLOW_SLEEP));
 
-out_release_bus:
-	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
+	if (entries <= 0) {
+		ret = entries;
+	} else {
+		ret = copy_packets(wilc, entries, vmm_table, vmm_entries_ac);
+		if (ret > 0) {
+			acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
+			ret = send_packets(wilc, ret);
+			release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
+		}
+	}
+	if (ret >= 0 && entries < vmm_table_len)
+		ret = WILC_VMM_ENTRY_FULL_RETRY;
 
 out_unlock:
 	mutex_unlock(&wilc->txq_add_to_head_cs);
-- 
2.25.1

