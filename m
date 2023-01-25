Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D8267BDD1
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbjAYVMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbjAYVMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:12:31 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2055AB5B
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:12:18 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i17-20020a25bc11000000b007b59a5b74aaso20840989ybh.7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mjUP68ZzzFyh8hG9RPeRlc5xrTMio/O97kr7jaJq5/0=;
        b=bZKAmtw+epp2hdpRq2aYZvzRqfJc+Q6/JLBQqH5S+RddlZ7/gEumJ8QBuUtH4JWCly
         j7q66n+q3gB/gV8f/YYIHMDdCMOwWhy+uzwQtvA/D61T0UT1V0/8briK5e8ZSyVk9mAq
         59XvAqGaezM4lbTaFzWrDGZIMwNbymCD559QZxaOngdKp1+Ve6S35nnMjPrWPEuM8mkv
         ipDr0Yg39ysUTCH6HQ/gFQfaGx9E+Nsl3gUQYX1hdhyHPC14SwlYYLynR6SU91texQ0c
         skYI1gNfNvokuscJm7PhDqmEn8trMNm6HJi7YaGhBxfK3BDztlX1jjguaQxvsshZ/wsm
         CxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mjUP68ZzzFyh8hG9RPeRlc5xrTMio/O97kr7jaJq5/0=;
        b=xMnWL3DPHBPWpRiiBHgJIQnjrgxXg7upsW+XEgLsC7QcXYSA0+ZXnjbER87zDiryIu
         0CbHk3AELbhBmCIzXuae58gYuiUXsSAymUDsTiJPFaViZSIS/IJsZAuAmvONbVz3P1iJ
         aa0x3ZAZnrHhZ9VKIG+PayvV3prERiS4fCnBK0gFdJgZpCo4oGRLwQhtZPV5PBJ7Wcqu
         ieQ47nzcsF2AFCpxsZbtQYtQ8qVZjPLB0Bjc8f5rhMq1zYLI08plzt2a0Gk/0qKaBn0W
         EzNGfPUSHeSeO6I7LNuY/tfYTuHenm+5OIqTLr8Nv4D/J06VmfwXQnXO4sIO6LvOknwJ
         2c/w==
X-Gm-Message-State: AO0yUKXEmoRHsWay9+ZlwXOzLSyRR8k/t8NO+NxWzHHBThg2fvgCjLXw
        LdtwD4Lj7o6P8QhIqo6of2OI18s4yITo
X-Google-Smtp-Source: AK7set/jBOwnX0/QoX7ixwv9e2pNPa64RC5YCboTV73zgRZKUW3KNBAU33alOxNSlCaoaeo/b2tuD9s294fU
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a0d:d6c7:0:b0:506:3481:ced0 with SMTP id
 y190-20020a0dd6c7000000b005063481ced0mr1197728ywd.396.1674681137911; Wed, 25
 Jan 2023 13:12:17 -0800 (PST)
Date:   Wed, 25 Jan 2023 13:12:10 -0800
In-Reply-To: <20230125211210.552679-1-jiangzp@google.com>
Mime-Version: 1.0
References: <20230125211210.552679-1-jiangzp@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230125131159.kernel.v1.1.Id80089feef7af8846cc6f8182eddc5d7a0ac4ea7@changeid>
Subject: [kernel PATCH v1 1/1] Bluetooth: Don't send HCI commands to remove
 adv if adapter is off
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Archie Pusaka <apusaka@chromium.org>,
        Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

Mark the advertisement as disabled when powering off the adapter
without removing the advertisement, so they can be correctly
re-enabled when adapter is powered on again.

When adapter is off and user requested to remove advertisement,
a HCI command will be issued. This causes the command to timeout
and trigger GPIO reset.

Therefore, immediately remove the advertisement without sending
any HCI commands.

