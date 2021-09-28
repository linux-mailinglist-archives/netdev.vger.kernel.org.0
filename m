Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB8F41BACE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243202AbhI1XLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243192AbhI1XLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 19:11:32 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82305C061760
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 16:09:51 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k23so227335pji.0
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 16:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2rba1xZZN9OkEhe0JLzg6qw4jXdeFqe9MRyQUmdrDh4=;
        b=JmJZeXyAwX49BhkJxQ76dKXJpQ1qJa2WhkYdSlk0bdhi7nyVLhp2ZvGEXmh2E03Tdx
         98QjtZlipaFxvCZ1QruWdHETETKMn8Gw3xMRm/0kLw18Xfixdy8enruyQmYj7Qc/ShVR
         aSWLEjPIgH9IWfLLf6Tl8UPqlNE7ZtXSC4RCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2rba1xZZN9OkEhe0JLzg6qw4jXdeFqe9MRyQUmdrDh4=;
        b=L7WGj+gNME7fMoKberj74OTLkg9auI/DVfB3xNj8ArgkoSJ0lAVh/M/pQKLXuhb6E0
         fQtDVOzN0sUD+mzQL71vf3ZVgfWKNCzEK66l/XX5kuFPSDjUshIe4jy0e7EwcULRRzSO
         xJH6mCr2ArGJbuPhJT4fR+4n/JIlf6eRphzLSVMlvcnbAwqrEQlYb7dobu2LPceCi7ME
         oRkfp8M46s4FHXPHU8THA5wP6p4vx0E3xxT+np+JO1oe0f0DkHiq7PLPscHOmx9GqRjU
         Q0i9oaLQ0z6yVRB7XxpmtQQrv3c+zif4alnHUDnKIKtqRf7Hnc/v6H2SEPDmwpRNgXbZ
         cP+A==
X-Gm-Message-State: AOAM53260TAtMKi3gW52H7G4NbjoPPOhc+aJpmudLo1ed88FUei+1Sz3
        GkW1vi+505xIUTlq8VjZuQQmgLjGpkjXSw==
X-Google-Smtp-Source: ABdhPJxH3Pn8PzwLjO/9gx8QMgTH8rQ/0eJbNfW26mgnV3CTESQErahFk0NcIAGi9nLgy4L4jABt3g==
X-Received: by 2002:a17:903:228b:b0:13c:94f8:d723 with SMTP id b11-20020a170903228b00b0013c94f8d723mr7491135plh.12.1632870591063;
        Tue, 28 Sep 2021 16:09:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n22sm212165pgc.55.2021.09.28.16.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 16:09:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH bpf-next v2 2/2] bpf: Replace callers of BPF_CAST_CALL with proper function typedef
Date:   Tue, 28 Sep 2021 16:09:46 -0700
Message-Id: <20210928230946.4062144-3-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928230946.4062144-1-keescook@chromium.org>
References: <20210928230946.4062144-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5823; h=from:subject; bh=bIODIAWxeyL04TePXGI79CL8QMIiwVlVilt68BmKwUY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhU6C6aGYZPCX+7LX7upl8u3qYxvQjavYR/tovWoe/ 5cj6HC+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYVOgugAKCRCJcvTf3G3AJqh4D/ 9rWQaEPtV7RuvYSZhnXiM25YXAfa8m5uB528TD0lmky4o5pugL4eg/wssw5aMplz44ciIBW8mNnMVq OO5mPJsXASrL+2xMgiLJuiKOR2vevBJ03OKYSBsu/gUSiFYW2qlX+hlrkP+ugJTUBNa10a9UfotmjM 51YZgjaZXh3ZYxqT8/Fz9oXqXkDKW15ch8724BqGdk93m9N8i4JL4FWBPM6HIXnPXH6EJOQLnntOQv tsQlQMh86KFuww0CKXjby9qqQd2ziI+lG+yzGBsMKHHrvzJVcqBi1Y99fkdCOobgFCKPxZqy7E4B1D HGafc+9hEM1SHCFMJNncxuFrbUXtM+yNIfNul4AjEeMcUPXPQkNBS0YJoxEXGV5zAkw0xKBZ8Ixk7g A994g2uerkAbA3fVNVkDupG1S3CYGdkthYv0jlrAitXS20Ri6xNefULdaPA9QWYKvawSHmzYx8vsfN xbAYoIEHK5Ko2YOzffdvnsHSpml3SWh4a90IDHzxyt57ceH95hFrXN1x2RT6Bl9NqYYSZsFsm+7UCc SVX5+4S0Zo/upEL3TCGr5m65WRXI9WlIVReb4rWTcnt7mZaArSiBhME1qf1hTeazu83653Bk4zUgfy 3u+YHQ76l1id476SERYHb8HVCEKowAxJpH/3uOmmRuAqOHUC3085wLuBC6hg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to keep ahead of cases in the kernel where Control Flow
Integrity (CFI) may trip over function call casts, enabling
-Wcast-function-type is helpful. To that end, BPF_CAST_CALL causes
various warnings and is one of the last places in the kernel
triggering this warning.

