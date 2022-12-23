Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74EE655683
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiLXAJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiLXAIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:08:48 -0500
Received: from smtpout7.r2.mail-out.ovh.net (smtpout7.r2.mail-out.ovh.net [54.36.141.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F00B389FD
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:07:13 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.110.115.38])
        by mo511.mail-out.ovh.net (Postfix) with ESMTPS id 639DE26719;
        Fri, 23 Dec 2022 23:50:12 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 00:50:10 +0100
From:   Quentin Deslandes <qde@naccy.de>
To:     <qde@naccy.de>
CC:     <kernel-team@meta.com>, Dmitrii Banshchikov <me@ubique.spb.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH bpf-next v3 07/16] bpfilter: add support for TC bytecode generation
Date:   Sat, 24 Dec 2022 00:40:15 +0100
Message-ID: <20221223234127.474463-8-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221223234127.474463-1-qde@naccy.de>
References: <20221223234127.474463-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4518236328503275127
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddugecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepshgufhesghhoohhglhgvrdgtohhmpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpshhhuhgrhheskhgvrhhnvghlrdhorhhgpdhmhihkohhlrghlsehfsgdrtghomhdpphgrsggvnhhisehrvgguhhgrthdrtghomhdpkhhusggrsehkvghrnhgvlhdrohhrghdpvgguuhhmrgiivghtsehgohhoghhlvgdrtghomhdpuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvth
 dpjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhhrgholhhuohesghhoohhglhgvrdgtohhmpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhmvgesuhgsihhquhgvrdhsphgsrdhruhdpkhgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheduuddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code generation support for TC hooks.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/codegen.c | 151 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/net/bpfilter/codegen.c b/net/bpfilter/codegen.c
index 545bc7aeb77c..e7ae7dfa5118 100644
--- a/net/bpfilter/codegen.c
+++ b/net/bpfilter/codegen.c
@@ -8,6 +8,8 @@
 
 #include "../../include/uapi/linux/bpfilter.h"
 
+#include <linux/pkt_cls.h>
+
 #include <unistd.h>
 #include <sys/syscall.h>
 
@@ -15,6 +17,8 @@
 #include <stdlib.h>
 #include <string.h>
 
+#include <bpf/libbpf.h>
+
 #include "logger.h"
 
 enum fixup_insn_type {
@@ -390,6 +394,150 @@ static void unload_maps(struct codegen *codegen)
 	}
 }
 
