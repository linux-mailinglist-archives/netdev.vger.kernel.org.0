Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0F0275459
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgIWJWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgIWJWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:22:41 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2703C0613D1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:22:41 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id y17so16197714qky.0
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ZXC6RIjQzvP4+2I2ajwE91pKSZgn0JwFP6uprOUMdtE=;
        b=KwBf6MdWhP0CknbKFW6SdYmhjmeKufVFeUTMS58YpG65Fa57LKDmq4GU4j1dXsqiIK
         KC7BzISj8ncc0A4zxKTitK5MCmXO218SNreBVdugutCob9UXG4C58Z2tRQeVF9EKNb2J
         HiBgyUGwChc7JqQKrA3Qq9ErOSHpPE/+rggv4QgrniULhscUIqiA0hrqw0rasVk5MzfA
         jLq6LVKHSx7vS1L664xoRfUvtfZidSSGCdb5Ds39MS9676fDRPgWxgdPcl7p0OjvaxVj
         dSTcruurTkrqS/H7wO7O2n8UQiS/8MAH0rIQdWjb3NUjXfb5cK5SAlj7AXAIPz1g0aAO
         CF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZXC6RIjQzvP4+2I2ajwE91pKSZgn0JwFP6uprOUMdtE=;
        b=OOnsW+NXlIULZmMpI46z1phknMW+PKqVFYoaDtagpuxYMzG/jTN6qS4GGnCnO2UlXD
         CdfXx7SFjshJgS1Sy2K5wQEDRsAj2eIo85Ii4+Eu/zKNWr0fi7P+s7yQ+OpjFoeE4Jg+
         4q8pJxGj2tidFR/ge0nVLMqax/XEk2SUDsQmHJJbbD6YlAnJom4L42yHw5YGJQgaZGMy
         h4Mm095AD9Ctdono5+A/L0mIO7W6ON02BPR2rrYNPUwCP5iAEN+VFWnCb2hwiE5z5XWs
         v4+LwWsXdSSUkkLrLFUtp/E7pfxmCXrOwAyxRrTNGU+uX4be68MDLkxvKkMyraNPi2QU
         QqHQ==
X-Gm-Message-State: AOAM533+J6f28t3Yw4Lw82otGexr7g4zMEDNMVlMZU99jnUDT9LjtS4i
        OwMCQShwHvc69TK52eXfd4/f7qx4dRRfEaNNaQ==
X-Google-Smtp-Source: ABdhPJw1JOPfZUWsb7sDXsDlMt//WE8y5Wm/J1mYW+p6E2cWqB3Sq1npvUx4u1vVd4USLPXEAs8GttiO5VkHSkIeJA==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a0c:f687:: with SMTP id
 p7mr10292000qvn.15.1600852960833; Wed, 23 Sep 2020 02:22:40 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:22:30 +0800
In-Reply-To: <20200923172129.v5.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200923172129.v5.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20200923172129.v5.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v5 2/4] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.orgi, mcchou@chromium.org, alainm@chromium.org,
        Howard Chung <howardchung@google.com>,
        Manish Mandlik <mmandlik@chromium.org>,
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
2.28.0.681.g6f77f65b4e-goog

