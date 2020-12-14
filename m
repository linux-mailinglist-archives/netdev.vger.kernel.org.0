Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D8E2DA137
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503098AbgLNUNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503085AbgLNUMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:12:25 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393CDC0617A6;
        Mon, 14 Dec 2020 12:11:35 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id y24so17031356otk.3;
        Mon, 14 Dec 2020 12:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o9Y3t8Nk2w6YOn+aCane90NBqrXU64pdv9z0KzYNQcM=;
        b=SKBHBLM5dDCb3JwuEfm+9iWPJnpkves4bhwMH4UENFEtBD1HsOtOFVouipB+HRHMFL
         LJag3tkLsWADTymPPEmypNx+9gTFTz7SvhbFUQJkNJGCigI82hh0pJAAA1+cePKq+FK2
         T/JvMiCmF52feBh+8ShF5z265q7asjFdRKt9nSOw1iuTX88nzuTtF7DU3ohKO0wZvyI6
         UYxjiBaex32AzfXsL5WEF55/g+oV2mP/Lw3aAvJAHdlwb4VuIllHzbF31V5PRU7j4FGW
         blKh3/tOkwq5jNC5aeXxYDqsFH8M9lq2jSEw1RhLevZLiV1cjNBmy0BeGr16FdDxYvip
         BGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o9Y3t8Nk2w6YOn+aCane90NBqrXU64pdv9z0KzYNQcM=;
        b=LbzzPCuVy6AxtfABml9jWTgsLFZCff1fxm/iB4AxzW9ThSBzeHXGxYr1R38EHqUTBQ
         IswCaPetuWE2SzyXREzW/lNCWxZeeVBIj8rBJpjDhKj4B6eFVROGlOv4GUnrJ6H7fCkA
         Lcgdqd/iPvKYq3clzjAPL6uQsyI+bFdhDNUxMr9+KsUSzERAuoE7YCEMGLnkzI+xnuje
         3BHIXkz8Sni+qhBGm7Bjt6KjKPHso/KeXWmDOah51u+jC536eUOI9jr8AcNeWFfxy8Sw
         OteusZ1hPNFMntG/jNqaEqKyDcgnyF29u11WnyfkGBKFa21LHYGEJpg4Myy9hCfS72JJ
         Ehaw==
X-Gm-Message-State: AOAM53200C2s5jY7o9QiXxVzx/MQbPSZghzS1tVF6FU0v8p6dSMbUQk7
        BddRfrKZuNtoVyvCDqvLlTPJydelxxOrVQ==
X-Google-Smtp-Source: ABdhPJzzF+vFqL72EuNuS3aPwTru5+b6OBGT8hh3HicI2PU72klrBS8onnVhAcKcYD1dRj8NPFEQ3g==
X-Received: by 2002:a05:6830:118b:: with SMTP id u11mr21016023otq.130.1607976694404;
        Mon, 14 Dec 2020 12:11:34 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id h26sm3905850ots.9.2020.12.14.12.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:11:33 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v2 4/5] selftests/bpf: add a test case for bpf timeout map
Date:   Mon, 14 Dec 2020 12:11:17 -0800
Message-Id: <20201214201118.148126-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Add a test case in test_maps.c for timeout map, which focuses
on testing timeout.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 tools/testing/selftests/bpf/test_maps.c | 41 +++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 0ad3e6305ff0..9fc7b5424fdf 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1723,6 +1723,45 @@ static void test_reuseport_array(void)
 	close(map_fd);
 }
 
+static void test_timeout_map(void)
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
+	assert(bpf_map_update_elem(fd, &key1, &val1, (u64)1<<32) == 0);
+	/* Timeout after 2 secs */
+	assert(bpf_map_update_elem(fd, &key2, &val2, (u64)2<<32) == 0);
+	/* Timeout after 10 secs */
+	assert(bpf_map_update_elem(fd, &key3, &val3, (u64)10<<32) == 0);
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
+	assert(bpf_map_update_elem(fd, &key3, &val3, (u64)1<<32) == 0);
+	sleep(1);
+	assert(bpf_map_lookup_elem(fd, &key3, &val3) != 0);
+
+	close(fd);
+}
+
 static void run_all_tests(void)
 {
 	test_hashmap(0, NULL);
@@ -1752,6 +1791,8 @@ static void run_all_tests(void)
 	test_stackmap(0, NULL);
 
 	test_map_in_map();
+
+	test_timeout_map();
 }
 
 #define DEFINE_TEST(name) extern void test_##name(void);
-- 
2.25.1

