Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6416E6D8C5E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbjDFBBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbjDFBBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291A26E96;
        Wed,  5 Apr 2023 18:00:54 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id z18so22829023pgj.13;
        Wed, 05 Apr 2023 18:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742853; x=1683334853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnWen7kjqNC6BHyX2tSKhXwmBzaOl/pAI54Si9NYoD0=;
        b=KriWCMYoLYgnBP/aXjqCdqCIxQ+wJuwMadvmj2qSJu4s1kFXCXhl+EYqbhh3GY9BN8
         Iegsetkf+Ia45KfK39uI9nTHjnjthBYpX/mxTa/hOjLp4eUvsZFEaaKpsQGpAdYz9dF+
         Tjf9wyx6i3MmGvyMhBlAs+jqEuQ9SWkkGguORM6KVNr6uny5GJfmdXc+/f6SrAukrV4x
         x6s4twz+OcP4XLMuGgPfZkSblmrOpHiwzjgKUJXp3IcJHmyHm2Iqn20OJRQVxmT+668w
         YZh/BLaXMm8oFEugLtcwDtwmnvRknd+3loQwuuXIb7RmpB1jLhwE/p2a3LWi9ZYXjCFV
         tEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742853; x=1683334853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnWen7kjqNC6BHyX2tSKhXwmBzaOl/pAI54Si9NYoD0=;
        b=qdtMipYA9JKNsMNX4e2YBBmGZ8GEnczpC6Vc9XxG/8TzVE0I9IYvjrLTFivYDFiElw
         chYmuulGh6CdPfUwGdUbfpG9d2HNTA9/hEVW/Wrqvg8wlKbB4VqmESc2s12KT1y4jF5s
         phWe7+My1+Yxwt8fe5Yh5ddhYgJ9aXLoZSwPmDhx5DmeS5TVv3NbyKVmyTWX8QzcWbQ5
         imdjnLuIXaxdtzgazX4gnyCapccaNvwKCC8PBavrV30RSJhQVnF8YA5cdbU7cmRVLwUr
         0qDjnnbsQxufaCqu0/aGOhNaL8L8dV+iX9xZJE/nwOoUAWRdwsnmTnYI20lCBShdEPFd
         iS6w==
X-Gm-Message-State: AAQBX9fCc1lKvggngtLHYarwUKH2aASZz+UMy1gim/J0CnitxWfA5+mJ
        JN1XY+avP5/pptvXzKXsb9w=
X-Google-Smtp-Source: AKy350ZepEa23KTudWLtVrwjTj9K2XmMZhky5f7lZxMFsKRlIn/4Txm0Obj3buogiDXF4p9VrPIIPw==
X-Received: by 2002:aa7:950d:0:b0:62a:443b:eb3 with SMTP id b13-20020aa7950d000000b0062a443b0eb3mr8077200pfp.27.1680742853692;
        Wed, 05 Apr 2023 18:00:53 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:53 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 10/12] bpf: sockmap, test shutdown() correctly exits epoll and recv()=0
Date:   Wed,  5 Apr 2023 18:00:29 -0700
Message-Id: <20230406010031.3354-11-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406010031.3354-1-john.fastabend@gmail.com>
References: <20230406010031.3354-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When session gracefully shutdowns epoll needs to wake up and any recv()
readers should return 0 not the -EAGAIN they previously returned.

Note we use epoll instead of select to test the epoll wake on shutdown
event as well.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 68 +++++++++++++++++++
 .../bpf/progs/test_sockmap_pass_prog.c        | 32 +++++++++
 2 files changed, 100 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 0ce25a967481..f9f611618e45 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2020 Cloudflare
 #include <error.h>
 #include <netinet/tcp.h>
+#include <sys/epoll.h>
 
 #include "test_progs.h"
 #include "test_skmsg_load_helpers.skel.h"
