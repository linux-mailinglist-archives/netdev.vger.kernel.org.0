Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAE41468E2
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgAWNRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:17:16 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:41776 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbgAWNRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:17:15 -0500
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jan 2020 08:17:13 EST
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.242.48])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id C21C330C123;
        Thu, 23 Jan 2020 05:01:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com C21C330C123
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1579784507;
        bh=GRbeVqWsXvHOOBiyzIBZ+swPrvzsE9qungb3Sc5kCHg=;
        h=From:To:Cc:Subject:Date:From;
        b=AaKLcq1HqgI96Pla0Fz4E2OjsKquCk2SOU1wtq/cyl3xZlgQixYJJT2a8zgQ5U7u2
         HbWSE0aVgxBGr1mJ6hhaV6Ge93zaEfARcs1vWj25PDGaOOsQDlKCNM7eRKPxiSYmuK
         VSg6ixTSxTkLzudFyFR7Ew/1NLW1BlRdqJj63rHc=
Received: from lvnvde3894.broadcom.com (lvnvde3894.lvn.broadcom.net [10.175.127.104])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 5F78E140069;
        Thu, 23 Jan 2020 05:08:25 -0800 (PST)
Received: by lvnvde3894.broadcom.com (Postfix, from userid 55335)
        id 58086220AF8; Thu, 23 Jan 2020 05:08:25 -0800 (PST)
From:   Kalimuthu Velappan <kalimuthu.velappan@broadcom.com>
To:     kalimuthu.velappan@broadcom.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Andrey Ignatov <rdna@fb.com>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Support for nlattr and nested_nlattr attribute search in EBPF filter
Date:   Thu, 23 Jan 2020 05:08:12 -0800
Message-Id: <20200123130816.24815-1-kalimuthu.velappan@broadcom.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added attribute search and nested attribute support in EBPF filter
functionality.

Signed-off-by: Kalimuthu Velappan <kalimuthu.velappan@broadcom.com>
---
 include/uapi/linux/bpf.h       |  5 ++++-
 net/core/filter.c              | 22 ++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  4 +++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dbbcf0b..ac9794c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2938,7 +2938,10 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),  \
+	FN(skb_get_nlattr),     \
+	FN(skb_get_nlattr_nest),
+
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index 538f6a7..56a87e1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2699,6 +2699,24 @@ static const struct bpf_func_proto bpf_set_hash_invalid_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+static const struct bpf_func_proto bpf_skb_get_nlattr_proto = {
+	.func		= bpf_skb_get_nlattr,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type  = ARG_ANYTHING,
+	.arg3_type  = ARG_ANYTHING,
+};
+
+static const struct bpf_func_proto skb_get_nlattr_nest_proto = {
+	.func		= bpf_skb_get_nlattr_nest,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type  = ARG_ANYTHING,
+	.arg3_type  = ARG_ANYTHING,
+};
+
 BPF_CALL_2(bpf_set_hash, struct sk_buff *, skb, u32, hash)
 {
 	/* Set user specified hash as L4(+), so that it gets returned
@@ -6091,6 +6109,10 @@ sk_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_uid_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
+	case BPF_FUNC_skb_get_nlattr:
+		return &bpf_skb_get_nlattr_proto;
+	case BPF_FUNC_skb_get_nlattr_nest:
+		return &skb_get_nlattr_nest_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index dbbcf0b..3bfbc0e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2938,7 +2938,9 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),  \
+	FN(skb_get_nlattr),     \
+	FN(skb_get_nlattr_nest),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.7.4

