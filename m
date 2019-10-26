Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1175E5B5D
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbfJZNWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729384AbfJZNWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:22:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EAD8222CE;
        Sat, 26 Oct 2019 13:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096150;
        bh=BW/7LX13A/wIKysvZrjp8mcwIsSHN7h+36idyLK+kKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LeCOn5Id2QjRWU16ucZ2wGoRtrBcnTIbNdNmv50If0jcCzgDWx2Scowyr3TFWdbI6
         QkzngE6JFvJW80cEXI5Z5d77DgwagmAEXhvSdLtOiMi2mMHvJ88truGaJSl1rcRsTb
         QXajYH+srqlt8ygmQfmKIIWRE3EvR1bsG/ngb5Q8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        syzbot+6b825a6494a04cc0e3f7@syzkaller.appspotmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/21] llc: fix sk_buff leak in llc_conn_service()
Date:   Sat, 26 Oct 2019 09:22:03 -0400
Message-Id: <20191026132217.4380-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132217.4380-1-sashal@kernel.org>
References: <20191026132217.4380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit b74555de21acd791f12c4a1aeaf653dd7ac21133 ]

syzbot reported:

    BUG: memory leak
    unreferenced object 0xffff88811eb3de00 (size 224):
       comm "syz-executor559", pid 7315, jiffies 4294943019 (age 10.300s)
       hex dump (first 32 bytes):
         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
         00 a0 38 24 81 88 ff ff 00 c0 f2 15 81 88 ff ff  ..8$............
       backtrace:
         [<000000008d1c66a1>] kmemleak_alloc_recursive  include/linux/kmemleak.h:55 [inline]
         [<000000008d1c66a1>] slab_post_alloc_hook mm/slab.h:439 [inline]
         [<000000008d1c66a1>] slab_alloc_node mm/slab.c:3269 [inline]
         [<000000008d1c66a1>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
         [<00000000447d9496>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
         [<000000000cdbf82f>] alloc_skb include/linux/skbuff.h:1058 [inline]
         [<000000000cdbf82f>] llc_alloc_frame+0x66/0x110 net/llc/llc_sap.c:54
         [<000000002418b52e>] llc_conn_ac_send_sabme_cmd_p_set_x+0x2f/0x140  net/llc/llc_c_ac.c:777
         [<000000001372ae17>] llc_exec_conn_trans_actions net/llc/llc_conn.c:475  [inline]
         [<000000001372ae17>] llc_conn_service net/llc/llc_conn.c:400 [inline]
         [<000000001372ae17>] llc_conn_state_process+0x1ac/0x640  net/llc/llc_conn.c:75
         [<00000000f27e53c1>] llc_establish_connection+0x110/0x170  net/llc/llc_if.c:109
         [<00000000291b2ca0>] llc_ui_connect+0x10e/0x370 net/llc/af_llc.c:477
         [<000000000f9c740b>] __sys_connect+0x11d/0x170 net/socket.c:1840
         [...]

The bug is that most callers of llc_conn_send_pdu() assume it consumes a
reference to the skb, when actually due to commit b85ab56c3f81 ("llc:
properly handle dev_queue_xmit() return value") it doesn't.

Revert most of that commit, and instead make the few places that need
llc_conn_send_pdu() to *not* consume a reference call skb_get() before.

Fixes: b85ab56c3f81 ("llc: properly handle dev_queue_xmit() return value")
Reported-by: syzbot+6b825a6494a04cc0e3f7@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/llc_conn.h |  2 +-
 net/llc/llc_c_ac.c     |  8 ++++++--
 net/llc/llc_conn.c     | 32 +++++++++-----------------------
 3 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/include/net/llc_conn.h b/include/net/llc_conn.h
index df528a6235487..ea985aa7a6c5e 100644
--- a/include/net/llc_conn.h
+++ b/include/net/llc_conn.h
@@ -104,7 +104,7 @@ void llc_sk_reset(struct sock *sk);
 
 /* Access to a connection */
 int llc_conn_state_process(struct sock *sk, struct sk_buff *skb);
-int llc_conn_send_pdu(struct sock *sk, struct sk_buff *skb);
+void llc_conn_send_pdu(struct sock *sk, struct sk_buff *skb);
 void llc_conn_rtn_pdu(struct sock *sk, struct sk_buff *skb);
 void llc_conn_resend_i_pdu_as_cmd(struct sock *sk, u8 nr, u8 first_p_bit);
 void llc_conn_resend_i_pdu_as_rsp(struct sock *sk, u8 nr, u8 first_f_bit);
diff --git a/net/llc/llc_c_ac.c b/net/llc/llc_c_ac.c
index 4b60f68cb4925..8354ae40ec85b 100644
--- a/net/llc/llc_c_ac.c
+++ b/net/llc/llc_c_ac.c
@@ -372,6 +372,7 @@ int llc_conn_ac_send_i_cmd_p_set_1(struct sock *sk, struct sk_buff *skb)
 	llc_pdu_init_as_i_cmd(skb, 1, llc->vS, llc->vR);
 	rc = llc_mac_hdr_init(skb, llc->dev->dev_addr, llc->daddr.mac);
 	if (likely(!rc)) {
+		skb_get(skb);
 		llc_conn_send_pdu(sk, skb);
 		llc_conn_ac_inc_vs_by_1(sk, skb);
 	}
@@ -389,7 +390,8 @@ static int llc_conn_ac_send_i_cmd_p_set_0(struct sock *sk, struct sk_buff *skb)
 	llc_pdu_init_as_i_cmd(skb, 0, llc->vS, llc->vR);
 	rc = llc_mac_hdr_init(skb, llc->dev->dev_addr, llc->daddr.mac);
 	if (likely(!rc)) {
-		rc = llc_conn_send_pdu(sk, skb);
+		skb_get(skb);
+		llc_conn_send_pdu(sk, skb);
 		llc_conn_ac_inc_vs_by_1(sk, skb);
 	}
 	return rc;
@@ -406,6 +408,7 @@ int llc_conn_ac_send_i_xxx_x_set_0(struct sock *sk, struct sk_buff *skb)
 	llc_pdu_init_as_i_cmd(skb, 0, llc->vS, llc->vR);
 	rc = llc_mac_hdr_init(skb, llc->dev->dev_addr, llc->daddr.mac);
 	if (likely(!rc)) {
+		skb_get(skb);
 		llc_conn_send_pdu(sk, skb);
 		llc_conn_ac_inc_vs_by_1(sk, skb);
 	}
@@ -916,7 +919,8 @@ static int llc_conn_ac_send_i_rsp_f_set_ackpf(struct sock *sk,
 	llc_pdu_init_as_i_cmd(skb, llc->ack_pf, llc->vS, llc->vR);
 	rc = llc_mac_hdr_init(skb, llc->dev->dev_addr, llc->daddr.mac);
 	if (likely(!rc)) {
-		rc = llc_conn_send_pdu(sk, skb);
+		skb_get(skb);
+		llc_conn_send_pdu(sk, skb);
 		llc_conn_ac_inc_vs_by_1(sk, skb);
 	}
 	return rc;
diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index b9290a183a2fd..94c78cc49d3e0 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -30,7 +30,7 @@
 #endif
 
 static int llc_find_offset(int state, int ev_type);
-static int llc_conn_send_pdus(struct sock *sk, struct sk_buff *skb);
+static void llc_conn_send_pdus(struct sock *sk);
 static int llc_conn_service(struct sock *sk, struct sk_buff *skb);
 static int llc_exec_conn_trans_actions(struct sock *sk,
 				       struct llc_conn_state_trans *trans,
@@ -193,11 +193,11 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 	return rc;
 }
 
-int llc_conn_send_pdu(struct sock *sk, struct sk_buff *skb)
+void llc_conn_send_pdu(struct sock *sk, struct sk_buff *skb)
 {
 	/* queue PDU to send to MAC layer */
 	skb_queue_tail(&sk->sk_write_queue, skb);
-	return llc_conn_send_pdus(sk, skb);
+	llc_conn_send_pdus(sk);
 }
 
 /**
@@ -255,7 +255,7 @@ void llc_conn_resend_i_pdu_as_cmd(struct sock *sk, u8 nr, u8 first_p_bit)
 	if (howmany_resend > 0)
 		llc->vS = (llc->vS + 1) % LLC_2_SEQ_NBR_MODULO;
 	/* any PDUs to re-send are queued up; start sending to MAC */
-	llc_conn_send_pdus(sk, NULL);
+	llc_conn_send_pdus(sk);
 out:;
 }
 
@@ -296,7 +296,7 @@ void llc_conn_resend_i_pdu_as_rsp(struct sock *sk, u8 nr, u8 first_f_bit)
 	if (howmany_resend > 0)
 		llc->vS = (llc->vS + 1) % LLC_2_SEQ_NBR_MODULO;
 	/* any PDUs to re-send are queued up; start sending to MAC */
-	llc_conn_send_pdus(sk, NULL);
+	llc_conn_send_pdus(sk);
 out:;
 }
 
@@ -340,16 +340,12 @@ int llc_conn_remove_acked_pdus(struct sock *sk, u8 nr, u16 *how_many_unacked)
 /**
  *	llc_conn_send_pdus - Sends queued PDUs
  *	@sk: active connection
- *	@hold_skb: the skb held by caller, or NULL if does not care
  *
- *	Sends queued pdus to MAC layer for transmission. When @hold_skb is
- *	NULL, always return 0. Otherwise, return 0 if @hold_skb is sent
- *	successfully, or 1 for failure.
+ *	Sends queued pdus to MAC layer for transmission.
  */
-static int llc_conn_send_pdus(struct sock *sk, struct sk_buff *hold_skb)
+static void llc_conn_send_pdus(struct sock *sk)
 {
 	struct sk_buff *skb;
-	int ret = 0;
 
 	while ((skb = skb_dequeue(&sk->sk_write_queue)) != NULL) {
 		struct llc_pdu_sn *pdu = llc_pdu_sn_hdr(skb);
@@ -361,20 +357,10 @@ static int llc_conn_send_pdus(struct sock *sk, struct sk_buff *hold_skb)
 			skb_queue_tail(&llc_sk(sk)->pdu_unack_q, skb);
 			if (!skb2)
 				break;
-			dev_queue_xmit(skb2);
-		} else {
-			bool is_target = skb == hold_skb;
-			int rc;
-
-			if (is_target)
-				skb_get(skb);
-			rc = dev_queue_xmit(skb);
-			if (is_target)
-				ret = rc;
+			skb = skb2;
 		}
+		dev_queue_xmit(skb);
 	}
-
-	return ret;
 }
 
 /**
-- 
2.20.1

