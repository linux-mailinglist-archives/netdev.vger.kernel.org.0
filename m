Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27615ECBD6
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfKAXTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:19:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:50490 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfKAXTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:19:02 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQgC2-0000TU-FL; Sat, 02 Nov 2019 00:18:58 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii.nakryiko@gmail.com,
        john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v3 7/8] bpf, testing: Convert prog tests to probe_read_{user,kernel}{,_str} helper
Date:   Sat,  2 Nov 2019 00:18:02 +0100
Message-Id: <4a61d4b71ce3765587d8ef5cb93afa18515e5b3e.1572649915.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572649915.git.daniel@iogearbox.net>
References: <cover.1572649915.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25620/Fri Nov  1 10:04:15 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use probe read *_{kernel,user}{,_str}() helpers instead of bpf_probe_read()
or bpf_probe_read_user_str() for program tests where appropriate.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/progs/kfree_skb.c |  4 +-
 tools/testing/selftests/bpf/progs/pyperf.h    | 67 ++++++++++---------
 .../testing/selftests/bpf/progs/strobemeta.h  | 36 +++++-----
 .../selftests/bpf/progs/test_tcp_estats.c     |  2 +-
 4 files changed, 57 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
index 89af8a921ee4..489319ea1d6a 100644
--- a/tools/testing/selftests/bpf/progs/kfree_skb.c
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -79,11 +79,11 @@ int trace_kfree_skb(struct trace_kfree_skb *ctx)
 		func = ptr->func;
 	}));
 
-	bpf_probe_read(&pkt_type, sizeof(pkt_type), _(&skb->__pkt_type_offset));
+	bpf_probe_read_kernel(&pkt_type, sizeof(pkt_type), _(&skb->__pkt_type_offset));
 	pkt_type &= 7;
 
 	/* read eth proto */
-	bpf_probe_read(&pkt_data, sizeof(pkt_data), data + 12);
+	bpf_probe_read_kernel(&pkt_data, sizeof(pkt_data), data + 12);
 
 	bpf_printk("rcuhead.next %llx func %llx\n", ptr, func);
 	bpf_printk("skb->len %d users %d pkt_type %x\n",
diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
index 003fe106fc70..71d383cc9b85 100644
--- a/tools/testing/selftests/bpf/progs/pyperf.h
+++ b/tools/testing/selftests/bpf/progs/pyperf.h
@@ -72,9 +72,9 @@ static __always_inline void *get_thread_state(void *tls_base, PidData *pidData)
 	void* thread_state;
 	int key;
 
-	bpf_probe_read(&key, sizeof(key), (void*)(long)pidData->tls_key_addr);
-	bpf_probe_read(&thread_state, sizeof(thread_state),
-		       tls_base + 0x310 + key * 0x10 + 0x08);
+	bpf_probe_read_user(&key, sizeof(key), (void*)(long)pidData->tls_key_addr);
+	bpf_probe_read_user(&thread_state, sizeof(thread_state),
+			    tls_base + 0x310 + key * 0x10 + 0x08);
 	return thread_state;
 }
 
@@ -82,31 +82,33 @@ static __always_inline bool get_frame_data(void *frame_ptr, PidData *pidData,
 					   FrameData *frame, Symbol *symbol)
 {
 	// read data from PyFrameObject
-	bpf_probe_read(&frame->f_back,
-		       sizeof(frame->f_back),
-		       frame_ptr + pidData->offsets.PyFrameObject_back);
-	bpf_probe_read(&frame->f_code,
-		       sizeof(frame->f_code),
-		       frame_ptr + pidData->offsets.PyFrameObject_code);
+	bpf_probe_read_user(&frame->f_back,
+			    sizeof(frame->f_back),
+			    frame_ptr + pidData->offsets.PyFrameObject_back);
+	bpf_probe_read_user(&frame->f_code,
+			    sizeof(frame->f_code),
+			    frame_ptr + pidData->offsets.PyFrameObject_code);
 
 	// read data from PyCodeObject
 	if (!frame->f_code)
 		return false;
-	bpf_probe_read(&frame->co_filename,
-		       sizeof(frame->co_filename),
-		       frame->f_code + pidData->offsets.PyCodeObject_filename);
-	bpf_probe_read(&frame->co_name,
-		       sizeof(frame->co_name),
-		       frame->f_code + pidData->offsets.PyCodeObject_name);
+	bpf_probe_read_user(&frame->co_filename,
+			    sizeof(frame->co_filename),
+			    frame->f_code + pidData->offsets.PyCodeObject_filename);
+	bpf_probe_read_user(&frame->co_name,
+			    sizeof(frame->co_name),
+			    frame->f_code + pidData->offsets.PyCodeObject_name);
 	// read actual names into symbol
 	if (frame->co_filename)
-		bpf_probe_read_str(&symbol->file,
-				   sizeof(symbol->file),
-				   frame->co_filename + pidData->offsets.String_data);
+		bpf_probe_read_user_str(&symbol->file,
+					sizeof(symbol->file),
+					frame->co_filename +
+					pidData->offsets.String_data);
 	if (frame->co_name)
-		bpf_probe_read_str(&symbol->name,
-				   sizeof(symbol->name),
-				   frame->co_name + pidData->offsets.String_data);
+		bpf_probe_read_user_str(&symbol->name,
+					sizeof(symbol->name),
+					frame->co_name +
+					pidData->offsets.String_data);
 	return true;
 }
 
