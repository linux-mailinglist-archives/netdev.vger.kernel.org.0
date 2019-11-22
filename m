Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FDB107846
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 20:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfKVTuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 14:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727715AbfKVTuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 14:50:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C5F8207DD;
        Fri, 22 Nov 2019 19:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452204;
        bh=DcYvt+Q+aSnKyphRdP2dH3cuxBzZPVYxLv7NZ00iOGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOtUVpW6fxZkFdRXSP0ZxvjKWQu6zUdmXWCa6JaMbD33pjsMtIAPgz/YLYcoEi9nO
         dVz11Z5pcSh/AQMVk141DcSMBptSyxvMQJf+9B8eEtxnco2sGJ5jkt7921vQ1gu4uE
         mqoS7U8rCcL29zocgIqF71IizMKfHyRHQ94D0x1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/13] NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error
Date:   Fri, 22 Nov 2019 14:49:50 -0500
Message-Id: <20191122194958.24926-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194958.24926-1-sashal@kernel.org>
References: <20191122194958.24926-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit a71a29f50de1ef97ab55c151a1598eb12dde379d ]

I2C communication errors (-EREMOTEIO) during the IRQ handler of nxp-nci
result in a NULL pointer dereference at the moment:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    Oops: 0002 [#1] PREEMPT SMP NOPTI
    CPU: 1 PID: 355 Comm: irq/137-nxp-nci Not tainted 5.4.0-rc6 #1
    RIP: 0010:skb_queue_tail+0x25/0x50
    Call Trace:
     nci_recv_frame+0x36/0x90 [nci]
     nxp_nci_i2c_irq_thread_fn+0xd1/0x285 [nxp_nci_i2c]
     ? preempt_count_add+0x68/0xa0
     ? irq_forced_thread_fn+0x80/0x80
     irq_thread_fn+0x20/0x60
     irq_thread+0xee/0x180
     ? wake_threads_waitq+0x30/0x30
     kthread+0xfb/0x130
     ? irq_thread_check_affinity+0xd0/0xd0
     ? kthread_park+0x90/0x90
     ret_from_fork+0x1f/0x40

Afterward the kernel must be rebooted to work properly again.

This happens because it attempts to call nci_recv_frame() with skb == NULL.
However, unlike nxp_nci_fw_recv_frame(), nci_recv_frame() does not have any
NULL checks for skb, causing the NULL pointer dereference.

Change the code to call only nxp_nci_fw_recv_frame() in case of an error.
Make sure to log it so it is obvious that a communication error occurred.
The error above then becomes:

    nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121
    nci: __nci_request: wait_for_completion_interruptible_timeout failed 0
    nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121

Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/i2c.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 06a157c63416a..7eab97585f22b 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -238,8 +238,10 @@ static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 
 	if (r == -EREMOTEIO) {
 		phy->hard_fault = r;
-		skb = NULL;
-	} else if (r < 0) {
+		if (info->mode == NXP_NCI_MODE_FW)
+			nxp_nci_fw_recv_frame(phy->ndev, NULL);
+	}
+	if (r < 0) {
 		nfc_err(&client->dev, "Read failed with error %d\n", r);
 		goto exit_irq_handled;
 	}
-- 
2.20.1

