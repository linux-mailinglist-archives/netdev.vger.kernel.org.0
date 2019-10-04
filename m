Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7C8CC19D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbfJDRWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:22:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388399AbfJDRWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 13:22:48 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0438879705
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 17:22:48 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id m2so4463136eds.12
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 10:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tTxe0YBCAHRDq7AE78oRk+k8RYg6kbZEgrUi0UlHpcg=;
        b=M1JwMPIUYDqSxAJZCkZK57AWiVumSZcxry7+RyrHxFhTkkFsgdy9/1h3qdyczEyPvn
         vzAu+xuNpK26i5b2MCKfgEeiF4JbEizAwhZ9H5H0tsooFlyRu7fPieaKVlka28aI6aRk
         6zrKWZ1WZlvvgu/9D6+TduTaebLfYnQqflwB2vdzkBUvftIMVtBrLUMNxMIb4gLbMDu0
         K4th/FzlWF+yToDMRXhLODz2pV43Z4GSQFmhC3GCPri5UL9emWkx/LpwO5jvXwYE2XIU
         emCrgJJlCnMgzAAbKuZ1w0eKCiyS9a2y0XmpVBGDafDC/sp9gpwhdusJsj6EK7BxhjRd
         hysw==
X-Gm-Message-State: APjAAAUPYWOmoFdsDk3WPcl9veWsPiT0bznkEwZCFNqcNnH0qrEBcrQ/
        pMvQ2YUDK6rE9/gcj0UTwcq7PXXgKarfvgfHSJP1fXyFBGRj8q2ymoNw/BH8Ism9+XA+5UaL3LJ
        fhptaEWQWwy7+48A4
X-Received: by 2002:a50:ab49:: with SMTP id t9mr16318396edc.301.1570209766791;
        Fri, 04 Oct 2019 10:22:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxTG4xScnLuFvaWNICxY54vUw9ElSy9/9Dni61Yni9KpZNA51yexs52Jee0AefO5rIiQz707g==
X-Received: by 2002:a50:ab49:: with SMTP id t9mr16318371edc.301.1570209766539;
        Fri, 04 Oct 2019 10:22:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id 30sm1246974edr.78.2019.10.04.10.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 10:22:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DB61918063D; Fri,  4 Oct 2019 19:22:44 +0200 (CEST)
Subject: [PATCH bpf-next v2 4/5] libbpf: Add syscall wrappers for
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
Date:   Fri, 04 Oct 2019 19:22:44 +0200
Message-ID: <157020976478.1824887.2460017336894785970.stgit@alrua-x1>
In-Reply-To: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
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