For actual function calls, replace BPF_CAST_CALL() with a typedef, which
captures the same details about the given function pointers.

This change results in no object code difference.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://github.com/KSPP/linux/issues/20
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/lkml/CAEf4Bzb46=-J5Fxc3mMZ8JQPtK1uoE0q6+g6WPz53Cvx=CBEhw@mail.gmail.com
---
 include/linux/bpf.h    | 4 +++-
 include/linux/filter.h | 5 -----
 kernel/bpf/arraymap.c  | 7 +++----
 kernel/bpf/hashtab.c   | 7 +++----
 kernel/bpf/helpers.c   | 5 ++---
 5 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b6c45a6cbbba..19735d59230a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -48,6 +48,7 @@ extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
 extern struct kobject *btf_kobj;
 
+typedef u64 (*bpf_callback_t)(u64, u64, u64, u64, u64);
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
 					struct bpf_iter_aux_info *aux);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
@@ -142,7 +143,8 @@ struct bpf_map_ops {
 	int (*map_set_for_each_callback_args)(struct bpf_verifier_env *env,
 					      struct bpf_func_state *caller,
 					      struct bpf_func_state *callee);
-	int (*map_for_each_callback)(struct bpf_map *map, void *callback_fn,
+	int (*map_for_each_callback)(struct bpf_map *map,
+				     bpf_callback_t callback_fn,
 				     void *callback_ctx, u64 flags);
 
 	/* BTF name and id of struct allocated by map_alloc */
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 6c247663d4ce..47f80adbe744 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -360,11 +360,6 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
 		.off   = 0,					\
 		.imm   = TGT })
 
-/* Function call */
-
-#define BPF_CAST_CALL(x)					\
-		((u64 (*)(u64, u64, u64, u64, u64))(x))
-
 /* Convert function address to BPF immediate */
 
 #define BPF_CALL_IMM(x)	((void *)(x) - (void *)__bpf_call_base)
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index cebd4fb06d19..5e1ccfae916b 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -645,7 +645,7 @@ static const struct bpf_iter_seq_info iter_seq_info = {
 	.seq_priv_size		= sizeof(struct bpf_iter_seq_array_map_info),
 };
 
-static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
+static int bpf_for_each_array_elem(struct bpf_map *map, bpf_callback_t callback_fn,
 				   void *callback_ctx, u64 flags)
 {
 	u32 i, key, num_elems = 0;
@@ -668,9 +668,8 @@ static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
 			val = array->value + array->elem_size * i;
 		num_elems++;
 		key = i;
-		ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
-					(u64)(long)&key, (u64)(long)val,
-					(u64)(long)callback_ctx, 0);
+		ret = callback_fn((u64)(long)map, (u64)(long)&key,
+				  (u64)(long)val, (u64)(long)callback_ctx, 0);
 		/* return value: 0 - continue, 1 - stop and return */
 		if (ret)
 			break;
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 3d8f9d6997d5..d29af9988f37 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2049,7 +2049,7 @@ static const struct bpf_iter_seq_info iter_seq_info = {
 	.seq_priv_size		= sizeof(struct bpf_iter_seq_hash_map_info),
 };
 
-static int bpf_for_each_hash_elem(struct bpf_map *map, void *callback_fn,
+static int bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_fn,
 				  void *callback_ctx, u64 flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
@@ -2089,9 +2089,8 @@ static int bpf_for_each_hash_elem(struct bpf_map *map, void *callback_fn,
 				val = elem->key + roundup_key_size;
 			}
 			num_elems++;
-			ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
-					(u64)(long)key, (u64)(long)val,
-					(u64)(long)callback_ctx, 0);
+			ret = callback_fn((u64)(long)map, (u64)(long)key,
+					  (u64)(long)val, (u64)(long)callback_ctx, 0);
 			/* return value: 0 - continue, 1 - stop and return */
 			if (ret) {
 				rcu_read_unlock();
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 2c604ff8c7fb..1ffd469c217f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1056,7 +1056,7 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 	struct bpf_hrtimer *t = container_of(hrtimer, struct bpf_hrtimer, timer);
 	struct bpf_map *map = t->map;
 	void *value = t->value;
-	void *callback_fn;
+	bpf_callback_t callback_fn;
 	void *key;
 	u32 idx;
 
@@ -1081,8 +1081,7 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 		key = value - round_up(map->key_size, 8);
 	}
 
-	BPF_CAST_CALL(callback_fn)((u64)(long)map, (u64)(long)key,
-				   (u64)(long)value, 0, 0);
+	callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value, 0, 0);
 	/* The verifier checked that return value is zero. */
 
 	this_cpu_write(hrtimer_running, NULL);
-- 
2.30.2

