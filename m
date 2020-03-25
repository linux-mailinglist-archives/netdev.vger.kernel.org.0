Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47F1193173
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgCYTz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:55:26 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:46360 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgCYTz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:55:26 -0400
Received: by mail-ua1-f73.google.com with SMTP id 16so1332967uag.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 12:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cH0tJYs53PTCLsdOYQQz/gzKpECnsr9ruFmx+0XDr8s=;
        b=cqua3BHYK0VDcoJgQQtAMLLLfQq3Mx0ig0iQYlc5He92FiAS0zrySvSFgsvbFdhm7q
         qlt7DnMaCjyUwCgqpfB/MKLfNWp5Djp5cvfOkRaajAKmXynCQ4xA376oGA52QPoignuQ
         D2qa3fyDFEoLNv87rRFpxE1Vo/TvnR+SNilWs3Zug4O1NDha3JQj7gdkS2PDccn+mL1y
         pxWktWtHpT670UEVMl2r+m/1P/CKXor+bFMChluwiszoZLXc4CIk5NGP9f+0ou0d3guO
         g6WpSPmItXylURM0dsyQJt4BlLeQoyuXgPeENlZu34+2zIoJn9GHCvBn524wML9tWWWV
         wh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cH0tJYs53PTCLsdOYQQz/gzKpECnsr9ruFmx+0XDr8s=;
        b=DQn4qwXZTqvdcMyFlsgsf5MP3g9ndiBauREB6BW1uunfATDjQwWBLPCj9SaPiFg4Y3
         lInabHnbKCQ5+dqoGqxgH6zLPHbu+MQZGFyY6rjVA9RMQ/j4xl1BaBenNGgpzauvgH+j
         7PNexO0f5Sw0hyIPzRH6cO7JDeLE/33MUWpwr++5yf4A7Ws8DAHh8YgxBK++7rv2G6I9
         oxINKT+fWEicTHxRkJEcxCCB3lXtb7T7GLVoM5ia2Vqxp8p1hAtFSZm/HJJ37f9XisfA
         C4t0stJ07smttsinyNapt8A4n+7ULg5Pg9KZUwtyiVZ/S9lkT7UpY4lASx0U3Ps/Xu3Q
         YagQ==
X-Gm-Message-State: ANhLgQ3NEHhYH3NFFTKIHOv6TEOGvpilnAmAm2y5ek/RIAixvmVd+ezN
        btfnYXg0zua4KomO/WAAohBtdBgFseVwZishEoL+eM9S2E1XmC0qrIlZWh+VZV9Ki+a6CmRQDXF
        rVqcRcRSIZ9+CnfWeYcBIchlHsdHks6mehAsMEEY8QOpSp78ayS1poA==
X-Google-Smtp-Source: ADFU+vv/TKtKqKQaugxqBf2p0AnT6IIfxkvar691odeHNmOBVevRXicl+XRMs58xgopTmvm9zwCsbz8=
X-Received: by 2002:a1f:ac91:: with SMTP id v139mr3772908vke.91.1585166123439;
 Wed, 25 Mar 2020 12:55:23 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:55:21 -0700
Message-Id: <20200325195521.112210-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [PATCH bpf-next v3] libbpf: don't allocate 16M for log buffer by default
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each prog/btf load we allocate and free 16 megs of verifier buffer.
On production systems it doesn't really make sense because the
programs/btf have gone through extensive testing and (mostly) guaranteed
to successfully load.

Let's assume successful case by default and skip buffer allocation
on the first try. If there is an error, start with BPF_LOG_BUF_SIZE
and double it on each ENOSPC iteration.

v3:
* Return -ENOMEM when can't allocate log buffer (Andrii Nakryiko)

v2:
* Don't allocate the buffer at all on the first try (Andrii Nakryiko)

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c    | 20 +++++++++++++++-----
 tools/lib/bpf/libbpf.c | 22 ++++++++++++++--------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3d1c25fc97ae..bfef3d606b54 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -657,22 +657,32 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
 
 int btf__load(struct btf *btf)
 {
-	__u32 log_buf_size = BPF_LOG_BUF_SIZE;
+	__u32 log_buf_size = 0;
 	char *log_buf = NULL;
 	int err = 0;
 
 	if (btf->fd >= 0)
 		return -EEXIST;
 
-	log_buf = malloc(log_buf_size);
-	if (!log_buf)
-		return -ENOMEM;
+retry_load:
+	if (log_buf_size) {
+		log_buf = malloc(log_buf_size);
+		if (!log_buf)
+			return -ENOMEM;
 
-	*log_buf = 0;
+		*log_buf = 0;
+	}
 
 	btf->fd = bpf_load_btf(btf->data, btf->data_size,
 			       log_buf, log_buf_size, false);
 	if (btf->fd < 0) {
+		if (!log_buf || errno == ENOSPC) {
+			log_buf_size = max((__u32)BPF_LOG_BUF_SIZE,
+					   log_buf_size << 1);
+			free(log_buf);
+			goto retry_load;
+		}
+
 		err = -errno;
 		pr_warn("Error loading BTF: %s(%d)\n", strerror(errno), errno);
 		if (*log_buf)
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 085e41f9b68e..00570d8bd388 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4855,8 +4855,8 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 {
 	struct bpf_load_program_attr load_attr;
 	char *cp, errmsg[STRERR_BUFSIZE];
-	int log_buf_size = BPF_LOG_BUF_SIZE;
-	char *log_buf;
+	size_t log_buf_size = 0;
+	char *log_buf = NULL;
 	int btf_fd, ret;
 
 	if (!insns || !insns_cnt)
@@ -4896,22 +4896,28 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.prog_flags = prog->prog_flags;
 
 retry_load:
-	log_buf = malloc(log_buf_size);
-	if (!log_buf)
-		pr_warn("Alloc log buffer for bpf loader error, continue without log\n");
+	if (log_buf_size) {
+		log_buf = malloc(log_buf_size);
+		if (!log_buf)
+			return -ENOMEM;
+
+		*log_buf = 0;
+	}
 
 	ret = bpf_load_program_xattr(&load_attr, log_buf, log_buf_size);
 
 	if (ret >= 0) {
-		if (load_attr.log_level)
+		if (log_buf && load_attr.log_level)
 			pr_debug("verifier log:\n%s", log_buf);
 		*pfd = ret;
 		ret = 0;
 		goto out;
 	}
 
-	if (errno == ENOSPC) {
-		log_buf_size <<= 1;
+	if (!log_buf || errno == ENOSPC) {
+		log_buf_size = max((size_t)BPF_LOG_BUF_SIZE,
+				   log_buf_size << 1);
+
 		free(log_buf);
 		goto retry_load;
 	}
-- 
2.25.1.696.g5e7596f4ac-goog

