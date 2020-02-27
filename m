Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0560A171629
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 12:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgB0Ljp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 06:39:45 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:47825 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbgB0Ljp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 06:39:45 -0500
Received: from kiste.fritz.box ([87.123.206.167]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MvbJw-1jNAEi2esY-00shlE; Thu, 27 Feb 2020 12:39:34 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, hwipl <ndev@hwipl.net>
Subject: [RFC net-next] net/smc: update peer ID on device changes
Date:   Thu, 27 Feb 2020 12:39:02 +0100
Message-Id: <20200227113902.318060-1-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:LUQIUUjvETEBymbGD22ORfJDDJkphX+sRh22dMbDM0OUVOIcqMc
 cssU4cIrdTAw7beLQlue2dWml3xrSzeu/ocm4vm7nkII5WGOm5X39rpeE5mLJRlfhOPm3f/
 ZU8QnAxgIBhPEXtQvvuF6nn6+Tv1TYfJxKpp5MKgTJt0YSJy24QwbYf/7lMyTWx1pk70AUF
 VPyVaE+THsfBYh0jQKdbQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JDwMI+XFHWI=:kOFWOv0vP63FH6q694lU9M
 S8mA31KalgRWdXURkj3hK5SEBbMCNCArd5XT+ua3GJUkgJHdQcG3/O6TVP74H8ynAEmvk3wvn
 sYnBw30T1OuWgtRDDVsYSZ+mjqrKy2tOMwP0T1wbnZu3ZsyBOTtNwtEoOsMNylV/qG9mPRSc4
 Fjd3TTHtk+VPFlsZYv3fp3DCErwCCi8dm9jOZBqkTm21yw0+8832uSydg2HZc2zQy/1AbQXcu
 EyqsLWR0Gy8LWW/tZ+jkl0fRplT7C58nFbimYCisfcKOcTmTh1RRmZm70R012gelSgBq2174A
 7e2ETx+KCGfsYjcy4ZJbwtGpbMFRogLuOOIRDEGLXpb1Bl6ebR0IFhgSW4G0+14xc+nXE3JiM
 +/HJmOZRC5VzcC9ug8bMT+PWXzE8Ga2Vu50BZVau+Z4okXkN77JzfjOTDPFVO1tVPEtN5hxDR
 bxgPDn6VL/kP6h6O4w/hMLhX7GEiiIba3xQortMJ/hxs7IwoqnSrjUBKigUy81brq4binN5fa
 9B1lfwCznj7pccosHNVuMBut4YyU07ukytwCbfGEO20h3Ka8YE8Tbn/L1yUCc9uWXja/pFr8N
 nw1lQnGoKkxWvcEccNJs4RxPOY1onGu0u3AkrvrumLxAC0Mdq9+66DaOeCHC6bXC2HzX9KtLV
 ZeLnJ+S/DBA3RLVnXybI7Rdu1GeFAQfuIe9xuuGxFZolpOZu55qurFRczQS/hvsI+aUdLXIh8
 D45l6QPK/wwPDtgThdCP6mHCF14XwvjJLhzV/17/QKGXRUnmofstcNzON2h0oMhPByOoBjPih
 N/BAKlD+KsqsZNsBagTk9w4NLDZiEHf6LpQWmD5W5rEx+ykOxpFxzQ7EsFBxCsGb8fSnSrx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hwipl <ndev@hwipl.net>

A SMC host's peer ID contains the MAC address of the first active RoCE
device. However, if this device becomes inactive or is removed, the peer
ID is not updated. This patch adds peer ID updates on device changes.

Signed-off-by: hwipl <ndev@hwipl.net>
---
 net/smc/smc_ib.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 3444de27fecd..5818636962c6 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -159,11 +159,29 @@ static int smc_ib_fill_mac(struct smc_ib_device *smcibdev, u8 ibport)
  * plus a random 2-byte number is used to create this identifier.
  * This name is delivered to the peer during connection initialization.
  */
-static inline void smc_ib_define_local_systemid(struct smc_ib_device *smcibdev,
-						u8 ibport)
+static void smc_ib_update_local_systemid(void)
 {
-	memcpy(&local_systemid[2], &smcibdev->mac[ibport - 1],
-	       sizeof(smcibdev->mac[ibport - 1]));
+	struct smc_ib_device *smcibdev;
+	u8 ibport;
+
+	/* get first ib device with an active port */
+	spin_lock(&smc_ib_devices.lock);
+	list_for_each_entry(smcibdev, &smc_ib_devices.list, list) {
+		for (ibport = 1; ibport <= SMC_MAX_PORTS; ibport++) {
+			if (smc_ib_port_active(smcibdev, ibport))
+				goto out;
+		}
+	}
+	smcibdev = NULL;
+out:
+	spin_unlock(&smc_ib_devices.lock);
+
+	/* set (new) mac address or reset to zero */
+	if (smcibdev)
+		ether_addr_copy(&local_systemid[2],
+				(u8 *)&smcibdev->mac[ibport - 1]);
+	else
+		eth_zero_addr(&local_systemid[2]);
 }
 
 bool smc_ib_is_valid_local_systemid(void)
@@ -229,10 +247,6 @@ static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
 	rc = smc_ib_fill_mac(smcibdev, ibport);
 	if (rc)
 		goto out;
-	if (!smc_ib_is_valid_local_systemid() &&
-	    smc_ib_port_active(smcibdev, ibport))
-		/* create unique system identifier */
-		smc_ib_define_local_systemid(smcibdev, ibport);
 out:
 	return rc;
 }
@@ -254,6 +268,7 @@ static void smc_ib_port_event_work(struct work_struct *work)
 			clear_bit(port_idx, smcibdev->ports_going_away);
 		}
 	}
+	smc_ib_update_local_systemid();
 }
 
 /* can be called in IRQ context */
@@ -599,6 +614,7 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
 	smc_ib_cleanup_per_ibdev(smcibdev);
 	ib_unregister_event_handler(&smcibdev->event_handler);
 	kfree(smcibdev);
+	smc_ib_update_local_systemid();
 }
 
 static struct ib_client smc_ib_client = {
-- 
2.25.1

