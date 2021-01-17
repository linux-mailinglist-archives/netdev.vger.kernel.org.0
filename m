Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAB22F906B
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 05:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbhAQEXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 23:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbhAQEXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 23:23:21 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257F3C061575;
        Sat, 16 Jan 2021 20:22:41 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id 34so2106661otd.5;
        Sat, 16 Jan 2021 20:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wM+spvP29mz4ZWD9AjIFNRY5IWLk+XxdpQKy6IXwsy4=;
        b=Efz4ZMFSW16RIsCIQxz/wNM5l1r2HB4rc2niPTQBOYcV16lgfHr2KZcEpem0elc77w
         gB4IS/aX+0s3L6lvOBEukuUlt6/zh8X85Yz1hLAvvSg4CjjAluxIIxj0eexQmTOYieeR
         mXFVKqBgHx6m7kBhPCRBLYH8hHT1C9TnqDjOwOHIx5/q9RktHUQtS3ZzaAfjrdMjk5s6
         1xCfXcpHZvwylfBACwrwlHFDwNgtFYSg2xZWxiHvBzo+onunZjedjPxDQYjguuSWRHE+
         RpGNvAXDujQGYmSIdzdMZCkr2ZU/Z8qJ4gV8OngwkBI2Crqsc6Ye9mfyoXFsUd1T5cAv
         ANww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wM+spvP29mz4ZWD9AjIFNRY5IWLk+XxdpQKy6IXwsy4=;
        b=UgfyqdBhHS8oDiqmnxW8RcRRwzaHa9xO6DQT0DB3Uqs3+qKkwt0uKT6Q1jbICimoWU
         UYnrIBvjtriq96juDtAEf4CkRt+PoqB+4dCxeLUi82P5rfULuCbeMhsDOc7PpLXJrU77
         vngC9HJHowhXXBfDaF1W0MRZasxtY9A+0/qJvKWIWSSemCGGrFcM7tmLPemrko4QX/Ue
         U4pcr7nlAqp3jcGCEfQ2/Nfqie8JiF5+XL7NHyJ78zz+aSPwNRuhGM+AwECwiWbXbSpv
         IuWGY6Pn+DPiliDbIlgKl4Bm5Xs8hqjqHTtIJNaglBKxnEPAA6tie+FO3Lumd3PD5V+N
         ZwOg==
X-Gm-Message-State: AOAM532MKZTDdqb6Fn00wngdcStOStKc/HMgBwXF+BwmKR4ePUVElJ58
        hOJhllzd923+GBwXQEKY3rUc7mq4k+tKhw==
X-Google-Smtp-Source: ABdhPJxVwxiNgcdyUhTQNBu4r8E/7uJYyYSzJisMT1mcUbeGD3GOfBSLhMd7CX263EsmVRzpoaV3EQ==
X-Received: by 2002:a9d:372:: with SMTP id 105mr13386480otv.118.1610857360407;
        Sat, 16 Jan 2021 20:22:40 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id l8sm537444ota.9.2021.01.16.20.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 20:22:39 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v4 2/3] selftests/bpf: add test cases for bpf timeout map
Date:   Sat, 16 Jan 2021 20:22:23 -0800
Message-Id: <20210117042224.17839-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210117042224.17839-1-xiyou.wangcong@gmail.com>
References: <20210117042224.17839-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Add some test cases in test_maps.c for timeout map, which focus
on testing timeout.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 tools/testing/selftests/bpf/test_maps.c | 47 +++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 51adc42b2b40..5e443d76512b 100644
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
-- 
2.25.1

