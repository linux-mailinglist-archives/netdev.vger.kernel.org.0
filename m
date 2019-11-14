Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C569FBF9F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfKNF1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:40 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34004 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfKNF1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:39 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so3357500pff.1
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bh3eMkHXJK4ihmLY5CzJ0Du5aBuWDE7tOk39cGgbouc=;
        b=fze40yiqc+4GkX5hUDM/ylzg9SlCXJiNZW9ue1h1S8wREdfsM5+/bEKctbCtAVcr1N
         qAhgHZ7t5Azfhf24YFiZ19a2HBKeTFFGp+PonyT1OMFY1xv3eSiR3jykrA5rIrE3phxS
         Jn4K4+aWVi75X+3cgqIWeDu4QvfafAaIzORZNuYUiKYu5wJxH19LH7cwL3LRAPRuWHgh
         kFYhLxJ+uBCLhvortSxwYWfVnV+CoZcWkIab/T7iM2vCp7Dc6N1PAl7dDNYDUeUEDjJB
         R6lqRtvYsJXKFablWnW2QJYllUdy/3cPTIyKeOvkIpXcybg5r10y4se2lN6bCSeGtzN3
         PeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bh3eMkHXJK4ihmLY5CzJ0Du5aBuWDE7tOk39cGgbouc=;
        b=dPKFLDTJjNV2fFzVDUVVym2eiBGK77Z2fCcBMZSmeB1rCDK1Q8LFGjx6Quso3M1nwK
         0jn2L8+uT6TnuLjqKuxgKjysKwww61DBM0PlUTe7QETBWrRMgV53LeBUe+bIbLYvRPvE
         MktAfueqj42gi/D8eJgidP4j3UHqJ2PulNcJqHPVYsZn8pdsxEuFYF7fJvbZ2xwrqWy4
         NcazKzdPrgLXhBZZAO9ankvyoFtDI4l28uLmgNf83vP9EkWTKxTGgeMene4Agij4rNDV
         qXk0x/InvaoYS1dKXcxwFwIXupC4rtVfs75cCa+kMiZDTHtp5lUf6aYcEL+wd8rv+dET
         Cf+A==
X-Gm-Message-State: APjAAAUlz518YeDcn1j7d7Q1ONHNTXFtWxhgUvINmoUC7TkGfFvzYkFW
        YHd6Gug0gfL4Ikq4TVO4SZGkUzgNGdQ=
X-Google-Smtp-Source: APXvYqwH3egOkfFAg0ot3/CeIoJ4pUPMVgZJPYnOKfKp4PHVReOaKmmlLQi7P7dnkNou2raDQXBS1g==
X-Received: by 2002:a63:ff46:: with SMTP id s6mr8044580pgk.337.1573709257137;
        Wed, 13 Nov 2019 21:27:37 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:36 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 09/18] octeontx2-af: Sync hw mbox with bounce buffer.
Date:   Thu, 14 Nov 2019 10:56:24 +0530
Message-Id: <1573709193-15446-10-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

If mailbox client has a bounce buffer or a intermediate buffer where
mbox messages are framed then copy them from there to HW buffer.
If 'mbase' and 'hw_mbase' are not same then assume 'mbase' points to
bounce buffer.

This patch also adds msg_size field to mbox header to copy only valid
data instead of whole buffer.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c | 40 +++++++++++++++++-------
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h |  3 +-
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
index 81c83d2..387e33f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
@@ -19,17 +19,20 @@ static const u16 msgs_offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
 
 void otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
 {
+	void *hw_mbase = mbox->hwbase + (devid * MBOX_SIZE);
 	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
 	struct mbox_hdr *tx_hdr, *rx_hdr;
 
-	tx_hdr = mdev->mbase + mbox->tx_start;
-	rx_hdr = mdev->mbase + mbox->rx_start;
+	tx_hdr = hw_mbase + mbox->tx_start;
+	rx_hdr = hw_mbase + mbox->rx_start;
 
 	spin_lock(&mdev->mbox_lock);
 	mdev->msg_size = 0;
 	mdev->rsp_size = 0;
 	tx_hdr->num_msgs = 0;
+	tx_hdr->msg_size = 0;
 	rx_hdr->num_msgs = 0;
+	rx_hdr->msg_size = 0;
 	spin_unlock(&mdev->mbox_lock);
 }
 EXPORT_SYMBOL(otx2_mbox_reset);