@@ -9,8 +10,11 @@
 #include "test_sockmap_invalid_update.skel.h"
 #include "test_sockmap_skb_verdict_attach.skel.h"
 #include "test_sockmap_progs_query.skel.h"
+#include "test_sockmap_pass_prog.skel.h"
 #include "bpf_iter_sockmap.skel.h"
 
+#include "sockmap_helpers.h"
+
 #define TCP_REPAIR		19	/* TCP sock is under repair right now */
 
 #define TCP_REPAIR_ON		1
@@ -350,6 +354,68 @@ static void test_sockmap_progs_query(enum bpf_attach_type attach_type)
 	test_sockmap_progs_query__destroy(skel);
 }
 
+#define MAX_EVENTS 10
+static void test_sockmap_skb_verdict_shutdown(void)
+{
+	int n, err, map, verdict, s, c0, c1, p0, p1;
+	struct epoll_event ev, events[MAX_EVENTS];
+	struct test_sockmap_pass_prog *skel;
+	int epollfd;
+	int zero = 0;
+	char b;
+
+	skel = test_sockmap_pass_prog__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	map = bpf_map__fd(skel->maps.sock_map_rx);
+
+	err = bpf_prog_attach(verdict, map, BPF_SK_SKB_STREAM_VERDICT, 0);
+	if (!ASSERT_OK(err, "bpf_prog_attach"))
+		goto out;
+
+	s = socket_loopback(AF_INET, SOCK_STREAM);
+	if (s < 0)
+		goto out;
+	err = create_socket_pairs(s, AF_INET, SOCK_STREAM, &c0, &c1, &p0, &p1);
+	if (err < 0)
+		goto out;
+
+	err = bpf_map_update_elem(map, &zero, &c1, BPF_NOEXIST);
+	if (err < 0)
+		goto out_close;
+
+	shutdown(c0, SHUT_RDWR);
+	shutdown(p1, SHUT_WR);
+
+	ev.events = EPOLLIN;
+	ev.data.fd = c1;
+
+	epollfd = epoll_create1(0);
+	if (!ASSERT_GT(epollfd, -1, "epoll_create(0)"))
+		goto out_close;
+	err = epoll_ctl(epollfd, EPOLL_CTL_ADD, c1, &ev);
+	if (!ASSERT_OK(err, "epoll_ctl(EPOLL_CTL_ADD)"))
+		goto out_close;
+	err = epoll_wait(epollfd, events, MAX_EVENTS, -1);
+	if (!ASSERT_EQ(err, 1, "epoll_wait(fd)"))
+		goto out_close;
+
+	n = recv(c1, &b, 1, SOCK_NONBLOCK);
+	ASSERT_EQ(n, 0, "recv_timeout(fin)");
+	n = recv(p0, &b, 1, SOCK_NONBLOCK);
+	ASSERT_EQ(n, 0, "recv_timeout(fin)");
+
+out_close:
+	close(c0);
+	close(p0);
+	close(c1);
+	close(p1);
+out:
+	test_sockmap_pass_prog__destroy(skel);
+}
+
 void test_sockmap_basic(void)
 {
 	if (test__start_subtest("sockmap create_update_free"))
@@ -384,4 +450,6 @@ void test_sockmap_basic(void)
 		test_sockmap_progs_query(BPF_SK_SKB_STREAM_VERDICT);
 	if (test__start_subtest("sockmap skb_verdict progs query"))
 		test_sockmap_progs_query(BPF_SK_SKB_VERDICT);
+	if (test__start_subtest("sockmap skb_verdict shutdown"))
+		test_sockmap_skb_verdict_shutdown();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c b/tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c
new file mode 100644
index 000000000000..1d86a717a290
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c
@@ -0,0 +1,32 @@
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_rx SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_tx SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_msg SEC(".maps");
+
+SEC("sk_skb")
+int prog_skb_verdict(struct __sk_buff *skb)
+{
+	return SK_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.33.0

