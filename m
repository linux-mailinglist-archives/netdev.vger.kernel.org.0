Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0535D61A
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGBS1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:27:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGBS1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 14:27:02 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B94B3C04BD48;
        Tue,  2 Jul 2019 18:27:01 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.205.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CA82422C;
        Tue,  2 Jul 2019 18:27:00 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <liu.song.a23@gmail.com>, Y Song <ys114321@gmail.com>
Subject: [PATCH bpf-next] selftests: bpf: standardize to static __always_inline
Date:   Tue,  2 Jul 2019 20:26:51 +0200
Message-Id: <b62ef44131bbe3b905fc42990d16b667a65c820c.1562091849.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 02 Jul 2019 18:27:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The progs for bpf selftests use several different notations to force
function inlining. Standardize to what most of them use,
static __always_inline.

Suggested-by: Song Liu <liu.song.a23@gmail.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/progs/pyperf.h    |  9 +++--
 .../testing/selftests/bpf/progs/strobemeta.h  | 36 ++++++++++---------
 .../testing/selftests/bpf/progs/test_jhash.h  |  3 +-
 .../selftests/bpf/progs/test_seg6_loop.c      | 23 ++++++------
 .../selftests/bpf/progs/test_verif_scale2.c   |  2 +-
 5 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
index 6b0781391be5..abf6224649be 100644
--- a/tools/testing/selftests/bpf/progs/pyperf.h
+++ b/tools/testing/selftests/bpf/progs/pyperf.h
@@ -75,8 +75,7 @@ typedef struct {
 	void* co_name; // PyCodeObject.co_name
 } FrameData;
 
-static inline __attribute__((__always_inline__)) void*
-get_thread_state(void* tls_base, PidData* pidData)
+static __always_inline void *get_thread_state(void *tls_base, PidData *pidData)
 {
 	void* thread_state;
 	int key;
@@ -87,8 +86,8 @@ get_thread_state(void* tls_base, PidData* pidData)
 	return thread_state;
 }
 
