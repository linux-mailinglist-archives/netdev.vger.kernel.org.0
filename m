Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53D316A7B0
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgBXNxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:53:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39884 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBXNxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:53:31 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so1670936wrn.6
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZSTwWAn3t7JMXjmqAY0yMV0jtle3ljPKptSRmgEMBQ=;
        b=vb8eMTfQd/zoi8WrDi71FZ2v6JZkFmV3Sc538G8bxxFQlaRoPjFfEIRq8nXAwetMSG
         +VyLAfQF4LfhnF3R5Ga/v/enjri7SyAos417Jv3iLSlpBtQkmMkexZG60HP6IfIVLd4C
         RGcZOSDen7mpl0lwtqVhu6G0psS0JH5xjs4Do=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZSTwWAn3t7JMXjmqAY0yMV0jtle3ljPKptSRmgEMBQ=;
        b=BW50xZ3SpFG0AB5L7Eky96RmDErd1Zhons2kxoBip5QutmT03B6yHCuBdA8bJcYT2J
         5xVyZWsh73X7G4N+xYbI8tF+jHOOlFB/I0Ohp5wt5iYh4jJhfF0bI6Frm6zBK/q2PxCT
         bZ/mbSm10oiBMUOIaCkvl9Ef/2HcnHFlwp2bYvhC+MxNVv0ugtVXMcQFn/xdSpGRzQEv
         9w62tjBBpzC8qUwnwu2rE9YyCZR5i/oq2eQzRASIWSlGDY8MHbi49/rPBxgV0rW8y+xK
         Xw0p8vXdzDKehF1ECEZBVZmBhxk6+Qs/qwbtNBstTOojlJJmViFT1QbKCM1syD/wvpSf
         DFow==
X-Gm-Message-State: APjAAAWIkCjE8WkMJUQFs9YrJO8J4sNg+4GaS6DaMH+OpUsARP28sels
        LVNJwIDktzHG3Rv3n2qrA9iL5g==
X-Google-Smtp-Source: APXvYqxtkoKYrvf8qfuBJvz5l/Dmdxrh1+KyJUu5NMZEsGHY4OKX+7kMzmzEiUXhBXt/6mP5aFWmmw==
X-Received: by 2002:adf:fa87:: with SMTP id h7mr70545877wrr.172.1582552409148;
        Mon, 24 Feb 2020 05:53:29 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id k16sm19139203wru.0.2020.02.24.05.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:53:28 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next 1/2] selftests/bpf: Run reuseport tests only with supported socket types
Date:   Mon, 24 Feb 2020 14:53:26 +0100
Message-Id: <20200224135327.121542-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCKMAP and SOCKHASH map types can be used with reuseport BPF programs but
don't support yet storing UDP sockets. Instead of marking UDP tests with
SOCK{MAP,HASH} as skipped, don't run them at all.

Skipped test might signal that the test environment is not suitable for
running the test, while in reality the functionality is not implemented in
the kernel yet.

Before:

  sh# ./test_progs -t select_reuseport
  …
  #40 select_reuseport:OK
  Summary: 1/126 PASSED, 30 SKIPPED, 0 FAILED

After:

  sh# ./test_progs  -t select_reuseport
  …
  #40 select_reuseport:OK
  Summary: 1/98 PASSED, 2 SKIPPED, 0 FAILED

The remaining two skipped tests are SYN cookies tests, which will be
addressed in the subsequent patch.

Fixes: 11318ba8cafd ("selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP/SOCKHASH")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/select_reuseport.c     | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 68d452bb9fd9..8c41d6d63fcf 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -807,6 +807,12 @@ static void test_config(int sotype, sa_family_t family, bool inany)
 	char s[MAX_TEST_NAME];
 	const struct test *t;
 
+	/* SOCKMAP/SOCKHASH don't support UDP yet */
+	if (sotype == SOCK_DGRAM &&
+	    (inner_map_type == BPF_MAP_TYPE_SOCKMAP ||
+	     inner_map_type == BPF_MAP_TYPE_SOCKHASH))
+		return;
+
 	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
 		snprintf(s, sizeof(s), "%s %s/%s %s %s",
 			 maptype_str(inner_map_type),
@@ -816,13 +822,6 @@ static void test_config(int sotype, sa_family_t family, bool inany)
 		if (!test__start_subtest(s))
 			continue;
 
-		if (sotype == SOCK_DGRAM &&
-		    inner_map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
-			/* SOCKMAP/SOCKHASH don't support UDP yet */
-			test__skip();
-			continue;
-		}
-
 		setup_per_test(sotype, family, inany, t->no_inner_map);
 		t->fn(sotype, family);
 		cleanup_per_test(t->no_inner_map);
-- 
2.24.1

