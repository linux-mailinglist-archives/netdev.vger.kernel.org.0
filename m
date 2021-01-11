Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEC82F1ECB
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390639AbhAKTRy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 Jan 2021 14:17:54 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:23914 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730166AbhAKTRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:17:53 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-8KY-7vDsO1ieSVcclgu1aA-1; Mon, 11 Jan 2021 14:16:58 -0500
X-MC-Unique: 8KY-7vDsO1ieSVcclgu1aA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBA69107ACF7;
        Mon, 11 Jan 2021 19:16:56 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC205D9F4;
        Mon, 11 Jan 2021 19:16:51 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH] bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach
Date:   Mon, 11 Jan 2021 20:16:50 +0100
Message-Id: <20210111191650.1241578-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_tracing_prog_attach error path calls bpf_prog_put
on prog, which causes refcount underflow when it's called
from link_create function.

  link_create
    prog = bpf_prog_get              <-- get
    ...
    tracing_bpf_link_attach(prog..
      bpf_tracing_prog_attach(prog..
        out_put_prog:
          bpf_prog_put(prog);        <-- put

    if (ret < 0)
      bpf_prog_put(prog);            <-- put

Removing bpf_prog_put call from bpf_tracing_prog_attach
and making sure its callers call it instead.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/syscall.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c3bb03c8371f..e5999d86c76e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2712,7 +2712,6 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 out_put_prog:
 	if (tgt_prog_fd && tgt_prog)
 		bpf_prog_put(tgt_prog);
-	bpf_prog_put(prog);
 	return err;
 }
 
@@ -2825,7 +2824,10 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog, 0, 0);
+		err = bpf_tracing_prog_attach(prog, 0, 0);
+		if (err >= 0)
+			return err;
+		goto out_put_prog;
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
-- 
2.26.2

