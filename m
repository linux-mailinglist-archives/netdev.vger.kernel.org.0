Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE4695DC0
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfHTLsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:48:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbfHTLr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:47:59 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC3B651EE9
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 11:47:58 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id d64so4006501edd.1
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 04:47:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tns3X20kzIxYMTEjCT9/3JYq9mPQM7ixlDT6OHIk8Ac=;
        b=q0SYsztgAciTnUD00R+EexZLFi/8keWWhde/P8URTovvRhwrB9fNFY6qY5fuqpoKLk
         hqJeX5fMUDAjLA7InSjpwn88yIPFvI11YlVAibd6Z+Iink5mM6ATVK4kKAJAuuMH2RUN
         mk7Z47R9f3q/GXjv+uhVuZccxpPblJxb8dGrVOe1Lmgy72kjrze7qbhIMrEqV5+oPVg9
         lVS27/rTFI9X73fuqPDfmElRRFhwLSmHBjK8Rzrw44MgaiwmJEaoQB0dGtEpP3lEQDCU
         RxKuT3bVEhV8aFNiEz97i4X7IGQD/LJGcBsdkG+4GSilbDP+shwbqBvXs+zkagBAb1rF
         3aHQ==
X-Gm-Message-State: APjAAAVlScUfbUmin1a1HogrBM2fw7fAIZaTC/pUl9QP+kLlfp3eYz0/
        x7mXHABZRo4BAZqDcFHmXv78/4yxpqhUGdWjFR9X2U4Y0UoxgqO6oJ8qMCusv89NN1RU03bimpv
        RixdtVwOoepl6QNkv
X-Received: by 2002:aa7:dd04:: with SMTP id i4mr15429671edv.235.1566301677435;
        Tue, 20 Aug 2019 04:47:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxTWRWkO8YxsKXoauqAjnJheJ39tiXDk3ZoJ3sI2LJTZhlpt/LrwJiSC8myAhKAE6dihJg42A==
X-Received: by 2002:aa7:dd04:: with SMTP id i4mr15429654edv.235.1566301677236;
        Tue, 20 Aug 2019 04:47:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d9sm3386687edz.85.2019.08.20.04.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 04:47:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3B18D181CE4; Tue, 20 Aug 2019 13:47:56 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC bpf-next 5/5] iproute2: Support loading XDP programs with libbpf
Date:   Tue, 20 Aug 2019 13:47:06 +0200
Message-Id: <20190820114706.18546-6-toke@redhat.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190820114706.18546-1-toke@redhat.com>
References: <20190820114706.18546-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switches over loading of XDP programs to the using libbpf, if it is
available. It uses the automatic pinning features added to libbpf to
construct the same pinning paths as the libelf-based loader.

Since map-in-map support has not yet been added to libbpf, this means that
map-in-map definitions will not work with this patch.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 lib/bpf.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 102 insertions(+), 13 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index c6e3bd0d..de1a655a 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -938,9 +938,17 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 	return ret;
 }
 
