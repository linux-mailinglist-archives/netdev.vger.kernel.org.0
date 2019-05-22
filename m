Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BEB26A35
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbfEVSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:55:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35512 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfEVSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:55:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so3483420wrv.2
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1ltC0XV47uD9Ss4Mv4UBpU2RzQzY2ir2n8PLOTN4Pg4=;
        b=P0xAhGWqM4issKsO8Kl0iT/oIwgYg0l2zx6vbcOjrWz2u1ofsU9AZQ/CxpcNd66fFJ
         qA6hFSY8ZuVymHOiMG2OUUBhHV/XVrXBWwS7449+ApZC4Bd9wB8grd+3Ts47YE6+Jufm
         qsTezc2V7O7M98y8YlRcu/aRAB3LppOlyko6dAQOm0QQv9pbUNbAI2rOUIUScFtZHKU7
         lCq99bARDDxgf4grc3hb4AE9V7PSq9Q41+yv7OqPt3zPu0DsLP7v3REBsm+a+laZPxAS
         6SzAbRGlyB9BxbxdVF8Q8ta9Zbl3P4kiPDKDSGgAMgvqUiDHX/69B7FecsoYg8+SFEHA
         cXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1ltC0XV47uD9Ss4Mv4UBpU2RzQzY2ir2n8PLOTN4Pg4=;
        b=aJpiWif+pGnDWka3ttiJZxi7fXXbiifSa06TFM4PRQhrYWEgMBlpK6IXX2DJnQ98FM
         BogfApdJrCDmy3j72b08JFozNLMGWnxYTAUyMulGt0+7YcyIiqUuzRj7ge+j0GFS33Ea
         TUeHwfTCkETRiCuxyIu2Fl09akLhIsW9pxHQ3kMj2E4M9mqZoyGeBZA7CvjQcfzkEod/
         eVV7ctKYraL7CF3XZFG19QfZaDgtiFm6B3PowVXW19Wx0DWopb0Rwwy6DKkT/k8KvCEB
         fRD5oTzKyClcgqlV8A+FddndYT3doEltPj3m7X2Wk4UCFty/JLZLyjjKj99SSzMsEzM1
         ebjA==
X-Gm-Message-State: APjAAAVTdcFGjV4sURhphbUigombNXvxnhYtNXToUTzosj6RyP1hnRaZ
        rq1tjGEzWFf/43/cgicjm1hVGw==
X-Google-Smtp-Source: APXvYqxNAL23kfWjmrURX0DdczM89KOvuxXG+QjjWR4o+x3c6mvq6obo78yLTr4F7ddumT6doIlkDw==
X-Received: by 2002:a5d:4d92:: with SMTP id b18mr55499385wru.212.1558551356592;
        Wed, 22 May 2019 11:55:56 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.55.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:55:56 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 07/16] libbpf: add "prog_flags" to bpf_program/bpf_prog_load_attr/bpf_load_program_attr
Date:   Wed, 22 May 2019 19:55:03 +0100
Message-Id: <1558551312-17081-8-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf doesn't allow passing "prog_flags" during bpf program load in a
couple of load related APIs, "bpf_load_program_xattr", "load_program" and
"bpf_prog_load_xattr".

It makes sense to allow passing "prog_flags" which is useful for
customizing program loading.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 tools/lib/bpf/bpf.c    | 1 +
 tools/lib/bpf/bpf.h    | 1 +
 tools/lib/bpf/libbpf.c | 3 +++
 tools/lib/bpf/libbpf.h | 1 +
 4 files changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index c4a4808..0d4b4fe 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -256,6 +256,7 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	if (load_attr->name)
 		memcpy(attr.prog_name, load_attr->name,
 		       min(strlen(load_attr->name), BPF_OBJ_NAME_LEN - 1));
+	attr.prog_flags = load_attr->prog_flags;
 
 	fd = sys_bpf_prog_load(&attr, sizeof(attr));
 	if (fd >= 0)
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9593fec..ff42ca0 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -87,6 +87,7 @@ struct bpf_load_program_attr {
 	const void *line_info;
 	__u32 line_info_cnt;
 	__u32 log_level;
+	__u32 prog_flags;
 };
 
 /* Flags to direct loading requirements */
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 197b574..ff14937 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -188,6 +188,7 @@ struct bpf_program {
 	void *line_info;
 	__u32 line_info_rec_size;
 	__u32 line_info_cnt;
+	__u32 prog_flags;
 };
 
 enum libbpf_map_type {
@@ -2076,6 +2077,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.line_info_rec_size = prog->line_info_rec_size;
 	load_attr.line_info_cnt = prog->line_info_cnt;
 	load_attr.log_level = prog->log_level;
+	load_attr.prog_flags = prog->prog_flags;
 	if (!load_attr.insns || !load_attr.insns_cnt)
 		return -EINVAL;
 
@@ -3521,6 +3523,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 						      expected_attach_type);
 
 		prog->log_level = attr->log_level;
+		prog->prog_flags = attr->prog_flags;
 		if (!first_prog)
 			first_prog = prog;
 	}
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c5ff005..5abc237 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -320,6 +320,7 @@ struct bpf_prog_load_attr {
 	enum bpf_attach_type expected_attach_type;
 	int ifindex;
 	int log_level;
+	int prog_flags;
 };
 
 LIBBPF_API int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
-- 
2.7.4

