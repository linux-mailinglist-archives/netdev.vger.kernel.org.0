Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63C3545A1E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 04:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345323AbiFJCdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 22:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbiFJCd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 22:33:28 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96908B5247
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 19:33:25 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x4so14093375pfj.10
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 19:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mF4zImcP1gOdN8UvsBrqYtbmiABYejHvUvi0EZlW7oI=;
        b=hgWxeUrVNLD6xuo/sbHEeTPmXp2NhZny0ThVZKmw6RtWaSwUUbNpi4Z3Y1UdSL6b2M
         Tyta/BfIoBl9kOl2B/zs9N01bG8tebru/PXcZVTVYKmLpxr4KgRCBN01PyVINbeLGq8G
         +xk9qR/DHuSBXRXubnx2WMMk5XF7ghs4W1Hnn9KvEpqaBGW2vS7qaPcbBDAzDPaMNKb+
         4lkof0i8/ad2vw66cpalcjGxJoIoTFyyWjArfLLVtBweoiQhaqO9W6BzXkjjqZ7qcgyD
         ILHt2s74NhcSSB/4S843Mw3susyrmFUP/WRTUkFd1VqMlgwXijm/W297orMx59aVDDxu
         xp6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mF4zImcP1gOdN8UvsBrqYtbmiABYejHvUvi0EZlW7oI=;
        b=HFguJFLTg8Hy2F7VKpXxq4fky02xSRsI9gP1k8iKRVaK5yDK+REqQT0MyXk5ZgiM/h
         29i0HZiZe4YanYl7xfkLdxc2dk39u8okw0o7ez/ZiKrPbPCpDhBMH7ZUkwH6pfyNohMt
         /YixmoKa4vPCQs6mqzbaeJ0Lqg8Wktb98dWEXDQIo/ce7tpdnOCzucL1IINrdNWrpuqR
         DGisdUp7Qsnmxw00GEgJ97klpIhn+I/sz16EP/WybefyI2R91xMw9c/EiRhxSU6EJlVk
         SDRYkLWAPq5pRH0YZp2NKuilTJCc+w0cPJY5KbVd3U2r3nQ8EgRQKmDo0N73N0B20p2Q
         mKtQ==
X-Gm-Message-State: AOAM532gaufW/Apbl0J+wLt6eHNOpW/yiRWlkY6DuCNIk73CcFEYPAMg
        0oEmmejnux54t7qixRiLAMkwKg==
X-Google-Smtp-Source: ABdhPJzrHcDnf8fUQlMQt/1PC+8KzbX6TvprSOKOfQpymsCfKFAZv/REJxP3/uLeNIABQfdTs7g/9A==
X-Received: by 2002:a05:6a00:1811:b0:51b:fec8:be7b with SMTP id y17-20020a056a00181100b0051bfec8be7bmr29391769pfa.22.1654828405113;
        Thu, 09 Jun 2022 19:33:25 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id o19-20020a170903009300b001620db30cd6sm17432481pld.201.2022.06.09.19.33.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jun 2022 19:33:24 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v6 1/2] bpf: avoid grabbing spin_locks of all cpus when no free elems
Date:   Fri, 10 Jun 2022 10:33:07 +0800
Message-Id: <20220610023308.93798-2-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220610023308.93798-1-zhoufeng.zf@bytedance.com>
References: <20220610023308.93798-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

This patch use head->first in pcpu_freelist_head to check freelist
having free or not. If having, grab spin_lock, or check next cpu's
freelist.

Before patch: hash_map performance
./map_perf_test 1
0:hash_map_perf pre-alloc 1043397 events per sec
...
The average of the test results is around 1050000 events per sec.

hash_map the worst: no free
./run_bench_bpf_hashmap_full_update.sh
Setting up benchmark 'bpf-hashmap-ful-update'...
Benchmark 'bpf-hashmap-ful-update' started.
1:hash_map_full_perf 15687 events per sec
...
The average of the test results is around 16000 events per sec.

