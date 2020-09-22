Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FC8274849
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgIVSiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:38:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726739AbgIVSiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NdxbpRK4UavAF30o40PwXgFNwMxEUuR9It+bYNln7c=;
        b=QbWOs1KZRS8msznhsKoL6rX8JynwmVoSnRzFj94hIavHXyS9Arw75y+Ch9hVo7PeKzVUHc
        0E4UaBdhFPnDiEYMG9IEjvUYBX/1kyRq2wG0thyQ8ayeueFu9pwAEE8uGFtw8ICnrUGVNX
        dgvOCb/pQ3XYlacv/cLSakdiORG3zZU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-R82gxFALOAm2KC_aDG_saA-1; Tue, 22 Sep 2020 14:38:48 -0400
X-MC-Unique: R82gxFALOAm2KC_aDG_saA-1
Received: by mail-pf1-f198.google.com with SMTP id m13so12038406pfk.19
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 11:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8NdxbpRK4UavAF30o40PwXgFNwMxEUuR9It+bYNln7c=;
        b=dDpKyDE2c0OKcx6GlNGDRPd7ZASClEIpUAV69F+S5K24KNqNdcGqlaQspeYlB+l2kB
         A1xf3HidZenbBQ9fMdcP/XKU7ZPnvaLVqZ/E/czCtfIYzZ92MZ5MoqvHbA3Kn7gTDHE6
         z7IX5sy4PrKOwi5EbPokZzofQLmDVdKl1Sx9JXhoHzBMdGcXAEMs+d62GW/IxpLhZcoF
         q261zDgkejhrHBAyQWl9sE3X0vGSrhXMvhXP69PN5aQ2VRzGxiBAUlmshsCEV/gmF/tg
         tgUEcHZlTM8lWyL/DmimaRItaLjX/XCBzC6LWiMbFx0JwBg1xsHie1TAFfo2NZrwO9ja
         mbfA==
X-Gm-Message-State: AOAM531UCtRNA/Vd9fWZ5Ilo8dC2dYPR9/z4pYG4k5bKqrh1Y+k9qSXb
        fyJXUR50pnizv4LjbkOa6s5c8hjNlLd0Lti51uVRwif1O3P+Q2lXpZ4dUqpox5GeN43rQpKZeyC
        P+Ltke2S2XAqR4aL7
X-Received: by 2002:a17:902:d202:b029:d2:2a0b:946b with SMTP id t2-20020a170902d202b02900d22a0b946bmr6168334ply.32.1600799926135;
        Tue, 22 Sep 2020 11:38:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+zKRpJst7lZzObVbvv9OWwuB2pHoJ4nEC2IfKox8Hzwx9+kSEQ14r+1+QHn0psghPYu7kIA==
X-Received: by 2002:a17:902:d202:b029:d2:2a0b:946b with SMTP id t2-20020a170902d202b02900d22a0b946bmr6168316ply.32.1600799925781;
        Tue, 22 Sep 2020 11:38:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b11sm15549426pfo.15.2020.09.22.11.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:38:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 46DA7183A8F; Tue, 22 Sep 2020 20:38:40 +0200 (CEST)
Subject: [PATCH bpf-next v8 06/11] bpf: Fix context type resolving for
 extension programs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 22 Sep 2020 20:38:40 +0200
Message-ID: <160079992022.8301.16531963814960393361.stgit@toke.dk>
In-Reply-To: <160079991372.8301.10648588027560707258.stgit@toke.dk>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

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

This version of the patch is tweaked slightly from Jiri's original one,
since the refactoring in the previous patches means we have to get the
target prog type from the new variable in prog->aux instead of directly
from the target prog.

Reported-by: Eelco Chaudron <echaudro@redhat.com>
Suggested-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/btf.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 76cc6ae46821..93cb8bfebe3b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3860,7 +3860,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 	info->reg_type = PTR_TO_BTF_ID;
 	if (tgt_prog) {
-		ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
+		enum bpf_prog_type tgt_type;
+
+		if (tgt_prog->type == BPF_PROG_TYPE_EXT)
+			tgt_type = tgt_prog->aux->tgt_prog_type;
+		else
+			tgt_type = tgt_prog->type;
+
+		ret = btf_translate_to_vmlinux(log, btf, t, tgt_type, arg);
 		if (ret > 0) {
 			info->btf_id = ret;
 			return true;

