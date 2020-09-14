Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF3526918F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgINQbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbgINQNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600100013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KIRSjC4TU6Nemo+ZjQS/Vw28P2tbe5/t6vRROo8Kshk=;
        b=OA6nBLGatZd8uV/i2yyfyz4tPuwCoRSk0IZkjB3ubOlNYr3sRgvb2yozjkKtkdfxjezB2U
        sdRUzi4FZTD8zujPPPhTsUiV8FNCGC5+GkmZ5kCfsAvAnAdHcYGuGKWCgpAjdY/c/61pTe
        EtB+SYsFaKTwznzaZRjgq+9/AS9LVzs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-wSnjEZOPMiqhjme2EzwRMA-1; Mon, 14 Sep 2020 12:13:32 -0400
X-MC-Unique: wSnjEZOPMiqhjme2EzwRMA-1
Received: by mail-wm1-f70.google.com with SMTP id q205so1709094wme.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KIRSjC4TU6Nemo+ZjQS/Vw28P2tbe5/t6vRROo8Kshk=;
        b=ZN/bA/08q7itcLfxP0mvKshu0mMr1TFR4q/Wic1wrjUiGksBStojytS6xs7srVgidv
         EKztLL9yFR6nMPSz2JVZRNz39GhvCmh3aMBjDs1AoAMKPRTi9+eYdZVhy1OxXYXDLLNE
         6VM4wkH/Jt+PpgAuHkgrwWyapqsExqQPGkfjGA+B/3InQf3A2wxAeBVXDX9ypGDpW4Hc
         q48G4WDRln42+TKKI736y55F6goLvkuyrR9y3kEtpT951SLoilEsRm5fui0MQWFCe1Cm
         sPUvpA9E4uNAO/wPFNn64/aMOJIWg55WVDGU3ErF3oOnPZxMVZjDLfwBP8jh1+h+fGIy
         T9Rw==
X-Gm-Message-State: AOAM531LmGlLbpbj6vwCAEAe35UqxdsZrHTucyGNQP1h2YnLDceJmWZH
        l2Ef5FQCT2vflKmVlZmNrKxHNafSyirhYUkX14jWG/nUrkxlsTgTUWoc2jIHjQpHYFXr4gvx0xt
        Ug6gifooahv6SO7ho
X-Received: by 2002:a05:600c:230f:: with SMTP id 15mr135649wmo.186.1600100010613;
        Mon, 14 Sep 2020 09:13:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsLyvw0+rZnKrTQr3mhXbwl+qrAkBTO3UgsCwKeuhgTjF+f7ZNzvDn+bYHnniFDCGscZqQkw==
X-Received: by 2002:a05:600c:230f:: with SMTP id 15mr135617wmo.186.1600100010312;
        Mon, 14 Sep 2020 09:13:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v6sm21237616wrt.90.2020.09.14.09.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:13:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 568281829CB; Mon, 14 Sep 2020 18:13:28 +0200 (CEST)
Subject: [PATCH bpf-next v4 5/8] bpf: Fix context type resolving for extension
 programs
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
Date:   Mon, 14 Sep 2020 18:13:28 +0200
Message-ID: <160010000825.80898.12912186494003019860.stgit@toke.dk>
In-Reply-To: <160010000272.80898.13117015273092905112.stgit@toke.dk>
References: <160010000272.80898.13117015273092905112.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
index e10f13f8251c..1a48253ba168 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3863,7 +3863,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
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