-static inline __attribute__((__always_inline__)) bool
-get_frame_data(void* frame_ptr, PidData* pidData, FrameData* frame, Symbol* symbol)
+static __always_inline bool get_frame_data(void *frame_ptr, PidData *pidData,
+					   FrameData *frame, Symbol *symbol)
 {
 	// read data from PyFrameObject
 	bpf_probe_read(&frame->f_back,
@@ -161,7 +160,7 @@ struct bpf_elf_map SEC("maps") stackmap = {
 	.max_elem = 1000,
 };
 
-static inline __attribute__((__always_inline__)) int __on_event(struct pt_regs *ctx)
+static __always_inline int __on_event(struct pt_regs *ctx)
 {
 	uint64_t pid_tgid = bpf_get_current_pid_tgid();
 	pid_t pid = (pid_t)(pid_tgid >> 32);
diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
index 1ff73f60a3e4..553bc3b62e89 100644
--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -266,8 +266,8 @@ struct tls_index {
 	uint64_t offset;
 };
 
-static inline __attribute__((always_inline))
-void *calc_location(struct strobe_value_loc *loc, void *tls_base)
+static __always_inline void *calc_location(struct strobe_value_loc *loc,
+					   void *tls_base)
 {
 	/*
 	 * tls_mode value is:
@@ -327,10 +327,10 @@ void *calc_location(struct strobe_value_loc *loc, void *tls_base)
 		: NULL;
 }
 
-static inline __attribute__((always_inline))
-void read_int_var(struct strobemeta_cfg *cfg, size_t idx, void *tls_base,
-		  struct strobe_value_generic *value,
-		  struct strobemeta_payload *data)
+static __always_inline void read_int_var(struct strobemeta_cfg *cfg,
+					 size_t idx, void *tls_base,
+					 struct strobe_value_generic *value,
+					 struct strobemeta_payload *data)
 {
 	void *location = calc_location(&cfg->int_locs[idx], tls_base);
 	if (!location)
@@ -342,10 +342,11 @@ void read_int_var(struct strobemeta_cfg *cfg, size_t idx, void *tls_base,
 		data->int_vals_set_mask |= (1 << idx);
 }
 
-static inline __attribute__((always_inline))
-uint64_t read_str_var(struct strobemeta_cfg* cfg, size_t idx, void *tls_base,
-		      struct strobe_value_generic *value,
-		      struct strobemeta_payload *data, void *payload)
+static __always_inline uint64_t read_str_var(struct strobemeta_cfg *cfg,
+					     size_t idx, void *tls_base,
+					     struct strobe_value_generic *value,
+					     struct strobemeta_payload *data,
+					     void *payload)
 {
 	void *location;
 	uint32_t len;
@@ -371,10 +372,11 @@ uint64_t read_str_var(struct strobemeta_cfg* cfg, size_t idx, void *tls_base,
 	return len;
 }
 
-static inline __attribute__((always_inline))
-void *read_map_var(struct strobemeta_cfg *cfg, size_t idx, void *tls_base,
-		   struct strobe_value_generic *value,
-		   struct strobemeta_payload* data, void *payload)
+static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
+					  size_t idx, void *tls_base,
+					  struct strobe_value_generic *value,
+					  struct strobemeta_payload *data,
+					  void *payload)
 {
 	struct strobe_map_descr* descr = &data->map_descrs[idx];
 	struct strobe_map_raw map;
@@ -435,9 +437,9 @@ void *read_map_var(struct strobemeta_cfg *cfg, size_t idx, void *tls_base,
  * read_strobe_meta returns NULL, if no metadata was read; otherwise returns
  * pointer to *right after* payload ends
  */
-static inline __attribute__((always_inline))
-void *read_strobe_meta(struct task_struct* task,
-		       struct strobemeta_payload* data) {
+static __always_inline void *read_strobe_meta(struct task_struct *task,
+					      struct strobemeta_payload *data)
+{
 	pid_t pid = bpf_get_current_pid_tgid() >> 32;
 	struct strobe_value_generic value = {0};
 	struct strobemeta_cfg *cfg;
diff --git a/tools/testing/selftests/bpf/progs/test_jhash.h b/tools/testing/selftests/bpf/progs/test_jhash.h
index 3d12c11a8d47..c300734d26f6 100644
--- a/tools/testing/selftests/bpf/progs/test_jhash.h
+++ b/tools/testing/selftests/bpf/progs/test_jhash.h
@@ -1,9 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2019 Facebook
+#include <features.h>
 
 typedef unsigned int u32;
 
-static __attribute__((always_inline)) u32 rol32(u32 word, unsigned int shift)
+static __always_inline u32 rol32(u32 word, unsigned int shift)
 {
 	return (word << shift) | (word >> ((-shift) & 31));
 }
diff --git a/tools/testing/selftests/bpf/progs/test_seg6_loop.c b/tools/testing/selftests/bpf/progs/test_seg6_loop.c
index 463964d79f73..1dbe1d4d467e 100644
--- a/tools/testing/selftests/bpf/progs/test_seg6_loop.c
+++ b/tools/testing/selftests/bpf/progs/test_seg6_loop.c
@@ -54,7 +54,7 @@ struct sr6_tlv_t {
 	unsigned char value[0];
 } BPF_PACKET_HEADER;
 
-static __attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff *skb)
+static __always_inline struct ip6_srh_t *get_srh(struct __sk_buff *skb)
 {
 	void *cursor, *data_end;
 	struct ip6_srh_t *srh;
@@ -88,9 +88,9 @@ static __attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff
 	return srh;
 }
 
-static __attribute__((always_inline))
-int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
-		   uint32_t old_pad, uint32_t pad_off)
+static __always_inline int update_tlv_pad(struct __sk_buff *skb,
+					  uint32_t new_pad, uint32_t old_pad,
+					  uint32_t pad_off)
 {
 	int err;
 
@@ -118,10 +118,11 @@ int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
 	return 0;
 }
 
-static __attribute__((always_inline))
-int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
-			  uint32_t *tlv_off, uint32_t *pad_size,
-			  uint32_t *pad_off)
+static __always_inline int is_valid_tlv_boundary(struct __sk_buff *skb,
+						 struct ip6_srh_t *srh,
+						 uint32_t *tlv_off,
+						 uint32_t *pad_size,
+						 uint32_t *pad_off)
 {
 	uint32_t srh_off, cur_off;
 	int offset_valid = 0;
@@ -177,9 +178,9 @@ int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	return 0;
 }
 
-static __attribute__((always_inline))
-int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
-	    struct sr6_tlv_t *itlv, uint8_t tlv_size)
+static __always_inline int add_tlv(struct __sk_buff *skb,
+				   struct ip6_srh_t *srh, uint32_t tlv_off,
+				   struct sr6_tlv_t *itlv, uint8_t tlv_size)
 {
 	uint32_t srh_off = (char *)srh - (char *)(long)skb->data;
 	uint8_t len_remaining, new_pad;
diff --git a/tools/testing/selftests/bpf/progs/test_verif_scale2.c b/tools/testing/selftests/bpf/progs/test_verif_scale2.c
index 77830693eccb..9897150ed516 100644
--- a/tools/testing/selftests/bpf/progs/test_verif_scale2.c
+++ b/tools/testing/selftests/bpf/progs/test_verif_scale2.c
@@ -2,7 +2,7 @@
 // Copyright (c) 2019 Facebook
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
-#define ATTR __attribute__((always_inline))
+#define ATTR __always_inline
 #include "test_jhash.h"
 
 SEC("scale90_inline")
-- 
2.18.1

