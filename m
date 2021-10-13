Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D71642B93C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbhJMHgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238509AbhJMHgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:36:19 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E98EC061570;
        Wed, 13 Oct 2021 00:34:16 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so1546066pjb.5;
        Wed, 13 Oct 2021 00:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uRw8ev8Sq3xSNTxh3mi2/kC9mLBG1rrnJ2qBvZCOQlI=;
        b=BGcAaI5PQmf0dYiSKzcmKWZN+cWa851iS3FsMCWg3MKvXAqIrsaTwwOcGlpMh3zAkd
         NRvmFUYJvSJ17ycW+8+hiYQ/KtNLxV+BbEuvrbD/UVCogIAnN5x7YGXbxSE7VNPLM5D4
         8hLNP51L69JlZCyzpHXMQh7BYRWqc/Bf0AWW3cDevWZdtWAvZhNrOmXy5cLe5fPNEMTj
         Hm9XAnadl1lDg2ZCyOpwruOWqF4t0s4fB7g1HjYF5aa8b7xiWiV1b8EZgMY2YHCbAopQ
         oqBcZvH6F3DGnMB1vq8criOucUvBE87GO2eFxFZImWFpi5fIHqApFcTrnSKq8KjnKuCG
         j2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRw8ev8Sq3xSNTxh3mi2/kC9mLBG1rrnJ2qBvZCOQlI=;
        b=He2POhTqeclCSovXfLWYiOG6ekJ1jibEJ683yvsQnZDa0x7ZKHdOw3L+4zg/hwiWqI
         6RCutsdKfCeEx1huG6EMmfMjprm/URlTcHiENqpQsZwgTS7QE9WGhcXg0eoiQASz9TwA
         AEk+R/NYxhne8WlmsZs8FQ0bsvut6IfIzwFlQzlzPqwF0xeYMn+iBFbMWTqBy/n555or
         mpq5rKwJ5FQGb2ON0hPvrRVERjC1OT1qcKekVA1pSgpqSCrsOAwyDIuv3hdximdETpmb
         ArU0qzWlkH/RjKF0Io+hmeoCM9nWtMDzOJ+GH5VYM4cS0xwkInanxly/5GzvdjBF3SzB
         Eh4w==
X-Gm-Message-State: AOAM532ALNGPZQmjZ9ttVFZI6v3cAncAT6ljfGMRKP/qGr2R1fUJWjgX
        QR6/BvShpU887vc18qej6YOIbVf6gGY=
X-Google-Smtp-Source: ABdhPJzYWhN9EXRlWRzutZ7lB7tv0CDIMrPg48y97vF92OdfjtFXR7EJDChQxiOugDzmyojDa7pQ6w==
X-Received: by 2002:a17:90b:694:: with SMTP id m20mr11695633pjz.160.1634110455852;
        Wed, 13 Oct 2021 00:34:15 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id r7sm13041369pff.112.2021.10.13.00.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:34:15 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 8/8] selftests/bpf: Fix memory leak in test_ima
Date:   Wed, 13 Oct 2021 13:03:48 +0530
Message-Id: <20211013073348.1611155-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013073348.1611155-1-memxor@gmail.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; h=from:subject; bh=l4THhEd2yt0B5MEgzUfB0eWsbv0o9TbBjS4jiWJ5iQA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhZovSwfaAqgynGxNWS0LoOrX257+duVJAwbNsaJ+G qycKr7KJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWaL0gAKCRBM4MiGSL8RyqonD/ 9X3DpGxvHdzNZyH4TKjjnzu1uS0GpmAgAwBCWrO4GETSZ0csA82/vFUhaxUyjmL4O4ZhxkvvokEa/z IIO374F8Gf99qOJGHZJfqlLuIdyJIaU40rYdOiSWBjEXZicwQgn8EPT5i3MWKhzIb8hVC+gcSjKyhh O85Rr0LId6lMUxrm5CPPX4Vyz4YKmjJ9GsVLGO5moKHB7BFm5am6BSY09ELOwzHiLvlhJ0v2nRpRvD w1kScRAxrxRvx/tMTfLxQRvcBmjaaeXIUmd9B2oFnQUi826dg5pqux41thfFgljcPewZPFZx4OAbam rqXRH3JhHcOX7/pjQGnTmPH0jkS06kXAsLyhWVMbrijn7DWrrgQpD6AfJgQ9RDXqAdG6usiCmux62F Y3N8KkOEZnlbipxhw/ohAJX2rptaFUAPyuVX9XiN2vC5zTYUrTrge0kDMKMeMLEssmQAGg3Dgu1dd7 80tlzxWXh4UaBb8MfjlieMag/oVNEElvBwJM0Qg2t8NnwKVNvBUwpnjX/j1CjmdmWj9QUC4KXkDX5T QW6qy5qeYTHC43U1FxfDqVnPhJSIcYd1vAkTsTnOaLfGakNhDFX5sXW+pzNwPauvuFvOSLLINNz1O+ z9aDceCqUkwcr3w8AmlnOVH9/5CvScNjmwiNyxEyUybrDSGyl5tjx5JCBLIg==
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

