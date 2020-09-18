Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E74F26EF6F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgIRCfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbgIRCNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:13:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 560002388D;
        Fri, 18 Sep 2020 02:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395187;
        bh=Ms8lENlLnFZ6YwfFPHM65qrhWiEu1s7AEcXco8pP22w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ar4a0FoMD9TlGRNN8aKHIo1TI4K9TybOaqngd2za/hA9E+rq5xIms8aEEgE9kB/sV
         Xr+xlF/9Jgf270CHnHzLOk5EeVG0Kg87F8DUWvwHGRFxjMhVneESScaQfxBF2AcvlQ
         sURacDwesSdHRBVQZ+5FNkllgDOD3mlCRJ53S8R4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot+c3c5bdea7863886115dc@syzkaller.appspotmail.com,
        Manish Mandlik <mmandlik@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 039/127] Bluetooth: prefetch channel before killing sock
Date:   Thu, 17 Sep 2020 22:10:52 -0400
Message-Id: <20200918021220.2066485-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

[ Upstream commit 2a154903cec20fb64ff4d7d617ca53c16f8fd53a ]

Prefetch channel before killing sock in order to fix UAF like

 BUG: KASAN: use-after-free in l2cap_sock_release+0x24c/0x290 net/bluetooth/l2cap_sock.c:1212
 Read of size 8 at addr ffff8880944904a0 by task syz-fuzzer/9751

Reported-by: syzbot+c3c5bdea7863886115dc@syzkaller.appspotmail.com
Fixes: 6c08fc896b60 ("Bluetooth: Fix refcount use-after-free issue")
Cc: Manish Mandlik <mmandlik@google.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index a5e618add17f4..511a1da6ca971 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1191,6 +1191,7 @@ static int l2cap_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	int err;
+	struct l2cap_chan *chan;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
@@ -1200,15 +1201,16 @@ static int l2cap_sock_release(struct socket *sock)
 	bt_sock_unlink(&l2cap_sk_list, sk);
 
 	err = l2cap_sock_shutdown(sock, 2);
+	chan = l2cap_pi(sk)->chan;
 
-	l2cap_chan_hold(l2cap_pi(sk)->chan);
-	l2cap_chan_lock(l2cap_pi(sk)->chan);
+	l2cap_chan_hold(chan);
+	l2cap_chan_lock(chan);
 
 	sock_orphan(sk);
 	l2cap_sock_kill(sk);
 
-	l2cap_chan_unlock(l2cap_pi(sk)->chan);
-	l2cap_chan_put(l2cap_pi(sk)->chan);
+	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.25.1

