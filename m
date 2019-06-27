Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EDD58BA0
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfF0UY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:24:59 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:38590 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF0UYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:24:48 -0400
Received: by mail-pg1-f202.google.com with SMTP id 3so1897841pgc.5
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CUCPsO3jo98uPWQzYPGBmLbPJQj/PLpHh9qafy5RrRc=;
        b=LnjgvAfDybABi6V7lSQb+wdIq4e6RdOJkUtvtk6sYkCLxLtq5GrRR1+AIAdagnbn2M
         32D60TgTSpoLNVtw4iateRMzPpu3hmdEkGLGGiBeWISyIr0MoIvWGL3QxdSgDgXG62Dy
         aDahwrys2fBFWhS+O6oF86FtlHhyU2ajOd2adaRnF7rHCTIjkzpf9Geu277wjRsmIREb
         0g9+jDvNSSKwpijDljMb/UXHyZ4zV0d3w3ltMhNkgWi4ljmOdAHCmU8nloUJQEMU7ZFa
         LR4usRHay9bY1yH4UgLjVzbLGuEtECeZbP4gxMhdyXxkGko3iYmmIOJPf8PDrQlqKrv+
         69vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CUCPsO3jo98uPWQzYPGBmLbPJQj/PLpHh9qafy5RrRc=;
        b=OAMU0z0Q3QHEdzKNaHYB+OWg814rUABQjckRyRSFIellhFFdNEnfOiaQfTAYhsbX9U
         SdpCZBqERUy8z3QJCO6Y/U7pnv2L/PiV9nac1rZwSHXejH4LkPDXUbV8feGwKyUWmlSi
         GG4SLDOSC+OyOaAmvGRoYjIRHSbPrymuLD53yOnYtC9mHa7evQDHde6cCxvlD9owowz/
         p2lsec6Yro09v8vWZk8+K4lUmvlUc/AOfzAChcq8YBZn08X4IDEpxZk2NQHVymO08JVD
         y6kZjaClO3M3v01oiLR1uceXBZkndSCCyOfzJWPHgoIA0B76K67eyGBngGQY1QpTmCHl
         1d7w==
X-Gm-Message-State: APjAAAXKyUFg1iHPsFxU60rWkbHVNmmYpRe0nmf01WyW5Rwnm5X1/cpP
        5y6FaT9cenNnX7VGgBBzk2Z/4xUrCtVd
X-Google-Smtp-Source: APXvYqw5LFVobnRiRG4j8Gp+4hna/3QYQOr9czsrBS2uV0kVKEFEFbqaE4VvrArgjd55nmb3YFBqnm/mUvoy
X-Received: by 2002:a65:6656:: with SMTP id z22mr5327171pgv.197.1561667087667;
 Thu, 27 Jun 2019 13:24:47 -0700 (PDT)
Date:   Thu, 27 Jun 2019 13:24:17 -0700
In-Reply-To: <20190627202417.33370-1-brianvv@google.com>
Message-Id: <20190627202417.33370-7-brianvv@google.com>
Mime-Version: 1.0
References: <20190627202417.33370-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [RFC PATCH bpf-next v2 6/6] selftests/bpf: add test to measure
 performance of BPF_MAP_DUMP
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
 tools/testing/selftests/bpf/test_maps.c | 71 +++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 3df72b46fd1d9..61050272c20ee 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -18,6 +18,7 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <linux/bpf.h>
+#include <linux/time64.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -376,6 +377,75 @@ static void test_hashmap_dump(void)
 	close(fd);
 }
 
+static void test_hashmap_dump_perf(void)
+{
+	int fd, i, max_entries = 100000;
+	uint64_t key, value, next_key;
+	bool next_key_valid = true;
+	void *buf;
+	u32 buf_len, entries;
+	int j, k = 0;
+	int num_ent, off;
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
+	entries = tests[k];
+	buf_len = elem_size*tests[k];
+	k++;
+	clock_gettime(clk_id, &begin);
+	errno = 0;
+	i = 0;
+	while (errno == 0) {
+		bpf_map_dump(fd, !i ? NULL : &key,
+				  buf, &buf_len);
+		if (errno)
+			break;
+		num_ent = buf_len / elem_size;
+		for (j = 0, off = 0;  j < num_ent; j++) {
+			key = *((uint64_t *)(buf + off));
+			off += sizeof(key);
+			value = *((uint64_t *)(buf + off));
+			off += sizeof(value);
+		}
+		i += num_ent;
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
+	if (k < test_len)
+		goto test;
+	free(buf);
+	close(fd);
+}
+
 static void test_hashmap_zero_seed(void)
 {
 	int i, first, second, old_flags;
@@ -1736,6 +1806,7 @@ static void run_all_tests(void)
 	test_hashmap_walk(0, NULL);
 	test_hashmap_zero_seed();
 	test_hashmap_dump();
+	test_hashmap_dump_perf();
 
 	test_arraymap(0, NULL);
 	test_arraymap_percpu(0, NULL);
-- 
2.22.0.410.gd8fdbe21b5-goog

