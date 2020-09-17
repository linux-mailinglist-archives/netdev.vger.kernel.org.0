Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2161126E68D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIQUUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:20:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgIQUUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:20:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600374006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gXFdiZ0D++Zjq+NMowyYUeopSCqhgf8iuD44JlXgxWA=;
        b=A/uBSZvlk/QbMTo0aSlHNI3daz4gkg/fMLQgQkvItLHuJte2GnK2BpP7G1RpRV2CTFdzoE
        MNiD8qtf7lzgA1W7ikeout+WRWsmmrXd+OwfUYY5GJe0tUcZfo0i1fONZ+vp3PY9LIASjs
        gb9NhysvYIAKsww0N3O1G4MFpPrsHgs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-vRtrpFcwN46PBphUjNqbAA-1; Thu, 17 Sep 2020 16:20:04 -0400
X-MC-Unique: vRtrpFcwN46PBphUjNqbAA-1
Received: by mail-ej1-f69.google.com with SMTP id b17so1325695ejb.20
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gXFdiZ0D++Zjq+NMowyYUeopSCqhgf8iuD44JlXgxWA=;
        b=ZBrYOjbH8vbASZSAdoST3zLX9wsNQrDUduc1CSoryF3nXfISTknRSseUdCWi0Fgh+c
         fpZRfqldFv8W1i3Tu7/m+n7CzPQE9I8Q4sgISKtnfoJuXMTLxmzHn4N73B7+yj3ugd+/
         D5GtdsFevqRrCFm9r5I5RkQTFDbulSQ7Emlma4r8hGRDbO9B3rGCfifv9gl78sStzJM7
         8vpQhQSScQSbRbGiNHpcGpXxS+IMVvF2DCQQUoFZh8tSpbERr96LaRxq/8YnSMjGL70W
         /5WsTveOq/2J4GjzaumVSkFjXIPKwU0ea3o6qD0j9UQOLUNDv7meSY7e4vGTHb+0TBXl
         VUtg==
X-Gm-Message-State: AOAM532iHM+6kpSoqD9Viz8Mdm2Ocpwfi2+e/A7ZHW1cKFluF0XFviJy
        9pZOPsTf3vdz7rR8/tYW+1SU0KC7bY8IcowQoFi1pbQIKJj3Bx5Utf3IWVzfKxK13qJXnApRq/j
        p5qfhCrLq+FMxKXRy
X-Received: by 2002:a05:6402:1641:: with SMTP id s1mr36136296edx.66.1600374003133;
        Thu, 17 Sep 2020 13:20:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwQvGC5OLafIbbPZ7FS+bEgBCAbtMZY2r2gfcPqjh8xGhhyM5PAzIIMZgDYDF+CQoG7pCE5A==
X-Received: by 2002:a05:6402:1641:: with SMTP id s1mr36136269edx.66.1600374002678;
        Thu, 17 Sep 2020 13:20:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o6sm509313edh.40.2020.09.17.13.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 13:20:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C153B183A91; Thu, 17 Sep 2020 22:20:01 +0200 (CEST)
Subject: [PATCH bpf-next v6 01/10] bpf: disallow attaching modify_return
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
Date:   Thu, 17 Sep 2020 22:20:01 +0200
Message-ID: <160037400169.28970.10809160856427167110.stgit@toke.dk>
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
index 814bc6c1ad16..da9c828a43dc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11295,7 +11295,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 					prog->aux->attach_func_name);
 		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
 			ret = check_attach_modify_return(prog, addr);
-			if (ret)
+			if (ret || tgt_prog)
 				verbose(env, "%s() is not modifiable\n",
 					prog->aux->attach_func_name);
 		}

