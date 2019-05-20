Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055F2244C8
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfETXxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:53:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38810 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfETXxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 19:53:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNi40n170553;
        Mon, 20 May 2019 23:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=KwT5CjG8BGz5FfDfRG99bCBkymH8G9vihC6x/vZ96Ng=;
 b=AaOZn/+GEPCRk1lWJoLRwL1KLiFwc8OcrHtbW7sQiFLo6MdChQQlu7OtfKK42zEVCKF6
 R3bTC7dLP5IQ62xVF/OmgUD3KSe1GzfLMwC6unB0/Rqi/+RkZgEBtqeZyd8KYoNR6AMK
 ZUuJ+SxdnLG95lhyDj0NUib7Xer81rsTQg+VIAYoy5vo/YtrsRSLLjQu0m7Sp7jwROol
 6HvcQfKJgvOc+p2iZeq1ZQ7wToO1B2+Aw2+XuHweuJ2CiKSw6+FCuQrFYQ+kUQJ9/KJZ
 Vmi8r2ltzQy52R9Nmw/hWwM1sJR2vvFRwdRD22i+cBE5WoZhRzU5J5+UKohvAxZRPI11 Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj8en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:52:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNq0RU188358;
        Mon, 20 May 2019 23:52:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2sks1xvknr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 May 2019 23:52:42 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4KNqffU189228;
        Mon, 20 May 2019 23:52:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2sks1xvknj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:52:41 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNqerq025360;
        Mon, 20 May 2019 23:52:40 GMT
Message-Id: <201905202352.x4KNqerq025360@userv0121.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Mon, 20 May 2019 23:52:39 +0000
MIME-Version: 1.0
Date:   Mon, 20 May 2019 23:52:40 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 09/11] bpf: mark helpers explicitly whether they may
 change the context
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some helpers may update the context.  Right now, various network filter
helpers may make changes to the packet data.  This is verified by calling
the bpf_helper_changes_pkt_data() function with the function pointer.

