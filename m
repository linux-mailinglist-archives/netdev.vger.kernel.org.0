Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A89CF4ACD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389389AbfKHMKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733228AbfKHLjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA5A4222C6;
        Fri,  8 Nov 2019 11:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213159;
        bh=v0Q4Snohb0rPBMGpAzHmPvwE44PlPjfHwBHTVwdU0+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R++CaginImy/LualAnumJkxXWWzrFcWFTK1hHJLpDbCc9MwHN6YbVmZO502J4Js+s
         HAcxYhkDa5FNDN3QeaI1jb42jWOdxVJ+R3OuyBG7qg/lLyEymaDpZpZTTL4jsvrf1h
         vNtYvTsfEk+xom9Lb3QnocR0Pf15EXIfKCo5rjM4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ganapathi Bhat <gbhat@marvell.com>,
        Vidya Dharmaraju <vidyad@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 066/205] mwifex: free rx_cmd skb in suspended state
Date:   Fri,  8 Nov 2019 06:35:33 -0500
Message-Id: <20191108113752.12502-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ganapathi Bhat <gbhat@marvell.com>

[ Upstream commit 33a164fa8a4c91408e0b7738f754cb1a7827c5f2 ]

USB suspend handler will kill the presubmitted rx_cmd URB. This
triggers a call to the corresponding URB complete handler, which
will free the rx_cmd skb, associated with rx_cmd URB. Due to a
possible race betwen suspend handler and main thread, depicted in
'commit bfcacac6c84b ("mwifiex: do no submit URB in suspended
state")', it is possible that the rx_cmd skb will fail to get
freed. This causes a memory leak, since the resume handler will
always allocate a new rx_cmd skb.

To fix this, free the rx_cmd skb in mwifiex_usb_submit_rx_urb, if
the device is in suspended state.

Signed-off-by: Vidya Dharmaraju <vidyad@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 76d80fd545236..d445acc4786b7 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -299,6 +299,12 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
 
 	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
+		if (card->rx_cmd_ep == ctx->ep) {
+			mwifiex_dbg(adapter, INFO, "%s: free rx_cmd skb\n",
+				    __func__);
+			dev_kfree_skb_any(ctx->skb);
+			ctx->skb = NULL;
+		}
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: card removed/suspended, EP %d rx_cmd URB submit skipped\n",
 			    __func__, ctx->ep);
-- 
2.20.1

