Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83106DB170
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjDGRRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjDGRRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:17:32 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5218EAD25;
        Fri,  7 Apr 2023 10:17:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id ix20so40510758plb.3;
        Fri, 07 Apr 2023 10:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680887834; x=1683479834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnWen7kjqNC6BHyX2tSKhXwmBzaOl/pAI54Si9NYoD0=;
        b=MGKYJVE6lMsulGz7Cs53t/EWULxOicqCFOYfUsX6NSMVzy7c9gCN9e96xf1Bgtf9ua
         07HFKYioTZwqaZ3zA6Js+1uvWJ0SmHznS+JaZE+Yh2HlLnBejKUxTevq4rx3w4KqmLei
         7hXK66jYw3RZMSCkuh9bUBUif6EOdwIKChymLvZF8yBD79GXMlP27uwWndX2DqzuMjjh
         5L73nHRo8ACy7cTZQiIHg2J7K59d89dKYdLcPTJr2RJygRyMN+x49C6YP9Sm3N0nkJUH
         lSxrY/8KBquBB/P46EzHTCIFq5fETQ4/SQs9EPtrJW+22GugUMFCkUdlczlEt0jBECI/
         B15A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680887834; x=1683479834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnWen7kjqNC6BHyX2tSKhXwmBzaOl/pAI54Si9NYoD0=;
        b=TEXGijOBGc3KCWigBTxvPxWOBoRvmpt/0kbU69oCmcJTdaW0XJ6E6i1uxGtBiSi3iT
         uY2GGOFbBDoF7icIs8jkS2uuccn4oSpEijeij+eIxWLVUa0pcfZK7QyyJ+RZUn3d59Vt
         az6R3ZVOIZJlpjr9jaz7dUMH3hb8zGpiM5nkeznNCbaYnOdHVP+4WtTGhpm/nNPwvifJ
         Me5JYUlXgBBABkbUuQ+0LqW2tBedBTnwc3p0iJET6lOt62muZwFQSgl0HsHdaCWTPq36
         I3wXIqK6O1lgr/2poOztoAKbYccfRJsWKmA0ymgaKFbbCqQwKu4+tRe2zewOELK9BBq9
         Zrnw==
X-Gm-Message-State: AAQBX9etRCa9iOdZJjm2ULH3oM3zNoK5M2SP3thAwujfIahcFLg1+Gpl
        tdbIy7feqWD0vb9zYyyc4eBBxe8WB34=
X-Google-Smtp-Source: AKy350ZGRtOxpEyjxuCrmNqWq4xJDSCp2rK2OsgzqZPvCUfRgkdgb6W8AfulSajvh9ottwBlFZrynw==
X-Received: by 2002:a17:902:ce8c:b0:19f:e9e7:4cb with SMTP id f12-20020a170902ce8c00b0019fe9e704cbmr3664742plg.45.1680887834723;
        Fri, 07 Apr 2023 10:17:14 -0700 (PDT)
Received: from john.lan ([98.97.116.126])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709028a8100b0019b0937003esm3185425plo.150.2023.04.07.10.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 10:17:14 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v6 10/12] bpf: sockmap, test shutdown() correctly exits epoll and recv()=0
Date:   Fri,  7 Apr 2023 10:16:52 -0700
Message-Id: <20230407171654.107311-11-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230407171654.107311-1-john.fastabend@gmail.com>
References: <20230407171654.107311-1-john.fastabend@gmail.com>
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

