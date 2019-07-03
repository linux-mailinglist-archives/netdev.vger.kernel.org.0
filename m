Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC9E5E9F0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfGCRCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:02:21 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:35049 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbfGCRCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:02:19 -0400
Received: by mail-qk1-f201.google.com with SMTP id 5so3789264qki.2
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 10:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ld5qNoKshdyRmavLPGoPc6BR++OK/w6IRlR9/ebcOn4=;
        b=TZrCGi3jcqjHluRGRqVScSH3nnF0ngfzc7kFNydCQYZVuwuUp9YebJ1FMq1bxqWMB2
         tHhtCnnfbK7nhfIkJVSbdsly1Sb2uJEw63ORMMbMjGr+rgwFeja8VYmU9bIvdijewmMB
         skRF5jPJjA2NhKt8fyeSp1jCTaAEYa1NkzzKxF1iRkEaRFI3/EQRfY+F+d+TlRIsPdAv
         IzoPvqZd+U6VyoEB4zaqJQ0v0zehg1PHAldRx3VPq/5pID7CAoImHt+9f8+LdaSB4iK/
         jfZo3e5+EO4pm+3WJra8HHkX2pcDrI7PQWAwwDh+lDqqDiUn/6Y+hvW1lnoMzw3cM47K
         dJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ld5qNoKshdyRmavLPGoPc6BR++OK/w6IRlR9/ebcOn4=;
        b=Xx92DqlaWzJjAdaWVp4u458vX+Rq27P4B+uQz39/h69HJQ6KoVK39+lMJG6ACpiJv1
         /ymMYUF3nKlo11JKTle0AS66FcEMo0EU/3BLGml16SJInkkCld9VLZeqxmvDKSjtdPuP
         hHDRGkLSb7EbLXYNCaj44toU41joakAJyZGC0WtpHKHJyYzLctVDxscXV0WVIKmDJGIU
         AwjsKj2u3i8LeadyeQAIYNscKlyD79/rNMLwOQC8tNumLgGN83va5A5Od55MqdlBDunG
         Py0/oJO16R2CFYp0beJ5bamWgK8ObVy/mYw+kbziKGCBR5AVIfWgT2LzSHicHu7vnB2P
         JbAQ==
X-Gm-Message-State: APjAAAUIDmwVBT5v50SI39RtTvY2KnDA7C07UptKiD2/v6Vt9LhIg1ns
        iV7GQQxSm4bkmHSTQaFldVi53IKTDA+6
X-Google-Smtp-Source: APXvYqzUJWgXSVAR31qVHYmLDhXP3MkV6i2uPSVDio5Wx5fkOVznYsw7k/Ij5SbCILaDCrihlPc/nePm9qGy
X-Received: by 2002:ac8:6958:: with SMTP id n24mr32368355qtr.360.1562173338277;
 Wed, 03 Jul 2019 10:02:18 -0700 (PDT)
Date:   Wed,  3 Jul 2019 10:01:18 -0700
In-Reply-To: <20190703170118.196552-1-brianvv@google.com>
Message-Id: <20190703170118.196552-7-brianvv@google.com>
Mime-Version: 1.0
References: <20190703170118.196552-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next RFC v3 6/6] selftests/bpf: add test to measure
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
 tools/testing/selftests/bpf/test_maps.c | 65 +++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index b19ba6aa8e36..786d0e340aed 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -18,6 +18,7 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <linux/bpf.h>
+#include <linux/time64.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -388,6 +389,69 @@ static void test_hashmap_dump(void)
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
@@ -1748,6 +1812,7 @@ static void run_all_tests(void)
 	test_hashmap_walk(0, NULL);
 	test_hashmap_zero_seed();
 	test_hashmap_dump();
+	test_hashmap_dump_perf();
 
 	test_arraymap(0, NULL);
 	test_arraymap_percpu(0, NULL);
-- 
2.22.0.410.gd8fdbe21b5-goog

