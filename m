Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC68279360
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgIYVZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:25:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729535AbgIYVZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:25:07 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=it5ErVQ9w78IEwPzrMsZouVB/NLpxKqq/aiTiBgHUus=;
        b=Zy6Uq+Sz4Id5GsjytSeCVKwnx4dlVvOsr7mkdu4lYqvOR/cuQOfjFtVIefXlD/nLlUsBRr
        KnK0PhVv5vIDDKfKhAv5b+o2Rk4gG8T3ES0+oTfqWUZmWDuyN5iUKf/VzwvlZZcnesew1G
        WHnbzuE4kNcLGKmP8YTv1dgrSJ3/mWg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-zM_UnrBTMVW5oFT1dnUVSw-1; Fri, 25 Sep 2020 17:25:04 -0400
X-MC-Unique: zM_UnrBTMVW5oFT1dnUVSw-1
Received: by mail-wm1-f72.google.com with SMTP id x6so135776wmi.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 14:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=it5ErVQ9w78IEwPzrMsZouVB/NLpxKqq/aiTiBgHUus=;
        b=PTmZBYxmlQH4xObt/sRdusrFxIInhqEgFX26gbi3tuXqf968o+es/oQX3mcNkLWYN9
         imZZp/cqesHT7ohxpaZJAFixCOrxw0E3yedWacGosz4iNJbDKadCS4kiiPR6px7tX6Ic
         t55eIPYIlc7cNAzlBjeLyKwXImrqHY/Bh4mMWqdFJN4yZ4kPzT54mV7ucuKq48AmAyEb
         VUCKmU1m0QYS4CU3xAjY7yCUexkwNOcQ+LdtiuMHhDs98bbBYS2GJfO3aP++sXec19i3
         k+Q6vKXy6LqweyhUSNGGSTWx07I+Lwip9OADtEBeMa/oqE8XJzkpCfspgJKH3iMersP9
         n2PA==
X-Gm-Message-State: AOAM530NqL83tfpiO8qc2RbDBHcBJnLTIJC7n0B/Cq8TLYC14Y278T/m
        egTC1cqUHAJ1RfFeRYCot9p8LsLyD0SbDnwKstHreUiJfO9fHvgTP4kx8F8LbFjzR3I2vd8s2bK
        Tn0M8rcnYap9xfXni
X-Received: by 2002:adf:a3d8:: with SMTP id m24mr6395135wrb.418.1601069103151;
        Fri, 25 Sep 2020 14:25:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPId+IZEsxZEWRovMUxoRBAzvDuFPYsRnMS78OlD1ckoyGcyrMSWRp0AJk3IQ3p0TdIrZ7Bg==
X-Received: by 2002:adf:a3d8:: with SMTP id m24mr6395109wrb.418.1601069102684;
        Fri, 25 Sep 2020 14:25:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m18sm289873wmg.32.2020.09.25.14.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:25:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B28A4183C5C; Fri, 25 Sep 2020 23:25:00 +0200 (CEST)
Subject: [PATCH bpf-next v9 01/11] bpf: disallow attaching modify_return
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
Date:   Fri, 25 Sep 2020 23:25:00 +0200
Message-ID: <160106910067.27725.5163435783598211744.stgit@toke.dk>
In-Reply-To: <160106909952.27725.8383447127582216829.stgit@toke.dk>
References: <160106909952.27725.8383447127582216829.stgit@toke.dk>
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/verifier.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 42dee5dcbc74..66b6714b3fd7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11470,6 +11470,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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

