Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02E44BCED0
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbiBTNtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243889AbiBTNtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:49:03 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B0921813;
        Sun, 20 Feb 2022 05:48:41 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id i21so6403317pfd.13;
        Sun, 20 Feb 2022 05:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pIC5+WXrEeyIxvYSwThdX0RKAIalXL8BJkc2S7tcfKw=;
        b=U09A3aHEWLcSZtIQs1bZGdvaq6QvKB6EcaoJk8Il0kaUMuCnQgG3EeKbHAL0uZhhgu
         81fImhEsABSb++rzCwIsZUrGFdrl/w3WkH58rxYcxTHxdOOLneZg3YAr++e7fjJA0tJH
         0u3yuMB6QmBL/UxZ7jqUzaBaZeCpv618APzpMfkreTuY7D4BJvmDTDqu/s3axFgKRQkh
         yzUoV8tDWTs0KGisddQlB24bP/RFJuxCjoX6XN+Kl3e28cuyIKbMa2V+kAdId/AF/VaL
         ylyltQqaGBF4vjOHiYi28Q3tidValepLrB0eN5fOv2Kdj2r25D0NkHEwRxVsmMIg8N7e
         U8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pIC5+WXrEeyIxvYSwThdX0RKAIalXL8BJkc2S7tcfKw=;
        b=hsdMdzQ9S2zSW6h23c/hF7VQDVnSgVNJweKUkZwVOqFKDRKF9IIwpSByYLf0vM6PjL
         r6+0KSNHrjIPucJ3j+5qmlDjCcPMCSAtMQFDJK1ZwkjymWNcUvm2PaEekKsOAWZ8vVgZ
         fUVZri7AJTSDV22/o4mwN8pcnfPIkPUjaJg/q1t9rJvB2kWQOrZkwRrFhPA47n3J4f5z
         49Vb7S/Mypdq4wPn3GI04z3G5mwqctPmOmWaUihuUxg92XfLDemxRlVFdye21EnOotBm
         3326xMa3f3OGqHhxZo1Xikp1/SDO/NBMwgusUYVuylpatv8GNAiCbM7ynJCfBOxZj1jv
         kOqQ==
X-Gm-Message-State: AOAM5312p5QxXCOmfQ1I2eelFG9kQSuLL7YMylf60qoHjjExU5t277DS
        lypIjTJrW4BaSiaYnh4DJSQTneCmsTk=
X-Google-Smtp-Source: ABdhPJzVaiY8SWSJqGrRIImmIAebrxfjydSNtUMRtokoWlWFgeHPxDXgj6g2I+oEAcAkY8wnUxAEGw==
X-Received: by 2002:a65:4c0f:0:b0:373:f389:b7e0 with SMTP id u15-20020a654c0f000000b00373f389b7e0mr7104280pgq.411.1645364921086;
        Sun, 20 Feb 2022 05:48:41 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id g20sm9526597pfj.64.2022.02.20.05.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:40 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 08/15] bpf: Adapt copy_map_value for multiple offset case
Date:   Sun, 20 Feb 2022 19:18:06 +0530
Message-Id: <20220220134813.3411982-9-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5506; h=from:subject; bh=QC3eOPhRZ70Vfv0ZVgnLYlIXFjYgOARRsEoQm0vCP0c=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZX8enrcy5zjuM51gXuZUW/extU3HrWA0LHh0RX sZCmGKKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RyudYD/ 4+0UiSISVfkfKRAa6IDsSX+iz6hWQgpXqBpxv2NMjJbQrxDmhk8/89wG/4gfFXl0WH8uLHalZsgbzs ttYc3Pi+/Hve9coTHxnli32ex5dQzRwpl7YbZJDKcwgr2zL/dSxLp4wl5RNrCpRZC8LNI4FMBbNLhB CwOz4Xv5HRvqTidT9lEFP4qAs2bI+FdC/U1ZabHtOXOMiLly77NXPIZkUI/sCdJ/L2fWUMk6XuWGDJ 4Pc7z/wCXTaIwsAvS2RlnhCT9aroZU5PXTolVL8ok/DgJLlVEwsdAud8Jlp0tZnSZotni2V1CqYQhH i3Q6zrQJHOhJ3b0FNEs6LluKjqmxjjzhxsns3yy81t2LW2w+xhrvOEVVf3KhDsVQ4vdRIEzgNoPP2c sDhKYVMCks9ViyZ8fMzFFXx5xGqPhFVmHe8Otuvc7UbcBNrBuyozNsKzi9VxSZxOx4TAVUb7ddeUKd cGZTtGQdleE4gYPr/SbkOMB+rtcfWB3ZhxrepvVwRHpoinTZTqcb5YRC53sgOGfKsYxcP98ePqEarD SWY3wTAwyvg93CrMgTfSL5m2GVUC1yhtmixv62g777r+13GHA8DIlQbImXTlIBc1Oxd2jY9zJJ1TZv wN264PZEcjPRZ0CTmqdbUTazUWarPGIKuyvvERrGyIdo9c9d4m2jMHOCqsNQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

The changes in this patch deserve closer look, so it has been split into
its own independent patch. While earlier we just had to skip two objects
at most while copying in and out of map, now we have potentially many
objects (at most 8 + 2 = 10, due to the BPF_MAP_VALUE_OFF_MAX limit).

Hence, divide the copy_map_value function into an inlined fast path and
function call to slowpath. The slowpath handles the case of > 3 offsets,
while we handle the most common cases (0, 1, 2, or 3 offsets) in the
inline function itself.

