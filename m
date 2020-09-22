Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F31274844
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgIVSir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:38:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgIVSiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pKOJqVkCN/RDCAG/fTLRlqx8WKM+s9hALBC3BDKVQU0=;
        b=cKMPJq67OGnuPi6m1nrsVgcfYl3sB7b2UAUzPly+wISjjWE5L2HX9bKv93JH+zSZZI9hS1
        ejnhGGlk2SlZMAY505xsbTsCZeSoY2lOBdhv18aO8VeRM3lQKN6cPoKVXRsZgaADLBTFae
        OMM5ZRFG6DmUhkiwPFgMxWyeP30Oj6I=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-tXpPUkpPPza20aUDMscuyQ-1; Tue, 22 Sep 2020 14:38:42 -0400
X-MC-Unique: tXpPUkpPPza20aUDMscuyQ-1
Received: by mail-pg1-f199.google.com with SMTP id r2so11214061pga.12
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 11:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pKOJqVkCN/RDCAG/fTLRlqx8WKM+s9hALBC3BDKVQU0=;
        b=HsNNZkiJtmzTWY5Q3JNnO0AYsto0N/0sY372VMgZOuGObUFAFgbdBKOjG+bGKJAx7G
         T2VwkGh1JBHZraUNn7XwwliXUB84h/X7sq+FsrbxhZqXBtsm4yZFQ+Uc7v2ItzeywUoa
         fi/ROChQKwlGQ48f2BKHGpTwgcflDTNgIbr8miSqsN8c/+WZvAQ5evErS5fngRhs6eDO
         NHsreO6MhBRodwZtd9HGPkT1OKsRHkrHqflzz5y/cU3cEbtEkWFVKTJL0xcoMirrCci+
         G5QkOpZ3V/7aIjixUfx5z+3MEvLyQ0TsjUlCul10cvZBnNEuFYlFQvd17ikUfD14XEfS
         6QEg==
X-Gm-Message-State: AOAM532+UJE0X8qUQAcjsxRnupo2NrMD0mwImIkP1MmYVxd20o1ATqd5
        nYH1JqbRAZqbxICn8qsBeE96oFslBDqODA20I44kElJabHteyNhkwQXBiPGAirluAEiHNX/6zU0
        4By7Gszqi4QmPLgfF
X-Received: by 2002:a17:90b:20d1:: with SMTP id ju17mr4575537pjb.134.1600799920897;
        Tue, 22 Sep 2020 11:38:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCZeuWwb93bPgoVTUUnceQtdJ+M6ksucVYQzdqoLFUlO3fKUXW3k3fqDp79XwLminT/RTtmQ==
X-Received: by 2002:a17:90b:20d1:: with SMTP id ju17mr4575511pjb.134.1600799920545;
        Tue, 22 Sep 2020 11:38:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e1sm16768206pfl.162.2020.09.22.11.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:38:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E46C5183A90; Tue, 22 Sep 2020 20:38:34 +0200 (CEST)
Subject: [PATCH bpf-next v8 01/11] bpf: disallow attaching modify_return
 tracing functions to other BPF programs
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
Date:   Tue, 22 Sep 2020 20:38:34 +0200
Message-ID: <160079991486.8301.10483022567832542496.stgit@toke.dk>
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

From the checks and commit messages for modify_return, it seems it was
never the intention that it should be possible to attach a tracing program
with expected_attach_type == BPF_MODIFY_RETURN to another BPF program.
However, check_attach_modify_return() will only look at the function name,
so if the target function starts with "security_", the attach will be
allowed even for bpf2bpf attachment.

Fix this oversight by also blocking the modification if a target program is
supplied.

Fixes: 18644cec714a ("bpf: Fix use-after-free in fmod_ret check")
Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/verifier.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 15ab889b0a3f..797e2b0d8bc2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11471,6 +11471,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				verbose(env, "%s is not sleepable\n",
 					prog->aux->attach_func_name);
 		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
+			if (tgt_prog) {
+				verbose(env, "can't modify return codes of BPF programs\n");
+				ret = -EINVAL;
+				goto out;
+			}
 			ret = check_attach_modify_return(prog, addr);
 			if (ret)
 				verbose(env, "%s() is not modifiable\n",

