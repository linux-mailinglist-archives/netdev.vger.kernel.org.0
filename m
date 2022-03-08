Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E504D18DC
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347039AbiCHNMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbiCHNMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:24 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAB6488B6;
        Tue,  8 Mar 2022 05:11:21 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id m2so11046481pll.0;
        Tue, 08 Mar 2022 05:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6X23AJzOcszEUYA+Oc8WYhr7w/7aeKWJdCFlxFdfbxc=;
        b=QzDOs9yQq9R1CZFP5kH/i37OmN2DriXgh+Uc29/28MK52/n2BNL5T+LpOEtCkDH1wT
         SArng9TL/tXBv+Z80bt9GxJnPhLPtlJphCtIvRp0gdbabeClqLN5OJJWkW3w2ZTfWwQa
         Rnjfw7mAFLLj9wTWH+Eh6SOwOz0vOv1IZ2Ez9Hdj3Lib06/AoNebKC9gEtTDUdNrv4NQ
         9DcZx2G8SWEzn6bao5aEaUSzUNDhlZZ1d3NO0Rldf6bomrFxx1CFs1Xa9YnCHp8zH9iB
         t5155kTpOmXdPuCwsVILsy5c1hsx6nSVXhy04JPx1GbVRQYFwe+KylhvR1CA514F2xZd
         3C/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6X23AJzOcszEUYA+Oc8WYhr7w/7aeKWJdCFlxFdfbxc=;
        b=G7uo/XXQehS2HJszpfZTnuqtAcr8oCVBolH9/xMu3y05Lb0tnx1km5sNug3rSo2c5e
         Cuh2U+3Zm5/FoO63TXJVV7QYkzHIMAwe6s8Gs91UdnpkGGrWJJQSn9KcBhI0FEfw6g4G
         OgFWJWlSm8YK5ZBU6yE0JCsxBjTpvd1nGceWK8YCpvu8Lyuo3E/Ez1LMrQxSnZHswSJq
         s8+3SZXKZSUXAIAMQPzmV7P6rLV+iSOCq60RNRZh3nnm82TrxWgOfq8IYvlWie+Vz8qr
         n80qEXyLk6i64dQuXcOdHlqK6O04TlMrs1gkBLSFzqTgYaxQcSPlGk5ssGz1IHiXNLCZ
         XHaw==
X-Gm-Message-State: AOAM530SSWe8Jun2y/rDFnh6IWe5wl2t2seGzqPp1TOMYbqjnDcL51Nj
        sub75A0zUunVWmfqqZiVRms=
X-Google-Smtp-Source: ABdhPJxKOq3e10aQ1RmNw8ArFeArmumS9bRFdOU8RkbwmtWaG0AV0PF5C3HqteolvWr6aJIng6XTbQ==
X-Received: by 2002:a17:90a:4fa2:b0:1bd:383a:2b6b with SMTP id q31-20020a17090a4fa200b001bd383a2b6bmr4727275pjh.108.1646745080990;
        Tue, 08 Mar 2022 05:11:20 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:20 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 5/9] mm: add methord to charge percpu address
Date:   Tue,  8 Mar 2022 13:10:52 +0000
Message-Id: <20220308131056.6732-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308131056.6732-1-laoar.shao@gmail.com>
References: <20220308131056.6732-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a methord to charge or uncharge a percpu address.
It is similar to free_percpu except that it doesn't touch the related
pages while does account only.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/percpu.h |  1 +
 mm/percpu.c            | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index f1ec5ad..1a65221 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -128,6 +128,7 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
 extern void __percpu *__alloc_percpu_gfp(size_t size, size_t align, gfp_t gfp) __alloc_size(1);
 extern void __percpu *__alloc_percpu(size_t size, size_t align) __alloc_size(1);
 extern void free_percpu(void __percpu *__pdata);
+void charge_percpu(void __percpu *__pdata, bool charge);
 extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 
 #define alloc_percpu_gfp(type, gfp)					\
diff --git a/mm/percpu.c b/mm/percpu.c
index ea28db2..22fc0ff 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -2309,6 +2309,56 @@ void free_percpu(void __percpu *ptr)
 }
 EXPORT_SYMBOL_GPL(free_percpu);
 
+void charge_percpu(void __percpu *ptr, bool charge)
+{
+	int bit_off, off, bits, size, end;
+	struct obj_cgroup *objcg;
+	struct pcpu_chunk *chunk;
+	unsigned long flags;
+	void *addr;
+
+	WARN_ON(!in_task());
+
+	if (!ptr)
+		return;
+
+	addr = __pcpu_ptr_to_addr(ptr);
+	spin_lock_irqsave(&pcpu_lock, flags);
+	chunk = pcpu_chunk_addr_search(addr);
+	off = addr - chunk->base_addr;
+	objcg = chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT];
+	if (!objcg) {
+		spin_unlock_irqrestore(&pcpu_lock, flags);
+		return;
+	}
+
+	bit_off = off / PCPU_MIN_ALLOC_SIZE;
+	/* find end index */
+	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
+			bit_off + 1);
+	bits = end - bit_off;
+	size = bits * PCPU_MIN_ALLOC_SIZE;
+
+	if (charge) {
+		obj_cgroup_get(objcg);
+		obj_cgroup_charge(objcg, GFP_KERNEL, size * num_possible_cpus());
+		rcu_read_lock();
+		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
+			(size * num_possible_cpus()));
+		rcu_read_unlock();
+	} else {
+		obj_cgroup_uncharge(objcg, size * num_possible_cpus());
+		rcu_read_lock();
+		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
+			-(size * num_possible_cpus()));
+		rcu_read_unlock();
+		obj_cgroup_put(objcg);
+	}
+
+	spin_unlock_irqrestore(&pcpu_lock, flags);
+}
+EXPORT_SYMBOL(charge_percpu);
+
 bool __is_kernel_percpu_address(unsigned long addr, unsigned long *can_addr)
 {
 #ifdef CONFIG_SMP
-- 
1.8.3.1

