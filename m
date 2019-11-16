Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4A8FF0CF
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbfKPQHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730486AbfKPPuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:20 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AFCB21783;
        Sat, 16 Nov 2019 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919419;
        bh=ZdfIT4acldax/0aBpIDoPq29X7aqh95wXh2ik/TGRMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMlxn9gIUIyRYJ3Oc21pqsMJjn9Sq4KrfL/iJunzISbyRR/kAShXXaq029vnBLKAk
         Qm6gNEYzIOFjq33TI9VSACyts/LYvS26BqwVmHZtnLfBzfNF9Ij5iALyzEUP9wjE0D
         BfN33oKqYN6t63kyJaeu9pSwE3i/Ns8XkCQkDHsY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lior David <liord@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 120/150] wil6210: fix locking in wmi_call
Date:   Sat, 16 Nov 2019 10:46:58 -0500
Message-Id: <20191116154729.9573-120-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior David <liord@codeaurora.org>

[ Upstream commit dc57731dbd535880fe6ced31c229262c34df7d64 ]

Switch from spin_lock to spin_lock_irqsave, because
wmi_ev_lock is used inside interrupt handler.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d63d7c3268018..798516f42f2f9 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1002,15 +1002,16 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 {
 	int rc;
 	unsigned long remain;
+	ulong flags;
 
 	mutex_lock(&wil->wmi_mutex);
 
-	spin_lock(&wil->wmi_ev_lock);
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
 	wil->reply_id = reply_id;
 	wil->reply_buf = reply;
 	wil->reply_size = reply_size;
 	reinit_completion(&wil->wmi_call);
-	spin_unlock(&wil->wmi_ev_lock);
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
 
 	rc = __wmi_send(wil, cmdid, buf, len);
 	if (rc)
@@ -1030,11 +1031,11 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 	}
 
 out:
-	spin_lock(&wil->wmi_ev_lock);
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
 	wil->reply_id = 0;
 	wil->reply_buf = NULL;
 	wil->reply_size = 0;
-	spin_unlock(&wil->wmi_ev_lock);
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
 
 	mutex_unlock(&wil->wmi_mutex);
 
-- 
2.20.1

