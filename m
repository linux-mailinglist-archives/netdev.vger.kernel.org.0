Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC3264FDE9
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 07:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiLRGPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 01:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiLRGPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 01:15:05 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6A7BF71;
        Sat, 17 Dec 2022 22:15:05 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so6183037pjd.0;
        Sat, 17 Dec 2022 22:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FF+eD2XRIoYlmEr/X2g308YQEbkC1R5Phje24seUWA4=;
        b=PQEO2/1uhh6i08hKQvNfTP/NunUTqn3rFJ2l0MNz976k4+qzK6TfGYPgTP3nMsJ/Tt
         VwKMbWyulMYUwjvuguuOUfXzmF13j4UKcFOrOrD764mkt6xOMgk5Pv0VkTG9J8GnDbkh
         R2KLaGlqibCs8QYO5nMEhIfhmpnQx4YV61n5LVg6jr7PkzPR393Lv3ARr6hmidj9a54D
         oXcDHNXhucZPMZRu4Xt9ayPdsBERap4UUKGyKg+CnoqCAAmOdDir+VPGc3iBFoEaK5Bf
         UF3T+nFIpe+vbOumWOfA2ljZh7Xlgy8g5g8jyp6zwblsEO7a7e8nk1pMvfUfvSwhlFYP
         X4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FF+eD2XRIoYlmEr/X2g308YQEbkC1R5Phje24seUWA4=;
        b=ZoaM9GU+IJ6QktVam1Gt81kJt+7Y2+jFDZTjlDfNBN/lEshCRPI54LIt9KalpeYSsO
         BkUZCr9OQ0ioJgphED497deKVi9heM25hcEXL0x88S5cLI/XQuPC6VW0mcK6EPtUwrXU
         Pp/PrdY4gr97piKG/1u0b07600jmGbwwKphDsdvV+iB0nkX0zsqPPo5sGQBL2iqIbxV+
         gD1kBpF/b1STLbNmusamOfqIGLOOlowL4oE/KlJCHAm2CvuhfWX8SmQrkgXq2bwFBQSj
         kl+vQaW1UahZYjnqqEwZHCK+uYN1tykq2/YDFUsNb+HAmAR5kFEf4RTA1xEbdRFlj+D+
         i9uA==
X-Gm-Message-State: AFqh2kqTEgxrxbA7XfESm5wkn50fXFxCtXsEVIfRfgL/wZvOZKvLMEHc
        I+ulvPhnEw+Gi6K+pib667ScYuykI+ZE
X-Google-Smtp-Source: AMrXdXuXmfFVcnOzF/KKbpFxJm+QHUWfcY1jnogksHkFvMfgaFfEabm2sDh1ZsjSrGRsNDw/9slu5Q==
X-Received: by 2002:a17:90a:c690:b0:21a:2d8:bf98 with SMTP id n16-20020a17090ac69000b0021a02d8bf98mr4563952pjt.10.1671344104559;
        Sat, 17 Dec 2022 22:15:04 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id r21-20020a17090b051500b00219eefe47c7sm3721836pjz.47.2022.12.17.22.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 22:15:04 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v4 3/3] samples/bpf: fix uninitialized warning with test_current_task_under_cgroup
Date:   Sun, 18 Dec 2022 15:14:53 +0900
Message-Id: <20221218061453.6287-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218061453.6287-1-danieltimlee@gmail.com>
References: <20221218061453.6287-1-danieltimlee@gmail.com>
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

Currently, compiling samples/bpf with LLVM warns about the uninitialized
use of variable with test_current_task_under_cgroup.

    ./samples/bpf/test_current_task_under_cgroup_user.c:57:6:
    warning: variable 'cg2' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
	    if (setup_cgroup_environment())
		^~~~~~~~~~~~~~~~~~~~~~~~~~
    ./samples/bpf/test_current_task_under_cgroup_user.c:106:8:
    note: uninitialized use occurs here
	    close(cg2);
		  ^~~
    ./samples/bpf/test_current_task_under_cgroup_user.c:57:2:
    note: remove the 'if' if its condition is always false
	    if (setup_cgroup_environment())
	    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./samples/bpf/test_current_task_under_cgroup_user.c:19:9:
    note: initialize the variable 'cg2' to silence this warning
	    int cg2, idx = 0, rc = 1;
		   ^
		    = 0
    1 warning generated.

This commit resolve this compiler warning by pre-initialize the variable
with error for safeguard.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 samples/bpf/test_current_task_under_cgroup_user.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/test_current_task_under_cgroup_user.c b/samples/bpf/test_current_task_under_cgroup_user.c
index ac251a417f45..6fb25906835e 100644
--- a/samples/bpf/test_current_task_under_cgroup_user.c
+++ b/samples/bpf/test_current_task_under_cgroup_user.c
@@ -14,9 +14,9 @@
 int main(int argc, char **argv)
 {
 	pid_t remote_pid, local_pid = getpid();
+	int cg2 = -1, idx = 0, rc = 1;
 	struct bpf_link *link = NULL;
 	struct bpf_program *prog;
-	int cg2, idx = 0, rc = 1;
 	struct bpf_object *obj;
 	char filename[256];
 	int map_fd[2];
@@ -103,7 +103,9 @@ int main(int argc, char **argv)
 	rc = 0;
 
 err:
-	close(cg2);
+	if (cg2 != -1)
+		close(cg2);
+
 	cleanup_cgroup_environment();
 
 cleanup:
-- 
2.34.1

