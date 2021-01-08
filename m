Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDAF2EF6E0
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbhAHSA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:00:26 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:24936 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAHSA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:00:26 -0500
Received: from heptagon.blr.asicdesigners.com (heptagon.blr.asicdesigners.com [10.193.186.108])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 108HxWAO008146;
        Fri, 8 Jan 2021 09:59:33 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net] cxgb4/chtls: Fix tid stuck due to wrong update of qid
Date:   Fri,  8 Jan 2021 23:29:14 +0530
Message-Id: <20210108175914.18876-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TID stuck is seen when there is a race in
CPL_PASS_ACCEPT_RPL/CPL_ABORT_REQ and abort is arriving
before the accept reply, which sets the queue number.
In this case HW ends up sending CPL_ABORT_RPL_RSS to an
incorrect ingress queue.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h   |  7 ++++
 .../chelsio/inline_crypto/chtls/chtls.h       |  4 ++
 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 35 ++++++++++++++--
 .../chelsio/inline_crypto/chtls/chtls_hw.c    | 42 +++++++++++++++++++
 4 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
index 92473dda55d9..22a0220123ad 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
@@ -40,6 +40,13 @@
 #define TCB_L2T_IX_M		0xfffULL
 #define TCB_L2T_IX_V(x)		((x) << TCB_L2T_IX_S)
 
+#define TCB_T_FLAGS_W           1
+#define TCB_T_FLAGS_S           0
+#define TCB_T_FLAGS_M           0xffffffffffffffffULL
+#define TCB_T_FLAGS_V(x)        ((__u64)(x) << TCB_T_FLAGS_S)
+
+#define TCB_FIELD_COOKIE_TFLAG	1
+
 #define TCB_SMAC_SEL_W		0
 #define TCB_SMAC_SEL_S		24
 #define TCB_SMAC_SEL_M		0xffULL
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
index 72bb123d53db..9e2378013642 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -575,7 +575,11 @@ int send_tx_flowc_wr(struct sock *sk, int compl,
 void chtls_tcp_push(struct sock *sk, int flags);
 int chtls_push_frames(struct chtls_sock *csk, int comp);
 int chtls_set_tcb_tflag(struct sock *sk, unsigned int bit_pos, int val);
+void chtls_set_tcb_field_rpl_skb(struct sock *sk, u16 word,
+				 u64 mask, u64 val, u8 cookie,
+				 int through_l2t);
 int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 mode, int cipher_type);
+void chtls_set_quiesce_ctrl(struct sock *sk, int val);
 void skb_entail(struct sock *sk, struct sk_buff *skb, int flags);
 unsigned int keyid_to_addr(int start_addr, int keyid);
 void free_tls_keyid(struct sock *sk);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 51dd030b3b36..0818d7fa484d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -32,6 +32,7 @@
 #include "chtls.h"
 #include "chtls_cm.h"
 #include "clip_tbl.h"
