Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0330C69EBDF
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 01:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBVASE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 19:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBVASD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 19:18:03 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8556B4491
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 16:18:00 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id la3-20020a170902fa0300b0019ca5ddecedso556955plb.1
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 16:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J9BtaV1ZeQpd3OOnFLxf3faqs1oNxew2rIeqnER9uJo=;
        b=EJEFUQAlfEKrvkYmyCpgmJInyPKTe3V/xDEINMW2a8e/zDFGP1uifrWMmX/1oEz9yn
         dIrLF0ezYBTmuB1ZhyLXzf8MzF6M47TLn8caRR9Hbjxg7dp7gLgKOvRVSnVWs4LN3ocS
         Jy4tR9tXYmbiSlw2ZJ5gLAaXvZVYzPSJvOuobOcThH9/PuLlX/l3vCoOBWSFrGUz2gXj
         WqsAgsGgfpwR0zeNK4JRtx07N2Gff8Mj8xbcXLIvQJ7cEP3bjmCQ7eC5OT6sv84YoYi5
         1qMNxE2fdQX2f1qhnporQuIbvCYgyoXnj4402MLDT/8eFGDeZ+QkMEGCifOWSaszxN1G
         9x3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J9BtaV1ZeQpd3OOnFLxf3faqs1oNxew2rIeqnER9uJo=;
        b=A0gVi1ybtFMioqHMaO9pC3oXmRWa33Yf87fYm4uggp+mxFTJCQqW+hu2x6GK2RE+vz
         HXh0w7rOfPvQvq9t24Yytptoxj8V0GUFOjQ2lnOsE6OrVej86AXfrh6c5Ug3Aa3RtPft
         FAA9NmTj6eUMrOdWIZyCWdfbDT4iCD9i2MVUjha24S32gnK6edHo2y8vTFuRv9uymPXv
         L5suDNMzdZyg46RCeTL8LrGsqJtBr48s7IwQPF8lBUCEeAeSwI25nnMNU7VF8ccWC46L
         8h0MhIEC90qnz7HVbdJI/AOIDB04YtMHTFbI4PcMPC9+IdgtJID4pQZ5ccDZcipJgxAZ
         LkmA==
X-Gm-Message-State: AO0yUKVbZ2S8p2RzA1oihzIALNk/Mp/hhnBWawRSg0W68n+h5mf5U1XJ
        VYJbsric4Vvq+Cv9WsNALlgzg6b+N1Np
X-Google-Smtp-Source: AK7set9P0icS9gZWiqtyf29s3v0oNfvjc9iMbwFgLVbB1XpIQX3QBe+LqpUwZGAaPeqLKAe+WrEjgEX1W2Lg
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a63:340d:0:b0:4fb:3591:c608 with SMTP id
 b13-20020a63340d000000b004fb3591c608mr795589pga.4.1677025080009; Tue, 21 Feb
 2023 16:18:00 -0800 (PST)
Date:   Tue, 21 Feb 2023 16:17:56 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230221161749.kernel.v3.1.Ibe4d3a42683381c1e78b8c3aa67b53fc74437ae9@changeid>
Subject: [kernel PATCH v3] Bluetooth: hci_sync: Resume adv with no RPA when
 active scan
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
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

The address resolution should be disabled during the active scan,
so all the advertisements can reach the host. The advertising
has to be paused before disabling the address resolution,
because the advertising will prevent any changes to the resolving
list and the address resolution status. Skipping this will cause
the hci error and the discovery failure.

According to the bluetooth specification:
"7.8.44 LE Set Address Resolution Enable command

This command shall not be used when:
- Advertising (other than periodic advertising) is enabled,
- Scanning is enabled, or
- an HCI_LE_Create_Connection, HCI_LE_Extended_Create_Connection, or
  HCI_LE_Periodic_Advertising_Create_Sync command is outstanding."

If the host is using RPA, the controller needs to generate RPA for
the advertising, so the advertising must remain paused during the
active scan.

If the host is not using RPA, the advertising can be resumed after
disabling the address resolution.

Fixes: 9afc675edeeb ("Bluetooth: hci_sync: allow advertise when scan without RPA")
Signed-off-by: Zhengping Jiang <jiangzp@google.com>
---

Changes in v3:
- Add a function to check the requirements to pause addr resolution
- Pause and resume advertising in hci_pause_addr_resolution
- Resume advertising if pausing addr resolution fails or privacy mode is
  not used for advertising

Changes in v2:
- Commit message format

Changes in v1:
- With LL privacy, always pause advertising when active scan
- Only resume the advertising if the host is not using RPA

 net/bluetooth/hci_sync.c | 64 +++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 117eedb6f709..37b002e1d576 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2367,6 +2367,45 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
 	return err;
 }
 
+static int hci_pause_addr_resolution(struct hci_dev *hdev)
+{
+	int err;
+
+	if (!use_ll_privacy(hdev))
+		return 0;
+
+	if (!hci_dev_test_flag(hdev, HCI_LL_RPA_RESOLUTION))
+		return 0;
+
+	/* Cannot disable addr resolution if scanning is enabled or
+	 * when initiating an LE connection.
+	 */
+	if (hci_dev_test_flag(hdev, HCI_LE_SCAN) ||
+	    hci_lookup_le_connect(hdev)) {
+		bt_dev_err(hdev, "Command not allowed when scan/LE connect");
+		return -EPERM;
+	}
+
+	// Cannot disable addr resolution if advertising is enabled.
+	err = hci_pause_advertising_sync(hdev);
+	if (err) {
+		bt_dev_err(hdev, "Pause advertising failed: %d", err);
+		return err;
+	}
+
+	err = hci_le_set_addr_resolution_enable_sync(hdev, 0x00);
+	if (err)
+		bt_dev_err(hdev, "Unable to disable Address Resolution: %d",
+			   err);
+
+	// Return if address resolution is disabled and RPA is not used.
+	if (!err && scan_use_rpa(hdev))
+		return err;
+
+	hci_resume_advertising_sync(hdev);
+	return err;
+}
+
 struct sk_buff *hci_read_local_oob_data_sync(struct hci_dev *hdev,
 					     bool extended, struct sock *sk)
 {
@@ -2402,7 +2441,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 	u8 filter_policy;
 	int err;
 
-	/* Pause advertising if resolving list can be used as controllers are
+	/* Pause advertising if resolving list can be used as controllers
 	 * cannot accept resolving list modifications while advertising.
 	 */
 	if (use_ll_privacy(hdev)) {
@@ -5394,27 +5433,12 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 
 	cancel_interleave_scan(hdev);
 
-	/* Pause advertising since active scanning disables address resolution
-	 * which advertising depend on in order to generate its RPAs.
-	 */
-	if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRIVACY)) {
-		err = hci_pause_advertising_sync(hdev);
-		if (err) {
-			bt_dev_err(hdev, "pause advertising failed: %d", err);
-			goto failed;
-		}
-	}
-
-	/* Disable address resolution while doing active scanning since the
-	 * accept list shall not be used and all reports shall reach the host
-	 * anyway.
+	/* Pause address resolution for active scan and stop advertising if
+	 * privacy is enabled.
 	 */
-	err = hci_le_set_addr_resolution_enable_sync(hdev, 0x00);
-	if (err) {
-		bt_dev_err(hdev, "Unable to disable Address Resolution: %d",
-			   err);
+	err = hci_pause_addr_resolution(hdev);
+	if (err)
 		goto failed;
-	}
 
 	/* All active scans will be done with either a resolvable private
 	 * address (when privacy feature has been enabled) or non-resolvable
-- 
2.39.2.637.g21b0678d19-goog

