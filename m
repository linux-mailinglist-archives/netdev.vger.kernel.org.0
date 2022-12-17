Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E74764FAE5
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 16:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiLQPzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 10:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiLQPyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 10:54:50 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1063C8F949;
        Sat, 17 Dec 2022 07:38:36 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 4so5106834plj.3;
        Sat, 17 Dec 2022 07:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5scM6H1KR3NuFmM3GwXtJX6bswpVcFplxcFPcjKDe2U=;
        b=jq6flea9qTjKTF/FvXfXoU9MrQ5CKJYqBaS6574qrCv7EQLL4LZDlfuV4sLcvwrXVZ
         7vmfLlesI9hGuUXobscqKMJUQDN9y47/lJFu0F5uFbMmGgqDm/ci2/XEt+gX4OYvmDVH
         nRNfXhlBI1d5bAJ2sQuIxyV9gKuBroYJ5zeV8sflYsi/11M1ATkzZXLrnzgS/kj7LCwj
         VYYKKtKjX2h8EQIC4+Nv238uYW2QbFKeukgPfMH/EdIXTtIMllmiqA9VeOJfHNaX1jXe
         euXDg9zhcDS2j61tUR0dfMYQTF81Wa4xxT9uVKVhnLiEYdk+W5aLu1ISTwuvjoU0qlN8
         N3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5scM6H1KR3NuFmM3GwXtJX6bswpVcFplxcFPcjKDe2U=;
        b=US0dJojPuhZ2ZQ4CiYAXma/M8Tc3w0ScKw8jKq4UlDRjIhddL95a4JAx7Gk4dutXjh
         BYS0KXuB2Db8yazU+mJqhekZkTTPX+5y8zvXHlkitmB2PfqVvGz6SCuGI6F33bj68a+K
         /h7SOAMfh1JTwXfz99lhn3rHgMfK2goEAKpsBU0Wn1HHfYQX4zPTtQ26eMVfHem7e7aC
         yk2ha+QbAgw+WgeSKqwzQ1FZrtc5lz+DUXxy95793cuQ43cWL0VN6Me4AgBiBZ215xX4
         HOvyfBNRa0bsRudqmOsCM1StJfeYSz70AS6jOK886LevnMFpFjDmX3tg07GcRl4E9URl
         kIxQ==
X-Gm-Message-State: ANoB5pn1C+BEgIW+kByEXWZEuKO7NVtomafc74yx8pLPKpTPKsSLK8FQ
        nHsMS2TOmwpQTzk2dgYUig==
X-Google-Smtp-Source: AA0mqf5vOszpsJtqyXdwLB4RjTNnV/6d/iUcQUwpegI0nSpAp2zb8BalkBbC8zVPO8JhVdc5HUDIOQ==
X-Received: by 2002:a17:902:d412:b0:18f:37ec:9675 with SMTP id b18-20020a170902d41200b0018f37ec9675mr24605055ple.21.1671291513143;
        Sat, 17 Dec 2022 07:38:33 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id u31-20020a63235f000000b00488b8ad57bfsm732039pgm.54.2022.12.17.07.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 07:38:32 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 3/3] samples/bpf: fix uninitialized warning with test_current_task_under_cgroup
Date:   Sun, 18 Dec 2022 00:38:21 +0900
Message-Id: <20221217153821.2285-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221217153821.2285-1-danieltimlee@gmail.com>
References: <20221217153821.2285-1-danieltimlee@gmail.com>
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

