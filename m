Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD92127CB2A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732667AbgI2MZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729685AbgI2Ldn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:33:43 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9796DC0613D2
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:25:53 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id m13so2683677qtu.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=/VsBobuTIfoCbFzJ0kQqpf8oU3yDxKHHFbs4g4IK6lE=;
        b=OOkMhc9kd/YE88zM44mAvr9hdQJnhfyFf/+Wf3DKnSyFaxsGd34jTGMKpJXAgB5W6t
         tx17kPa/mRwFvluvQ72yoXRMEvtwgT26e5d4KsHaIZNyrKjA+nNWaxK73+6MEvypnEwx
         TGmbbK7jdvsMUzVXf/NKciW7hZPxPFZKTNAJ96HZFAxBBgS30Rt6EBa0X3MUOCGgdZjM
         fp8kbGxGFCdVRbT/w2439Fow/i2m62XdbjXQtZOJfe59fM29JGgrYof2AFnXE+5tqmbQ
         whozH39NbiWScSh4FZxSVUXOleDMflrFSblR9flbBj0ymSK3cGFcolS0enqYxIBl5d6I
         d1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/VsBobuTIfoCbFzJ0kQqpf8oU3yDxKHHFbs4g4IK6lE=;
        b=dIn1asARbdtrqNjsSgedHycbAN5RBCd278WCzjsjRrFhboW7ywquYn4g/5l0B9k74A
         TBHnJf27+X1Gnxekwv/xxX7JxjqXheC6PoQZz6OEBQ7afuYznDlk9t27k/P08I7czFxc
         kqG7sU3tFx1YViOZTwQb+elJ26rH9SL8f7MBfmHWK5n5oLtpWzDWWJ/YeMBD0QrjQJyH
         WgL6JanPCkJ8j7ik9ze7a04qVBVbBXli3gqxi14HdzN40g1gO8seRSBlZGVN+jTmwLOw
         smJApeR8JHBh6J6Gviy0p+3nNIQECtZEtH36UhmutPdRpGUGkUvuwKfY0pBszZRLutOG
         GfnA==
X-Gm-Message-State: AOAM531PGHfga+jR8VVSJuam1wEgF0FTH4U1JZMSgKraXrsMVDK2VKns
        kKt2ao6XhQtRgUkQ/QZQNBNAQlsibP/nDghllQ==
X-Google-Smtp-Source: ABdhPJzLzPklrSrGkyauOe8xVu8TSVmdlQbBVWjWRiw60PlVaYo2l3XoJjNawqozcNCs75lSLOyxEjtCHPW7SUlaOg==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a05:6214:292:: with SMTP id
 l18mr4013077qvv.11.1601378752727; Tue, 29 Sep 2020 04:25:52 -0700 (PDT)
Date:   Tue, 29 Sep 2020 19:25:24 +0800
In-Reply-To: <20200929192508.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200929192508.v7.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20200929192508.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v7 2/4] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.org, alainm@chromium.org, mcchou@chromium.org,
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
index ba3016cc0b573..db44680fbe9c9 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1281,8 +1281,10 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
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
2.28.0.709.gb0816b6eb0-goog

