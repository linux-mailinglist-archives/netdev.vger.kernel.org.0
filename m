Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB41C2E03E2
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgLVBej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLVBei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 20:34:38 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D42EC061282
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:33:58 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id n127so2626485ooa.13
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aXPD6thwBtqdB4npGpORoLVKTKIlQxrFKyjvobpN53c=;
        b=BH5lx3fMv5x/iAAx0Hg1IbmQ8+NR/Ux+uXz95Fa6ZViUbYXbbnr4TLL7YYIAZRmfNZ
         D31XeN6gztC4HJ1tJ1PdN/MfIpWKIRvQeNBXSK4QimScVZfs9wnPhRxmDkhZ6XXH7Glk
         r/WZHrc14zZ5K3GzsWBSsNm1lyNWEM/Rf+Dvro9FaOJnL7QEPODl0EQMpYK2sJsy9P4a
         FhF8hPkvBhQfulHcWmaabV4PkGG8HiBgN5k6jWXpC32eqNanHLN8jB4k05tfQ3psEA6W
         A44OZ8BXAptKIQQoTdWQARm4QOEEfW9eBSj4g2qfMxENkWT8dehw0vyZU4bKujSn1t7O
         z1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aXPD6thwBtqdB4npGpORoLVKTKIlQxrFKyjvobpN53c=;
        b=sGiSTe6EK8/fyerAjEvfuO8/ezd/ZvAF/2nuiCv13Th+UnMMzZaDyiI0OJEIyDjhWU
         6c+qnJ/ebJH5qDkUzBF2xalAfDW9sOsCKhY+B+mTYJKr/MI0KF9FQHNlwDcDzsopusAc
         evd3P62Cpe2p2I5vLExnebQHJ78blx1KihpYoM4Uu7DomS6DNdy32PsIh4bH1dpBvUqH
         HJqIOPZj2Nhom0uuk8aze2nqDlbjYnMfsYKuae6dl9RPLc0pvxIttjHShzFDZNScZwFw
         WZuhhno75RsNZkLDEvt/y0tYHOCiK2lpDXY+tUzQ7Pi1+P6W3gp0m1baim3vY/TSzwyc
         3dTQ==
X-Gm-Message-State: AOAM5334Bwb7J/nqlAuKPBcKAsT4RaU5nVP35IgQZG2TztYkhYXxXrnY
        1TJJg5PXwXADSdAcqYv/36mjhfaeJ/Y6hA==
X-Google-Smtp-Source: ABdhPJwxqDG7OKODIpAnWiejuy4nuG6Pc78GPR+qV/hGf0ZUayiVNvuBY7TKaHXlTRo5AmXddddlow==
X-Received: by 2002:a4a:9722:: with SMTP id u31mr13278252ooi.28.1608600837846;
        Mon, 21 Dec 2020 17:33:57 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id z14sm4089607oot.5.2020.12.21.17.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 17:33:57 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v3 2/3] selftests/bpf: add test cases for bpf timeout map
Date:   Mon, 21 Dec 2020 17:33:43 -0800
Message-Id: <20201222013344.795259-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222013344.795259-1-xiyou.wangcong@gmail.com>
References: <20201222013344.795259-1-xiyou.wangcong@gmail.com>
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
 tools/testing/selftests/bpf/test_maps.c | 46 +++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 0ad3e6305ff0..19c7c0f64a5d 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -639,6 +639,49 @@ static void test_stackmap(unsigned int task, void *data)
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
+	close(fd);
+}
+
 #include <sys/ioctl.h>
 #include <arpa/inet.h>
 #include <sys/select.h>
@@ -1305,6 +1348,7 @@ static void test_map_stress(void)
 
 	run_parallel(100, test_arraymap, NULL);
 	run_parallel(100, test_arraymap_percpu, NULL);
+	run_parallel(100, test_timeout_map, NULL);
 }
 
 #define TASKS 1024
@@ -1752,6 +1796,8 @@ static void run_all_tests(void)
 	test_stackmap(0, NULL);
 
 	test_map_in_map();
+
+	test_timeout_map(0, NULL);
 }
 
 #define DEFINE_TEST(name) extern void test_##name(void);
-- 
2.25.1

