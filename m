Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FDEF6A11
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfKJQVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:21:48 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:33181 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfKJQVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573402906;
        s=strato-dkim-0002; d=gerhold.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=69FfUeSqb2fedNCohVljQrRWHmyf/9ZXSdgsxjOGuNI=;
        b=QP7GK7AnnTwE7wadEIXRoRKYUu8exR2EBMevCsa3NncBQ7zn1WDdr7At+oy8ppyIcl
        GEitvgsbTf1Un9xGH/z1DbqiOyTUNHVyLD+BNVtfRHA5lVvTHa8mHbWhIQEj9O5Z98WZ
        OK7p3eLlcjp6h+O9qLSy0H+CARqXFbHEM2cqEl6bg1AOqw/y5SnowFvWv2/NRGnPUKuo
        BeZkre9Qr79u/ea7yVC/BsqxJBsgVcSx04cBZHegTwbN32toupHAS6LNardq8iIkdh2s
        vj/di3ujOI40fLdc875qYDCoTXxF0RLUs9iYrUmnjIk1aSwnxtoMmTN3DkrpZg0Ke9LV
        s3IQ==
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXQrEOHTIXt8PvtxJQng=="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 44.29.0 AUTH)
        with ESMTPSA id e07688vAAGLQywV
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sun, 10 Nov 2019 17:21:26 +0100 (CET)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@credativ.de>,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH] NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error
Date:   Sun, 10 Nov 2019 17:19:15 +0100
Message-Id: <20191110161915.11059-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
Note: Not sure why NFC is broken on this laptop (a Lenovo ThinkPad L490).
It runs into the I2C communication errors immediately when enabling NFC.
This patch fixes the NULL pointer dereference at least.
---
 drivers/nfc/nxp-nci/i2c.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 307bd2afbe05..4d1909aecd6c 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -220,8 +220,10 @@ static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 
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
2.23.0

