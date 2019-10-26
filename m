Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECEFE5C7F
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfJZNax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfJZNTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:19:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B882070B;
        Sat, 26 Oct 2019 13:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095975;
        bh=q1E0FxPMYC4aSCbIZPtT/+vHqf1AwqFt2itoITXyEh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oj4LIckoGadSvLshWYjLI7BsOfBWqsRX7cLx6JvTsFNEBMlCjZRU/8Cy9DTabaMt4
         RZE5R9oKkiodR/UTSvuioxulOk7laVHfMXMacS9qXlHu+5iOUHRca5XBdj6NnoHrqm
         5EnVvncG+1GKib6mP9plZ6MxsBrgNtUpYA7BJF4Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        syzbot+6bf095f9becf5efef645@syzkaller.appspotmail.com,
        syzbot+31c16aa4202dace3812e@syzkaller.appspotmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/59] llc: fix sk_buff leak in llc_sap_state_process()
Date:   Sat, 26 Oct 2019 09:18:28 -0400
Message-Id: <20191026131910.3435-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit c6ee11c39fcc1fb55130748990a8f199e76263b4 ]

syzbot reported:

    BUG: memory leak
    unreferenced object 0xffff888116270800 (size 224):
       comm "syz-executor641", pid 7047, jiffies 4294947360 (age 13.860s)
       hex dump (first 32 bytes):
         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
         00 20 e1 2a 81 88 ff ff 00 40 3d 2a 81 88 ff ff  . .*.....@=*....
       backtrace:
         [<000000004d41b4cc>] kmemleak_alloc_recursive  include/linux/kmemleak.h:55 [inline]
         [<000000004d41b4cc>] slab_post_alloc_hook mm/slab.h:439 [inline]
         [<000000004d41b4cc>] slab_alloc_node mm/slab.c:3269 [inline]
         [<000000004d41b4cc>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
         [<00000000506a5965>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
         [<000000001ba5a161>] alloc_skb include/linux/skbuff.h:1058 [inline]
         [<000000001ba5a161>] alloc_skb_with_frags+0x5f/0x250  net/core/skbuff.c:5327
         [<0000000047d9c78b>] sock_alloc_send_pskb+0x269/0x2a0  net/core/sock.c:2225
         [<000000003828fe54>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2242
         [<00000000e34d94f9>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
         [<00000000de2de3fb>] sock_sendmsg_nosec net/socket.c:652 [inline]
         [<00000000de2de3fb>] sock_sendmsg+0x54/0x70 net/socket.c:671
         [<000000008fe16e7a>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
	 [...]

The bug is that llc_sap_state_process() always takes an extra reference
to the skb, but sometimes neither llc_sap_next_state() nor
llc_sap_state_process() itself drops this reference.

Fix it by changing llc_sap_next_state() to never consume a reference to
the skb, rather than sometimes do so and sometimes not.  Then remove the
extra skb_get() and kfree_skb() from llc_sap_state_process().

Reported-by: syzbot+6bf095f9becf5efef645@syzkaller.appspotmail.com
Reported-by: syzbot+31c16aa4202dace3812e@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/llc_s_ac.c | 12 +++++++++---
 net/llc/llc_sap.c  | 23 ++++++++---------------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/net/llc/llc_s_ac.c b/net/llc/llc_s_ac.c
index a94bd56bcac6f..7ae4cc684d3ab 100644
--- a/net/llc/llc_s_ac.c
+++ b/net/llc/llc_s_ac.c
@@ -58,8 +58,10 @@ int llc_sap_action_send_ui(struct llc_sap *sap, struct sk_buff *skb)
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_ui_cmd(skb);
 	rc = llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc = dev_queue_xmit(skb);
+	}
 	return rc;
 }
 
@@ -81,8 +83,10 @@ int llc_sap_action_send_xid_c(struct llc_sap *sap, struct sk_buff *skb)
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_xid_cmd(skb, LLC_XID_NULL_CLASS_2, 0);
 	rc = llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc = dev_queue_xmit(skb);
+	}
 	return rc;
 }
 
@@ -135,8 +139,10 @@ int llc_sap_action_send_test_c(struct llc_sap *sap, struct sk_buff *skb)
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_test_cmd(skb);
 	rc = llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc = dev_queue_xmit(skb);
+	}
 	return rc;
 }
 
diff --git a/net/llc/llc_sap.c b/net/llc/llc_sap.c
index a7f7b8ff47292..be419062e19a6 100644
--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -197,29 +197,22 @@ static int llc_sap_next_state(struct llc_sap *sap, struct sk_buff *skb)
  *	After executing actions of the event, upper layer will be indicated
  *	if needed(on receiving an UI frame). sk can be null for the
  *	datalink_proto case.
+ *
+ *	This function always consumes a reference to the skb.
  */
 static void llc_sap_state_process(struct llc_sap *sap, struct sk_buff *skb)
 {
 	struct llc_sap_state_ev *ev = llc_sap_ev(skb);
 
-	/*
-	 * We have to hold the skb, because llc_sap_next_state
-	 * will kfree it in the sending path and we need to
-	 * look at the skb->cb, where we encode llc_sap_state_ev.
-	 */
-	skb_get(skb);
 	ev->ind_cfm_flag = 0;
 	llc_sap_next_state(sap, skb);
-	if (ev->ind_cfm_flag == LLC_IND) {
-		if (skb->sk->sk_state == TCP_LISTEN)
-			kfree_skb(skb);
-		else {
-			llc_save_primitive(skb->sk, skb, ev->prim);
 
-			/* queue skb to the user. */
-			if (sock_queue_rcv_skb(skb->sk, skb))
-				kfree_skb(skb);
-		}
+	if (ev->ind_cfm_flag == LLC_IND && skb->sk->sk_state != TCP_LISTEN) {
+		llc_save_primitive(skb->sk, skb, ev->prim);
+
+		/* queue skb to the user. */
+		if (sock_queue_rcv_skb(skb->sk, skb) == 0)
+			return;
 	}
 	kfree_skb(skb);
 }
-- 
2.20.1

