Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DF9373C53
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 15:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhEEN0l convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 May 2021 09:26:41 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:28489 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231774AbhEEN0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 09:26:40 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-FAzjf175OqW2qSZ0s4nKyw-1; Wed, 05 May 2021 09:25:39 -0400
X-MC-Unique: FAzjf175OqW2qSZ0s4nKyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4978E91164;
        Wed,  5 May 2021 13:25:38 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E32FE5D703;
        Wed,  5 May 2021 13:25:35 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH] bpf: Forbid trampoline attach for functions with variable arguments
Date:   Wed,  5 May 2021 15:25:29 +0200
Message-Id: <20210505132529.401047-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't currently allow to attach functions with variable arguments.
The problem is that we should save all the registers for arguments,
which is probably doable, but if caller uses more than 6 arguments,
we need stack data, which will be wrong, because of the extra stack
frame we do in bpf trampoline, so we could crash.

Also currently there's malformed trampoline code generated for such
functions at the moment as described in:
  https://lore.kernel.org/bpf/20210429212834.82621-1-jolsa@kernel.org/

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0600ed325fa0..161511bb3e51 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5206,6 +5206,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 	m->ret_size = ret;
 
 	for (i = 0; i < nargs; i++) {
+		if (i == nargs - 1 && args[i].type == 0) {
+			bpf_log(log,
+				"The function %s with variable args is unsupported.\n",
+				tname);
+			return -EINVAL;
+
+		}
 		ret = __get_type_size(btf, args[i].type, &t);
 		if (ret < 0) {
 			bpf_log(log,
@@ -5213,6 +5220,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 				tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
 			return -EINVAL;
 		}
+		if (ret == 0) {
+			bpf_log(log,
+				"The function %s has malformed void argument.\n",
+				tname);
+			return -EINVAL;
+		}
 		m->arg_size[i] = ret;
 	}
 	m->nr_args = nargs;
-- 
2.30.2