This function resides in net/core/filter.c and needs to be updated for any
helper function that modifies packet data.  To allow for other helpers
(possibly not part of the network filter code) to do the same, this patch
changes the code from using a central function to list all helpers that
have this feature to marking each individual helper that may change the
context data.  This way, whenever a new helper is added that may change
the content of the context, there is no need to update a hardcoded list of
functions.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 include/linux/bpf.h    |  1 +
 include/linux/filter.h |  1 -
 kernel/bpf/core.c      |  5 ----
 kernel/bpf/verifier.c  |  2 +-
 net/core/filter.c      | 59 ++++++++++++++++++------------------------
 5 files changed, 27 insertions(+), 41 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fc3eda0192fb..9e255d5b1062 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -226,6 +226,7 @@ enum bpf_return_type {
 struct bpf_func_proto {
 	u64 (*func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 	bool gpl_only;
+	bool ctx_update;
 	bool pkt_access;
 	enum bpf_return_type ret_type;
 	enum bpf_arg_type arg1_type;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7148bab96943..9dacca7d3ef6 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -811,7 +811,6 @@ u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
-bool bpf_helper_changes_pkt_data(void *func);
 
 static inline bool bpf_dump_raw_ok(void)
 {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 225b1be766b0..8e9accf90c37 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2112,11 +2112,6 @@ void __weak bpf_jit_compile(struct bpf_prog *prog)
 {
 }
 
-bool __weak bpf_helper_changes_pkt_data(void *func)
-{
-	return false;
-}
-
 /* To execute LD_ABS/LD_IND instructions __bpf_prog_run() may call
  * skb_copy_bits(), so provide a weak definition of it for NET-less config.
  */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5fba4e6f5424..90ae04b4d5c7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3283,7 +3283,7 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	}
 
 	/* With LD_ABS/IND some JITs save/restore skb from r1. */
-	changes_data = bpf_helper_changes_pkt_data(fn->func);
+	changes_data = fn->ctx_update;
 	if (changes_data && fn->arg1_type != ARG_PTR_TO_CTX) {
 		verbose(env, "kernel subsystem misconfigured func %s#%d: r1 != ctx\n",
 			func_id_name(func_id), func_id);
diff --git a/net/core/filter.c b/net/core/filter.c
index 55bfc941d17a..a9e7d3174d36 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1693,6 +1693,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 static const struct bpf_func_proto bpf_skb_store_bytes_proto = {
 	.func		= bpf_skb_store_bytes,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -1825,6 +1826,7 @@ BPF_CALL_2(bpf_skb_pull_data, struct sk_buff *, skb, u32, len)
 static const struct bpf_func_proto bpf_skb_pull_data_proto = {
 	.func		= bpf_skb_pull_data,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -1868,6 +1870,7 @@ BPF_CALL_2(sk_skb_pull_data, struct sk_buff *, skb, u32, len)
 static const struct bpf_func_proto sk_skb_pull_data_proto = {
 	.func		= sk_skb_pull_data,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -1909,6 +1912,7 @@ BPF_CALL_5(bpf_l3_csum_replace, struct sk_buff *, skb, u32, offset,
 static const struct bpf_func_proto bpf_l3_csum_replace_proto = {
 	.func		= bpf_l3_csum_replace,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -1962,6 +1966,7 @@ BPF_CALL_5(bpf_l4_csum_replace, struct sk_buff *, skb, u32, offset,
 static const struct bpf_func_proto bpf_l4_csum_replace_proto = {
 	.func		= bpf_l4_csum_replace,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -2145,6 +2150,7 @@ BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
 static const struct bpf_func_proto bpf_clone_redirect_proto = {
 	.func           = bpf_clone_redirect,
 	.gpl_only       = false,
+	.ctx_update	= true,
 	.ret_type       = RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
@@ -2337,6 +2343,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 static const struct bpf_func_proto bpf_msg_pull_data_proto = {
 	.func		= bpf_msg_pull_data,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -2468,6 +2475,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 static const struct bpf_func_proto bpf_msg_push_data_proto = {
 	.func		= bpf_msg_push_data,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -2636,6 +2644,7 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 static const struct bpf_func_proto bpf_msg_pop_data_proto = {
 	.func		= bpf_msg_pop_data,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -2738,6 +2747,7 @@ BPF_CALL_3(bpf_skb_vlan_push, struct sk_buff *, skb, __be16, vlan_proto,
 static const struct bpf_func_proto bpf_skb_vlan_push_proto = {
 	.func           = bpf_skb_vlan_push,
 	.gpl_only       = false,
+	.ctx_update	= true,
 	.ret_type       = RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
@@ -2759,6 +2769,7 @@ BPF_CALL_1(bpf_skb_vlan_pop, struct sk_buff *, skb)
 static const struct bpf_func_proto bpf_skb_vlan_pop_proto = {
 	.func           = bpf_skb_vlan_pop,
 	.gpl_only       = false,
+	.ctx_update	= true,
 	.ret_type       = RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
@@ -2962,6 +2973,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 static const struct bpf_func_proto bpf_skb_change_proto_proto = {
 	.func		= bpf_skb_change_proto,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -3198,6 +3210,7 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 static const struct bpf_func_proto bpf_skb_adjust_room_proto = {
 	.func		= bpf_skb_adjust_room,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -3285,6 +3298,7 @@ BPF_CALL_3(bpf_skb_change_tail, struct sk_buff *, skb, u32, new_len,
 static const struct bpf_func_proto bpf_skb_change_tail_proto = {
 	.func		= bpf_skb_change_tail,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -3303,6 +3317,7 @@ BPF_CALL_3(sk_skb_change_tail, struct sk_buff *, skb, u32, new_len,
 static const struct bpf_func_proto sk_skb_change_tail_proto = {
 	.func		= sk_skb_change_tail,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -3351,6 +3366,7 @@ BPF_CALL_3(bpf_skb_change_head, struct sk_buff *, skb, u32, head_room,
 static const struct bpf_func_proto bpf_skb_change_head_proto = {
 	.func		= bpf_skb_change_head,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -3369,6 +3385,7 @@ BPF_CALL_3(sk_skb_change_head, struct sk_buff *, skb, u32, head_room,
 static const struct bpf_func_proto sk_skb_change_head_proto = {
 	.func		= sk_skb_change_head,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -3403,6 +3420,7 @@ BPF_CALL_2(bpf_xdp_adjust_head, struct xdp_buff *, xdp, int, offset)
 static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.func		= bpf_xdp_adjust_head,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -3427,6 +3445,7 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 static const struct bpf_func_proto bpf_xdp_adjust_tail_proto = {
 	.func		= bpf_xdp_adjust_tail,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -3455,6 +3474,7 @@ BPF_CALL_2(bpf_xdp_adjust_meta, struct xdp_buff *, xdp, int, offset)
 static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
 	.func		= bpf_xdp_adjust_meta,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -4987,6 +5007,7 @@ BPF_CALL_4(bpf_lwt_xmit_push_encap, struct sk_buff *, skb, u32, type,
 static const struct bpf_func_proto bpf_lwt_in_push_encap_proto = {
 	.func		= bpf_lwt_in_push_encap,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -4997,6 +5018,7 @@ static const struct bpf_func_proto bpf_lwt_in_push_encap_proto = {
 static const struct bpf_func_proto bpf_lwt_xmit_push_encap_proto = {
 	.func		= bpf_lwt_xmit_push_encap,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -5040,6 +5062,7 @@ BPF_CALL_4(bpf_lwt_seg6_store_bytes, struct sk_buff *, skb, u32, offset,
 static const struct bpf_func_proto bpf_lwt_seg6_store_bytes_proto = {
 	.func		= bpf_lwt_seg6_store_bytes,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -5128,6 +5151,7 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 static const struct bpf_func_proto bpf_lwt_seg6_action_proto = {
 	.func		= bpf_lwt_seg6_action,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -5188,6 +5212,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 static const struct bpf_func_proto bpf_lwt_seg6_adjust_srh_proto = {
 	.func		= bpf_lwt_seg6_adjust_srh,
 	.gpl_only	= false,
+	.ctx_update	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
@@ -5756,40 +5781,6 @@ static const struct bpf_func_proto bpf_tcp_check_syncookie_proto = {
 
 #endif /* CONFIG_INET */
 
-bool bpf_helper_changes_pkt_data(void *func)
-{
-	if (func == bpf_skb_vlan_push ||
-	    func == bpf_skb_vlan_pop ||
-	    func == bpf_skb_store_bytes ||
-	    func == bpf_skb_change_proto ||
-	    func == bpf_skb_change_head ||
-	    func == sk_skb_change_head ||
-	    func == bpf_skb_change_tail ||
-	    func == sk_skb_change_tail ||
-	    func == bpf_skb_adjust_room ||
-	    func == bpf_skb_pull_data ||
-	    func == sk_skb_pull_data ||
-	    func == bpf_clone_redirect ||
-	    func == bpf_l3_csum_replace ||
-	    func == bpf_l4_csum_replace ||
-	    func == bpf_xdp_adjust_head ||
-	    func == bpf_xdp_adjust_meta ||
-	    func == bpf_msg_pull_data ||
-	    func == bpf_msg_push_data ||
-	    func == bpf_msg_pop_data ||
-	    func == bpf_xdp_adjust_tail ||
-#if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
-	    func == bpf_lwt_seg6_store_bytes ||
-	    func == bpf_lwt_seg6_adjust_srh ||
-	    func == bpf_lwt_seg6_action ||
-#endif
-	    func == bpf_lwt_in_push_encap ||
-	    func == bpf_lwt_xmit_push_encap)
-		return true;
-
-	return false;
-}
-
 static const struct bpf_func_proto *
 bpf_base_func_proto(enum bpf_func_id func_id)
 {
-- 
2.20.1

