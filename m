Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2F5291EFA
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgJRTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbgJRTTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:19:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAABD222E8;
        Sun, 18 Oct 2020 19:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048773;
        bh=BYqb3Qbu9GcKH/vEgELr2psyicoVNiS0fNpSimfYShg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knNpUKsleLWekplWkBlOMkX644r2imhzG8ny6uMquFkwS80nzbogyyHT/n3jzz/7e
         vIpWvCpI1O3wn0sUXGQzfCfugdSW3J5AUSbLt14Wkapd5t33YvhKxJg8iVJv29gbgS
         8fnrH9FwTtEC4P3DzGAImKXaEvH0qXFgisqYtfXo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 072/111] Bluetooth: Only mark socket zapped after unlocking
Date:   Sun, 18 Oct 2020 15:17:28 -0400
Message-Id: <20201018191807.4052726-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
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
index e1a3e66b17540..e7cfe28140c39 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1521,8 +1521,6 @@ static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
 
 	parent = bt_sk(sk)->parent;
 
-	sock_set_flag(sk, SOCK_ZAPPED);
-
 	switch (chan->state) {
 	case BT_OPEN:
 	case BT_BOUND:
@@ -1549,8 +1547,11 @@ static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
 
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

