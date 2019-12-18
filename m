Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772CC124963
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfLROXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:23:36 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39082 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLROXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:23:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so2503049wrt.6;
        Wed, 18 Dec 2019 06:23:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0648WLJ82wK9ljqDtuvQ+IQPq2epp7f6MQG1HLhoxxI=;
        b=jlzU+psoeGDNBo16bviJSP05I3AFUMWfkGq9NrTJr4js9H/kfpVL35se7e2FrWEbow
         cIsjw3V4CxuPKeCzD/WX2vueZsN7kihJCF6eDGh7LHrWbUWrK/qjxjsIOHuXsKwmr25q
         176c1Egids+U5gWXp27cTuDWcgRjd/n8sxMXqZfl5i2sNcFtc4G8iSnRs22GhsnjZwcM
         QQ2Uet7aGfKP5lBJ4qj3TDqH/W0sESgPAVSH4lLUKu4ZPSd2uPZLIYCLxvtz8Y/+W5Y6
         +I4ITE1cUDUGha6lyHCCDGxk5WSyEKqymElnwOmi028SjsrxuQeT/w25nHtZrLCJWP/8
         cygw==
X-Gm-Message-State: APjAAAWOjkfS3TXJD32FtbwSQ0moqxolGUGeipOoA39Wbnb5lzqX5hH/
        BEqQLaJ5o+bi9Bz3Q4It+AA=
X-Google-Smtp-Source: APXvYqzR5ZZzkiyAedJ/bMBW1pBSy39v2omcSjXnAkrZ3BrC3GD0n6BqcSNN9aH1EykVl8FIbn/nBQ==
X-Received: by 2002:adf:ce87:: with SMTP id r7mr3074706wrn.245.1576679014538;
        Wed, 18 Dec 2019 06:23:34 -0800 (PST)
Received: from Omicron ([217.76.31.1])
        by smtp.gmail.com with ESMTPSA id d14sm2929307wru.9.2019.12.18.06.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:23:34 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:23:33 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 2/3] selftests/bpf: Tests for single-cpu updates of
 per-cpu maps
Message-ID: <d922ded45e0d3a76e918e1eed0426d3743d20f0d.1576673843.git.paul.chaignon@orange.com>
References: <cover.1576673841.git.paul.chaignon@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1576673841.git.paul.chaignon@orange.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds test cases for single-cpu updates of per-cpu maps.  It
updates values for the first and last CPUs and checks that only their
values were updated.

Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 tools/testing/selftests/bpf/test_maps.c | 34 ++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 02eae1e864c2..e3d3b15e1b91 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -150,6 +150,7 @@ static void test_hashmap_percpu(unsigned int task, void *data)
 	BPF_DECLARE_PERCPU(long, value);
 	long long key, next_key, first_key;
 	int expected_key_mask = 0;
+	long new_value = 42;
 	int fd, i;
 
 	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_HASH, sizeof(key),
@@ -232,6 +233,23 @@ static void test_hashmap_percpu(unsigned int task, void *data)
 	key = 1;
 	assert(bpf_map_update_elem(fd, &key, value, BPF_EXIST) == 0);
 
+	/* Update value for a single CPU. */
+	assert(bpf_map_update_elem(fd, &key, &new_value,
+				   BPF_NOEXIST | BPF_CPU) == -1 &&
+	       errno == EEXIST);
+	assert(bpf_map_update_elem(fd, &key, &new_value,
+				   ((__u64)nr_cpus) << 32 | BPF_CPU) == -1 &&
+	       errno == EINVAL);
+	assert(bpf_map_update_elem(fd, &key, &new_value,
+				   BPF_EXIST | BPF_CPU) == 0);
+	assert(bpf_map_update_elem(fd, &key, &new_value,
+				   (nr_cpus - 1ULL) << 32 | BPF_CPU) == 0);
+	assert(bpf_map_lookup_elem(fd, &key, value) == 0);
+	assert(bpf_percpu(value, 0) == new_value);
+	for (i = 1; i < nr_cpus - 1; i++)
+		assert(bpf_percpu(value, i) == i + 100);
+	assert(bpf_percpu(value, nr_cpus - 1) == new_value);
+
 	/* Delete both elements. */
 	key = 1;
 	assert(bpf_map_delete_elem(fd, &key) == 0);
@@ -402,6 +420,7 @@ static void test_arraymap_percpu(unsigned int task, void *data)
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	BPF_DECLARE_PERCPU(long, values);
 	int key, next_key, fd, i;
+	long new_value = 42;
 
 	fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
 			    sizeof(bpf_percpu(values, 0)), 2, 0);
@@ -449,8 +468,21 @@ static void test_arraymap_percpu(unsigned int task, void *data)
 	assert(bpf_map_get_next_key(fd, &next_key, &next_key) == -1 &&
 	       errno == ENOENT);
 
-	/* Delete shouldn't succeed. */
+	/* Update value for a single CPU */
 	key = 1;
+	assert(bpf_map_update_elem(fd, &key, &new_value,
+				   ((__u64)nr_cpus) << 32 | BPF_CPU) == -1 &&
+	       errno == EINVAL);
+	assert(bpf_map_update_elem(fd, &key, &new_value, BPF_CPU) == 0);
+	assert(bpf_map_update_elem(fd, &key, &new_value,
+				   (nr_cpus - 1ULL) << 32 | BPF_CPU) == 0);
+	assert(bpf_map_lookup_elem(fd, &key, values) == 0);
+	assert(bpf_percpu(values, 0) == new_value);
+	for (i = 1; i < nr_cpus - 1; i++)
+		assert(bpf_percpu(values, i) == i + 100);
+	assert(bpf_percpu(values, nr_cpus - 1) == new_value);
+
+	/* Delete shouldn't succeed. */
 	assert(bpf_map_delete_elem(fd, &key) == -1 && errno == EINVAL);
 
 	close(fd);
-- 
2.24.0

