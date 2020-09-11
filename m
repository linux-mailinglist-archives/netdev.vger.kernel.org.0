Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C1D2675F3
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgIKWdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgIKWdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:33:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF21CC0613ED
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:33:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f18so8370395pfa.10
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iF8TeyEikj2biNaQshg9KmYrlvScdBVXMRfciSkg73c=;
        b=Yd9JMHZ4gRDa89ZRRST+nnkKT5nMC4F4WZV+lxJDsSchgQvCyDFn/qTDUiuNjvoM5T
         f74Q0IKIkVbhjKrrDb/TTVAo5MZmTBHEcSd6xcU+/4CPOZrUR/lYXWa6y3eQHZOXrIU5
         WbIcq2/QrYHhNZS8vhNJiOEZR2gTp7eEP/Nko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iF8TeyEikj2biNaQshg9KmYrlvScdBVXMRfciSkg73c=;
        b=JKGr2yX4i1XnoQqLWF7wCh9OA0dDkfjUhe8UUEU4Ket5MocpUr5tHsBnGUUAx7Q53g
         5BfZeUyfgdqRjufXtEoCJ4KqBHQUbTxc26E+Be6fNMqLRxGR3EXLbPqS/kssi+Sfr938
         w1+OmTK/2sLePB1wF+p0kv3FwSg7Crvvlu4Jy+il1b4uFvJE2vZRDXkOHlnAGwD4m31T
         QBHvLoDipyQOzKqIhgL2fVXG8/RZXAgqRHskCajZ6zbr+6O3X5TaWbIkh6tH7UvfT8Sb
         UOZrxFG/5B4IuM/814oQ2OjutCLgeUAhJkAJTTGCoEwpUzWaPpN0KNmVdgDAOLRtoyru
         cacw==
X-Gm-Message-State: AOAM531e+GWwBjQZbPLjAMR0HTBHhHD80Q7ILYz3W/YIha/Gnm+rLQ7z
        1qfFSz5Ofx/T33q4z4f9M0YF6Q==
X-Google-Smtp-Source: ABdhPJz33TmyqHCPoZmtb9fB7qGdH/76wHh1Tqbf++au1bjlFFSi6FxvuJEn/lmaLEoqiBUxAoCvIA==
X-Received: by 2002:a63:3d0e:: with SMTP id k14mr3282477pga.219.1599863603371;
        Fri, 11 Sep 2020 15:33:23 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id n128sm2546314pga.5.2020.09.11.15.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 15:33:22 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RESEND PATCH] Bluetooth: Only mark socket zapped after unlocking
Date:   Fri, 11 Sep 2020 15:33:18 -0700
Message-Id: <20200911153256.RESEND.1.Ic1b9d93cf2d393e3efda4c2977639c095d276311@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
We had some more data available (outside of dmesg and oops) that led us
to suspect a race between l2cap_sock_teardown_cb and l2cap_sock_release.
I've left this out of the commit message since it's not an oops or dmesg
logs.

Crash stack from CPU4:
--
-24 |spin_bug(
    |    [X19] lock = 0xFFFFFF810BDB1EC0,
    |    [X20] msg = 0xFFFFFFD143FD7960)
-25 |debug_spin_lock_before(inline)
    |  [X19] lock = 0xFFFFFF810BDB1EC0
-25 |do_raw_spin_lock(
    |    [X19] lock = 0xFFFFFF810BDB1EC0)
-26 |raw_spin_lock_irqsave(
    |    [X19] lock = 0xFFFFFF810BDB1EC0)
-27 |skb_peek(inline)
-27 |__skb_dequeue(inline)
-27 |skb_dequeue(
    |    [X20] list = 0xFFFFFF810BDB1EA8)
    |  [locdesc] flags = 12297829382473034410
-28 |skb_queue_purge(
    |    [X19] list = 0xFFFFFF810BDB1EA8 -> (
    |      [D:0xFFFFFF810BDB1EA8] next = 0x0,
    |      [D:0xFFFFFF810BDB1EB0] prev = 0x0,
    |      [D:0xFFFFFF810BDB1EB8] qlen = 0,
    |      [D:0xFFFFFF810BDB1EC0] lock = ([D:0xFFFFFF810BDB1EC0] rlock = ([D:0xFFFFFF810BDB1EC0] raw_lock
    |  [X0] skb = ???
-29 |l2cap_seq_list_free(inline)
    |  [locdesc] seq_list = 0xFFFFFF810BDB1ED8 -> (
    |    [D:0xFFFFFF810BDB1ED8] head = 0,
    |    [D:0xFFFFFF810BDB1EDA] tail = 0,
    |    [D:0xFFFFFF810BDB1EDC] mask = 0,
    |    [D:0xFFFFFF810BDB1EE0] list = 0x0)
-29 |l2cap_chan_del(
    |    [X19] chan = 0xFFFFFF810BDB1C00,
    |  ?)
-30 |l2cap_chan_unlock(inline)
-30 |l2cap_connect_create_rsp(inline)
    |  [X20] conn = 0xFFFFFF81231F2600
    |  [locdesc] err = 0
    |  [X27] chan = 0xFFFFFF810BDB1C00
-30 |l2cap_bredr_sig_cmd(inline)
    |  [X20] conn = 0xFFFFFF81231F2600
    |  [locdesc] err = 0
-30 |l2cap_sig_channel(inline)
    |  [X20] conn = 0xFFFFFF81231F2600
    |  [X19] skb = 0xFFFFFF813DE4C040
    |  [X28] data = 0xFFFFFF8131582014
    |  [locdesc] cmd_len = 43690
-30 |l2cap_recv_frame(
    |    [X20] conn = 0xFFFFFF81231F2600,
    |    [X19] skb = 0xFFFFFF813DE4C040)
    |  [locdesc] psm = 43690
-31 |l2cap_recv_acldata(
    |  ?,
    |    [X19] skb = 0xFFFFFF813DE4C040,
    |  ?)
    |  [X21] len = 16
-32 |hci_rx_work(
    |  ?)
    |  [X21] hdev = 0xFFFFFF8133A02000
-33 |__read_once_size(inline)
    |  [locdesc] size = 4
-33 |atomic_read(inline)
    |  [locdesc] __u = ([locdesc] __val = -1431655766, [locdesc] __c = (170))
-33 |static_key_count(inline)
-33 |static_key_false(inline)
-33 |trace_workqueue_execute_end(inline)
    |  [X22] work = 0xFFFFFF8133A02838
-33 |process_one_work(
    |    [X19] worker = 0xFFFFFF8133FE4500,
    |    [X22] work = 0xFFFFFF8133A02838)
    |  [locdesc] work_color = -1431655766
-34 |__read_once_size(inline)
    |  [locdesc] size = 8
-34 |list_empty(inline)
    |  [locdesc] __u = ([locdesc] __val = 0xAAAAAAAAAAAAAAAA, [locdesc] __c = (170))
-34 |worker_thread(
    |    [X19] __worker = 0xFFFFFF8133FE4500)
    |  [X19] worker = 0xFFFFFF8133FE4500
-35 |kthread(
    |    [X20] _create = 0xFFFFFF8133FB3A00)
    |  [X20] create = 0xFFFFFF8133FB3A00
    |  [X0] ret = ???
-36 |ret_from_fork(asm)

 net/bluetooth/l2cap_sock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index e1a3e66b175402..e7cfe28140c39b 100644
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
2.28.0.618.gf4bc123cb7-goog

