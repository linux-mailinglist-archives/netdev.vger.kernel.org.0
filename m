Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A696A522E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 05:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjB1ECL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 23:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjB1EBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 23:01:48 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A551DBA1;
        Mon, 27 Feb 2023 20:01:47 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id c10so4246343pfv.13;
        Mon, 27 Feb 2023 20:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qp4YHVt88a5XfD4HvsGKZcN8zUAMsrArvjmuKYbS6l8=;
        b=Itr/QewmIM560gmzYfRZ7c1WKHxiUHX+nTsmC4PxYfxlnJL32uF9JWx7a3CFRrPX9a
         SLsSuBwvLvb+gFmLMt/ZxL9RTFmTjRf4lY/HDodQLPyzeC/xro1BCLZZm+EpATleGyII
         sRYjvc2BC9hO/r4TTsoNTH7Z6DLl3bOZ6xbzofm1q25BI6ydN8i9qkiix3/C2Q5zLn/j
         6Wkw9P53W5kshSxha+DDMnSNq541jLxAnSbIXLSgqkMjl+2Ijz9J7F0YSrbcWjU0V2YQ
         Wt783shsTbdrAZpXxfLA+Rm04INHGTnKAdXxSKHoKFxHnnr9TwwuT5GV/6yEatOkWi3z
         63hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qp4YHVt88a5XfD4HvsGKZcN8zUAMsrArvjmuKYbS6l8=;
        b=0ykyzPkaQW2reO/HOa7EwpXPGAlLECjt0VL9i5W6LJYXdWucImRV8SHCkGufnJvbh3
         A1j3A2hzokeBSLG6P8UEZcjKjOCXFLGYFgsvXxE708zfeRUTRoDZ3J5cmAQAp2FYmyYt
         tuefJx1+1RdF5hSmzZNM4UwNMEyfWCw54TuuLXkipJRd4SqG2ILKEzXRC5JZRDWAHGRH
         PQcJj7Qvop5CdTz2I6NmqvAusmvFhRsSaJVUZvTEiIubWzuyB6/sMbhlwtzniR5eoOUB
         ujoH/irwCo1aCVWFIdUx5pXOFvLRZfE1L9zgNGeQSjTpFPqYMEAOyZAjfONc0w187+ee
         8XIQ==
X-Gm-Message-State: AO0yUKXSyfsHbRKuWaut8lY7ogeRKxkrYNqlijLFkDMuEgoXqIFPlI4E
        8e1gCX2WHlLXapCtr8hu99E=
X-Google-Smtp-Source: AK7set8UOmFG0AhjSqrrUB7u8GV8xDOa5pF9tyBCiapreA3GKmLYeRlFJQsQNdECesrX+VKRWzUqYA==
X-Received: by 2002:aa7:9e05:0:b0:5cd:81a7:4094 with SMTP id y5-20020aa79e05000000b005cd81a74094mr1235728pfq.5.1677556905724;
        Mon, 27 Feb 2023 20:01:45 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:6245])
        by smtp.gmail.com with ESMTPSA id x6-20020aa793a6000000b005e093020cabsm4843083pff.45.2023.02.27.20.01.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Feb 2023 20:01:45 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v3 bpf-next 5/5] selftests/bpf: Tweak cgroup kfunc test.
Date:   Mon, 27 Feb 2023 20:01:21 -0800
Message-Id: <20230228040121.94253-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Adjust cgroup kfunc test to dereference RCU protected cgroup pointer
as PTR_TRUSTED and pass into KF_TRUSTED_ARGS kfunc.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c | 2 +-
 tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
index 4ad7fe24966d..d5a53b5e708f 100644
--- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
+++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
@@ -205,7 +205,7 @@ int BPF_PROG(cgrp_kfunc_get_unreleased, struct cgroup *cgrp, const char *path)
 }
 
 SEC("tp_btf/cgroup_mkdir")
-__failure __msg("arg#0 is untrusted_ptr_or_null_ expected ptr_ or socket")
+__failure __msg("bpf_cgroup_release expects refcounted")
 int BPF_PROG(cgrp_kfunc_release_untrusted, struct cgroup *cgrp, const char *path)
 {
 	struct __cgrps_kfunc_map_value *v;
diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
index 42e13aebdd62..85becaa8573b 100644
--- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
+++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
@@ -61,7 +61,7 @@ int BPF_PROG(test_cgrp_acquire_leave_in_map, struct cgroup *cgrp, const char *pa
 SEC("tp_btf/cgroup_mkdir")
 int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
 {
-	struct cgroup *kptr;
+	struct cgroup *kptr, *cg;
 	struct __cgrps_kfunc_map_value *v;
 	long status;
 
@@ -80,6 +80,11 @@ int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
 		return 0;
 	}
 
+	kptr = v->cgrp;
+	cg = bpf_cgroup_ancestor(kptr, 1);
+	if (cg)	/* verifier only check */
+		bpf_cgroup_release(cg);
+
 	kptr = bpf_kptr_xchg(&v->cgrp, NULL);
 	if (!kptr) {
 		err = 3;
-- 
2.30.2

