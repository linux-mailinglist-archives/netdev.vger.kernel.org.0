Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE37F404C38
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241433AbhIIL4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242225AbhIILxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:53:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ADDA6137D;
        Thu,  9 Sep 2021 11:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187877;
        bh=NHcXO79jXv10lKu0O6cfzY4KRkcVlLCMuWwriAIMQc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPb/5/OH4MgNUcfuKjH/eM7Qqt9L6jEBdZ+T+GYq1Ers1d1X0+djUMjkVCUxI9mN2
         vVP1mDyY67NH2aq/RLzmFLQ+KLk1bDfBphlf5omIilFNHI6D/+CQ27Yi605XWuighx
         OHEuVdXFKWZ4SHuCDGbGaEzGhttTGzVwxSV20+wILuy4UbrUhE6gFhSslLbRXxxZ7K
         ql+LYqJJNFRMDYzJjjWOgbd3i/rrU76kXtKxDPxiEIvpb9iKkuTrotNnV+xYqi46ay
         b2jQa067XfBx02/+v4fFh6zgKLtbsBW5I+DgPsTRkf/dSMaIf44xZuwI+U+bYuu9oS
         vLjK1nkTKZ+4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiran K <kiran.k@intel.com>,
        Chethan T N <chethan.tumkur.narayan@intel.com>,
        Srivatsa Ravishankar <ravishankar.srivatsa@intel.com>,
        Manish Mandlik <mmandlik@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 161/252] Bluetooth: Fix race condition in handling NOP command
Date:   Thu,  9 Sep 2021 07:39:35 -0400
Message-Id: <20210909114106.141462-161-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran K <kiran.k@intel.com>

[ Upstream commit ecb71f2566673553bc067e5b0036756871d0b9d3 ]

For NOP command, need to cancel work scheduled on cmd_timer,
on receiving command status or commmand complete event.

Below use case might lead to race condition multiple when NOP
commands are queued sequentially:

hci_cmd_work() {
   if (atomic_read(&hdev->cmd_cnt) {
            .
            .
            .
      atomic_dec(&hdev->cmd_cnt);
      hci_send_frame(hdev,...);
      schedule_delayed_work(&hdev->cmd_timer,...);
   }
}

On receiving event for first NOP, the work scheduled on hdev->cmd_timer
is not cancelled and second NOP is dequeued and sent to controller.

While waiting for an event for second NOP command, work scheduled on
cmd_timer for the first NOP can get scheduled, resulting in sending third
NOP command (sending back to back NOP commands). This might
cause issues at controller side (like memory overrun, controller going
unresponsive) resulting in hci tx timeouts, hardware errors etc.

The fix to this issue is to cancel the delayed work scheduled on
cmd_timer on receiving command status or command complete event for
NOP command (this patch handles NOP command same as any other SIG
command).

Signed-off-by: Kiran K <kiran.k@intel.com>
Reviewed-by: Chethan T N <chethan.tumkur.narayan@intel.com>
Reviewed-by: Srivatsa Ravishankar <ravishankar.srivatsa@intel.com>
Acked-by: Manish Mandlik <mmandlik@google.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index f41bd5dfc313..0d0b958b7fe7 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3282,11 +3282,9 @@ static void hci_remote_features_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev,
-					    u16 opcode, u8 ncmd)
+static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
 {
-	if (opcode != HCI_OP_NOP)
-		cancel_delayed_work(&hdev->cmd_timer);
+	cancel_delayed_work(&hdev->cmd_timer);
 
 	if (!test_bit(HCI_RESET, &hdev->flags)) {
 		if (ncmd) {
@@ -3661,7 +3659,7 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		break;
 	}
 
-	handle_cmd_cnt_and_timer(hdev, *opcode, ev->ncmd);
+	handle_cmd_cnt_and_timer(hdev, ev->ncmd);
 
 	hci_req_cmd_complete(hdev, *opcode, *status, req_complete,
 			     req_complete_skb);
@@ -3762,7 +3760,7 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		break;
 	}
 
-	handle_cmd_cnt_and_timer(hdev, *opcode, ev->ncmd);
+	handle_cmd_cnt_and_timer(hdev, ev->ncmd);
 
 	/* Indicate request completion if the command failed. Also, if
 	 * we're not waiting for a special event and we get a success
-- 
2.30.2

