Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4615C270DB7
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 13:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgISLtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 07:49:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55615 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726157AbgISLtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 07:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600516190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ip21qnHHS16Z3f+mJxexKMv0xWUpMEM596sNCwhn4Qs=;
        b=GCywwUy+FDRqD+MDfGWPGFnu7V26IUoBZtj/NoVSxNOaXhOmbSGDOt1GeTYw4fGa9gM0f/
        EYpibiUTIUe2PqeDJMmr9mpHsae5qCDvMjM4oFM9MX6eZYwhiOfJxxBPhM25QEw8iJ5lbf
        z68wYPPGsrMunTdaoEdg3XkInfsYcV0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-5p38BD4IPbm0mouJWfybRw-1; Sat, 19 Sep 2020 07:49:48 -0400
X-MC-Unique: 5p38BD4IPbm0mouJWfybRw-1
Received: by mail-ed1-f69.google.com with SMTP id i23so3269998edr.14
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 04:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ip21qnHHS16Z3f+mJxexKMv0xWUpMEM596sNCwhn4Qs=;
        b=pX1kuB33s/PLv3JkZ8YA+eEtSYWkE3kvyJANbSKAk4zYg9ZBnjDqfERQmTNJLAQN1x
         MG+jYMUaiSQFzeTDI+KRzF/xZ+GJY+ofyuYFqmIrPv6rHpvTEC217YvmNZAf25V52d9r
         Jy1koSt5gWI9JFX/xfjbXiTKoFswAXQ8QBKQFiR5Lu4hWL67qXKTvT2KW+Nll9Dr6R27
         LriPn9fQvcmNl45nVgZIKtnRyU16sYcIn+J7RiuqbEVFIt1DyWFFvaxMMk89Km50srQ8
         42lDEdCFllg4aVcs6EjECXWrpEvFAyJ6YSyhmYDrfbeJpkdzOu5iHXkP9pHWMcDh7vGw
         jMbw==
X-Gm-Message-State: AOAM531OyBtCTAkI5DHTeX+b5ZIp3g2ImkLZxhfEGpsDRDaU5mAiUg4n
        0VDrhfTcM+4s1uS21nhI9Eu6+NGePvEajKpi6DVEgvqXZNrfWjTXUIBZtgCUjnhIScRuefS8LM+
        Dp4cFwf3AEZSeDyFT
X-Received: by 2002:a50:fe07:: with SMTP id f7mr45183643edt.173.1600516186649;
        Sat, 19 Sep 2020 04:49:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3Ujzxo+bmJuNBBCiVLNMDrlem1ZDBFJhLSOaS7snoBtysOe+HYC+esH2+6DLSIdwOx1GMpA==
X-Received: by 2002:a50:fe07:: with SMTP id f7mr45183618edt.173.1600516186248;
        Sat, 19 Sep 2020 04:49:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a15sm4233428eje.16.2020.09.19.04.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 04:49:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 14D30183A91; Sat, 19 Sep 2020 13:49:44 +0200 (CEST)
Subject: [PATCH bpf-next v7 01/10] bpf: disallow attaching modify_return
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
Date:   Sat, 19 Sep 2020 13:49:44 +0200
Message-ID: <160051618391.58048.12525358750568883938.stgit@toke.dk>
In-Reply-To: <160051618267.58048.2336966160671014012.stgit@toke.dk>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
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
 kernel/bpf/verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4161b6c406bc..cb1b0f9fd770 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11442,7 +11442,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 					prog->aux->attach_func_name);
 		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
 			ret = check_attach_modify_return(prog, addr);
-			if (ret)
+			if (ret || tgt_prog)
 				verbose(env, "%s() is not modifiable\n",
 					prog->aux->attach_func_name);
 		}

