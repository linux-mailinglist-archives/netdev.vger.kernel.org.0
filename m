Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568F212BCA
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfECKoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:44:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45382 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfECKnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id s15so7209207wra.12
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NA7Zmed3nLQuw1MNsM252lDKOYqIIWGI4OywzuFN9TQ=;
        b=oJ/kkam9bs/yjmdpEULbSM7b6BZr/9Hn+TTNPfQI0x9t+CDGrQg5E5Q1sqkeh/LxyU
         kjmaf2a2jBXqpEw2OjVDj8HF5Dx3l6WKWRi6OMtA41ZvcjmFeAakWYCmvSTDvLRUxcuj
         df18dF45bRV2zz5kRjDln06UuzUxGcwiOb9M10dMVH0WMisVV+J5AEJEbXLGK9BNxXKZ
         +f3LZl50bc9wLLydrRGb536/YBfsdNNWU5Y04iiwW04O13pdA4gFvz7+tEk7NdT+okRY
         +xPGmFeR+OOGgFhkxNHDf0cNXmzSPMoIpjQh6eGBfhj94NWRmRzaVJanPdF7OmykSTwL
         53hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NA7Zmed3nLQuw1MNsM252lDKOYqIIWGI4OywzuFN9TQ=;
        b=oSGOTSe//mxLiLsXviCeE7eXluWCgGAmBFzYyRxohGzIFb3lSlpUyg08vSbOOqHKr9
         CVDot2kVDKC7yU/ETnfpC9a42r6nnhKyxhsyCp/EoiSE7J/nV96WsM0uZXJ1EBLQ+dKa
         ZlbiuIIG1qD7EbzrZcoO8ZlzJaJtuPM/IdGJPCG9Wn/T4U6UDU1srTv4vX77WR0u+cVl
         SJgE/q0C05A81LmvVh6hPcc9ROMtxrvATxZx5YtyIpZtl1bNb6IHxF73lh6ek1SFV0eM
         muTuAYtzJGgEA4K1F/AMUvwYdbD+K6Gvxc27H4nUa5+tZ0GiLzsjcUHAedIE37dzpyGk
         W4Ig==
X-Gm-Message-State: APjAAAVToYxcYaX2J5oEm9Y66TudNFeMZt1Hlm+7NHeDBwB4TYNmWBuu
        PnsXCXG52E7NMYSculHd1mQF5A==
X-Google-Smtp-Source: APXvYqyJEKh1xPoG/mg/1jP4cw49utwLfxPf0zIQY1DbGyrmgUS5pxRAbbGjqdEl0KTaz9MKBc80Rw==
X-Received: by 2002:a5d:54c7:: with SMTP id x7mr315384wrv.253.1556880231739;
        Fri, 03 May 2019 03:43:51 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:51 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v6 bpf-next 08/17] libbpf: add "prog_flags" to bpf_program/bpf_prog_load_attr/bpf_load_program_attr
Date:   Fri,  3 May 2019 11:42:35 +0100
Message-Id: <1556880164-10689-9-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
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
index 955191c..f79ec49 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -254,6 +254,7 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
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
index 11a65db..debca21 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -184,6 +184,7 @@ struct bpf_program {
 	void *line_info;
 	__u32 line_info_rec_size;
 	__u32 line_info_cnt;
+	__u32 prog_flags;
 };
 
 enum libbpf_map_type {
@@ -1949,6 +1950,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.line_info_rec_size = prog->line_info_rec_size;
 	load_attr.line_info_cnt = prog->line_info_cnt;
 	load_attr.log_level = prog->log_level;
+	load_attr.prog_flags = prog->prog_flags;
 	if (!load_attr.insns || !load_attr.insns_cnt)
 		return -EINVAL;
 
@@ -3394,6 +3396,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
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

