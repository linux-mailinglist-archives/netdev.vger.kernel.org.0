Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833FC41D5E0
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 11:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349197AbhI3JBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 05:01:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13010 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349112AbhI3JBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 05:01:45 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKnGT1hP0zWWTw;
        Thu, 30 Sep 2021 16:58:41 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:59:59 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 30 Sep
 2021 16:59:59 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v4 2/3] libbpf: support detecting and attaching of writable tracepoint program
Date:   Thu, 30 Sep 2021 17:13:53 +0800
Message-ID: <20210930091355.2794601-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210930091355.2794601-1-houtao1@huawei.com>
References: <20210930091355.2794601-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Program on writable tracepoint is BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
but its attachment is the same as BPF_PROG_TYPE_RAW_TRACEPOINT.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/lib/bpf/libbpf.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7544d7d09160..80faa53dff35 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8005,6 +8005,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("tp/",			TRACEPOINT, 0, SEC_NONE, attach_tp),
 	SEC_DEF("raw_tracepoint/",	RAW_TRACEPOINT, 0, SEC_NONE, attach_raw_tp),
 	SEC_DEF("raw_tp/",		RAW_TRACEPOINT, 0, SEC_NONE, attach_raw_tp),
+	SEC_DEF("raw_tracepoint.w/",	RAW_TRACEPOINT_WRITABLE, 0, SEC_NONE, attach_raw_tp),
+	SEC_DEF("raw_tp.w/",		RAW_TRACEPOINT_WRITABLE, 0, SEC_NONE, attach_raw_tp),
 	SEC_DEF("tp_btf/",		TRACING, BPF_TRACE_RAW_TP, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("fentry/",		TRACING, BPF_TRACE_FENTRY, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("fmod_ret/",		TRACING, BPF_MODIFY_RETURN, SEC_ATTACH_BTF, attach_trace),
@@ -9762,12 +9764,21 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(const struct bpf_program *pr
 
 static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cookie)
 {
-	const char *tp_name;
+	static const char *prefixes[] = {
+		"raw_tp/",
+		"raw_tracepoint/",
+		"raw_tp.w/",
+		"raw_tracepoint.w/",
+	};
+	size_t i;
+	const char *tp_name = NULL;
 
-	if (str_has_pfx(prog->sec_name, "raw_tp/"))
-		tp_name = prog->sec_name + sizeof("raw_tp/") - 1;
-	else
-		tp_name = prog->sec_name + sizeof("raw_tracepoint/") - 1;
+	for (i = 0; i < ARRAY_SIZE(prefixes); i++) {
+		if (str_has_pfx(prog->sec_name, prefixes[i])) {
+			tp_name = prog->sec_name + strlen(prefixes[i]);
+			break;
+		}
+	}
 
 	return bpf_program__attach_raw_tracepoint(prog, tp_name);
 }
-- 
2.29.2

