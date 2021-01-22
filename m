Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90982300E5F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 21:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbhAVU5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 15:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730831AbhAVUzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:55:13 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BC2C061786;
        Fri, 22 Jan 2021 12:54:33 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id x137so6250329oix.11;
        Fri, 22 Jan 2021 12:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nYq626qG3iPZ8mDSqFFjj9nxHU5At0ReYF42/qIrow0=;
        b=DCBJJHvDe4bD5Ts3xqg0loaxnKTefbV6eXf7xb1hJ5CBabgE+ReGB/q1SBfLWBa4V/
         ej1Jidj6diIRIIcZxKJntLYhKoGYyv1ObVYgc6Nvik2FpzaB1a9tSFuGffUS6VIMhggK
         ZvQdzQC5alzDxETHy4VOfgyQNKZFJClVbKkNic6ChIgIUlII+S9qrxYfKXgL6XbrSWnS
         X6o5Fgi7koQaGR4SBSh0sMlsF5ytpi17ns76QHzTc3eo3FKklQGn6eyzh/2P80yzCG1H
         W2z/663hRibQgl0sMT2YF19VDwyH9K65wMpPF92WY+CvpLWKuY2YUAvp3WAwPfNl8BhO
         bVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nYq626qG3iPZ8mDSqFFjj9nxHU5At0ReYF42/qIrow0=;
        b=btoTWb7Qd3xRqnIGFvLwcfTD/Sb7x2+cWzyqPrzPAJlNchhce+cZYps5tlb/GvpeSY
         AhkO83GMwohba+ejgPP6CDIcMuj7zNR7K02+swVBykb24k7lLZSbmJ+MUztT+jVPHJWT
         /XYPfIvGwdgXf8vqsM9odh5SxC5QND5EnauS/LjrtLCdTlsjSMb8xxFVZ0MMSYuwx/hl
         O/2XQ8FVnnyvghrwFmtCGAnLdhiTNc2Q+5BhKWpoh0njUzaGA9QmknFJAjyoYu2eRlcz
         aXjbB515K0GOVmykKPkSNig36FX/naEirSBzCeHs18Qlm5gtpwlkd9QoqEWvak+k3T77
         U06Q==
X-Gm-Message-State: AOAM533Z28JYzyVsYoEJvYONHvA7h+GX+g0HTMUqnfywr+xliUdXwE9p
        d3Dmj3FLyqLLFtH8hLSAJajr+ZGiTJArEQ==
X-Google-Smtp-Source: ABdhPJxHmUm9+lfgTdBg4MRseeoE/oJZL/GInrjmqGTi1OLnZS5CNNJSHivoKEd78Qs7v2zePq8juA==
X-Received: by 2002:aca:3f07:: with SMTP id m7mr4391473oia.104.1611348872763;
        Fri, 22 Jan 2021 12:54:32 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id k18sm1349193otj.36.2021.01.22.12.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 12:54:32 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jhs@mojatatu.com, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        Cong Wang <cong.wang@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v5 2/3] selftests/bpf: add test cases for bpf timeout map
Date:   Fri, 22 Jan 2021 12:54:14 -0800
Message-Id: <20210122205415.113822-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Add some test cases in test_maps.c for timeout map, which focus
on testing timeout. The parallel tests make sure to catch race
conditions and the large map test stresses GC.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 tools/testing/selftests/bpf/test_maps.c | 68 +++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 51adc42b2b40..58b4712a0f98 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -639,6 +639,52 @@ static void test_stackmap(unsigned int task, void *data)
 	close(fd);
 }
 
+static void test_timeout_map(unsigned int task, void *data)
+{
+	int val1 = 1, val2 = 2, val3 = 3;
+	int key1 = 1, key2 = 2, key3 = 3;
+	int fd;
+
+	fd = bpf_create_map(BPF_MAP_TYPE_TIMEOUT_HASH, sizeof(int), sizeof(int),
+			    3, map_flags);
+	if (fd < 0) {
+		printf("Failed to create timeout map '%s'!\n", strerror(errno));
+		exit(1);
+	}
+
+	/* Timeout after 1 secs */
+	assert(bpf_map_update_elem(fd, &key1, &val1, (u64)1000<<32) == 0);
+	/* Timeout after 2 secs */
+	assert(bpf_map_update_elem(fd, &key2, &val2, (u64)2000<<32) == 0);
+	/* Timeout after 10 secs */
+	assert(bpf_map_update_elem(fd, &key3, &val3, (u64)10000<<32) == 0);
+
+	sleep(1);
+	assert(bpf_map_lookup_elem(fd, &key1, &val1) != 0);
+	val2 = 0;
+	assert(bpf_map_lookup_elem(fd, &key2, &val2) == 0 && val2 == 2);
+
+	sleep(1);
+	assert(bpf_map_lookup_elem(fd, &key1, &val1) != 0);
+	assert(bpf_map_lookup_elem(fd, &key2, &val2) != 0);
+
+	/* Modify timeout to expire it earlier */
+	val3 = 0;
+	assert(bpf_map_lookup_elem(fd, &key3, &val3) == 0 && val3 == 3);
+	assert(bpf_map_update_elem(fd, &key3, &val3, (u64)1000<<32) == 0);
+	sleep(1);
+	assert(bpf_map_lookup_elem(fd, &key3, &val3) != 0);
+
+	/* Add one elem expired immediately and try to delete this expired */
+	assert(bpf_map_update_elem(fd, &key3, &val3, 0) == 0);
+	assert(bpf_map_delete_elem(fd, &key3) == -1 && errno == ENOENT);
+
+	/* Add one elem and let the map removal clean up */
+	assert(bpf_map_update_elem(fd, &key3, &val3, (u64)10000<<32) == 0);
+
+	close(fd);
+}
+
 #include <sys/ioctl.h>
 #include <arpa/inet.h>
 #include <sys/select.h>
@@ -1305,6 +1351,7 @@ static void test_map_stress(void)
 
 	run_parallel(100, test_arraymap, NULL);
 	run_parallel(100, test_arraymap_percpu, NULL);
+	run_parallel(100, test_timeout_map, NULL);
 }
 
 #define TASKS 1024
@@ -1759,6 +1806,25 @@ static void test_reuseport_array(void)
 	close(map_fd);
 }
 
+static void test_large_timeout_map(int nr_elems)
+{
+	int val, key;
+	int i, fd;
+
+	fd = bpf_create_map(BPF_MAP_TYPE_TIMEOUT_HASH, sizeof(int), sizeof(int),
+			    nr_elems, map_flags);
+	if (fd < 0) {
+		printf("Failed to create a large timeout map '%s'!\n", strerror(errno));
+		exit(1);
+	}
+	for (i = 0; i < nr_elems; i++) {
+		key = val = i;
+		/* Timeout after 10 secs */
+		assert(bpf_map_update_elem(fd, &key, &val, (u64)10000<<32) == 0);
+	}
+	close(fd);
+}
+
 static void run_all_tests(void)
 {
 	test_hashmap(0, NULL);
@@ -1788,6 +1854,8 @@ static void run_all_tests(void)
 	test_stackmap(0, NULL);
 
 	test_map_in_map();
+
+	test_large_timeout_map(1000000);
 }
 
 #define DEFINE_TEST(name) extern void test_##name(void);
-- 
2.25.1