@@ -133,16 +136,17 @@ EXPORT_SYMBOL(otx2_mbox_init);
 
 int otx2_mbox_wait_for_rsp(struct otx2_mbox *mbox, int devid)
 {
+	unsigned long timeout = jiffies + msecs_to_jiffies(MBOX_RSP_TIMEOUT);
 	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
-	int timeout = 0, sleep = 1;
+	struct device *sender = &mbox->pdev->dev;
 
-	while (mdev->num_msgs != mdev->msgs_acked) {
-		msleep(sleep);
-		timeout += sleep;
-		if (timeout >= MBOX_RSP_TIMEOUT)
-			return -EIO;
+	while (!time_after(jiffies, timeout)) {
+		if (mdev->num_msgs == mdev->msgs_acked)
+			return 0;
+		usleep_range(800, 1000);
 	}
-	return 0;
+	dev_dbg(sender, "timed out while waiting for rsp\n");
+	return -EIO;
 }
 EXPORT_SYMBOL(otx2_mbox_wait_for_rsp);
 
@@ -162,13 +166,25 @@ EXPORT_SYMBOL(otx2_mbox_busy_poll_for_rsp);
 
 void otx2_mbox_msg_send(struct otx2_mbox *mbox, int devid)
 {
+	void *hw_mbase = mbox->hwbase + (devid * MBOX_SIZE);
 	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
 	struct mbox_hdr *tx_hdr, *rx_hdr;
 
-	tx_hdr = mdev->mbase + mbox->tx_start;
-	rx_hdr = mdev->mbase + mbox->rx_start;
+	tx_hdr = hw_mbase + mbox->tx_start;
+	rx_hdr = hw_mbase + mbox->rx_start;
+
+	/* If bounce buffer is implemented copy mbox messages from
+	 * bounce buffer to hw mbox memory.
+	 */
+	if (mdev->mbase != hw_mbase)
+		memcpy(hw_mbase + mbox->tx_start + msgs_offset,
+		       mdev->mbase + mbox->tx_start + msgs_offset,
+		       mdev->msg_size);
 
 	spin_lock(&mdev->mbox_lock);
+
+	tx_hdr->msg_size = mdev->msg_size;
+
 	/* Reset header for next messages */
 	mdev->msg_size = 0;
 	mdev->rsp_size = 0;
@@ -215,7 +231,7 @@ struct mbox_msghdr *otx2_mbox_alloc_msg_rsp(struct otx2_mbox *mbox, int devid,
 	msghdr = mdev->mbase + mbox->tx_start + msgs_offset + mdev->msg_size;
 
 	/* Clear the whole msg region */
-	memset(msghdr, 0, sizeof(*msghdr) + size);
+	memset(msghdr, 0, size);
 	/* Init message header with reset values */
 	msghdr->ver = OTX2_MBOX_VERSION;
 	mdev->msg_size += size;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 25f0e6f..94c198a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -36,7 +36,7 @@
 
 #define INTR_MASK(pfvfs) ((pfvfs < 64) ? (BIT_ULL(pfvfs) - 1) : (~0ull))
 
-#define MBOX_RSP_TIMEOUT	1000 /* in ms, Time to wait for mbox response */
+#define MBOX_RSP_TIMEOUT	2000 /* Time(ms) to wait for mbox response */
 
 #define MBOX_MSG_ALIGN		16  /* Align mbox msg start to 16bytes */
 
@@ -75,6 +75,7 @@ struct otx2_mbox {
 
 /* Header which preceeds all mbox messages */
 struct mbox_hdr {
+	u64 msg_size;	/* Total msgs size embedded */
 	u16  num_msgs;   /* No of msgs embedded */
 };
 
-- 
2.7.4

