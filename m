Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6CD6C3D14
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjCUVxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCUVwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:45 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAAE58C3C;
        Tue, 21 Mar 2023 14:52:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c18so17494129ple.11;
        Tue, 21 Mar 2023 14:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4hZZQ2mIzy3LU2Gpjy5oQ2SLZ1jhZM9Dhcqx1wEiVz8=;
        b=a5fSOkkJYv+0+E8Z0hmI4oaTmUkfo3t+Vi5kPHoT17nd1IKEg8d4sGp1ntUFeHF4bn
         KSf91HSiPyESIJxYsAawXnLjoff0jd6c48lr+5umetF/J4IeWkcqJZ/j75TD0rae+7+i
         ClD9Mv2UblqbefErJw8ym8sv0tVxcJdbbVGqdlTvNXkOWqigF6mtuRRDkNISrB9skDhz
         LVW+8rM8zxo3FlbONwriq7GHO1h9qkVCPyOAUyo/vdUYUQVi0TAVHwl+cG0+mq2+PxFQ
         YAYuWFPH6qW1ntep/vdAEXbYOGQnq3um88aMjwaCLNMKmlpkvszg88a5NUmN4goGumPc
         UCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4hZZQ2mIzy3LU2Gpjy5oQ2SLZ1jhZM9Dhcqx1wEiVz8=;
        b=clT+pgaMAbLOIhxQxCKltnt04ZDzSU+lXX5cVmvSUhWFIe2zO0ofrsPPN2Me4Ai0Pq
         w5DWwktsuBlgCKRuRApu1ev5qGjUfbOou5ZPiYT2rydbZgyVlFdgnBYmRB4Rzktqu+Pi
         F9F9gcSMQiUUhbdGHvvLo7vaH4P0rdu+DMW0/rG65tGFSL89qI8WxNHGZN3oDu/wDYkV
         OcFIW2CaSJXgr7mF5kc8fVDU7KB7A3M8r/bXGg4HDn0I8GZ6+Jw+STWv87jAkagNAyGX
         AFl465jH+7USEczaZN6NZDzbpy5o++Y/InPa6PyfmKRePku8+/PPx/xruiBq75X419vF
         IocA==
X-Gm-Message-State: AO0yUKWJ8/2XgfbizW1SoBEGHTPnZZAtEVfjHF+a+lKGKvS1Y28BkV6E
        hwp21Qt/Yqxpp5NffcWE0Yk=
X-Google-Smtp-Source: AK7set+fdc0fZqq4yFDJHuweU3uPvmhd4ZlYbkPY060kyYg4q7/4VYWqHeGWwKEByPc7IizXZkdBpg==
X-Received: by 2002:a17:903:4306:b0:1a1:dd3a:7512 with SMTP id jz6-20020a170903430600b001a1dd3a7512mr511954plb.21.1679435556032;
        Tue, 21 Mar 2023 14:52:36 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:35 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 10/11] bpf: sockmap, test shutdown() correctly exits epoll and recv()=0
Date:   Tue, 21 Mar 2023 14:52:11 -0700
Message-Id: <20230321215212.525630-11-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230321215212.525630-1-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 71 ++++++++++++++++++-
 .../bpf/progs/test_sockmap_pass_prog.c        | 32 +++++++++
 2 files changed, 100 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 0aa088900699..38a22c71b8dd 100644
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
@@ -286,9 +290,6 @@ static void test_sockmap_skb_verdict_attach(enum bpf_attach_type first,
 	err = bpf_prog_attach(verdict, map, second, 0);
 	ASSERT_EQ(err, -EBUSY, "prog_attach_fail");
 
-	err = bpf_prog_detach2(verdict, map, first);
-	if (!ASSERT_OK(err, "bpf_prog_detach2"))
-		goto out;
 out:
 	test_sockmap_skb_verdict_attach__destroy(skel);
 }
@@ -350,6 +351,68 @@ static void test_sockmap_progs_query(enum bpf_attach_type attach_type)
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
@@ -384,4 +447,6 @@ void test_sockmap_basic(void)
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

