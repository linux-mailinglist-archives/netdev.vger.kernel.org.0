Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609A662660
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403976AbfGHQcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:32:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36411 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388701AbfGHQbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:31:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so176382wme.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yfapiFsE4OmxP9vMHIQmElH3PTxTJhdK3T96JsR6xmY=;
        b=AwysrBJC39iPhW8fSEU+3huktCPgPvzlgzNdwOdQrw+V5E8uP/wIg/Q0wCJVSkrQUJ
         Y12gYUKKE5NakL3+MVgJ2Fsu1guDhor2brgYw+CkRNveotznlgGG4HBX8Dk9thPw/Y5A
         6Xk42e56KAaitNCqYeA68tZW2ACB2UxzsxWm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yfapiFsE4OmxP9vMHIQmElH3PTxTJhdK3T96JsR6xmY=;
        b=TrcmX2bqX28njbPFDoV8XUC2V8qzNB+7wMttcePyrtUtMRwk8fNH/PV3pNLewR/d8b
         qwl9d4OJEyreEfbEj6CNTC208jq6tznk3+8Sgh7tnSbAr+a9KLQ4Fcm3sD6nKlbahpTK
         TgOEl0j3cOnR26m2s3jmmDnOb3xis6QsmX4nGcP1nHrQNEn3QFbtD1dFXFOY1qg6gbzm
         t2UIkXkRR6fyR3+WjBPU5bls00oyKBfosEIQWC0ksJvmKc7wdIYTFi6jEdMSvOwNXDUv
         +anNOSTGnv9PxVHZpFz+mSGcLGa3eGnBWbGowHLFy14hqXPPTjSeGrquC8GH7yr4MTW6
         5khA==
X-Gm-Message-State: APjAAAWcRKuBX6fa1Bzha8EhzTezjUFDj0OETaaCQOHEaTSNLYhH3AF2
        0E5ckPKkw4IXFtuwDilowxy75w==
X-Google-Smtp-Source: APXvYqy4tMsGFA84bjXV72y0LxdF54qkE5Rr12cM5BrQCv2eDz3tBHn7eYNxh9WEPMBYW/RPdWOQtg==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr18325919wmi.78.1562603510047;
        Mon, 08 Jul 2019 09:31:50 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedbe.dynamic.kabel-deutschland.de. [95.90.237.190])
        by smtp.gmail.com with ESMTPSA id e6sm18255086wrw.23.2019.07.08.09.31.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:31:49 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     linux-kernel@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 03/12] selftests/bpf: Avoid another case of errno clobbering
Date:   Mon,  8 Jul 2019 18:31:12 +0200
Message-Id: <20190708163121.18477-4-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8184d44c9a57 ("selftests/bpf: skip verifier tests for
unsupported program types") added a check for an unsupported program
type. The function doing it changes errno, so test_verifier should
save it before calling it if test_verifier wants to print a reason why
verifying a BPF program of a supported type failed.

Changes since v2:
- Move the declaration to fit the reverse christmas tree style.

Fixes: 8184d44c9a57 ("selftests/bpf: skip verifier tests for unsupported program types")
Cc: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 3fe126e0083b..c7541f572932 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -864,6 +864,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	int run_errs, run_successes;
 	int map_fds[MAX_NR_MAPS];
 	const char *expected_err;
+	int saved_errno;
 	int fixup_skips;
 	__u32 pflags;
 	int i, err;
@@ -894,6 +895,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		pflags |= BPF_F_ANY_ALIGNMENT;
 	fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
 				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
+	saved_errno = errno;
 	if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
 		printf("SKIP (unsupported program type %d)\n", prog_type);
 		skips++;
@@ -910,7 +912,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	if (expected_ret == ACCEPT) {
 		if (fd_prog < 0) {
 			printf("FAIL\nFailed to load prog '%s'!\n",
-			       strerror(errno));
+			       strerror(saved_errno));
 			goto fail_log;
 		}
 #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-- 
2.20.1

