Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5993A0495
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbhFHTl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbhFHTlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 15:41:11 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C892C061156;
        Tue,  8 Jun 2021 12:30:45 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id w14so11258991ilv.1;
        Tue, 08 Jun 2021 12:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mfH1UX8C5+kcSTDkXc72bX/N/gu9ql6SA6+vXMivO/w=;
        b=HkyAPlyktMCbzAyk2VZTLUAFjP+Snr6IZra0iQPMUFKI9KSfB3bV/nHTvDjpFkBZH/
         6HczMKxpviei57dDW2TKEIlK+ZRdK1lYnihz/tLC/trEsajFTcnpMgNm3rsbtBf48nDh
         yKQFdCgE9+GniwrUBLR6x3+64xtqmSAQcS4z2wUM5B9SAvU9RfWGsu01Tehe0GdSVjZw
         ctFFLgh2KK/aiFf3cW3lYrHGRVYLg+8CziqOwu4aqZzT1RKXGiX1cLTJsusW9svTeMK4
         l2Ij6u8jmbIYgkqUzJi9zbBr82Oimx+TIrN4OMMBu+NNMxc7+0bZQJAAOVVCXD5GTr5c
         BPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mfH1UX8C5+kcSTDkXc72bX/N/gu9ql6SA6+vXMivO/w=;
        b=a2ds4uUSEsTu9Y4hToE8bu+VCB23GHI8AntbqnFarl7d7+X+oZGnA6CQEBlkM8cB6E
         cop2hEWTLvEQv4Lh6Eu4eFnxfJIvDXaZ3XfnVG7LHd4UIkna6XsyShh+DBen2JhqWJEG
         4SYHH+hVbWByq0HJGfUVd2Wzh/qf2akrlXhDiqaazbsSVHdLvTJzkPVWE0PQujGlZkgg
         X0D45Zk4o5nbZ43AOC6+0HqvNWgG27Fh6a3CxrDyPI/I1toUXKeYhqBXuC7lWYYwO8JS
         sR8eoOWBzWlPviansIwKCyNW7auRVS9ZFsMlrwpN6TfMfqiV2jtxxa84fIQJNKvZXPnT
         solw==
X-Gm-Message-State: AOAM530Qp4fD0rhb3ExOi7furnuTr2DInfWkE+5ujJCFYS7MHsS69Se6
        zK309glngoFwc91+oNQfiB0=
X-Google-Smtp-Source: ABdhPJyGfiffRj8Igu6XoH+AerY0dm06DNsar7wcF97f9/YR8/oAwx521NsERdWXNC0a7e/2DZa9PQ==
X-Received: by 2002:a05:6e02:1d1a:: with SMTP id i26mr21564716ila.180.1623180644884;
        Tue, 08 Jun 2021 12:30:44 -0700 (PDT)
Received: from [127.0.1.1] ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n33sm311500ioz.51.2021.06.08.12.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 12:30:44 -0700 (PDT)
Subject: [PATCH bpf 2/2] bpf: selftest to verify mixing bpf2bpf calls and
 tailcalls with insn patch
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Date:   Tue, 08 Jun 2021 12:30:33 -0700
Message-ID: <162318063321.323820.18256758193426055338.stgit@john-XPS-13-9370>
In-Reply-To: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some extra noise to the tailcall_bpf2bpf4 tests that will cause
verifier to patch insns. This then moves around subprog start/end insn
index and poke descriptor insn index to ensure that verify and JIT will
continue to track these correctly.

Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
index 9a1b166b7fbe..0d70de5f97e2 100644
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
@@ -2,6 +2,13 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} nop_table SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
 	__uint(max_entries, 3);
@@ -11,9 +18,19 @@ struct {
 
 static volatile int count;
 
+__noinline
+int subprog_noise(struct __sk_buff *skb)
+{
+	__u32 key = 0;
+
+	bpf_map_lookup_elem(&nop_table, &key);
+	return 0;
+}
+
 __noinline
 int subprog_tail_2(struct __sk_buff *skb)
 {
+	subprog_noise(skb);
 	bpf_tail_call_static(skb, &jmp_table, 2);
 	return skb->len * 3;
 }


