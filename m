Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3F526E69D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIQUUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:20:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbgIQUUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:20:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600374012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIGbpCZmz89BH4RaSE1d8nNgeBGwQPZU+jdCtpvbXO4=;
        b=cK8wGwIwO3/1v2FhspdUGfLIKGkvbKrBp+z2d9bUdDXfgX5Tfk6i3Rlpqznf5a/RDWPkXj
        ojR00d/2uG/0emU+MxZ8Gmb49guvmFgJ1JZsRQsRQQBUYp0yY4Vtv6zyT4CAcCxzDST1Zm
        83ItDSjaBf/EaiWv5JFrwHMjb6dG8Xw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-_khjAWMHNWqR2D9W5afuMQ-1; Thu, 17 Sep 2020 16:20:11 -0400
X-MC-Unique: _khjAWMHNWqR2D9W5afuMQ-1
Received: by mail-ej1-f71.google.com with SMTP id hh10so1328440ejb.13
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:20:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yIGbpCZmz89BH4RaSE1d8nNgeBGwQPZU+jdCtpvbXO4=;
        b=pUQ2By2ikBjt/Lb1WZyIJEvyvKzGZCR47DcoAovoJG+Zoafec7MtQz6sjQGCkbXkFv
         rR38mjOI6SxxZKJImsuGz1EnrXlvsYj5qxaGKnMRwPlnXirT3HtA3VNdFFTEz2unMSXi
         5JL1t95rg2iHwQHZRBLaTGiUkOl2ZYA9n4wBqvSKWJtUPzDtCOoWoHcsHQ3eEzfLOLh6
         yIWPffG8jJ2PLfQwThyohFftPq9YO1RVGygLxeQyS9mR1DBw1bVrvGehz0Pkd9uMW3ML
         3JqFFBR0y9fL8TBSWbo8YU3BSzKRznAK9NhX790foLRauOBTUstdy1XS/M3F1EUKl+lV
         HI2g==
X-Gm-Message-State: AOAM532ToEVmvfkIsQOPSuYxdgrLw64CutYPb9fT9dFZmcdigzU6qRU5
        KTTV445XHpKTS++Vp4rFscq9zqCogX7GYkV6tlTlUs4IIVFVUmzgUCTeFuxFctIb2pXSUILAeUe
        CnB5rLdeN36pz8q++
X-Received: by 2002:a17:906:c289:: with SMTP id r9mr33947322ejz.402.1600374009907;
        Thu, 17 Sep 2020 13:20:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDzp8PFMMUGx71+4Le3zZryehPDfyMnG9pPkDd4mXk5NQGPGcOHdA4dd2xmMSXBewgaGbQLw==
X-Received: by 2002:a17:906:c289:: with SMTP id r9mr33947301ejz.402.1600374009706;
        Thu, 17 Sep 2020 13:20:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id dt8sm551547ejc.113.2020.09.17.13.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 13:20:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2C7DE183A91; Thu, 17 Sep 2020 22:20:07 +0200 (CEST)
Subject: [PATCH bpf-next v6 06/10] bpf: Fix context type resolving for
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
Date:   Thu, 17 Sep 2020 22:20:07 +0200
Message-ID: <160037400712.28970.6100042329111941661.stgit@toke.dk>
In-Reply-To: <160037400056.28970.7647821897296177963.stgit@toke.dk>
References: <160037400056.28970.7647821897296177963.stgit@toke.dk>
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
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/btf.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9228af9917a8..55f7b2ba1cbd 100644
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