ftrace trace:
0)               |  htab_map_update_elem() {
0)               |      __pcpu_freelist_pop() {
0)               |        _raw_spin_lock()
0)               |        _raw_spin_unlock()
0)               |        ...
0) + 25.188 us   |      }
0) + 28.439 us   |  }

The test machine is 16C, trying to get spin_lock 17 times, in addition
to 16c, there is an extralist.

after patch: hash_map performance
./map_perf_test 1
0:hash_map_perf pre-alloc 1053298 events per sec
...
The average of the test results is around 1050000 events per sec.

hash_map worst: no free
./run_bench_bpf_hashmap_full_update.sh
Setting up benchmark 'bpf-hashmap-ful-update'...
Benchmark 'bpf-hashmap-ful-update' started.
1:hash_map_full_perf 555830 events per sec
...
The average of the test results is around 550000 events per sec.

ftrace trace:
0)               |  htab_map_update_elem() {
0)               |    alloc_htab_elem() {
0)   0.586 us    |      __pcpu_freelist_pop();
0)   0.945 us    |    }
0)   8.669 us    |  }

It can be seen that after adding this patch, the map performance is
almost not degraded, and when free=0, first check head->first instead of
directly acquiring spin_lock.

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 kernel/bpf/percpu_freelist.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index 3d897de89061..00b874c8e889 100644
--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -31,7 +31,7 @@ static inline void pcpu_freelist_push_node(struct pcpu_freelist_head *head,
 					   struct pcpu_freelist_node *node)
 {
 	node->next = head->first;
-	head->first = node;
+	WRITE_ONCE(head->first, node);
 }
 
 static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *head,
@@ -130,14 +130,17 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
 	orig_cpu = cpu = raw_smp_processor_id();
 	while (1) {
 		head = per_cpu_ptr(s->freelist, cpu);
+		if (!READ_ONCE(head->first))
+			goto next_cpu;
 		raw_spin_lock(&head->lock);
 		node = head->first;
 		if (node) {
-			head->first = node->next;
+			WRITE_ONCE(head->first, node->next);
 			raw_spin_unlock(&head->lock);
 			return node;
 		}
 		raw_spin_unlock(&head->lock);
+next_cpu:
 		cpu = cpumask_next(cpu, cpu_possible_mask);
 		if (cpu >= nr_cpu_ids)
 			cpu = 0;
@@ -146,10 +149,12 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
 	}
 
 	/* per cpu lists are all empty, try extralist */
+	if (!READ_ONCE(s->extralist.first))
+		return NULL;
 	raw_spin_lock(&s->extralist.lock);
 	node = s->extralist.first;
 	if (node)
-		s->extralist.first = node->next;
+		WRITE_ONCE(s->extralist.first, node->next);
 	raw_spin_unlock(&s->extralist.lock);
 	return node;
 }
@@ -164,15 +169,18 @@ ___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
 	orig_cpu = cpu = raw_smp_processor_id();
 	while (1) {
 		head = per_cpu_ptr(s->freelist, cpu);
+		if (!READ_ONCE(head->first))
+			goto next_cpu;
 		if (raw_spin_trylock(&head->lock)) {
 			node = head->first;
 			if (node) {
-				head->first = node->next;
+				WRITE_ONCE(head->first, node->next);
 				raw_spin_unlock(&head->lock);
 				return node;
 			}
 			raw_spin_unlock(&head->lock);
 		}
+next_cpu:
 		cpu = cpumask_next(cpu, cpu_possible_mask);
 		if (cpu >= nr_cpu_ids)
 			cpu = 0;
@@ -181,11 +189,11 @@ ___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
 	}
 
 	/* cannot pop from per cpu lists, try extralist */
-	if (!raw_spin_trylock(&s->extralist.lock))
+	if (!READ_ONCE(s->extralist.first) || !raw_spin_trylock(&s->extralist.lock))
 		return NULL;
 	node = s->extralist.first;
 	if (node)
-		s->extralist.first = node->next;
+		WRITE_ONCE(s->extralist.first, node->next);
 	raw_spin_unlock(&s->extralist.lock);
 	return node;
 }
-- 
2.20.1

