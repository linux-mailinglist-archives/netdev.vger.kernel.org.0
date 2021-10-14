Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F0642E2FB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 22:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhJNU7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 16:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbhJNU7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 16:59:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7089FC061570;
        Thu, 14 Oct 2021 13:57:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q12so3707653pgq.11;
        Thu, 14 Oct 2021 13:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uRw8ev8Sq3xSNTxh3mi2/kC9mLBG1rrnJ2qBvZCOQlI=;
        b=fGeY8VXguArczrDK6eEIWds8igwxMjy6wHQwQId1RlXRgG73cvO5DpUcVuwms7xGEk
         pSCAU/dygEUJGiTajPMK+bSJJNvTtsNJl9mjhnNOukW0zv++TmCv/ERQDGGQBIBc65i8
         HnlpN7KXpG25R+keTsKu2AsaEyIqFghr8DzJfghMvRJSqp0kNJoXqZ3TkRjyC6ldKQ8h
         2L09S/OUp0dk9lBzweAbot1a+d0EtZr9NVTR+llOWptpoZxRhtLUE3BmCTO3BFv15zsZ
         axZCfsBa+tLsCigxm82eac3LZWE0wJtjjSVhBiKpjclipCaSscnasPuFC5+c4y6VsuxZ
         5wIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRw8ev8Sq3xSNTxh3mi2/kC9mLBG1rrnJ2qBvZCOQlI=;
        b=JpQeUDsG+JXwMZnzGCtGtxrIWiHufZ3VOFk5gWhm0XaqmuyEeSf1Cr/c9ROsCPPYi2
         4b4DEopnQa+SMN9/HLVeZLgm0VKqXmJBQa2Cz5/dIM385iGxtTYFidl6u7kPhx0RY87M
         5VYlw+E/B6LhUIzHPHFzndtvCNZg6vipzNGrsCs/6keMFd276UE+P3dRY8IvrDeIZ4Yt
         QCm+d+FSbF9ytFizxQQs7MadIJGkYBvp2dIGLwF/3Bqjdti2gbYVCCPAiDpWS7y14hFm
         kJpoHWZMjZeKo5xY+UjSoMGnc1joD8//gTqWgvNds1TZtr9ZTF2L6ysJxtUfT9XHgrSD
         N9Og==
X-Gm-Message-State: AOAM530SJSVXTRapUkYvgEc75ibkzzT+7OIc6jR+LwkU6GMCiUAY7URS
        g4VJ2r3kXsquzKORrf1Knb/630qcVuE=
X-Google-Smtp-Source: ABdhPJwHKzCnb2WqMUAX4VVTcZp6gCMNTnCuMtF3L2DJYquoOBS2GOyOg4Wwm5GTmVRFmj+Dd6Nulw==
X-Received: by 2002:a05:6a00:a94:b0:44c:ecb2:6018 with SMTP id b20-20020a056a000a9400b0044cecb26018mr7360586pfl.57.1634245033833;
        Thu, 14 Oct 2021 13:57:13 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id i13sm3202574pgf.77.2021.10.14.13.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 13:57:13 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 8/8] selftests/bpf: Fix memory leak in test_ima
Date:   Fri, 15 Oct 2021 02:26:44 +0530
Message-Id: <20211014205644.1837280-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014205644.1837280-1-memxor@gmail.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; h=from:subject; bh=l4THhEd2yt0B5MEgzUfB0eWsbv0o9TbBjS4jiWJ5iQA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhaJk/wfaAqgynGxNWS0LoOrX257+duVJAwbNsaJ+G qycKr7KJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWiZPwAKCRBM4MiGSL8RyhgcEA Cjq0DMBUzh/Jk5TARd8rR5hf2L7f5hBLwvjcGmM6HFhss1ws3vvrE/ruP65vTTU1KxyYcl9wN9ATMI qLJzBaU7lKMLUI1DdAH8uX73CX+fcu7ohNJ9OxVgt3gaizsFRVUDLsnKCudifUDzIyKe/sUTEQmfz+ oU6ony9p2OktkQ2L+MDGyctR6LiwsSD27OsTovNW+WTba43nnpbrGbuobSXOaU+hyaeuX/0qG2GTTK LsI4W8937nq6H/ua+J02L6Z+u8Do4nM2BJj3C4Vj26sBa9SQGXVPYZpSD/vPJdLmizjeS05jqnC3hX 5H6QjdL0Cgsdi9EqEMJlCLF8h1mwdGzyIK44kQDogrmDSiOL9WxCSWTyQBrMGIUPMxOqrS7a+D4n0/ 6rruF4l5sfxzwN+jziLpWKUV3YE6rOPOqq0uHCVN7FNk1+ma8RBjJ6H/f93LyTDdc5XoayM47+qBEK z5x7rBryjcbHXeW/2GJb/68AIv35s9t/93lWf5Lb14oZ1lQ2e4Hv38bo8svvAMgrPMRYbb5ak/U3k1 sZJxlygCV391iDCkBB/+lvU+QCz+c47MO5MfpILV/W/WoQprK0HtLEI011NQOEHSe7iC3YvE5/9EhE GR/qSpdpXUq5kv7CELe5nW1PM5aV4/EsYJg5YeKtjEO/jdvnVQhC6XchZzBg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The allocated ring buffer is never freed, do so in the cleanup path.

Fixes: f446b570ac7e ("bpf/selftests: Update the IMA test to use BPF ring buffer")
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/test_ima.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 0252f61d611a..97d8a6f84f4a 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -43,7 +43,7 @@ static int process_sample(void *ctx, void *data, size_t len)
 void test_test_ima(void)
 {
 	char measured_dir_template[] = "/tmp/ima_measuredXXXXXX";
-	struct ring_buffer *ringbuf;
+	struct ring_buffer *ringbuf = NULL;
 	const char *measured_dir;
 	char cmd[256];
 
@@ -85,5 +85,6 @@ void test_test_ima(void)
 	err = system(cmd);
 	CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno);
 close_prog:
+	ring_buffer__free(ringbuf);
 	ima__destroy(skel);
 }
-- 
2.33.0

