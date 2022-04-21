Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7750509476
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383469AbiDUAl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383457AbiDUAlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:41:55 -0400
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39B0220ED;
        Wed, 20 Apr 2022 17:39:07 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:38:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501546;
        bh=h36ggskq9XGdjBzPQnssVWN6Wf4iatLNUirRoRiZBiw=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=OPefelKWg3a3dc5CM+Llww0E8ejWJF79yrwH+/bMFAp0Vdv6ZMhndPKiLLkJhzfnc
         LvMJixUnblLiq/pjz3DQf+QJ/KQ/eUxdr242SV+sx5UKT9QwIXJekNU/04JIuPORn8
         pa4tlEnFh2HIfI9h66mm4nrIQyX/XDOXaZ8qvB8r7YrjmvG5Kn0DJQzss47Zuj4buw
         Ve++O26D0XYWZ7AKDswIgatuWGqdnJGtuQJI8pXviQVdQJD97FlbWKR0OpX4Lvkjkc
         UHUm9ZGCjpyp6rWoew0zGtTUIlhR9rVqh8BbOJRu/FFQrWneE5Cw1fA2NqW4C7gBSi
         wjtnfMp8ViNAg==
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
Subject: [PATCH v2 bpf 02/11] bpftool: define a local bpf_perf_link to fix accessing its fields
Message-ID: <20220421003152.339542-3-alobakin@pm.me>
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

When building bpftool with !CONFIG_PERF_EVENTS:

skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type 'struct=
 bpf_perf_link'
        perf_link =3D container_of(link, struct bpf_perf_link, link);
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: note: e=
xpanded from macro 'container_of'
                ((type *)(__mptr - offsetof(type, member)));    \
                                   ^~~~~~~~~~~~~~~~~~~~~~
tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: note: e=
xpanded from macro 'offsetof'
 #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBER)
                                                  ~~~~~~~~~~~^
skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct bpf_perf=
_link'
        struct bpf_perf_link *perf_link;
               ^

&bpf_perf_link is being defined and used only under the ifdef.
Define struct bpf_perf_link___local with the `preserve_access_index`
attribute inside the pid_iter BPF prog to allow compiling on any
configs. CO-RE will substitute it with the real struct bpf_perf_link
accesses later on.
container_of() is not CO-REd, but it is a noop for
bpf_perf_link <-> bpf_link and the local copy is a full mirror of
the original structure.

Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/=
skeleton/pid_iter.bpf.c
index e2af8e5fb29e..3a4c4f7d83d8 100644
--- a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
+++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
@@ -15,6 +15,11 @@ enum bpf_obj_type {
 =09BPF_OBJ_BTF,
 };

+struct bpf_perf_link___local {
+=09struct bpf_link link;
+=09struct file *perf_file;
+} __attribute__((preserve_access_index));
+
 struct perf_event___local {
 =09u64 bpf_cookie;
 } __attribute__((preserve_access_index));
@@ -45,10 +50,10 @@ static __always_inline __u32 get_obj_id(void *ent, enum=
 bpf_obj_type type)
 /* could be used only with BPF_LINK_TYPE_PERF_EVENT links */
 static __u64 get_bpf_cookie(struct bpf_link *link)
 {
+=09struct bpf_perf_link___local *perf_link;
 =09struct perf_event___local *event;
-=09struct bpf_perf_link *perf_link;

-=09perf_link =3D container_of(link, struct bpf_perf_link, link);
+=09perf_link =3D container_of(link, struct bpf_perf_link___local, link);
 =09event =3D BPF_CORE_READ(perf_link, perf_file, private_data);
 =09return BPF_CORE_READ(event, bpf_cookie);
 }
--
2.36.0


