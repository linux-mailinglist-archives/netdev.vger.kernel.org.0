Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90066971E6
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 00:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbjBNXlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 18:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjBNXlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 18:41:15 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7362CC42
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 15:41:14 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z9-20020a25ba49000000b007d4416e3667so17649073ybj.23
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 15:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=grEA36ljVWkareCn41RVV7kCMGzVsX5H4mlh3GnOHcg=;
        b=Rj+QKRBuWBXtbyjeSkwpjtr37IZdkvFx8SDbZv19ynPGWB6r9GqkTi7SyaUIpEet5y
         NMI0kOIOnH90AI29yIs0OMJ+9hxOb4fbApbgleJNmJuSr5oGOZrcZpCQJo+OGkYDRbYT
         UTWvdK/I6zkiY1lck/j+h8674fjCaUA3eJp4LRoL4Psz1AIUqXT0OiGgJV1Xw22HQ8qe
         qRSM+LidPIk+0x0kmzXl2cjLY474HS7loprG1CBJsvWjRDUXB1tNF0rNmZseZ/PRigrL
         aTu1bTleqE7J1j5Ma6zofFItjuBwRYNamr6E7eLjtHH7CK6O+SHpqiuipH8SlLaiat6T
         qfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=grEA36ljVWkareCn41RVV7kCMGzVsX5H4mlh3GnOHcg=;
        b=65YP7xdTMf3jr6UYnJH1b5Hzd9nszda1fDHdK9VOYPZtXAxNA9DE4v45mfzu0VVBVd
         Tr8t/f2PideyuDB7gi+XCECsBfYOF9CwbrCfeW/JhWFwv4xp9jWwSDQt/QpiS2hKwLcd
         UP9evsgQk6bLuNDeuiEp+gTtTrIEjDtBJNLoHi4DGeLVxoNbF8to+I8ggsZxmSjC+h6X
         7O0BKlbdBHdAnZJRxo1S/WIBnwLdB9C/NmpGkTKcoUyh5YCM09ggO1mHnd09DGMVQndP
         /voVaAzvt7sNuq/NESlHiDmJh0mhF7Sr0rp7BapfWs5Vv1Q+FjcmOUrmeIY23j90Y2iQ
         Oszw==
X-Gm-Message-State: AO0yUKV+dBMdWXhXDnbiWKq1aZvJ1K4OW4KZX4kv/jNnD9b4LwYnYnAx
        lo59VG5m7SBJ8m8nwhasj1xBSG1Wym4b
X-Google-Smtp-Source: AK7set8UWf9ag5bskq5yKp7JvmYMGfgeqRAqbG2T139Y6sSk9CkyzZs3FVSHlecILKKQ19vikSUX/1C7Kigy
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a5b:7c6:0:b0:8cb:3bb0:8a35 with SMTP id
 t6-20020a5b07c6000000b008cb3bb08a35mr52918ybq.100.1676418073501; Tue, 14 Feb
 2023 15:41:13 -0800 (PST)
Date:   Tue, 14 Feb 2023 15:41:09 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230214154104.kernel.v2.1.Ibe4d3a42683381c1e78b8c3aa67b53fc74437ae9@changeid>
Subject: [kernel PATCH v2] Bluetooth: hci_sync: Resume adv with no RPA when
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

If the host is using RPA, the controller needs to generate RPA for
the advertising, so the advertising must remain paused during the
active scan.

If the host is not using RPA, the advertising can be resumed after
disabling the address resolution.

Fixes: 9afc675edeeb ("Bluetooth: hci_sync: allow advertise when scan without RPA")
Signed-off-by: Zhengping Jiang <jiangzp@google.com>
---

Changes in v2:
- Commit message format

Changes in v1:
- With LL privacy, always pause advertising when active scan
- Only resume the advertising if the host is not using RPA

 net/bluetooth/hci_sync.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 117eedb6f709..edbf9faf7fa1 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2402,7 +2402,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 	u8 filter_policy;
 	int err;
 
-	/* Pause advertising if resolving list can be used as controllers are
+	/* Pause advertising if resolving list can be used as controllers
 	 * cannot accept resolving list modifications while advertising.
 	 */
 	if (use_ll_privacy(hdev)) {
@@ -5397,7 +5397,7 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 	/* Pause advertising since active scanning disables address resolution
 	 * which advertising depend on in order to generate its RPAs.
 	 */
-	if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRIVACY)) {
+	if (use_ll_privacy(hdev)) {
 		err = hci_pause_advertising_sync(hdev);
 		if (err) {
 			bt_dev_err(hdev, "pause advertising failed: %d", err);
@@ -5416,6 +5416,10 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 		goto failed;
 	}
 
+	// Resume paused advertising if the host is not using RPA
+	if (use_ll_privacy(hdev) && !hci_dev_test_flag(hdev, HCI_PRIVACY))
+		hci_resume_advertising_sync(hdev);
+
 	/* All active scans will be done with either a resolvable private
 	 * address (when privacy feature has been enabled) or non-resolvable
 	 * private address.
-- 
2.39.1.581.gbfd45094c4-goog

