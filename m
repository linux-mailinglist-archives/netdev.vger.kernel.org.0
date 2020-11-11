Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EC72AE956
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgKKHCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKKHCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:02:46 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C6FC0613D4
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 23:02:46 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c9so1442654ybs.8
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 23:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=/ezy6lAqc7MUpQhd7aVdTsjzC/c2bjGSDjWe3QgakvQ=;
        b=s/H6zmoLfEXRQNcRx7zUFU8wfrx5RJAaSHfdhk84w3Dqq1BpMLRQQLcnGQe7KGOzyD
         a67A2Hhljl2ShnN7/NFTvFO4b9IN55IAl9CcULX3/Y7h8Mg2pjSQLNdnWj923uJ4O459
         PublNtsKunIM7vnIfav+d11sNkZSJrFwRvtXcs81MrFGxeeBXS1noHnZLKF+yvqE9igb
         bY/TddyyNVGasiZRr9W2AFqbC9yoP6vNSqqQq9wejOVFbx52F6/yuevdhURow/hva6mu
         Au8f5v9OY4A8Vpcm2Iz3RTmNWgSCanNrWhEF9P6TEOG7Gz2qGx5ofh+rdJqUbWiTqwGn
         vyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/ezy6lAqc7MUpQhd7aVdTsjzC/c2bjGSDjWe3QgakvQ=;
        b=BRzmF6zzuLnSzYBp0gSWLK2fKTweUzgMVe3ThsI9zl1DLzoMj2CfgzZyciJBxoDxHl
         cj7x+KlNyLiwc3ff6a5xOCbsM65e4MGSlByMOWdLajC3BgHKYMBuEfmk9mTzhRRsa1ON
         iHLjXxF7yuRQdsmEu9JteJJ9gK1vFhmvwW0vSlqZ63P+lmzSaRyWm7prPPnI3psRf8i7
         AoGxYY3Y5OKQttUFbdK7UMx/i8M6U1YF5TZCnQpcqVqDRvgwFIvorYRyFaE+Jwficxi8
         inFvf/zBFKrMnZXU7il2qlm/NOW0VyCWm+rQeP9GTaUaqNjm6/Hy4mq38e1giK5Mjbjw
         4Prg==
X-Gm-Message-State: AOAM531yRKiQSbhRd1C+QYd3WRhZcVjPELLcvfqaPvVZ5l5vPw4Ihn4Y
        f7CL+EnuA848Hyhwk8hgj2H2UGN3ns8OK/K8vw==
X-Google-Smtp-Source: ABdhPJzpTsl4TADfaUaX6uWEna/KkVxRUWr84P5WsPegWiLLwekP/jEttU9YuVCUBO9RwOFpxEZ5A6nPk+JgDefg7g==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:be90:: with SMTP id
 i16mr28501321ybk.189.1605078165464; Tue, 10 Nov 2020 23:02:45 -0800 (PST)
Date:   Wed, 11 Nov 2020 15:02:21 +0800
In-Reply-To: <20201111150115.v9.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
Message-Id: <20201111150115.v9.3.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20201111150115.v9.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH v9 3/6] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mmandlik@chromium.org, mcchou@chromium.org,
        Howard Chung <howardchung@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds code to handle the system suspension during interleave
scan. The interleave scan will be canceled when the system is going to
sleep, and will be restarted after waking up.

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
---

(no changes since v5)

Changes in v5:
- Remove the change in hci_req_config_le_suspend_scan

 net/bluetooth/hci_request.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 2fd56ee21d31f..d943ad2885aa0 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1293,8 +1293,10 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
 
 		/* Disable LE passive scan if enabled */
-		if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
+		if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
+			cancel_interleave_scan(hdev);
 			hci_req_add_le_scan_disable(&req, false);
+		}
 
 		/* Mark task needing completion */
 		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
-- 
2.29.2.222.g5d2a92d10f8-goog

