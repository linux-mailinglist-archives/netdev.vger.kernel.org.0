Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F382630DA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbgIIPqf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Sep 2020 11:46:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730462AbgIIPqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:46:18 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-GlHbXRhlPymod5mQwk-Pig-1; Wed, 09 Sep 2020 11:11:26 -0400
X-MC-Unique: GlHbXRhlPymod5mQwk-Pig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6D84801AE8;
        Wed,  9 Sep 2020 15:11:24 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57AA9100238E;
        Wed,  9 Sep 2020 15:11:16 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next 1/2] bpf: Fix context type resolving for extension programs
Date:   Wed,  9 Sep 2020 17:11:14 +0200
Message-Id: <20200909151115.1559418-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0.0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco reported we can't properly access arguments if the tracing
program is attached to extension program.

Having following program:

  SEC("classifier/test_pkt_md_access")
  int test_pkt_md_access(struct __sk_buff *skb)

with its extension:

  SEC("freplace/test_pkt_md_access")
  int test_pkt_md_access_new(struct __sk_buff *skb)

and tracing that extension with:

  SEC("fentry/test_pkt_md_access_new")
  int BPF_PROG(fentry, struct sk_buff *skb)

It's not possible to access skb argument in the fentry program,
with following error from verifier:

  ; int BPF_PROG(fentry, struct sk_buff *skb)
  0: (79) r1 = *(u64 *)(r1 +0)
  invalid bpf_context access off=0 size=8

The problem is that btf_ctx_access gets the context type for the
traced program, which is in this case the extension.

But when we trace extension program, we want to get the context
type of the program that the extension is attached to, so we can
access the argument properly in the trace program.

Reported-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f9ac6935ab3c..37ad01c32e5a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3859,6 +3859,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	}
 
 	info->reg_type = PTR_TO_BTF_ID;
+
+	/* When we trace extension program, we want to get the context
+	 * type of the program that the extension is attached to, so
+	 * we can access the argument properly in the trace program.
+	 */
+	if (tgt_prog && tgt_prog->type == BPF_PROG_TYPE_EXT)
+		tgt_prog = tgt_prog->aux->linked_prog;
+
 	if (tgt_prog) {
 		ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
 		if (ret > 0) {
-- 
2.26.2

