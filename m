Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4BB291ABF
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbgJRT0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbgJRT0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE268207DE;
        Sun, 18 Oct 2020 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049175;
        bh=GwReP5S7w2Fjy/LChrZty43c7cfGrzddYTZbZCLqK08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi1qaE53fLZ5RauzVJzjcW1Rgacfy2gp6DZ7Z4pW02wt1JeW4v7MKojjpbfpcnPOq
         R/O9QDKdJSjC4wC/ZVR/8tVaFrOmikExTtka8LDB0w9oRODWcoVv3siBCJWbQavhL0
         JgzWIpr5u6oYa1kIZoKle8wD873L4RHZWdST8+Io=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 38/52] Bluetooth: Only mark socket zapped after unlocking
Date:   Sun, 18 Oct 2020 15:25:15 -0400
Message-Id: <20201018192530.4055730-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

[ Upstream commit 20ae4089d0afeb24e9ceb026b996bfa55c983cc2 ]

Since l2cap_sock_teardown_cb doesn't acquire the channel lock before
setting the socket as zapped, it could potentially race with
l2cap_sock_release which frees the socket. Thus, wait until the cleanup
is complete before marking the socket as zapped.

This race was reproduced on a JBL GO speaker after the remote device
rejected L2CAP connection due to resource unavailability.

Here is a dmesg log with debug logs from a repro of this bug:
[ 3465.424086] Bluetooth: hci_core.c:hci_acldata_packet() hci0 len 16 handle 0x0003 flags 0x0002
[ 3465.424090] Bluetooth: hci_conn.c:hci_conn_enter_active_mode() hcon 00000000cfedd07d mode 0
[ 3465.424094] Bluetooth: l2cap_core.c:l2cap_recv_acldata() conn 000000007eae8952 len 16 flags 0x2
[ 3465.424098] Bluetooth: l2cap_core.c:l2cap_recv_frame() len 12, cid 0x0001
[ 3465.424102] Bluetooth: l2cap_core.c:l2cap_raw_recv() conn 000000007eae8952
[ 3465.424175] Bluetooth: l2cap_core.c:l2cap_sig_channel() code 0x03 len 8 id 0x0c
[ 3465.424180] Bluetooth: l2cap_core.c:l2cap_connect_create_rsp() dcid 0x0045 scid 0x0000 result 0x02 status 0x00
[ 3465.424189] Bluetooth: l2cap_core.c:l2cap_chan_put() chan 000000006acf9bff orig refcnt 4
[ 3465.424196] Bluetooth: l2cap_core.c:l2cap_chan_del() chan 000000006acf9bff, conn 000000007eae8952, err 111, state BT_CONNECT
[ 3465.424203] Bluetooth: l2cap_sock.c:l2cap_sock_teardown_cb() chan 000000006acf9bff state BT_CONNECT
[ 3465.424221] Bluetooth: l2cap_core.c:l2cap_chan_put() chan 000000006acf9bff orig refcnt 3
[ 3465.424226] Bluetooth: hci_core.h:hci_conn_drop() hcon 00000000cfedd07d orig refcnt 6
[ 3465.424234] BUG: spinlock bad magic on CPU#2, kworker/u17:0/159
[ 3465.425626] Bluetooth: hci_sock.c:hci_sock_sendmsg() sock 000000002bb0cb64 sk 00000000a7964053
[ 3465.430330]  lock: 0xffffff804410aac0, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[ 3465.430332] Causing a watchdog bite!

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reported-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 511a1da6ca971..3c4e56167a760 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1342,8 +1342,6 @@ static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
 
 	parent = bt_sk(sk)->parent;
 
-	sock_set_flag(sk, SOCK_ZAPPED);
-
 	switch (chan->state) {
 	case BT_OPEN:
 	case BT_BOUND:
@@ -1370,8 +1368,11 @@ static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
 
 		break;
 	}
-
 	release_sock(sk);
+
+	/* Only zap after cleanup to avoid use after free race */
+	sock_set_flag(sk, SOCK_ZAPPED);
+
 }
 
 static void l2cap_sock_state_change_cb(struct l2cap_chan *chan, int state,
-- 
2.25.1