@@ -174,9 +176,9 @@ static __always_inline int __on_event(struct pt_regs *ctx)
 	event->kernel_stack_id = bpf_get_stackid(ctx, &stackmap, 0);
 
 	void* thread_state_current = (void*)0;
-	bpf_probe_read(&thread_state_current,
-		       sizeof(thread_state_current),
-		       (void*)(long)pidData->current_state_addr);
+	bpf_probe_read_user(&thread_state_current,
+			    sizeof(thread_state_current),
+			    (void*)(long)pidData->current_state_addr);
 
 	struct task_struct* task = (struct task_struct*)bpf_get_current_task();
 	void* tls_base = (void*)task;
@@ -188,11 +190,13 @@ static __always_inline int __on_event(struct pt_regs *ctx)
 	if (pidData->use_tls) {
 		uint64_t pthread_created;
 		uint64_t pthread_self;
-		bpf_probe_read(&pthread_self, sizeof(pthread_self), tls_base + 0x10);
+		bpf_probe_read_user(&pthread_self, sizeof(pthread_self),
+				    tls_base + 0x10);
 
-		bpf_probe_read(&pthread_created,
-			       sizeof(pthread_created),
-			       thread_state + pidData->offsets.PyThreadState_thread);
+		bpf_probe_read_user(&pthread_created,
+				    sizeof(pthread_created),
+				    thread_state +
+				    pidData->offsets.PyThreadState_thread);
 		event->pthread_match = pthread_created == pthread_self;
 	} else {
 		event->pthread_match = 1;
@@ -204,9 +208,10 @@ static __always_inline int __on_event(struct pt_regs *ctx)
 		Symbol sym = {};
 		int cur_cpu = bpf_get_smp_processor_id();
 
-		bpf_probe_read(&frame_ptr,
-			       sizeof(frame_ptr),
-			       thread_state + pidData->offsets.PyThreadState_frame);
+		bpf_probe_read_user(&frame_ptr,
+				    sizeof(frame_ptr),
+				    thread_state +
+				    pidData->offsets.PyThreadState_frame);
 
 		int32_t* symbol_counter = bpf_map_lookup_elem(&symbolmap, &sym);
 		if (symbol_counter == NULL)
diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
index 067eb625d01c..4bf16e0a1b0e 100644
--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -98,7 +98,7 @@ struct strobe_map_raw {
 	/*
 	 * having volatile doesn't change anything on BPF side, but clang
 	 * emits warnings for passing `volatile const char *` into
-	 * bpf_probe_read_str that expects just `const char *`
+	 * bpf_probe_read_user_str that expects just `const char *`
 	 */
 	const char* tag;
 	/*
@@ -309,18 +309,18 @@ static __always_inline void *calc_location(struct strobe_value_loc *loc,
 	dtv_t *dtv;
 	void *tls_ptr;
 
-	bpf_probe_read(&tls_index, sizeof(struct tls_index),
-		       (void *)loc->offset);
+	bpf_probe_read_user(&tls_index, sizeof(struct tls_index),
+			    (void *)loc->offset);
 	/* valid module index is always positive */
 	if (tls_index.module > 0) {
 		/* dtv = ((struct tcbhead *)tls_base)->dtv[tls_index.module] */
-		bpf_probe_read(&dtv, sizeof(dtv),
-			       &((struct tcbhead *)tls_base)->dtv);
+		bpf_probe_read_user(&dtv, sizeof(dtv),
+				    &((struct tcbhead *)tls_base)->dtv);
 		dtv += tls_index.module;
 	} else {
 		dtv = NULL;
 	}
-	bpf_probe_read(&tls_ptr, sizeof(void *), dtv);
+	bpf_probe_read_user(&tls_ptr, sizeof(void *), dtv);
 	/* if pointer has (void *)-1 value, then TLS wasn't initialized yet */
 	return tls_ptr && tls_ptr != (void *)-1
 		? tls_ptr + tls_index.offset
@@ -336,7 +336,7 @@ static __always_inline void read_int_var(struct strobemeta_cfg *cfg,
 	if (!location)
 		return;
 
-	bpf_probe_read(value, sizeof(struct strobe_value_generic), location);
+	bpf_probe_read_user(value, sizeof(struct strobe_value_generic), location);
 	data->int_vals[idx] = value->val;
 	if (value->header.len)
 		data->int_vals_set_mask |= (1 << idx);
@@ -356,13 +356,13 @@ static __always_inline uint64_t read_str_var(struct strobemeta_cfg *cfg,
 	if (!location)
 		return 0;
 
-	bpf_probe_read(value, sizeof(struct strobe_value_generic), location);
-	len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN, value->ptr);
+	bpf_probe_read_user(value, sizeof(struct strobe_value_generic), location);
+	len = bpf_probe_read_user_str(payload, STROBE_MAX_STR_LEN, value->ptr);
 	/*
-	 * if bpf_probe_read_str returns error (<0), due to casting to
+	 * if bpf_probe_read_user_str returns error (<0), due to casting to
 	 * unsinged int, it will become big number, so next check is
 	 * sufficient to check for errors AND prove to BPF verifier, that
-	 * bpf_probe_read_str won't return anything bigger than
+	 * bpf_probe_read_user_str won't return anything bigger than
 	 * STROBE_MAX_STR_LEN
 	 */
 	if (len > STROBE_MAX_STR_LEN)
@@ -391,8 +391,8 @@ static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
 	if (!location)
 		return payload;
 
-	bpf_probe_read(value, sizeof(struct strobe_value_generic), location);
-	if (bpf_probe_read(&map, sizeof(struct strobe_map_raw), value->ptr))
+	bpf_probe_read_user(value, sizeof(struct strobe_value_generic), location);
+	if (bpf_probe_read_user(&map, sizeof(struct strobe_map_raw), value->ptr))
 		return payload;
 
 	descr->id = map.id;
@@ -402,7 +402,7 @@ static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
 		data->req_meta_valid = 1;
 	}
 
-	len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN, map.tag);
+	len = bpf_probe_read_user_str(payload, STROBE_MAX_STR_LEN, map.tag);
 	if (len <= STROBE_MAX_STR_LEN) {
 		descr->tag_len = len;
 		payload += len;
@@ -418,15 +418,15 @@ static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
 			break;
 
 		descr->key_lens[i] = 0;
-		len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN,
-					 map.entries[i].key);
+		len = bpf_probe_read_user_str(payload, STROBE_MAX_STR_LEN,
+					      map.entries[i].key);
 		if (len <= STROBE_MAX_STR_LEN) {
 			descr->key_lens[i] = len;
 			payload += len;
 		}
 		descr->val_lens[i] = 0;
-		len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN,
-					 map.entries[i].val);
+		len = bpf_probe_read_user_str(payload, STROBE_MAX_STR_LEN,
+					      map.entries[i].val);
 		if (len <= STROBE_MAX_STR_LEN) {
 			descr->val_lens[i] = len;
 			payload += len;
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_estats.c b/tools/testing/selftests/bpf/progs/test_tcp_estats.c
index c8c595da38d4..87b7d934ce73 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_estats.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_estats.c
@@ -38,7 +38,7 @@
 #include <sys/socket.h>
 #include "bpf_helpers.h"
 
-#define _(P) ({typeof(P) val = 0; bpf_probe_read(&val, sizeof(val), &P); val;})
+#define _(P) ({typeof(P) val = 0; bpf_probe_read_kernel(&val, sizeof(val), &P); val;})
 #define TCP_ESTATS_MAGIC 0xBAADBEEF
 
 /* This test case needs "sock" and "pt_regs" data structure.
-- 
2.21.0

