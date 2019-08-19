Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94C191C18
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 06:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfHSEhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 00:37:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35782 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSEhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 00:37:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id k2so7193008wrq.2;
        Sun, 18 Aug 2019 21:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZUCw4jAs77fJWvJ1Lbk9AJyiu5YLLMkfP4oKtMz1NVw=;
        b=uYH4KbWl08ZgKEpjhyYlfwvt9PdrFvpKMSKrDB/bHWMyRU+XUtYSStUbBLT5ziwZGl
         t60r3tqUrSES+VTAuxKq3qBMi3tLrQQNaL0SIigL/02DNaxLMfCrVhVHJ211ZyUXZ2CQ
         auHG0As1cCwaTCqHlXIhGDIYQWlDA7UERd0CKQTsAQUNqEnPjlbwK2klFMq2mJshC6Qj
         EBIpU7+XyUzC5g/mNOtUuxvLD/JQM5MPi0R2nfcrpj8ak8j6MXSLzEMQqVf154qbaI3Q
         XtxeoHtsJPy7cv8bhx/BVrTiyu9jgeKD7IcKIy0KruGZZm/p3HQSrvz3cJG2aFSc+Umi
         7Mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZUCw4jAs77fJWvJ1Lbk9AJyiu5YLLMkfP4oKtMz1NVw=;
        b=bWkDL8CL579GUqvVxFdcPOeEvD8g/9YTNR5FFATA0/4DgtD8zCZbux/xOwpzxHRMId
         P2N2fS7vZzMf6u614sHqfNvW53bWt7kEKglX+0yMw+c4DYFu7kr9WMHubG0tfvzUswN2
         n+t1chn3iVHAbeaGEQqt7sNi2sjhdTAEf4ej0RUgZ3IBOvtjMjvh6IcBh1qvXlFLDcNi
         awFlUNvLkmJUTNZawGqDr8XmPM86eMhrneTv6qeYEq1AyuJ+eX/PuTScrqzH7qOMfu7g
         hG3c7UfKbHo2eO9HBRUsCGxLrIjXOhdBmoY37RXMzRIw+jvs3eAfoyxLv6u10+8u3bqd
         oXZQ==
X-Gm-Message-State: APjAAAUBkgeTWcun9KOpTKvGWz1WFsG5mK6f/ohAFvRFOhUh3/4C9r72
        Ej8sCDxpqIUZexBWrSqx/dY=
X-Google-Smtp-Source: APXvYqyHKAGqzXXD27TODaxzJH2S8swRrcvJBmyoQQcxyqBVpHYwkStPF7Y+58W+JKHUm4F7neENzA==
X-Received: by 2002:adf:de02:: with SMTP id b2mr24526170wrm.204.1566189417661;
        Sun, 18 Aug 2019 21:36:57 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id j10sm15218526wrd.26.2019.08.18.21.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 21:36:56 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] test_bpf: Fix a new clang warning about xor-ing two numbers
Date:   Sun, 18 Aug 2019 21:34:20 -0700
Message-Id: <20190819043419.68223-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r369217 in clang added a new warning about potential misuse of the xor
operator as an exponentiation operator:

../lib/test_bpf.c:870:13: warning: result of '10 ^ 300' is 294; did you
mean '1e300'? [-Wxor-used-as-pow]
                { { 4, 10 ^ 300 }, { 20, 10 ^ 300 } },
                       ~~~^~~~~
                       1e300
../lib/test_bpf.c:870:13: note: replace expression with '0xA ^ 300' to
silence this warning
../lib/test_bpf.c:870:31: warning: result of '10 ^ 300' is 294; did you
mean '1e300'? [-Wxor-used-as-pow]
                { { 4, 10 ^ 300 }, { 20, 10 ^ 300 } },
                                         ~~~^~~~~
                                         1e300
../lib/test_bpf.c:870:31: note: replace expression with '0xA ^ 300' to
silence this warning

The commit link for this new warning has some good logic behind wanting
to add it but this instance appears to be a false positive. Adopt its
suggestion to silence the warning but not change the code. According to
the differential review link in the clang commit, GCC may eventually
adopt this warning as well.

Link: https://github.com/ClangBuiltLinux/linux/issues/643
Link: https://github.com/llvm/llvm-project/commit/920890e26812f808a74c60ebc14cc636dac661c1
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

I highly doubt that 1e300 was intented but if it was (or something else
was), please let me know. Commit history wasn't entirely clear on why
this expression was used over just a raw number.

 lib/test_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index c41705835cba..5ef3eccee27c 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -867,7 +867,7 @@ static struct bpf_test tests[] = {
 		},
 		CLASSIC,
 		{ },
-		{ { 4, 10 ^ 300 }, { 20, 10 ^ 300 } },
+		{ { 4, 0xA ^ 300 }, { 20, 0xA ^ 300 } },
 	},
 	{
 		"SPILL_FILL",
-- 
2.23.0