+#ifdef HAVE_LIBBPF
+static int bpf_do_load_libbpf(struct bpf_cfg_in *cfg);
+#endif
+
 static int bpf_do_load(struct bpf_cfg_in *cfg)
 {
 	if (cfg->mode == EBPF_OBJECT) {
+#ifdef HAVE_LIBBPF
+		if(cfg->type == BPF_PROG_TYPE_XDP)
+			return bpf_do_load_libbpf(cfg);
+#endif
 		cfg->prog_fd = bpf_obj_open(cfg->object, cfg->type,
 					    cfg->section, cfg->ifindex,
 					    cfg->verbose);
@@ -1407,25 +1415,22 @@ static bool bpf_no_pinning(const struct bpf_elf_ctx *ctx,
 	}
 }
 
-static void bpf_make_pathname(char *pathname, size_t len, const char *name,
+static int bpf_make_pathname(char *pathname, size_t len, const char *name,
 			      const struct bpf_elf_ctx *ctx, uint32_t pinning)
 {
 	switch (pinning) {
 	case PIN_OBJECT_NS:
-		snprintf(pathname, len, "%s/%s/%s",
-			 bpf_get_work_dir(ctx->type),
-			 ctx->obj_uid, name);
-		break;
+		return snprintf(pathname, len, "%s/%s/%s",
+				bpf_get_work_dir(ctx->type),
+				ctx->obj_uid, name);
 	case PIN_GLOBAL_NS:
-		snprintf(pathname, len, "%s/%s/%s",
-			 bpf_get_work_dir(ctx->type),
-			 BPF_DIR_GLOBALS, name);
-		break;
+		return snprintf(pathname, len, "%s/%s/%s",
+				bpf_get_work_dir(ctx->type),
+				BPF_DIR_GLOBALS, name);
 	default:
-		snprintf(pathname, len, "%s/../%s/%s",
-			 bpf_get_work_dir(ctx->type),
-			 bpf_custom_pinning(ctx, pinning), name);
-		break;
+		return snprintf(pathname, len, "%s/../%s/%s",
+				bpf_get_work_dir(ctx->type),
+				bpf_custom_pinning(ctx, pinning), name);
 	}
 }
 
@@ -3160,3 +3165,87 @@ int bpf_recv_map_fds(const char *path, int *fds, struct bpf_map_aux *aux,
 	return ret;
 }
 #endif /* HAVE_ELF */
+
+#ifdef HAVE_LIBBPF
+static int bpf_gen_pin_name(void *priv, char *buf, int buf_len,
+			    const char *name, unsigned int pinning)
+{
+	struct bpf_elf_ctx *ctx = priv;
+	const char *tmp;
+	int ret = 0;
+
+	if (bpf_no_pinning(ctx, pinning) || !bpf_get_work_dir(ctx->type))
+		return 0;
+
+	if (pinning == PIN_OBJECT_NS)
+		ret = bpf_make_obj_path(ctx);
+	else if ((tmp = bpf_custom_pinning(ctx, pinning)))
+		ret = bpf_make_custom_path(ctx, tmp);
+	if (ret < 0)
+		return ret;
+
+	return bpf_make_pathname(buf, buf_len, name, ctx, pinning);
+}
+
+static int bpf_elf_ctx_init_stub(struct bpf_elf_ctx *ctx, const char *pathname,
+				 enum bpf_prog_type type, int verbose)
+{
+	uint8_t tmp[20];
+	int ret;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ret = bpf_obj_hash(pathname, tmp, sizeof(tmp));
+	if (ret)
+		ctx->noafalg = true;
+	else
+		hexstring_n2a(tmp, sizeof(tmp), ctx->obj_uid,
+			      sizeof(ctx->obj_uid));
+
+	ctx->verbose = verbose;
+	ctx->type    = type;
+	bpf_hash_init(ctx, CONFDIR "/bpf_pinning");
+
+	return 0;
+}
+
+static int verbose_print(enum libbpf_print_level level, const char *format,
+			 va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
+static int bpf_do_load_libbpf(struct bpf_cfg_in *cfg)
+{
+	struct bpf_elf_ctx *ctx = &__ctx;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int err, prog_fd = -1;
+
+	struct bpf_prog_load_attr attr = {
+		.file = cfg->object,
+		.prog_type = cfg->type,
+		.ifindex = cfg->ifindex,
+		.log_level = cfg->verbose,
+		.auto_pin_cb = bpf_gen_pin_name,
+		.auto_pin_ctx = ctx,
+	};
+
+	if (cfg->verbose)
+		libbpf_set_print(verbose_print);
+
+	bpf_elf_ctx_init_stub(ctx, cfg->object, cfg->type, cfg->verbose);
+
+	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
+	if (err)
+		return err;
+
+	if (cfg->section) {
+		prog = bpf_object__find_program_by_title(obj,
+							 cfg->section);
+		prog_fd = bpf_program__fd(prog);
+	}
+
+	cfg->prog_fd = prog_fd;
+	return cfg->prog_fd;
+}
+#endif
-- 
2.22.1

