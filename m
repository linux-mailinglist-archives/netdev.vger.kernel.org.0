Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0A073464
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbfGXQ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:58:45 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:41089 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387631AbfGXQ6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:58:42 -0400
Received: by mail-pg1-f202.google.com with SMTP id b18so28691213pgg.8
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 09:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IGj/M+6U995Y52IjNEaLV6LDl7AzZ6dG3QadQeE37S0=;
        b=oUJf1bx45jmFQxsX5BUA7N5crPP1ky/I4ydMP3+NZjrKcZ4IYQv4NSrYFZBPh3ba0O
         KUW1JA/XDot9TQDgD/EvsU9/6KMH52NYJD8iaa4EOdbMpnGsL6uni6HvqR4DMzOwNwio
         N8yHR4BK5WrbGWJK9M4mePqRz7Wm3KIjGMGXT/W9N81Sxaa5dfxA8oNe7rhc79J2bIPh
         wGFiZme9haD7UKM+LZj8frc9mP3ygbLlM4Fo9CjVF+6ZEbYfWG3sLl8oOqUnaYmLHL5D
         xo5t97SRL2RDscENQ7xblfMyvHnihOW0px4qIhxJVR+kZby+J9MPvDefXh/0ONgDkIn6
         3wKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IGj/M+6U995Y52IjNEaLV6LDl7AzZ6dG3QadQeE37S0=;
        b=HGVr+c32abdtfIn+t6yJeHX18aW0f7QbwdsxU6U/IV8fGzID8/rM50bFfXl3xerOCx
         X/eCKjxyy27pvvEBGD6tn1jfmx0lpgrqvd4c5Bay17Z0psvUKddJi0UtEJfPslcshNpA
         7n+vqzhbpelMn/crRe4mNjG+GqgfOBDuFQ3WOl1vLUGGeKJ9GyIriGA5cZF5jUqGiZdr
         wqKW61nPzl1aXmmDCrYWgB1TaZ1n8Xfx9fSolKRH7K6dtfi4EZj9zPix8LQjDH6qp7Et
         WiQ6Nq2RdL/A4v68QdKoemHziZhkldvLgKlNMzUZvf712qhJpLW/t9/FRItZBaEuttr8
         D0uA==
X-Gm-Message-State: APjAAAUndYIksEw/t36TOaK0kWCoo2X7D4l2gwNa0CIbVs06ubQvVym9
        Byq0ofDZJ9i1mpOsGT7p40iOxAptC/8N
X-Google-Smtp-Source: APXvYqxbKxLxrhzXjYCucyVFxZ24iwUfubUGnAiPkh3hmQBII0u/pLXrbRWzMfSy+YCD5R9UAeHnyTFZA0Z4
X-Received: by 2002:a63:1455:: with SMTP id 21mr38502725pgu.116.1563987520966;
 Wed, 24 Jul 2019 09:58:40 -0700 (PDT)
Date:   Wed, 24 Jul 2019 09:58:03 -0700
In-Reply-To: <20190724165803.87470-1-brianvv@google.com>
Message-Id: <20190724165803.87470-7-brianvv@google.com>
Mime-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 6/6] selftests/bpf: add test to measure performance
 of BPF_MAP_DUMP
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests compares the amount of time that takes to read an entire
table of 100K elements on a bpf hashmap using both BPF_MAP_DUMP and
BPF_MAP_GET_NEXT_KEY + BPF_MAP_LOOKUP_ELEM.

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 tools/testing/selftests/bpf/test_maps.c | 65 +++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index f7ab401399d40..c4593a8904ca6 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -18,6 +18,7 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <linux/bpf.h>
+#include <linux/time64.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -389,6 +390,69 @@ static void test_hashmap_dump(void)
 	close(fd);
 }
 
+static void test_hashmap_dump_perf(void)
+{
+	int fd, i, max_entries = 100000;
+	uint64_t key, value, next_key;
+	bool next_key_valid = true;
+	void *buf;
+	u32 buf_len, entries;
+	int j = 0;
+	int clk_id = CLOCK_MONOTONIC;
+	struct timespec begin, end;
+	long long time_spent, dump_time_spent;
+	double res;
+	int tests[] = {1, 2, 230, 5000, 73000, 100000, 234567};
+	int test_len = ARRAY_SIZE(tests);
+	const int elem_size = sizeof(key) + sizeof(value);
+
+	fd = helper_fill_hashmap(max_entries);
+	// Alloc memory considering the largest buffer
+	buf = malloc(elem_size * tests[test_len-1]);
+	assert(buf != NULL);
+
+test:
+	entries = tests[j];
+	buf_len = elem_size*tests[j];
+	j++;
+	clock_gettime(clk_id, &begin);
+	errno = 0;
+	i = 0;
+	while (errno == 0) {
+		bpf_map_dump(fd, !i ? NULL : &key,
+				  buf, &buf_len);
+		if (errno)
+			break;
+		if (!i)
+			key = *((uint64_t *)(buf + buf_len - elem_size));
+		i += buf_len / elem_size;
+	}
+	clock_gettime(clk_id, &end);
+	assert(i  == max_entries);
+	dump_time_spent = NSEC_PER_SEC * (end.tv_sec - begin.tv_sec) +
+			  end.tv_nsec - begin.tv_nsec;
+	next_key_valid = true;
+	clock_gettime(clk_id, &begin);
+	assert(bpf_map_get_next_key(fd, NULL, &key) == 0);
+	for (i = 0; next_key_valid; i++) {
+		next_key_valid = bpf_map_get_next_key(fd, &key, &next_key) == 0;
+		assert(bpf_map_lookup_elem(fd, &key, &value) == 0);
+		key = next_key;
+	}
+	clock_gettime(clk_id, &end);
+	time_spent = NSEC_PER_SEC * (end.tv_sec - begin.tv_sec) +
+		     end.tv_nsec - begin.tv_nsec;
+	res = (1-((double)dump_time_spent/time_spent))*100;
+	printf("buf_len_%u:\t %llu entry-by-entry: %llu improvement %lf\n",
+	       entries, dump_time_spent, time_spent, res);
+	assert(i  == max_entries);
+
+	if (j < test_len)
+		goto test;
+	free(buf);
+	close(fd);
+}
+
 static void test_hashmap_zero_seed(void)
 {
 	int i, first, second, old_flags;
@@ -1758,6 +1822,7 @@ static void run_all_tests(void)
 	test_hashmap_walk(0, NULL);
 	test_hashmap_zero_seed();
 	test_hashmap_dump();
+	test_hashmap_dump_perf();
 
 	test_arraymap(0, NULL);
 	test_arraymap_percpu(0, NULL);
-- 
2.22.0.657.g960e92d24f-goog

