Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB79D2E13C6
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgLWCel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:34:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730310AbgLWCYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC5C2313F;
        Wed, 23 Dec 2020 02:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690271;
        bh=zPXB7wyDekSdccQ22KuAKpHqjNfCvVWvWNbp+TJu9ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZ5aUR0rAsSfRo8SOQHlctmJxjRJrYyLGjxZ6O6LeKFhT52EWa6yNxCoI0NerhXEp
         5KzE+cEwUoIuZe9u9qJshnLMBYe2K+KcjAnodiIxarxnm6hmZwk7BkoTD/CMnA6SV0
         hRe0E9qzE1glYxxdqXsTDB1iLkH7sH7mSRgOZiytnoP0TP+TR0bWQ5s4w0cvG5a2io
         O0ZUNOrYE/j7dnvZjiB6z5fEGSYGS9Z4yvNWjnag1IX9DrcvimIFF73j7n1dRz/QjQ
         QnLoEnaW//vMvk8+x9Qg8yOVJ17ttK6eMtnRr/++xOFSdAze00Nez/s3a2dtfvZ74O
         GYrXqITujVrBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ole=20Bj=C3=B8rn=20Midtb=C3=B8?= <omidtbo@cisco.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/48] Bluetooth: hidp: use correct wait queue when removing ctrl_wait
Date:   Tue, 22 Dec 2020 21:23:40 -0500
Message-Id: <20201223022417.2794032-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ole Bjørn Midtbø <omidtbo@cisco.com>

[ Upstream commit cca342d98bef68151a80b024f7bf5f388d1fbdea ]

A different wait queue was used when removing ctrl_wait than when adding
it. This effectively made the remove operation without locking compared
to other operations on the wait queue ctrl_wait was part of. This caused
issues like below where dead000000000100 is LIST_POISON1 and
dead000000000200 is LIST_POISON2.

 list_add corruption. next->prev should be prev (ffffffc1b0a33a08), \
	but was dead000000000200. (next=ffffffc03ac77de0).
 ------------[ cut here ]------------
 CPU: 3 PID: 2138 Comm: bluetoothd Tainted: G           O    4.4.238+ #9
 ...
 ---[ end trace 0adc2158f0646eac ]---
 Call trace:
 [<ffffffc000443f78>] __list_add+0x38/0xb0
 [<ffffffc0000f0d04>] add_wait_queue+0x4c/0x68
 [<ffffffc00020eecc>] __pollwait+0xec/0x100
 [<ffffffc000d1556c>] bt_sock_poll+0x74/0x200
 [<ffffffc000bdb8a8>] sock_poll+0x110/0x128
 [<ffffffc000210378>] do_sys_poll+0x220/0x480
 [<ffffffc0002106f0>] SyS_poll+0x80/0x138
 [<ffffffc00008510c>] __sys_trace_return+0x0/0x4

 Unable to handle kernel paging request at virtual address dead000000000100
 ...
 CPU: 4 PID: 5387 Comm: kworker/u15:3 Tainted: G        W  O    4.4.238+ #9
 ...
 Call trace:
  [<ffffffc0000f079c>] __wake_up_common+0x7c/0xa8
  [<ffffffc0000f0818>] __wake_up+0x50/0x70
  [<ffffffc000be11b0>] sock_def_wakeup+0x58/0x60
  [<ffffffc000de5e10>] l2cap_sock_teardown_cb+0x200/0x224
  [<ffffffc000d3f2ac>] l2cap_chan_del+0xa4/0x298
  [<ffffffc000d45ea0>] l2cap_conn_del+0x118/0x198
  [<ffffffc000d45f8c>] l2cap_disconn_cfm+0x6c/0x78
  [<ffffffc000d29934>] hci_event_packet+0x564/0x2e30
  [<ffffffc000d19b0c>] hci_rx_work+0x10c/0x360
  [<ffffffc0000c2218>] process_one_work+0x268/0x460
  [<ffffffc0000c2678>] worker_thread+0x268/0x480
  [<ffffffc0000c94e0>] kthread+0x118/0x128
  [<ffffffc000085070>] ret_from_fork+0x10/0x20
  ---[ end trace 0adc2158f0646ead ]---

Signed-off-by: Ole Bjørn Midtbø <omidtbo@cisco.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hidp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 552e00b07196e..9ec37c6c8c4aa 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -1282,7 +1282,7 @@ static int hidp_session_thread(void *arg)
 
 	/* cleanup runtime environment */
 	remove_wait_queue(sk_sleep(session->intr_sock->sk), &intr_wait);
-	remove_wait_queue(sk_sleep(session->intr_sock->sk), &ctrl_wait);
+	remove_wait_queue(sk_sleep(session->ctrl_sock->sk), &ctrl_wait);
 	wake_up_interruptible(&session->report_queue);
 	hidp_del_timer(session);
 
-- 
2.27.0

