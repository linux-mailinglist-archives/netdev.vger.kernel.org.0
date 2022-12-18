Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26FE64FD4E
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiLRAnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiLRAnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:43:20 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB31BC99;
        Sat, 17 Dec 2022 16:43:20 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id n4so5821909plp.1;
        Sat, 17 Dec 2022 16:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FF+eD2XRIoYlmEr/X2g308YQEbkC1R5Phje24seUWA4=;
        b=KcAn0d7idQOqi6LHRK6UIf0FLN/bRAgSckzYdGogxkVjyTElzaUYSalimwM8D45eI/
         1xSJo0eC7sf8WHdz4zg8lhYVqP6IqFmDD2LeIOROYX9zAi02KpZyfcntGUcKhQ/lwcHR
         DKIcBIfWGBs4XBoVrnsEEgHdf81vxvpRhYqA/RBaLf9aDj2SdHN0aLOVdK75tbMromFQ
         QzytLmpMIxc7zJaCcs/BFcAa4Fss1jO50me243Of5RSBWi0fjKMNZpMDP1HuWTPhSwps
         zGchAMxQF6me7Pu93/UZNGDbD/oEEeO8u5NAECpaHJeAXlpT57qqfodpC8DhPc2YLDAB
         DFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FF+eD2XRIoYlmEr/X2g308YQEbkC1R5Phje24seUWA4=;
        b=WqmmiLJZL7M9tAzYhhu/MmrZM39Z+9Nu32f8K6SP2lMufYFUOPwE5soqUZzyn/qrt8
         8hgPvydIw48Hl2dH+P4WGeegSZRcv1QrU4QOY3Dfe6kS+HD6BkNYWlrHu2WQ57/yQb5p
         uQiur3CXDfqCb/l5B8RqxNQCdFTGJmQuoB9GEXe0+AaJTUDkNZ6CfGqORhXe+m3pDPIS
         kuGVnRiCL8MKBfRfCWIR6I2ZClKcZB0w0RduoWZkvOnQzUoSbBR3w6q3VhCEzRUHDkjN
         YNtuDrwT+EVY0i8jglyPbvBfR1AosnLLnAcxBlhJadLTFEipnVf2+NBjVbL2jOKZ5Zn4
         S3LQ==
X-Gm-Message-State: AFqh2kqO0nih23ZOhIHb71zpR9pagBJ4g8UVuXZrNCbyRLH4JaDOTZ7t
        9exoIaFDls7ADLJIprNeZA==
X-Google-Smtp-Source: AMrXdXsX7/+2ElWg7Q/+7NITnKYX5cKiDXbTcTVPD5mtdxjZf4iohSKtwKd0RcS16VdVyFBKEYIF5w==
X-Received: by 2002:a17:90b:3744:b0:219:89c2:b70b with SMTP id ne4-20020a17090b374400b0021989c2b70bmr4267106pjb.16.1671324199828;
        Sat, 17 Dec 2022 16:43:19 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id k10-20020a63ff0a000000b0047048c201e3sm3639458pgi.33.2022.12.17.16.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 16:43:19 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 3/3] samples/bpf: fix uninitialized warning with test_current_task_under_cgroup
Date:   Sun, 18 Dec 2022 09:43:07 +0900
Message-Id: <20221218004307.4872-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218004307.4872-1-danieltimlee@gmail.com>
References: <20221218004307.4872-1-danieltimlee@gmail.com>
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

