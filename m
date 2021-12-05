Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE1946892B
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhLEEyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhLEEyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:54:37 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F941C061751;
        Sat,  4 Dec 2021 20:51:10 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id y7so4913394plp.0;
        Sat, 04 Dec 2021 20:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TIBsLuBe2Uw4GhA4NG4hs+lUD45TYma1E3udwdUPRts=;
        b=bT/XDIRuZKP92ukFlMRwPi92FG5D08WZ+Fe4usE+t5FKFOSc5Ow0PyJwjyXfbIVLrH
         FcRtwn7Nk/VM4Tg5mHU1eEiz7krf2kscUxWGd3B+G/Hpo+8euP6Npdy6oCBpT/PAfvmF
         qECO8PmqDvcLRgUfxjDntEtymML+M0Y3NCWdE3OFUA/Mc/coAKZnQ4TSo+YDqzj/8Y4j
         BhN8Um/WBSckqdwn1pVt58TQS7h7nWjAksLf2Kykhvw1Jf/LDR1CayeHkFCH1FgLaQFU
         +NTLMdH7PAUTFKAOfgow5G3Eju4msIuDOp2xn4nbu5VDNbmO4pC9xO2LUVBKfT/kPq/y
         AKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TIBsLuBe2Uw4GhA4NG4hs+lUD45TYma1E3udwdUPRts=;
        b=xPqowiO3fmsxLpSpQaAnT7ragClBXFIij1RV8/BpCezZ4TH7o6dslLRLJTsU3lEk+4
         phfVC+BvVuTZEt11+8PLJJp4dvOQP7kH4NALoMiaPFJu7J3dqdGZ+qX9uOkJKabY3CTo
         7jqhAnrtchNg9l9Na1VcIOidVe5wmoiFXbrKnMkdboeSJEotL7ppktcKMjb1rnzpWkOs
         h2Tq3xjbzYbI9SInvo/2Zbmj9vll0nXms5lD/diBycVGNiZ9RXcW0sIdwdyW81vhVr8p
         yCRfWt3CGlRUOJle0rpadh2jYo0rEJkPm+JCmkWsGMzfMa1cxqzhEtlp16QF/Ursm0Gl
         pW2Q==
X-Gm-Message-State: AOAM531VjI/WKWZCQO/G+3d//rQ5NGq/OQlJxr0Ki0edqeOPB+XtRabE
        p6ACpWeJXjITu6ZJ/YUv1nKudGmNlYdBgQ==
X-Google-Smtp-Source: ABdhPJy9sf/N2yXY9s21KBb3U1nM5gU0lmIkS2pD4d3RJDIiXVCy6lZYp6eLyx6gV7eon/bo4eUbgA==
X-Received: by 2002:a17:90b:2409:: with SMTP id nr9mr26807369pjb.244.1638679870063;
        Sat, 04 Dec 2021 20:51:10 -0800 (PST)
Received: from localhost.localdomain ([139.155.25.230])
        by smtp.gmail.com with ESMTPSA id d18sm305582pfv.0.2021.12.04.20.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:51:09 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, quentin@isovalent.com, cong.wang@bytedance.com,
        liujian56@huawei.com, davemarchevsky@fb.com, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH] bpftool: add support of pin prog by name
Date:   Sun,  5 Dec 2021 12:50:41 +0800
Message-Id: <20211205045041.129716-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

For now, the command 'bpftool prog loadall' use section name as the
name of the pin file. However, once there are prog with the same
section name in ELF file, this command will failed with the error
'File Exist'.

So, add the support of pin prog by function name with the 'pinbyname'
argument.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 tools/bpf/bpftool/prog.c | 7 +++++++
 tools/lib/bpf/libbpf.c   | 5 +++++
 tools/lib/bpf/libbpf.h   | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index e47e8b06cc3d..74e0aaebfefc 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1471,6 +1471,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 	unsigned int old_map_fds = 0;
 	const char *pinmaps = NULL;
 	struct bpf_object *obj;
+	bool pinbyname = false;
 	struct bpf_map *map;
 	const char *pinfile;
 	unsigned int i, j;
@@ -1589,6 +1590,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 				goto err_free_reuse_maps;
 
 			pinmaps = GET_ARG();
+		} else if (is_prefix(*argv, "pinbyname")) {
+			pinbyname = true;
+			NEXT_ARG();
 		} else {
 			p_err("expected no more arguments, 'type', 'map' or 'dev', got: '%s'?",
 			      *argv);
@@ -1616,6 +1620,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 				goto err_close_obj;
 		}
 
+		if (pinbyname)
+			bpf_program__set_pinname(pos,
+						 (char *)bpf_program__name(pos));
 		bpf_program__set_ifindex(pos, ifindex);
 		bpf_program__set_type(pos, prog_type);
 		bpf_program__set_expected_attach_type(pos, expected_attach_type);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f6faa33c80fa..e8fc1d0fe16e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8119,6 +8119,11 @@ void bpf_program__set_ifindex(struct bpf_program *prog, __u32 ifindex)
 	prog->prog_ifindex = ifindex;
 }
 
+void bpf_program__set_pinname(struct bpf_program *prog, char *name)
+{
+	prog->pin_name = name;
+}
+
 const char *bpf_program__name(const struct bpf_program *prog)
 {
 	return prog->name;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 4ec69f224342..107cf736c2bb 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -216,6 +216,8 @@ LIBBPF_API int bpf_program__set_priv(struct bpf_program *prog, void *priv,
 LIBBPF_API void *bpf_program__priv(const struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_ifindex(struct bpf_program *prog,
 					 __u32 ifindex);
+LIBBPF_API void bpf_program__set_pinname(struct bpf_program *prog,
+					 char *name);
 
 LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog);
 LIBBPF_API const char *bpf_program__section_name(const struct bpf_program *prog);
-- 
2.30.2

