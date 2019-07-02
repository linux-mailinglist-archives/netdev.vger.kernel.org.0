Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D50435D565
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfGBRlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:41:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfGBRlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 13:41:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77106307C947;
        Tue,  2 Jul 2019 17:41:09 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.205.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7CF360C43;
        Tue,  2 Jul 2019 17:41:07 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>, Y Song <ys114321@gmail.com>
Subject: [PATCH bpf v2] selftests: bpf: fix inlines in test_lwt_seg6local
Date:   Tue,  2 Jul 2019 19:40:31 +0200
Message-Id: <bf60860191c7d4ab0f50fe3143f3d175bd6ee112.1562089104.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 02 Jul 2019 17:41:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Selftests are reporting this failure in test_lwt_seg6local.sh:

+ ip netns exec ns2 ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
Error fetching program/map!
Failed to parse eBPF program: Operation not permitted

The problem is __attribute__((always_inline)) alone is not enough to prevent
clang from inserting those functions in .text. In that case, .text is not
marked as relocateable.

See the output of objdump -h test_lwt_seg6local.o:

Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         00003530  0000000000000000  0000000000000000  00000040  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, CODE

This causes the iproute bpf loader to fail in bpf_fetch_prog_sec:
bpf_has_call_data returns true but bpf_fetch_prog_relo fails as there's no
relocateable .text section in the file.

To fix this, convert to 'static __always_inline'.

v2: Use 'static __always_inline' instead of 'static inline
    __attribute__((always_inline))'

Fixes: c99a84eac026 ("selftests/bpf: test for seg6local End.BPF action")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 .../testing/selftests/bpf/progs/test_lwt_seg6local.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c b/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
index 0575751bc1bc..e2f6ed0a583d 100644
--- a/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
+++ b/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
@@ -61,7 +61,7 @@ struct sr6_tlv_t {
 	unsigned char value[0];
 } BPF_PACKET_HEADER;
 
-__attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff *skb)
+static __always_inline struct ip6_srh_t *get_srh(struct __sk_buff *skb)
 {
 	void *cursor, *data_end;
 	struct ip6_srh_t *srh;
@@ -95,7 +95,7 @@ __attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff *skb)
 	return srh;
 }
 
-__attribute__((always_inline))
+static __always_inline
 int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
 		   uint32_t old_pad, uint32_t pad_off)
 {
@@ -125,7 +125,7 @@ int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
 	return 0;
 }
 
-__attribute__((always_inline))
+static __always_inline
 int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
 			  uint32_t *tlv_off, uint32_t *pad_size,
 			  uint32_t *pad_off)
@@ -184,7 +184,7 @@ int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	return 0;
 }
 
-__attribute__((always_inline))
+static __always_inline
 int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
 	    struct sr6_tlv_t *itlv, uint8_t tlv_size)
 {
@@ -228,7 +228,7 @@ int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
 	return update_tlv_pad(skb, new_pad, pad_size, pad_off);
 }
 
-__attribute__((always_inline))
+static __always_inline
 int delete_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	       uint32_t tlv_off)
 {
@@ -266,7 +266,7 @@ int delete_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	return update_tlv_pad(skb, new_pad, pad_size, pad_off);
 }
 
-__attribute__((always_inline))
+static __always_inline
 int has_egr_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh)
 {
 	int tlv_offset = sizeof(struct ip6_t) + sizeof(struct ip6_srh_t) +
-- 
2.18.1