In copy_map_value_slow, we use 11 offsets, just to make the for loop
that copies the value free of edge cases for the last offset, by using
map->value_size as final offset to subtract remaining area to copy from.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h  | 43 +++++++++++++++++++++++++++++++---
 kernel/bpf/syscall.c | 55 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ae599aaf8d4c..5d845ca02eba 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -253,12 +253,22 @@ static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
 		memset(dst + map->spin_lock_off, 0, sizeof(struct bpf_spin_lock));
 	if (unlikely(map_value_has_timer(map)))
 		memset(dst + map->timer_off, 0, sizeof(struct bpf_timer));
+	if (unlikely(map_value_has_ptr_to_btf_id(map))) {
+		struct bpf_map_value_off *tab = map->ptr_off_tab;
+		int i;
+
+		for (i = 0; i < tab->nr_off; i++)
+			*(u64 *)(dst + tab->off[i].offset) = 0;
+	}
 }
 
+void copy_map_value_slow(struct bpf_map *map, void *dst, void *src, u32 s_off,
+			 u32 s_sz, u32 t_off, u32 t_sz);
+
 /* copy everything but bpf_spin_lock and bpf_timer. There could be one of each. */
 static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 {
-	u32 s_off = 0, s_sz = 0, t_off = 0, t_sz = 0;
+	u32 s_off = 0, s_sz = 0, t_off = 0, t_sz = 0, p_off = 0, p_sz = 0;
 
 	if (unlikely(map_value_has_spin_lock(map))) {
 		s_off = map->spin_lock_off;
@@ -268,13 +278,40 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 		t_off = map->timer_off;
 		t_sz = sizeof(struct bpf_timer);
 	}
+	/* Multiple offset case is slow, offload to function */
+	if (unlikely(map_value_has_ptr_to_btf_id(map))) {
+		struct bpf_map_value_off *tab = map->ptr_off_tab;
+
+		/* Inline the likely common case */
+		if (likely(tab->nr_off == 1)) {
+			p_off = tab->off[0].offset;
+			p_sz = sizeof(u64);
+		} else {
+			copy_map_value_slow(map, dst, src, s_off, s_sz, t_off, t_sz);
+			return;
+		}
+	}
+
+	if (unlikely(s_sz || t_sz || p_sz)) {
+		/* The order is p_off, t_off, s_off, use insertion sort */
 
-	if (unlikely(s_sz || t_sz)) {
+		if (t_off < p_off || !t_sz) {
+			swap(t_off, p_off);
+			swap(t_sz, p_sz);
+		}
 		if (s_off < t_off || !s_sz) {
 			swap(s_off, t_off);
 			swap(s_sz, t_sz);
+			if (t_off < p_off || !t_sz) {
+				swap(t_off, p_off);
+				swap(t_sz, p_sz);
+			}
 		}
-		memcpy(dst, src, t_off);
+
+		memcpy(dst, src, p_off);
+		memcpy(dst + p_off + p_sz,
+		       src + p_off + p_sz,
+		       t_off - p_off - p_sz);
 		memcpy(dst + t_off + t_sz,
 		       src + t_off + t_sz,
 		       s_off - t_off - t_sz);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index beb96866f34d..83d71d6912f5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -30,6 +30,7 @@
 #include <linux/pgtable.h>
 #include <linux/bpf_lsm.h>
 #include <linux/poll.h>
+#include <linux/sort.h>
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
@@ -230,6 +231,60 @@ static int bpf_map_update_value(struct bpf_map *map, struct fd f, void *key,
 	return err;
 }
 
+static int copy_map_value_cmp(const void *_a, const void *_b)
+{
+	const u32 a = *(const u32 *)_a;
+	const u32 b = *(const u32 *)_b;
+
+	/* We only need to sort based on offset */
+	if (a < b)
+		return -1;
+	else if (a > b)
+		return 1;
+	return 0;
+}
+
+void copy_map_value_slow(struct bpf_map *map, void *dst, void *src, u32 s_off,
+			 u32 s_sz, u32 t_off, u32 t_sz)
+{
+	struct bpf_map_value_off *tab = map->ptr_off_tab; /* already set to non-NULL */
+	/* 3 = 2 for bpf_timer, bpf_spin_lock, 1 for map->value_size sentinel */
+	struct {
+		u32 off;
+		u32 sz;
+	} off_arr[BPF_MAP_VALUE_OFF_MAX + 3];
+	int i, cnt = 0;
+
+	/* Reconsider stack usage when bumping BPF_MAP_VALUE_OFF_MAX */
+	BUILD_BUG_ON(sizeof(off_arr) != 88);
+
+	for (i = 0; i < tab->nr_off; i++) {
+		off_arr[cnt].off = tab->off[i].offset;
+		off_arr[cnt++].sz = sizeof(u64);
+	}
+	if (s_sz) {
+		off_arr[cnt].off = s_off;
+		off_arr[cnt++].sz = s_sz;
+	}
+	if (t_sz) {
+		off_arr[cnt].off = t_off;
+		off_arr[cnt++].sz = t_sz;
+	}
+	off_arr[cnt].off = map->value_size;
+
+	sort(off_arr, cnt, sizeof(off_arr[0]), copy_map_value_cmp, NULL);
+
+	/* There is always at least one element */
+	memcpy(dst, src, off_arr[0].off);
+	/* Copy the rest, while skipping other regions */
+	for (i = 1; i < cnt; i++) {
+		u32 curr_off = off_arr[i - 1].off + off_arr[i - 1].sz;
+		u32 next_off = off_arr[i].off;
+
+		memcpy(dst + curr_off, src + curr_off, next_off - curr_off);
+	}
+}
+
 static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
 			      __u64 flags)
 {
-- 
2.35.1

