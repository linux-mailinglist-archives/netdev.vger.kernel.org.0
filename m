Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403622D6C5A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393311AbgLKAHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392435AbgLKAHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 19:07:44 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B392C061794;
        Thu, 10 Dec 2020 16:07:03 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id x13so6703562oto.8;
        Thu, 10 Dec 2020 16:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/i0UI6xFIxF7BfhYNpD6zVF3l23yWAMOLUUOWmnTUdQ=;
        b=pIwbVw3LvA4w48P81cmYpNvtgwZt01k10V6LTOqmM9AShmcEzt0C/bVAEHnywEI4BT
         ZeUSuaOF04y71OzJ9I8LaCjw/B5kiYlU4NiUPSizQZ6NfOfKy9afEuYCSEQNR4Q8iAYR
         A+/4A5LdQYD0sCbXVKtc5U3yvLSmKdaQFTkrMQz65TTUddCc1fOPjsFc1jGS7uNpsCRr
         km9d/Pivg+qLpkWPXctrGiIjFk46JHLI7C4eZjj/59QqNlvHssXNLwsuuYq8h91SuW2z
         DOB86Kq2R0hia9cet6hEDYJaAoWb3CVEIRwqcvhZGtZ4Vabpem7zpRLgl4tpkkEkbYUp
         hXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/i0UI6xFIxF7BfhYNpD6zVF3l23yWAMOLUUOWmnTUdQ=;
        b=A5AXjh8YehYXndMw+6SPcMz2hOJKm1WSWnohzI1gp2sIlz5JsHzbkCe8v4uLDuNgqx
         GvrYj0u7aydst5iHGRXK2YuwHBcSZDxakfPm2Gz8lR3n/Ai2L+ufI73PsQgri0blTg48
         ZMMKVI/2Iuh1vj/Ry0ufTlGqMEvE41hPBEqVkp1OMlqdHg4KWHJXcnsCCbdnp7dCg5d0
         1yA5Al8qRkLn/CM/QPc9Ifpssf8wWnSHRTROKZg+6vxjkQlctlNIXsHSwKd4ZWpHeWCQ
         IHvx/LKlZl88aFrfDAc+BFXNDDAQZtJNfS5BE1hcfx4Joh0aenu7/atJilKcb1tpKElK
         X6cQ==
X-Gm-Message-State: AOAM533ZeN8XNn98SV6gGpD5knKnzbab13ClcmF1OcIAhDSKfgD9tvzl
        2SDsHEHi5AaE+Zpz0RsJfCtKm8RfXDLpUA==
X-Google-Smtp-Source: ABdhPJy6Tz8Fo0n4hIaYhKXV780ApsRo2E4uPGmvvcN0sJTnPpFzd4u4KkIbPqTXUNbvUOD2KLQoCw==
X-Received: by 2002:a9d:7441:: with SMTP id p1mr6939740otk.333.1607645222456;
        Thu, 10 Dec 2020 16:07:02 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4819:cc94:4d6e:dad2])
        by smtp.gmail.com with ESMTPSA id l21sm1543570otd.0.2020.12.10.16.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 16:07:01 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next 3/3] tools: add a test case for bpf timeout map
Date:   Thu, 10 Dec 2020 16:06:49 -0800
Message-Id: <20201211000649.236635-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
References: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

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

