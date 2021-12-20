Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0200647B477
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 21:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhLTUk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 15:40:58 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:44270 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhLTUk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 15:40:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1640032857; x=1671568857;
  h=from:to:cc:subject:date:message-id;
  bh=7gcjqFEBl1z2FIEX9a6YE4vBVG8KWut/aOElnJSSrx4=;
  b=YjVbEq+Uqn1vEafSbwy4Xfls3NO7LztXzhbStHJRf+b0NyWJJngbuHL/
   TYE0yAh6tczk6MnT3Q4+wK2SCvsGH5oLhPLNKLaB69Dn4c9342DA/bwBU
   jPDozy52UZnYWGtaRzHV/aC/SkepEBKtQXuxoFoOX1VIG2Gi2zKqxfned
   w=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 20 Dec 2021 12:40:57 -0800
X-QCInternal: smtphost
Received: from hu-twear-lv.qualcomm.com (HELO hu-devc-lv-u18-c.qualcomm.com) ([10.47.234.142])
  by ironmsg08-lv.qualcomm.com with ESMTP; 20 Dec 2021 12:40:56 -0800
Received: by hu-devc-lv-u18-c.qualcomm.com (Postfix, from userid 202676)
        id C5C4C500177; Mon, 20 Dec 2021 12:40:36 -0800 (PST)
From:   Tyler Wear <quic_twear@quicinc.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Tyler Wear <quic_twear@quicinc.com>
Subject: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Date:   Mon, 20 Dec 2021 12:40:34 -0800
Message-Id: <20211220204034.24443-1-quic_twear@quicinc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New bpf helper function BPF_FUNC_skb_change_dsfield
"int bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)".
BPF_PROG_TYPE_CGROUP_SKB typed bpf_prog which currently can
be attached to the ingress and egress path. The helper is needed
because this type of bpf_prog cannot modify the skb directly.

Used by a bpf_prog to specify DS field values on egress or
ingress.

Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
---
 include/uapi/linux/bpf.h |  9 ++++++++
 net/core/filter.c        | 46 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 556216dc9703..742cea7dcf8c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3742,6 +3742,14 @@ union bpf_attr {
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
+ *
+ * long bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)
+ *	Description
+ *		Set DS field of IP header to the specified *value*. The *value*
+ *		is masked with the provided *mask* when ds field is updated.
+ *		Works with IPv6 and IPv4.
+ *	Return
+ *		1 if the DS field is set, 0 if it is not set.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3900,6 +3908,7 @@ union bpf_attr {
 	FN(per_cpu_ptr),		\
 	FN(this_cpu_ptr),		\
 	FN(redirect_peer),		\
+	FN(skb_change_dsfield),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 035d66227ae2..71ea943c8059 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6402,6 +6402,50 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk_buff *, skb)
 	return INET_ECN_set_ce(skb);
 }
 
+BPF_CALL_3(bpf_skb_change_dsfield, struct sk_buff *, skb, u8, mask, u8, value)
+{
+	unsigned int iphdr_len;
+
+	switch (skb_protocol(skb, true)) {
+	case cpu_to_be16(ETH_P_IP):
+		iphdr_len = sizeof(struct iphdr);
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		iphdr_len = sizeof(struct ipv6hdr);
+		break;
+	default:
+		return 0;
+	}
+
+	if (skb_headlen(skb) < iphdr_len)
+		return 0;
+
+	if (skb_cloned(skb) && !skb_clone_writable(skb, iphdr_len))
+		return 0;
+
+	switch (skb_protocol(skb, true)) {
+	case cpu_to_be16(ETH_P_IP):
+		ipv4_change_dsfield(ipip_hdr(skb), mask, value);
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		ipv6_change_dsfield(ipv6_hdr(skb), mask, value);
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static const struct bpf_func_proto bpf_skb_change_dsfield_proto = {
+	.func           = bpf_skb_change_dsfield,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type      = ARG_ANYTHING,
+};
+
 bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info)
 {
@@ -7057,6 +7101,8 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_listener_sock_proto;
 	case BPF_FUNC_skb_ecn_set_ce:
 		return &bpf_skb_ecn_set_ce_proto;
+	case BPF_FUNC_skb_change_dsfield:
+		return &bpf_skb_change_dsfield_proto;
 #endif
 	default:
 		return sk_filter_func_proto(func_id, prog);
-- 
2.17.1

