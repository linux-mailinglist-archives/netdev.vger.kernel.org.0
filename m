Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6689DCEA7A
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbfJGRUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:20:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbfJGRUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 13:20:44 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F4E9C055673
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 17:20:43 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id g88so3711657lje.10
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 10:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tTxe0YBCAHRDq7AE78oRk+k8RYg6kbZEgrUi0UlHpcg=;
        b=HruCiLyQlWoWLmL4eFKbk09AC+c/9mBf4LKxF4gDX8/whplzyiXiuFfVJgaVmDlzXV
         zu2MJAH2fGf/dd5dArfN93iz8G3aJaFpc+dVzSDjqJf2G8ycShkonDZzi8QgR8xXC7c3
         fbzxVDku42c3WN4vw6bI83iuEuuOtc+KnFLWzXT7G0ab8ybyBQbhJ8Afr7aBuK+AjKUH
         Ptj4LkYRi1ArCoPMUqnjN7ZfFluX44IdoBXgkb9XYHNzFF3xQM7lR3Eqk/8HRsb5pldU
         E0E+zbUZD00uH7UwGjKMdRh39OFxTgdurw5AWfVmjEak6fDcEdFazmzcpQmh3ZDtXeMn
         lJVA==
X-Gm-Message-State: APjAAAWdXbackAp54K9PhvmMEYND1YfjX4txAQWaHDuy1pYZQDfy/iY1
        sf2+CG3lnlVrR19Kq1YuZ6B8Ugr2tz85XxHkcgEFyrXlpnajycnB23vbNCSMe6JD+H1r8ajtWJd
        1nK1Fn23m4adB1Uz5
X-Received: by 2002:a2e:8789:: with SMTP id n9mr19282005lji.52.1570468841938;
        Mon, 07 Oct 2019 10:20:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw4yuFLqw3buhtiSBBMrP4Eyd5VAt0ZbYU30A4FGLEUEgBxjAQKO7QI9S6+wmyEdzGHQNySGQ==
X-Received: by 2002:a2e:8789:: with SMTP id n9mr19281987lji.52.1570468841795;
        Mon, 07 Oct 2019 10:20:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 6sm2853116lfa.24.2019.10.07.10.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 10:20:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7761D180641; Mon,  7 Oct 2019 19:20:39 +0200 (CEST)
Subject: [PATCH bpf-next v3 4/5] libbpf: Add syscall wrappers for
 BPF_PROG_CHAIN_* commands
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 07 Oct 2019 19:20:39 +0200
Message-ID: <157046883940.2092443.14475136847242640757.stgit@alrua-x1>
In-Reply-To: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds simple syscall wrappers for the new BPF_PROG_CHAIN_* commands to
libbpf.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf.c      |   34 ++++++++++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h      |    4 ++++
 tools/lib/bpf/libbpf.map |    3 +++
 3 files changed, 41 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index cbb933532981..23246fa169e7 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -703,3 +703,37 @@ int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf, __u32 *buf_len,
 
 	return err;
 }
+
+int bpf_prog_chain_add(int prev_prog_fd, __u32 retcode, int next_prog_fd) {
+	union bpf_attr attr = {};
+
+	attr.prev_prog_fd = prev_prog_fd;
+	attr.next_prog_fd = next_prog_fd;
+	attr.retcode = retcode;
+
+	return sys_bpf(BPF_PROG_CHAIN_ADD, &attr, sizeof(attr));
+}
+
+int bpf_prog_chain_del(int prev_prog_fd, __u32 retcode) {
+	union bpf_attr attr = {};
+
+	attr.prev_prog_fd = prev_prog_fd;
+	attr.retcode = retcode;
+
+	return sys_bpf(BPF_PROG_CHAIN_DEL, &attr, sizeof(attr));
+}
+
+int bpf_prog_chain_get(int prev_prog_fd, __u32 retcode, __u32 *prog_id) {
+	union bpf_attr attr = {};
+	int err;
+
+	attr.prev_prog_fd = prev_prog_fd;
+	attr.retcode = retcode;
+
+	err = sys_bpf(BPF_PROG_CHAIN_GET, &attr, sizeof(attr));
+
+	if (!err)
+		*prog_id = attr.next_prog_id;
+
+	return err;
+}
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 0db01334740f..0300cb8c8bed 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -171,6 +171,10 @@ LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
 				 __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
 				 __u64 *probe_offset, __u64 *probe_addr);
 
+LIBBPF_API int bpf_prog_chain_add(int prev_prog_fd, __u32 retcode, int next_prog_fd);
+LIBBPF_API int bpf_prog_chain_del(int prev_prog_fd, __u32 retcode);
+LIBBPF_API int bpf_prog_chain_get(int prev_prog_fd, __u32 retcode, __u32 *prog_id);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 8d10ca03d78d..9c483c554054 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -192,4 +192,7 @@ LIBBPF_0.0.5 {
 } LIBBPF_0.0.4;
 
 LIBBPF_0.0.6 {
+		bpf_prog_chain_add;
+		bpf_prog_chain_del;
+		bpf_prog_chain_get;
 } LIBBPF_0.0.5;

