Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EB7509441
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383480AbiDUAmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383466AbiDUAl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:41:57 -0400
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B068921824;
        Wed, 20 Apr 2022 17:39:09 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:39:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501548;
        bh=/g4pmmtM4Oo/NDEXoriizu4gAbFoM5evYeKkWecSlPo=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=k/WI8gCgbA/7H7mcN1b6NuIjFe0vc31u1hLtl8ksxXxNWMUBpPV5i7+qGZgZDfOMb
         ZJJtN9LFRURpWzTf7z1pHMoE+x+8GcvXhM7910qM83oEd2Gv8RWCqv5wMgPINl8aIP
         YZobarZReKbUDhIXsN0Yieq/ylDE5hbIyA+2WlIv6h3pEshLaIpfzUVkhgn0ZN8iSU
         gc/LruJoeWTqcYNoNLYXsz4ZJfrGja8GC6KzYjv5FSZ9Wc6SJ33IIyqixSsrfySm9D
         2j5uOuMIIslSFFlzkSyjeYdGGn2NAc84b01sXRDRpBoEBEY8FvrRTpBnjAVd2C+/2s
         bgGUZtREiDHbQ==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf 03/11] bpftool: use a local bpf_perf_event_value to fix accessing its fields
Message-ID: <20220421003152.339542-4-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following error when building bpftool:

  CLANG   profiler.bpf.o
  CLANG   pid_iter.bpf.o
skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof' to an=
 incomplete type 'struct bpf_perf_event_value'
        __uint(value_size, sizeof(struct bpf_perf_event_value));
                           ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:13:39: note: e=
xpanded from macro '__uint'
tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helper_defs.h:7:8: note:=
 forward declaration of 'struct bpf_perf_event_value'
struct bpf_perf_event_value;
       ^

struct bpf_perf_event_value is being used in the kernel only when
CONFIG_BPF_EVENTS is enabled, so it misses a BTF entry then.
Define struct bpf_perf_event_value___local with the
`preserve_access_index` attribute inside the pid_iter BPF prog to
allow compiling on any configs. It is a full mirror of a UAPI
structure, so is compatible both with and w/o CO-RE.
bpf_perf_event_read_value() requires a pointer of the original type,
so a cast is needed.

Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 tools/bpf/bpftool/skeleton/profiler.bpf.c | 27 ++++++++++++++---------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/=
skeleton/profiler.bpf.c
index ce5b65e07ab1..2f80edc682f1 100644
--- a/tools/bpf/bpftool/skeleton/profiler.bpf.c
+++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
@@ -4,6 +4,12 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>

+struct bpf_perf_event_value___local {
+=09__u64 counter;
+=09__u64 enabled;
+=09__u64 running;
+} __attribute__((preserve_access_index));
+
 /* map of perf event fds, num_cpu * num_metric entries */
 struct {
 =09__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
@@ -15,14 +21,14 @@ struct {
 struct {
 =09__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 =09__uint(key_size, sizeof(u32));
-=09__uint(value_size, sizeof(struct bpf_perf_event_value));
+=09__uint(value_size, sizeof(struct bpf_perf_event_value___local));
 } fentry_readings SEC(".maps");

 /* accumulated readings */
 struct {
 =09__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 =09__uint(key_size, sizeof(u32));
-=09__uint(value_size, sizeof(struct bpf_perf_event_value));
+=09__uint(value_size, sizeof(struct bpf_perf_event_value___local));
 } accum_readings SEC(".maps");

 /* sample counts, one per cpu */
@@ -39,7 +45,7 @@ const volatile __u32 num_metric =3D 1;
 SEC("fentry/XXX")
 int BPF_PROG(fentry_XXX)
 {
-=09struct bpf_perf_event_value *ptrs[MAX_NUM_MATRICS];
+=09struct bpf_perf_event_value___local *ptrs[MAX_NUM_MATRICS];
 =09u32 key =3D bpf_get_smp_processor_id();
 =09u32 i;

@@ -53,10 +59,10 @@ int BPF_PROG(fentry_XXX)
 =09}

 =09for (i =3D 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
-=09=09struct bpf_perf_event_value reading;
+=09=09struct bpf_perf_event_value___local reading;
 =09=09int err;

-=09=09err =3D bpf_perf_event_read_value(&events, key, &reading,
+=09=09err =3D bpf_perf_event_read_value(&events, key, (void *)&reading,
 =09=09=09=09=09=09sizeof(reading));
 =09=09if (err)
 =09=09=09return 0;
@@ -68,14 +74,14 @@ int BPF_PROG(fentry_XXX)
 }

 static inline void
-fexit_update_maps(u32 id, struct bpf_perf_event_value *after)
+fexit_update_maps(u32 id, struct bpf_perf_event_value___local *after)
 {
-=09struct bpf_perf_event_value *before, diff;
+=09struct bpf_perf_event_value___local *before, diff;

 =09before =3D bpf_map_lookup_elem(&fentry_readings, &id);
 =09/* only account samples with a valid fentry_reading */
 =09if (before && before->counter) {
-=09=09struct bpf_perf_event_value *accum;
+=09=09struct bpf_perf_event_value___local *accum;

 =09=09diff.counter =3D after->counter - before->counter;
 =09=09diff.enabled =3D after->enabled - before->enabled;
@@ -93,7 +99,7 @@ fexit_update_maps(u32 id, struct bpf_perf_event_value *af=
ter)
 SEC("fexit/XXX")
 int BPF_PROG(fexit_XXX)
 {
-=09struct bpf_perf_event_value readings[MAX_NUM_MATRICS];
+=09struct bpf_perf_event_value___local readings[MAX_NUM_MATRICS];
 =09u32 cpu =3D bpf_get_smp_processor_id();
 =09u32 i, zero =3D 0;
 =09int err;
@@ -102,7 +108,8 @@ int BPF_PROG(fexit_XXX)
 =09/* read all events before updating the maps, to reduce error */
 =09for (i =3D 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
 =09=09err =3D bpf_perf_event_read_value(&events, cpu + i * num_cpu,
-=09=09=09=09=09=09readings + i, sizeof(*readings));
+=09=09=09=09=09=09(void *)(readings + i),
+=09=09=09=09=09=09sizeof(*readings));
 =09=09if (err)
 =09=09=09return 0;
 =09}
--
2.36.0


