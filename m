Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7B64FD2E
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiLRAIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiLRAIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:08:07 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B8EFAE4;
        Sat, 17 Dec 2022 16:08:05 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id a9so5745728pld.7;
        Sat, 17 Dec 2022 16:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OnAU/FC5uHJjclWRokeb4prP8VtXKwpPQow8jIA2gqk=;
        b=GeutwiTKyu8xwmjY1Vpq75p6UYm3jHTNyWmpECiwvU7zCHEn6Tk3/4K3rGSydyTQqu
         7bAPZBDD3MI5oaDFKdq9wltvzi7fVvE+rtSWEBVymk6nmpFI5fdjP7rMiet7Z0XZHgb0
         XDL0OhQcGzaiAeWzRv6maADcaY28EM64Sjksqra0M5WTyHk6ZcRiKfhVIjVuzg/ZHJ8D
         0j8wgm8dJqPyYFveJM/FA4dFmsRQYIH6zZK6bi1OJKJLYys7eXAM/P27/vT+cYryfkJW
         HPWWBJevrYZWfqPEy46IJftlYjn43sbtBBiZc8zpcag1lr170YEC9y8rufSHBNHU7HVx
         Vh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OnAU/FC5uHJjclWRokeb4prP8VtXKwpPQow8jIA2gqk=;
        b=GMsphv/pvGlIHkLC5abxPVsUjAU6rEYpAhh5WxWTaYP/z7+eIU6uXiNT5GdWE9UKkm
         ummGqh/Pc6sKHY/gdhP2RJH9xraLMzBQECXM+aj2W1Fp5GLEpvT4jUZsQ9X2Ccff9YnC
         eYXecZs1xtZShbxxdKlp2+yzmy9GjZwUbouJ1NwyZIusGtUEXWp6XQbozsUZU1HsIzZr
         4Uel+BvYFZzIby3S9eOehZ6dGQmuFt+bC9cfcKDbeTbCjt5NqcJBlGxDTpAuSFOZFZd9
         E6c/4APFajg+Z1IguzuAnZ9gCOUcZjTPi9X/4e7qTr30RxZvuIDRBjSknomenm6RFNUL
         GGtA==
X-Gm-Message-State: ANoB5pk6uUuPLJHcqoOBIAC0uOaHvcWg39IsCM75QpCVoFv+JQaEaqge
        wu+g7fRuhVwNw+SCDCZq4mx4Vueyz4Gp
X-Google-Smtp-Source: AA0mqf45Hkxl5oK0sU7WiE9FAUeymhJYW/ZStyJX77UcUu2lvLWIrn55+tJK2UUuLDD5Se0KSIXBKQ==
X-Received: by 2002:a05:6a20:3b20:b0:ac:16ae:6204 with SMTP id c32-20020a056a203b2000b000ac16ae6204mr45350120pzh.41.1671322085416;
        Sat, 17 Dec 2022 16:08:05 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id r7-20020a63b107000000b00478bd458bdfsm3554330pgf.88.2022.12.17.16.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 16:08:04 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v1 3/3] samples/bpf: fix uninitialized warning with test_current_task_under_cgroup
Date:   Sun, 18 Dec 2022 09:07:53 +0900
Message-Id: <20221218000753.4519-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218000753.4519-1-danieltimlee@gmail.com>
References: <20221218000753.4519-1-danieltimlee@gmail.com>
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

    samples/bpf $ export LLVM=-16;
    samples/bpf $ make
    /tmp/bpf/samples/bpf/test_current_task_under_cgroup_user.c:57:6:
    warning: variable 'cg2' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
	    if (setup_cgroup_environment())
		^~~~~~~~~~~~~~~~~~~~~~~~~~
    /tmp/bpf/samples/bpf/test_current_task_under_cgroup_user.c:106:8:
    note: uninitialized use occurs here
	    close(cg2);
		  ^~~
    /tmp/bpf/samples/bpf/test_current_task_under_cgroup_user.c:57:2:
    note: remove the 'if' if its condition is always false
	    if (setup_cgroup_environment())
	    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /tmp/bpf/samples/bpf/test_current_task_under_cgroup_user.c:19:9:
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