Note that the above scenario only happens with extended advertisement
(i.e. not using software rotation), because on the SW rotation
scenario, we just wait until the rotation timer runs out before
sending the HCI command. Since the timer is inactive when adapter is
off, no HCI commands are sent.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Signed-off-by: Zhengping Jiang <jiangzp@google.com>

---

Changes in v1:
- Mark the advertisement as disabled instead of clearing it.
- Remove the advertisement without sending HCI command if the adapter is off.

 net/bluetooth/hci_sync.c | 57 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 117eedb6f709..08da68a30acc 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1591,6 +1591,16 @@ int hci_remove_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance,
 	if (!ext_adv_capable(hdev))
 		return 0;
 
+	/* When adapter is off, remove adv without sending HCI commands */
+	if (!hdev_is_powered(hdev)) {
+		hci_dev_lock(hdev);
+		err = hci_remove_adv_instance(hdev, instance);
+		if (!err)
+			mgmt_advertising_removed(sk, hdev, instance);
+		hci_dev_unlock(hdev);
+		return err;
+	}
+
 	err = hci_disable_ext_adv_instance_sync(hdev, instance);
 	if (err)
 		return err;
@@ -1772,6 +1782,23 @@ int hci_schedule_adv_instance_sync(struct hci_dev *hdev, u8 instance,
 	return hci_start_adv_sync(hdev, instance);
 }
 
+static void hci_clear_ext_adv_ins_during_power_off(struct hci_dev *hdev,
+						   struct sock *sk)
+{
+	struct adv_info *adv, *n;
+	int err;
+
+	hci_dev_lock(hdev);
+	list_for_each_entry_safe(adv, n, &hdev->adv_instances, list) {
+		u8 instance = adv->instance;
+
+		err = hci_remove_adv_instance(hdev, instance);
+		if (!err)
+			mgmt_advertising_removed(sk, hdev, instance);
+	}
+	hci_dev_unlock(hdev);
+}
+
 static int hci_clear_adv_sets_sync(struct hci_dev *hdev, struct sock *sk)
 {
 	int err;
@@ -1779,6 +1806,12 @@ static int hci_clear_adv_sets_sync(struct hci_dev *hdev, struct sock *sk)
 	if (!ext_adv_capable(hdev))
 		return 0;
 
+	/* When adapter is off, remove adv without sending HCI commands */
+	if (!hdev_is_powered(hdev)) {
+		hci_clear_ext_adv_ins_during_power_off(hdev, sk);
+		return 0;
+	}
+
 	/* Disable instance 0x00 to disable all instances */
 	err = hci_disable_ext_adv_instance_sync(hdev, 0x00);
 	if (err)
@@ -5177,9 +5210,27 @@ static int hci_disconnect_all_sync(struct hci_dev *hdev, u8 reason)
 	return 0;
 }
 
+static void hci_disable_ext_advertising_temporarily(struct hci_dev *hdev)
+{
+	struct adv_info *adv, *n;
+
+	if (!ext_adv_capable(hdev))
+		return;
+
+	hci_dev_lock(hdev);
+
+	list_for_each_entry_safe(adv, n, &hdev->adv_instances, list)
+		adv->enabled = false;
+
+	hci_dev_clear_flag(hdev, HCI_LE_ADV);
+
+	hci_dev_unlock(hdev);
+}
+
 /* This function perform power off HCI command sequence as follows:
  *
- * Clear Advertising
+ * Disable Advertising Instances. Do not clear adv instances so advertising
+ * can be re-enabled on power on.
  * Stop Discovery
  * Disconnect all connections
  * hci_dev_close_sync
@@ -5199,9 +5250,7 @@ static int hci_power_off_sync(struct hci_dev *hdev)
 			return err;
 	}
 
-	err = hci_clear_adv_sync(hdev, NULL, false);
-	if (err)
-		return err;
+	hci_disable_ext_advertising_temporarily(hdev);
 
 	err = hci_stop_discovery_sync(hdev);
 	if (err)
-- 
2.39.1.456.gfc5497dd1b-goog

