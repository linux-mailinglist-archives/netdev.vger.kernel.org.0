Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFE41542DE
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 12:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgBFLRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 06:17:04 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38273 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbgBFLRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 06:17:02 -0500
Received: by mail-wm1-f67.google.com with SMTP id a9so6564924wmj.3
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 03:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WgjC54an/BsE9+r+d7h+ThtXSsEnf/5wIybUYx0C7/s=;
        b=PYvVPgFTYk2ky/EPLel3tNo86NsfUQWDr0ifWuQjf+cvL0Wbm84skc6h+eooSBmLks
         RL+UWkAYk2erkGpt2jjWWouF6C2UAwJWOeQRpelql71vs2nz2ySuzzUNU7x0t+4bfRvq
         dK5Zgr+zVRKVMam1Z6/dcWglTRrIzajHbWcKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WgjC54an/BsE9+r+d7h+ThtXSsEnf/5wIybUYx0C7/s=;
        b=kAFLF/Ce1O8MUwS2lqNUWf4Yf32rFIyUT+gTWiEoVk70sqizY61Yb5AixV0m5OCRyf
         a8qyIuVaRH7j+/jNPCnw9rguGa+d9qpb1BsH+nqBmvLvTi9aHvNvMMvefWo3B0aTHEjG
         glLpg0IL0rNl0M3TT4Zdj+0tfxKT9bUdTX8AoYwxoSebotF1APwPvCwxQkHFZQtjAvbe
         U5/ZI66IRJMWvvxMnOWFEq2Hj5C0wZd/cKgcPFa+kFFRvss6FAcRly/W8/6rODUuUJBK
         IgXVNnv7BuGvuy3Ydoj/3oQXflpcoudDvOuNo1ITDpsBAZvpqginh5/5Nm19g+6flF1/
         HjMg==
X-Gm-Message-State: APjAAAUR6sWlMqACkJyLkB5E5S1UaQy/AcKPsPdQsBFpjsmn6w2uCvsT
        QQRLOCSvak9kKaxEOreAyP8XWg==
X-Google-Smtp-Source: APXvYqx0hcoSru418OaERRG7HYUyMtGRJbQvWS6e7ehBSfajeZpRXufOLaPiAT9GKHFS6p2Kpt3bmw==
X-Received: by 2002:a05:600c:2290:: with SMTP id 16mr4058246wmf.93.1580987820279;
        Thu, 06 Feb 2020 03:17:00 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id a26sm3470605wmm.18.2020.02.06.03.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:16:59 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf 3/3] selftests/bpf: Test freeing sockmap/sockhash with a socket in it
Date:   Thu,  6 Feb 2020 12:16:52 +0100
Message-Id: <20200206111652.694507-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206111652.694507-1-jakub@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear
down") introduced sleeping issues inside RCU critical sections and while
holding a spinlock on sockmap/sockhash tear-down. There has to be at least
one socket in the map for the problem to surface.

This adds a test that triggers the warnings for broken locking rules. Not a
fix per se, but rather tooling to verify the accompanying fixes. Run on a
VM with 1 vCPU to reproduce the warnings.

Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
new file mode 100644
index 000000000000..07f5b462c2ef
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Cloudflare
+
+#include "test_progs.h"
+
+static int connected_socket_v4(void)
+{
+	struct sockaddr_in addr = {
+		.sin_family = AF_INET,
+		.sin_port = htons(80),
+		.sin_addr = { inet_addr("127.0.0.1") },
+	};
+	socklen_t len = sizeof(addr);
+	int s, repair, err;
+
+	s = socket(AF_INET, SOCK_STREAM, 0);
+	if (CHECK_FAIL(s == -1))
+		goto error;
+
+	repair = TCP_REPAIR_ON;
+	err = setsockopt(s, SOL_TCP, TCP_REPAIR, &repair, sizeof(repair));
+	if (CHECK_FAIL(err))
+		goto error;
+
+	err = connect(s, (struct sockaddr *)&addr, len);
+	if (CHECK_FAIL(err))
+		goto error;
+
+	repair = TCP_REPAIR_OFF_NO_WP;
+	err = setsockopt(s, SOL_TCP, TCP_REPAIR, &repair, sizeof(repair));
+	if (CHECK_FAIL(err))
+		goto error;
+
+	return s;
+error:
+	perror(__func__);
+	close(s);
+	return -1;
+}
+
+/* Create a map, populate it with one socket, and free the map. */
+static void test_sockmap_create_update_free(enum bpf_map_type map_type)
+{
+	const int zero = 0;
+	int s, map, err;
+
+	s = connected_socket_v4();
+	if (CHECK_FAIL(s == -1))
+		return;
+
+	map = bpf_create_map(map_type, sizeof(int), sizeof(int), 1, 0);
+	if (CHECK_FAIL(map == -1)) {
+		perror("bpf_create_map");
+		goto out;
+	}
+
+	err = bpf_map_update_elem(map, &zero, &s, BPF_NOEXIST);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_map_update");
+		goto out;
+	}
+
+out:
+	close(map);
+	close(s);
+}
+
+void test_sockmap_basic(void)
+{
+	if (test__start_subtest("sockmap create_update_free"))
+		test_sockmap_create_update_free(BPF_MAP_TYPE_SOCKMAP);
+	if (test__start_subtest("sockhash create_update_free"))
+		test_sockmap_create_update_free(BPF_MAP_TYPE_SOCKHASH);
+}
-- 
2.24.1

