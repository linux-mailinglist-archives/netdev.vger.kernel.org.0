Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71CC58466F
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiG1TS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiG1TS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:18:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A906069C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:18:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2EB8234755;
        Thu, 28 Jul 2022 19:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659035934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fnZmAaoN7tWe7H2f2+ScWI7LBk8Mm/FaPBvmmo+kY0g=;
        b=SOasKaJZvHHzIZa2Xa6OEpKkmSQNY/uJkRClBerDxsvD1fL3ZAZojm6bjX/P03rvGKoVHl
        2Dw36Mf6LrMMXSv0piXKlNe4lzrtIlSC6t7tvcHINwpNaTI1Mfoftf7YRuvJgDsduEzj1e
        Lbj/LsqMSJ0g7nykhy5VJVkrw3ynhGE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0514313A7E;
        Thu, 28 Jul 2022 19:18:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wnMvOx3h4mJyTAAAMHmgww
        (envelope-from <oneukum@suse.com>); Thu, 28 Jul 2022 19:18:53 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     hayeswang@realtek.com, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [RFC] r8152: pass through needs to be singular
Date:   Thu, 28 Jul 2022 21:18:51 +0200
Message-Id: <20220728191851.30402-1-oneukum@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If multiple devices are connected only one of them
is allowed to get the pass through MAC

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/r8152.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0f6efaabaa32..15f695398284 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1193,6 +1193,9 @@ static unsigned int agg_buf_sz = 16384;
 
 #define RTL_LIMITED_TSO_SIZE	(size_to_mtu(agg_buf_sz) - sizeof(struct tx_desc))
 
+static struct r8152 *holder_of_pass_through = NULL;
+static DEFINE_MUTEX(pass_through_lock);
+
 static
 int get_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 {
@@ -1587,8 +1590,19 @@ static int __rtl8152_set_mac_address(struct net_device *netdev, void *p,
 	return ret;
 }
 
+static void give_up_pass_through(struct r8152 *tp)
+{
+	mutex_lock(&pass_through_lock);
+	if (tp == holder_of_pass_through)
+		holder_of_pass_through = NULL;
+	mutex_unlock(&pass_through_lock);
+}
+
 static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 {
+	struct r8152 *tp = netdev_priv(netdev);
+
+	give_up_pass_through(tp);
 	return __rtl8152_set_mac_address(netdev, p, false);
 }
 
@@ -1608,6 +1622,12 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 	acpi_object_type mac_obj_type;
 	int mac_strlen;
 
+	mutex_lock(&pass_through_lock);
+
+	if (!holder_of_pass_through) {
+		ret = -EBUSY;
+		goto failout;
+	}
 	if (tp->lenovo_macpassthru) {
 		mac_obj_name = "\\MACA";
 		mac_obj_type = ACPI_TYPE_STRING;
@@ -1621,7 +1641,8 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 			if ((ocp_data & PASS_THRU_MASK) != 1) {
 				netif_dbg(tp, probe, tp->netdev,
 						"No efuse for RTL8153-AD MAC pass through\n");
-				return -ENODEV;
+				ret = -ENODEV;
+				goto failout;
 			}
 		} else {
 			/* test for RTL8153-BND and RTL8153-BD */
@@ -1629,7 +1650,8 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 			if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK) == 0) {
 				netif_dbg(tp, probe, tp->netdev,
 						"Invalid variant for MAC pass through\n");
-				return -ENODEV;
+				ret = -ENODEV;
+				goto failout;
 			}
 		}
 
@@ -1641,8 +1663,10 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 	/* returns _AUXMAC_#AABBCCDDEEFF# */
 	status = acpi_evaluate_object(NULL, mac_obj_name, NULL, &buffer);
 	obj = (union acpi_object *)buffer.pointer;
-	if (!ACPI_SUCCESS(status))
-		return -ENODEV;
+	if (!ACPI_SUCCESS(status)) {
+		ret = -ENODEV;
+		goto failout;
+	}
 	if (obj->type != mac_obj_type || obj->string.length != mac_strlen) {
 		netif_warn(tp, probe, tp->netdev,
 			   "Invalid buffer for pass-thru MAC addr: (%d, %d)\n",
@@ -1670,6 +1694,10 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 
 amacout:
 	kfree(obj);
+failout:
+	if (!ret)
+		holder_of_pass_through = tp;
+	mutex_unlock(&pass_through_lock);
 	return ret;
 }
 
@@ -8287,6 +8315,7 @@ static int rtl8152_pre_reset(struct usb_interface *intf)
 		tp->rtl_ops.disable(tp);
 		mutex_unlock(&tp->control);
 	}
+	give_up_pass_through(tp);
 
 	return 0;
 }
@@ -9802,6 +9831,7 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 		cancel_delayed_work_sync(&tp->hw_phy_work);
 		if (tp->rtl_ops.unload)
 			tp->rtl_ops.unload(tp);
+		give_up_pass_through(tp);
 		rtl8152_release_firmware(tp);
 		free_netdev(tp->netdev);
 	}
-- 
2.35.3

