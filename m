Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29FC4F10F
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 01:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfFUXRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 19:17:15 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:37981 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfFUXRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 19:17:14 -0400
Received: by mail-pl1-f201.google.com with SMTP id s22so4438480plp.5
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 16:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CUCPsO3jo98uPWQzYPGBmLbPJQj/PLpHh9qafy5RrRc=;
        b=HZK8KCjJImIc7GaiInhM8ZZ/258RRA2Voe62DwCyvpjD8nA7Lw/bF+G4AkFymv2J6v
         O7aN1jKPiR4BSV3MHpXtCQchPzekAqEtrsrSXMZfEF5kKtBtAiBUpFktqslwp1aJMqUX
         E5jnTKGOvXz2fg6ObmERGenqiVYoud3ya1wWGbtPyHaNRaMr8OxpgHkLZdLBgNieLfP3
         Z8AFI3kiGPnMKMGfrneLKhxmNMx7qKiqNYEyvt5vS3gmr72hAOChLjr5v6wHm31VXaKo
         UiwoHxYa2hylnNqTX5YodwEF8MnkzhI5rcM9iJMrIu7Xxol/q/jD2wRVLRopeaoCZJAx
         dnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CUCPsO3jo98uPWQzYPGBmLbPJQj/PLpHh9qafy5RrRc=;
        b=PXl6zowlGGPkZIrJ0jHI+69FOMMuk/7zVc0jcR+GfO+uTIjuyoeCOk8RkKWE6BhfXQ
         lWYYde171fZ9fH2nie5OEo9nGIAOj9B4cnyoMBqoom+Q0EQfg3YWPuACcsGhAq4KdaG/
         WxL5iImqVpCVHLthyNohsykGWgNioImQ+ezzY3ecPipDkRNhNT8IZJsha8HzNKVAcOfS
         wKbQFqSXYtnPjC1odZOGWlas16NzCPVeIu8f6VcWp/gNEB/SurYfRqAs8z013ZHHMRm1
         a8hhixIU+dCCRRvfC7swc1AClzkExIGdZHXURp1gOUVBQyZzXf+NYla+1pHNfWus59FI
         cAhA==
X-Gm-Message-State: APjAAAXpjoXCVT90+PDL2zNrH+F3y5eXB+q3BzUncu8ubvo+FX5h8JiJ
        /H0sWI1TJE4WO/C7pmqYMisLUfDcHqnV
X-Google-Smtp-Source: APXvYqwFBmSJsBUFYd6ijdvz1XM4mXf7aPBuGASZP0bhWfFcnZlAzKCOnLFVEX3C8DsDYoYO/r1RMEZFS0AV
X-Received: by 2002:a63:3f48:: with SMTP id m69mr20448994pga.17.1561159033052;
 Fri, 21 Jun 2019 16:17:13 -0700 (PDT)
Date:   Fri, 21 Jun 2019 16:16:50 -0700
In-Reply-To: <20190621231650.32073-1-brianvv@google.com>
Message-Id: <20190621231650.32073-7-brianvv@google.com>
Mime-Version: 1.0
References: <20190621231650.32073-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [RFC PATCH 6/6] selftests/bpf: add test to measure performance of BPF_MAP_DUMP
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

