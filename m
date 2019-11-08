Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B30AF4AA5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbfKHLjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733218AbfKHLjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A04B120869;
        Fri,  8 Nov 2019 11:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213158;
        bh=cE+XnpIA2UlQ3+nHh+xT7kPEuciIqH7gZf5c/sPtmCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrsjlXdM6wL/XIbJrCodJsmytnUQzXl0XoYS9d0r8p4ceSJNHlLBBxvxjWl34gr3G
         DFgFwbv3Y6VTdLgCc2FD8uwets21ZWxzmo+uk7NjkYNQgJKULqAUE1HANzSO59blyv
         YaXphWwMRob1BJUjxzLwsfoFYUZXr35ZvJ7tprQk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ganapathi Bhat <gbhat@marvell.com>,
        Vidya Dharmaraju <vidyad@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 065/205] mwifiex: do no submit URB in suspended state
Date:   Fri,  8 Nov 2019 06:35:32 -0500
Message-Id: <20191108113752.12502-65-sashal@kernel.org>
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

[ Upstream commit 7bd4628c2f31c51254aa39628ecae521d00d0b90 ]

There is a possible race between USB suspend and main thread:

1. After processing the command response, main thread will submit
rx_cmd URB back so as to process next command response, by
calling mwifiex_usb_submit_rx_urb.

2. During USB suspend, the suspend handler will check if rx_cmd
URB is pending(submitted) and if true, kill this URB.

There is a possible race between #1 and #2, where rx_cmd URB will
be submitted by main thread(#1) after the suspend handler check
in #2.

To fix this, check if device is already suspended in
mwifiex_usb_submit_rx_urb, in which case do not submit the URB.

Signed-off-by: Vidya Dharmaraju <vidyad@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 433c6a16870b6..76d80fd545236 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -298,6 +298,13 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 	struct mwifiex_adapter *adapter = ctx->adapter;
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
 
+	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: card removed/suspended, EP %d rx_cmd URB submit skipped\n",
+			    __func__, ctx->ep);
+		return -1;
+	}
+
 	if (card->rx_cmd_ep != ctx->ep) {
 		ctx->skb = dev_alloc_skb(size);
 		if (!ctx->skb) {
-- 
2.20.1