+static int tc_gen_inline_prologue(struct codegen *codegen)
+{
+	EMIT(codegen, BPF_MOV64_REG(CODEGEN_REG_CTX, BPF_REG_ARG1));
+	EMIT(codegen, BPF_MOV64_REG(CODEGEN_REG_RUNTIME_CTX, BPF_REG_FP));
+	EMIT(codegen, BPF_MOV32_IMM(CODEGEN_REG_RETVAL, TC_ACT_OK));
+
+	return 0;
+}
+
+static int tc_load_packet_data(struct codegen *codegen, int dst_reg)
+{
+	EMIT(codegen, BPF_LDX_MEM(BPF_W, dst_reg, CODEGEN_REG_CTX,
+				  offsetof(struct __sk_buff, data)));
+
+	return 0;
+}
+
+static int tc_load_packet_data_end(struct codegen *codegen, int dst_reg)
+{
+	EMIT(codegen, BPF_LDX_MEM(BPF_W, CODEGEN_REG_DATA_END, CODEGEN_REG_CTX,
+				  offsetof(struct __sk_buff, data_end)));
+
+	return 0;
+}
+
+static int tc_emit_ret_code(struct codegen *codegen, int ret_code)
+{
+	int tc_ret_code;
+
+	if (ret_code == BPFILTER_NF_ACCEPT)
+		tc_ret_code = TC_ACT_UNSPEC;
+	else if (ret_code == BPFILTER_NF_DROP)
+		tc_ret_code = TC_ACT_SHOT;
+	else
+		return -EINVAL;
+
+	EMIT(codegen, BPF_MOV32_IMM(BPF_REG_0, tc_ret_code));
+
+	return 0;
+}
+
+static int tc_gen_inline_epilogue(struct codegen *codegen)
+{
+	EMIT(codegen, BPF_EXIT_INSN());
+
+	return 0;
+}
+
+struct tc_img_ctx {
+	int fd;
+	struct bpf_tc_hook hook;
+	struct bpf_tc_opts opts;
+};
+
+static int tc_load_img(struct codegen *codegen)
+{
+	struct tc_img_ctx *img_ctx;
+	int fd;
+	int r;
+
+	if (codegen->img_ctx) {
+		BFLOG_ERR("TC context missing from codegen");
+		return -EINVAL;
+	}
+
+	img_ctx = calloc(1, sizeof(*img_ctx));
+	if (!img_ctx) {
+		BFLOG_ERR("out of memory");
+		return -ENOMEM;
+	}
+
+	img_ctx->hook.sz = sizeof(img_ctx->hook);
+	img_ctx->hook.ifindex = 2;
+	img_ctx->hook.attach_point = codegen->bpf_tc_hook;
+
+	fd = load_img(codegen);
+	if (fd < 0) {
+		BFLOG_ERR("failed to load TC codegen image: %s", STRERR(fd));
+		r = fd;
+		goto err_free;
+	}
+
+	r = bpf_tc_hook_create(&img_ctx->hook);
+	if (r && r != -EEXIST) {
+		BFLOG_ERR("failed to create TC hook: %s\n", STRERR(r));
+		goto err_free;
+	}
+
+	img_ctx->opts.sz = sizeof(img_ctx->opts);
+	img_ctx->opts.handle = codegen->iptables_hook;
+	img_ctx->opts.priority = 0;
+	img_ctx->opts.prog_fd = fd;
+	r = bpf_tc_attach(&img_ctx->hook, &img_ctx->opts);
+	if (r) {
+		BFLOG_ERR("failed to attach TC program: %s", STRERR(r));
+		goto err_free;
+	}
+
+	img_ctx->fd = fd;
+	codegen->img_ctx = img_ctx;
+
+	return fd;
+
+err_free:
+	if (fd > -1)
+		close(fd);
+	free(img_ctx);
+	return r;
+}
+
+static void tc_unload_img(struct codegen *codegen)
+{
+	struct tc_img_ctx *img_ctx;
+	int r;
+
+	BUG_ON(!codegen->img_ctx);
+
+	img_ctx = (struct tc_img_ctx *)codegen->img_ctx;
+	img_ctx->opts.flags = 0;
+	img_ctx->opts.prog_fd = 0;
+	img_ctx->opts.prog_id = 0;
+	r = bpf_tc_detach(&img_ctx->hook, &img_ctx->opts);
+	if (r)
+		BFLOG_EMERG("failed to detach TC program: %s", STRERR(r));
+
+	BUG_ON(img_ctx->fd < 0);
+	close(img_ctx->fd);
+	free(img_ctx);
+
+	codegen->img_ctx = NULL;
+
+	unload_img(codegen);
+}
+
+static const struct codegen_ops tc_codegen_ops = {
+	.gen_inline_prologue = tc_gen_inline_prologue,
+	.load_packet_data = tc_load_packet_data,
+	.load_packet_data_end = tc_load_packet_data_end,
+	.emit_ret_code = tc_emit_ret_code,
+	.gen_inline_epilogue = tc_gen_inline_epilogue,
+	.load_img = tc_load_img,
+	.unload_img = tc_unload_img,
+};
+
 void create_shared_codegen(struct shared_codegen *shared_codegen)
 {
 	shared_codegen->maps_refcnt = 0;
@@ -413,6 +561,9 @@ int create_codegen(struct codegen *codegen, enum bpf_prog_type type)
 	memset(codegen, 0, sizeof(*codegen));
 
 	switch (type) {
+	case BPF_PROG_TYPE_SCHED_CLS:
+		codegen->codegen_ops = &tc_codegen_ops;
+		break;
 	default:
 		BFLOG_ERR("unsupported BPF program type %d", type);
 		return -EINVAL;
-- 
2.38.1

