Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D76970B
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733090AbfGON6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731422AbfGON6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:58:09 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9931C212F5;
        Mon, 15 Jul 2019 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199088;
        bh=97Q3CfjQC/RAT6mrkOvfJELQhlqT+olkTSGEkR8ZWk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7PT3UMCDnkt2xiK7SqLkmKwGGcSk+NifPMb/cjBSqyViBNB7iAMDIuphz3cT792N
         nfBcG1dDaUl+Qe+5YeXWehlLbafaFu2MZpURQRf6YCPeyoyvH6uIXgHjQe7B9zAk8p
         JI4haIY18o6AAwAV9dJtTgM5RoVfnVlx/vpxTP3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 187/249] wil6210: drop old event after wmi_call timeout
Date:   Mon, 15 Jul 2019 09:45:52 -0400
Message-Id: <20190715134655.4076-187-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

[ Upstream commit 1a276003111c0404f6bfeffe924c5a21f482428b ]

This change fixes a rare race condition of handling WMI events after
wmi_call expires.

wmi_recv_cmd immediately handles an event when reply_buf is defined and
a wmi_call is waiting for the event.
However, in case the wmi_call has already timed-out, there will be no
waiting/running wmi_call and the event will be queued in WMI queue and
will be handled later in wmi_event_handle.
Meanwhile, a new similar wmi_call for the same command and event may
be issued. In this case, when handling the queued event we got WARN_ON
printed.

Fixing this case as a valid timeout and drop the unexpected event.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d89cd41e78ac..89a75ff29410 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -3220,7 +3220,18 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 		/* check if someone waits for this event */
 		if (wil->reply_id && wil->reply_id == id &&
 		    wil->reply_mid == mid) {
-			WARN_ON(wil->reply_buf);
+			if (wil->reply_buf) {
+				/* event received while wmi_call is waiting
+				 * with a buffer. Such event should be handled
+				 * in wmi_recv_cmd function. Handling the event
+				 * here means a previous wmi_call was timeout.
+				 * Drop the event and do not handle it.
+				 */
+				wil_err(wil,
+					"Old event (%d, %s) while wmi_call is waiting. Drop it and Continue waiting\n",
+					id, eventid2name(id));
+				return;
+			}
 
 			wmi_evt_call_handler(vif, id, evt_data,
 					     len - sizeof(*wmi));
-- 
2.20.1

