Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0974D528CE1
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344772AbiEPS1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344775AbiEPS13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:27:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C65AA3DA7F
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652725648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=q+4QwzbSZp2bNTgsjIzHj4mmv53hcboZAM1lkwTA8ZE=;
        b=R6dc4foiL2HRCaQcruuinWcore6sPmhc3CqSeTOoVenEfKB5//GLuTG5Wc35wb6VGbgKel
        zD+vOjg8trWjiOJwThX9piz745XyTvj2OyJOHhkuClWBlU7Nx+aK5WxWGFJiXSH3LZOHev
        PMocfQD4+QMbKw9NpDe/Rj3pdgBwVH0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-pC3RWEnNNa2uYIEl3ffSbA-1; Mon, 16 May 2022 14:27:26 -0400
X-MC-Unique: pC3RWEnNNa2uYIEl3ffSbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E97918C5ABD;
        Mon, 16 May 2022 18:27:15 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C163C27EBB;
        Mon, 16 May 2022 18:27:11 +0000 (UTC)
Date:   Mon, 16 May 2022 20:27:08 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 1/4] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <20220516182708.GA29437@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check that size would not overflow before calculation (and return
-EOVERFLOW if it will), to prevent potential out-of-bounds write
with the following copy_from_user.  Add the same check
to kprobe_multi_resolve_syms in case it will be called from elsewhere
in the future.

Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 kernel/trace/bpf_trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d8553f4..e90c4ce7 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2358,6 +2358,8 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
 	unsigned int i;
 	char *func;
 
+	if (check_mul_overflow(cnt, sizeof(*syms), &size))
+		return -EOVERFLOW;
 	size = cnt * sizeof(*syms);
 	syms = kvzalloc(size, GFP_KERNEL);
 	if (!syms)
@@ -2429,6 +2431,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!cnt)
 		return -EINVAL;
 
+	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
+		return -EOVERFLOW;
 	size = cnt * sizeof(*addrs);
 	addrs = kvmalloc(size, GFP_KERNEL);
 	if (!addrs)
-- 
2.1.4

