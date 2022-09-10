Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF95B493C
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 23:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiIJVSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 17:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiIJVRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 17:17:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BE34D162;
        Sat, 10 Sep 2022 14:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 192D9B80943;
        Sat, 10 Sep 2022 21:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873D9C433D7;
        Sat, 10 Sep 2022 21:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844617;
        bh=wmRTbkNoy8Zu27AllxgCCaSC6UIUZ/PeINE7D8BHCA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/dWPOt4QhdpWtNPi0fcM5EmC5O3yLFBT2O0usbocPi0pPPP2s4uW4g8KMYqBDjYX
         TotoZ87uC57xtPiORu1slIwA5IA8XhttO7cKzfOBonzSTpAFruc10c4UnObpsTYbv5
         LEj26N2AqOPqeCJDUBRPZ+KWFrFmzX9mDW0wc1FL9nJhkXoETHz4PjK7IJUw84mXyW
         IcRlD0hS9QbchQSVzLUOyFr4jwPC76h8S0eodIo05v5Vm4Iw6cagQnwMKyRwvX3jpT
         aMmaWCx4CBPygumDxqu0PCtz/ymKmyHtu2zXTNq+9+LY0ECDGC1RWT76c1OOepLhbL
         djo+tif60lEDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 18/38] Bluetooth: MGMT: Fix Get Device Flags
Date:   Sat, 10 Sep 2022 17:16:03 -0400
Message-Id: <20220910211623.69825-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 23b72814da1a094b4c065e0bb598249f310c5577 ]

Get Device Flags don't check if device does actually use an RPA in which
case it shall only set HCI_CONN_FLAG_REMOTE_WAKEUP if LL Privacy is
enabled.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 71 ++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index cbdf0e2bc5ae0..d0fb74b0db1d5 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4420,6 +4420,22 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 			       MGMT_STATUS_NOT_SUPPORTED);
 }
 
+static u32 get_params_flags(struct hci_dev *hdev,
+			    struct hci_conn_params *params)
+{
+	u32 flags = hdev->conn_flags;
+
+	/* Devices using RPAs can only be programmed in the acceptlist if
+	 * LL Privacy has been enable otherwise they cannot mark
+	 * HCI_CONN_FLAG_REMOTE_WAKEUP.
+	 */
+	if ((flags & HCI_CONN_FLAG_REMOTE_WAKEUP) && !use_ll_privacy(hdev) &&
+	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type))
+		flags &= ~HCI_CONN_FLAG_REMOTE_WAKEUP;
+
+	return flags;
+}
+
 static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 			    u16 data_len)
 {
@@ -4451,10 +4467,10 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 	} else {
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						le_addr_type(cp->addr.type));
-
 		if (!params)
 			goto done;
 
+		supported_flags = get_params_flags(hdev, params);
 		current_flags = params->flags;
 	}
 
@@ -4523,38 +4539,35 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 			bt_dev_warn(hdev, "No such BR/EDR device %pMR (0x%x)",
 				    &cp->addr.bdaddr, cp->addr.type);
 		}
-	} else {
-		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
-						le_addr_type(cp->addr.type));
-		if (params) {
-			/* Devices using RPAs can only be programmed in the
-			 * acceptlist LL Privacy has been enable otherwise they
-			 * cannot mark HCI_CONN_FLAG_REMOTE_WAKEUP.
-			 */
-			if ((current_flags & HCI_CONN_FLAG_REMOTE_WAKEUP) &&
-			    !use_ll_privacy(hdev) &&
-			    hci_find_irk_by_addr(hdev, &params->addr,
-						 params->addr_type)) {
-				bt_dev_warn(hdev,
-					    "Cannot set wakeable for RPA");
-				goto unlock;
-			}
 
-			params->flags = current_flags;
-			status = MGMT_STATUS_SUCCESS;
+		goto unlock;
+	}
 
-			/* Update passive scan if HCI_CONN_FLAG_DEVICE_PRIVACY
-			 * has been set.
-			 */
-			if (params->flags & HCI_CONN_FLAG_DEVICE_PRIVACY)
-				hci_update_passive_scan(hdev);
-		} else {
-			bt_dev_warn(hdev, "No such LE device %pMR (0x%x)",
-				    &cp->addr.bdaddr,
-				    le_addr_type(cp->addr.type));
-		}
+	params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
+					le_addr_type(cp->addr.type));
+	if (!params) {
+		bt_dev_warn(hdev, "No such LE device %pMR (0x%x)",
+			    &cp->addr.bdaddr, le_addr_type(cp->addr.type));
+		goto unlock;
+	}
+
+	supported_flags = get_params_flags(hdev, params);
+
+	if ((supported_flags | current_flags) != supported_flags) {
+		bt_dev_warn(hdev, "Bad flag given (0x%x) vs supported (0x%0x)",
+			    current_flags, supported_flags);
+		goto unlock;
 	}
 
+	params->flags = current_flags;
+	status = MGMT_STATUS_SUCCESS;
+
+	/* Update passive scan if HCI_CONN_FLAG_DEVICE_PRIVACY
+	 * has been set.
+	 */
+	if (params->flags & HCI_CONN_FLAG_DEVICE_PRIVACY)
+		hci_update_passive_scan(hdev);
+
 unlock:
 	hci_dev_unlock(hdev);
 
-- 
2.35.1