+#include "t4_tcb.h"
 
 /*
  * State transitions and actions for close.  Note that if we are in SYN_SENT
@@ -267,11 +268,14 @@ static void chtls_send_reset(struct sock *sk, int mode, struct sk_buff *skb)
 	if (sk->sk_state != TCP_SYN_RECV)
 		chtls_send_abort(sk, mode, skb);
 	else
-		goto out;
+		chtls_set_tcb_field_rpl_skb(sk, TCB_T_FLAGS_W,
+					    TCB_T_FLAGS_V(TCB_T_FLAGS_M), 0,
+					    TCB_FIELD_COOKIE_TFLAG, 1);
 
 	return;
 out:
-	kfree_skb(skb);
+	if (skb)
+		kfree_skb(skb);
 }
 
 static void release_tcp_port(struct sock *sk)
@@ -1949,6 +1953,8 @@ static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
 		else if (tcp_sk(sk)->linger2 < 0 &&
 			 !csk_flag_nochk(csk, CSK_ABORT_SHUTDOWN))
 			chtls_abort_conn(sk, skb);
+		else if (csk_flag_nochk(csk, CSK_TX_DATA_SENT))
+			chtls_set_quiesce_ctrl(sk, 0);
 		break;
 	default:
 		pr_info("close_con_rpl in bad state %d\n", sk->sk_state);
@@ -2292,6 +2298,28 @@ static int chtls_wr_ack(struct chtls_dev *cdev, struct sk_buff *skb)
 	return 0;
 }
 
+static int chtls_set_tcb_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
+{
+	struct cpl_set_tcb_rpl *rpl = cplhdr(skb) + RSS_HDR;
+	unsigned int hwtid = GET_TID(rpl);
+	struct sock *sk;
+
+	sk = lookup_tid(cdev->tids, hwtid);
+
+	/* return EINVAL if socket doesn't exist */
+	if (!sk)
+		return -EINVAL;
+
+	/* Reusing the skb as size of cpl_set_tcb_field structure
+	 * is greater than cpl_abort_req
+	 */
+	if (TCB_COOKIE_G(rpl->cookie) == TCB_FIELD_COOKIE_TFLAG)
+		chtls_send_abort(sk, CPL_ABORT_SEND_RST, NULL);
+
+	kfree_skb(skb);
+	return 0;
+}
+
 chtls_handler_func chtls_handlers[NUM_CPL_CMDS] = {
 	[CPL_PASS_OPEN_RPL]     = chtls_pass_open_rpl,
 	[CPL_CLOSE_LISTSRV_RPL] = chtls_close_listsrv_rpl,
@@ -2304,5 +2332,6 @@ chtls_handler_func chtls_handlers[NUM_CPL_CMDS] = {
 	[CPL_CLOSE_CON_RPL]     = chtls_conn_cpl,
 	[CPL_ABORT_REQ_RSS]     = chtls_conn_cpl,
 	[CPL_ABORT_RPL_RSS]     = chtls_conn_cpl,
-	[CPL_FW4_ACK]           = chtls_wr_ack,
+	[CPL_FW4_ACK]		= chtls_wr_ack,
+	[CPL_SET_TCB_RPL]	= chtls_set_tcb_rpl,
 };
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
index a4fb463af22a..9f1c50c9c41b 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
@@ -88,6 +88,24 @@ static int chtls_set_tcb_field(struct sock *sk, u16 word, u64 mask, u64 val)
 	return ret < 0 ? ret : 0;
 }
 
+void chtls_set_tcb_field_rpl_skb(struct sock *sk, u16 word,
+				 u64 mask, u64 val, u8 cookie,
+				 int through_l2t)
+{
+	struct sk_buff *skb;
+	unsigned int wrlen;
+
+	wrlen = sizeof(struct cpl_set_tcb_field) + sizeof(struct ulptx_idata);
+	wrlen = roundup(wrlen, 16);
+
+	skb = alloc_skb(wrlen, GFP_KERNEL | __GFP_NOFAIL);
+	if (!skb)
+		return;
+
+	__set_tcb_field(sk, skb, word, mask, val, cookie, 0);
+	send_or_defer(sk, tcp_sk(sk), skb, through_l2t);
+}
+
 /*
  * Set one of the t_flags bits in the TCB.
  */
@@ -113,6 +131,30 @@ static int chtls_set_tcb_quiesce(struct sock *sk, int val)
 				   TF_RX_QUIESCE_V(val));
 }
 
+void chtls_set_quiesce_ctrl(struct sock *sk, int val)
+{
+	struct chtls_sock *csk;
+	struct sk_buff *skb;
+	unsigned int wrlen;
+	unsigned int len;
+	int ret;
+
+	wrlen = sizeof(struct cpl_set_tcb_field) + sizeof(struct ulptx_idata);
+	wrlen = roundup(wrlen, 16);
+
+	skb = alloc_skb(wrlen, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	csk = rcu_dereference_sk_user_data(sk);
+
+	__set_tcb_field(sk, skb, 1, TF_RX_QUIESCE_V(1), 0, 0, 1);
+	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->port_id);
+	ret = cxgb4_ofld_send(csk->egress_dev, skb);
+	if (ret < 0)
+		kfree_skb(skb);
+}
+
 /* TLS Key bitmap processing */
 int chtls_init_kmap(struct chtls_dev *cdev, struct cxgb4_lld_info *lldi)
 {
-- 
2.28.0.rc1.6.gae46588

