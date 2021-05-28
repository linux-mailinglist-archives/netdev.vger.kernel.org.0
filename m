Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C2B394947
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhE1XzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhE1XzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:19 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C464C061761;
        Fri, 28 May 2021 16:53:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d78so4410699pfd.10;
        Fri, 28 May 2021 16:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4uDJfsiaEde7mtiom3feHmGREEMUxgwXXDZIdtVjj4=;
        b=SgWXtiljBZS0tybMKTByV6k+FiuKCKaFN/g6flYuc6lSEg43E22dMoSyvJTxjOYZf2
         7b4a+8spAqBMcKRBnTKr9yD19H6Vyri6y5qVK7wBM/GVWyzo2MSoJlZ1cSO3ARBTyW/a
         xurle3Oy/Jd+alkYtYWUDjaHqg2aAO03txmEi/I/+n0D/i+yAh/csULvdMj4MPJ1vwF2
         Clr6HcNGhS5L3hYmXRg/PRZizqkkq3HgaS5RXT0PgrTfvlx2egArByoUv7KzdZIG5rTY
         MPXXtjMSXvSHTD5CvbP0B1DPxRr4/9/iTp+88/TrQ60luEy5ZQoFalrmXHcvkRP90avA
         kdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4uDJfsiaEde7mtiom3feHmGREEMUxgwXXDZIdtVjj4=;
        b=FyynsHUCvAam6XpVnZc6Rc0++5BHqahiaDcgy8XAEhmeE1HzlI6Ou113+yDwBo6feX
         tEznA3s3hQXi6DBX2jOBKfIQtPrkc1UHrgCLr9pDfrWgCNvQ5TxUEd3T5HycGw2Vi36h
         AM/5ecPBQobcvVCM1xkY3Qg0HSEGu3UQXV23ctnyJ79tCcSS6nw5NyxdzMgN970n+olr
         STtX0WPibiUAEy2NIur7hREjKFYRLaI+ZDGRv0B12t63/K2548S/mWiNjCuyD4v7zJCV
         EoYt6Teuc2fSj5PkT72j6XeIAilVRxCD1tdleNOrIWaS4zuYQNN/GiyXLm7t/UiJp+up
         cd4w==
X-Gm-Message-State: AOAM5338pZru3q6lwoBc/qC1Elhj+yEKQUeFbiq5Dpjp8rlJZlRfbVo/
        pnHVicsDMOmGE8WW2WxsZpwa98lhwI4=
X-Google-Smtp-Source: ABdhPJywhmRiSIiDvaOFuTlLDzlcgOctv+G28m35JpToTg4hHXaCEusyy+D0MjoaCtHgyzrfGfCA4A==
X-Received: by 2002:aa7:8b4f:0:b029:2bd:ea13:c4b4 with SMTP id i15-20020aa78b4f0000b02902bdea13c4b4mr6163994pfd.48.1622246022727;
        Fri, 28 May 2021 16:53:42 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id b9sm5093068pfo.107.2021.05.28.16.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:53:42 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 02/15] samples: bpf: fix a couple of warnings
Date:   Sat, 29 May 2021 05:22:37 +0530
Message-Id: <20210528235250.2635167-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cookie_uid_helper_example.c: In function ‘main’:
cookie_uid_helper_example.c:178:69: warning: ‘ -j ACCEPT’ directive
	writing 10 bytes into a region of size between 8 and 58
	[-Wformat-overflow=]
  178 |  sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
      |								       ^~~~~~~~~~
/home/kkd/src/linux/samples/bpf/cookie_uid_helper_example.c:178:9: note:
	‘sprintf’ output between 53 and 103 bytes into a destination of size 100
  178 |  sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  179 |         file);
      |         ~~~~~

Fix by using snprintf and a sufficiently sized buffer.

tracex4_user.c:35:15: warning: ‘write’ reading 12 bytes from a region of
	size 11 [-Wstringop-overread]
   35 |         key = write(1, "\e[1;1H\e[2J", 12); /* clear screen */
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use size as 11.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/cookie_uid_helper_example.c | 12 +++++++++---
 samples/bpf/tracex4_user.c              |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/cookie_uid_helper_example.c b/samples/bpf/cookie_uid_helper_example.c
index cc3bce8d3aac..30fdcd664da2 100644
--- a/samples/bpf/cookie_uid_helper_example.c
+++ b/samples/bpf/cookie_uid_helper_example.c
@@ -1,3 +1,4 @@
+
 /* This test is a demo of using get_socket_uid and get_socket_cookie
  * helper function to do per socket based network traffic monitoring.
  * It requires iptables version higher then 1.6.1. to load pinned eBPF
@@ -167,7 +168,7 @@ static void prog_load(void)
 static void prog_attach_iptables(char *file)
 {
 	int ret;
-	char rules[100];
+	char rules[256];
 
 	if (bpf_obj_pin(prog_fd, file))
 		error(1, errno, "bpf_obj_pin");
@@ -175,8 +176,13 @@ static void prog_attach_iptables(char *file)
 		printf("file path too long: %s\n", file);
 		exit(1);
 	}
-	sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
-		file);
+	ret = snprintf(rules, sizeof(rules),
+		       "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
+		       file);
+	if (ret < 0 || ret >= sizeof(rules)) {
+		printf("error constructing iptables command\n");
+		exit(1);
+	}
 	ret = system(rules);
 	if (ret < 0) {
 		printf("iptables rule update failed: %d/n", WEXITSTATUS(ret));
diff --git a/samples/bpf/tracex4_user.c b/samples/bpf/tracex4_user.c
index cea399424bca..566e6440e8c2 100644
--- a/samples/bpf/tracex4_user.c
+++ b/samples/bpf/tracex4_user.c
@@ -32,7 +32,7 @@ static void print_old_objects(int fd)
 	__u64 key, next_key;
 	struct pair v;
 
-	key = write(1, "\e[1;1H\e[2J", 12); /* clear screen */
+	key = write(1, "\e[1;1H\e[2J", 11); /* clear screen */
 
 	key = -1;
 	while (bpf_map_get_next_key(fd, &key, &next_key) == 0) {
-- 
2.31.1

