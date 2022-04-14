Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44CB501E8F
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347172AbiDNWrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347153AbiDNWrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:47:39 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B2FC559B;
        Thu, 14 Apr 2022 15:45:13 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:45:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976310;
        bh=uv61apQIeQt8drF2A52PZrs8AoOA0Lvm41y6dOx4zW4=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=dWY+JprLs4JIrIWoJF/Ubs58DGuvqgzq0bbgkJbERbj+vlcFLFU4rLtZoy/LqcBem
         j5UIXLMFErTLjO5XpUmTD1bJor/Sv45lvgS54UbUxhe4TFAvY2KbYulb1Bc6QfZ7YY
         GEluu1k5+/WyknMrfSSIHY3WTmzhoGSpwCUZ/dwyv/lZGHRo3ell+m8rxkxWI34P0t
         zg2nC6c1GBM5nxedFuxOziSD0uwPAUxoWlzIYpkXqeG1VlJpQ+eowVW9yrtjgdiWVJ
         +zQtLu/qJJaA85eYPNHDmu6+wcUeI06oX1xMr9mrHwF3zuEkxafI4uQ2aEkxqHe7xu
         InZyBMxrBp/Gg==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH bpf-next 02/11] bpf: always emit struct bpf_perf_link BTF
Message-ID: <20220414223704.341028-3-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-1-alobakin@pm.me>
References: <20220414223704.341028-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Move it out of the block and explicitly emit a BTF to fix
compilation.

Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 kernel/bpf/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e9621cfa09f2..34fdf27d14cf 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2952,12 +2952,12 @@ static const struct bpf_link_ops bpf_raw_tp_link_lo=
ps =3D {
 =09.fill_link_info =3D bpf_raw_tp_link_fill_link_info,
 };

-#ifdef CONFIG_PERF_EVENTS
 struct bpf_perf_link {
 =09struct bpf_link link;
 =09struct file *perf_file;
 };

+#ifdef CONFIG_PERF_EVENTS
 static void bpf_perf_link_release(struct bpf_link *link)
 {
 =09struct bpf_perf_link *perf_link =3D container_of(link, struct bpf_perf_=
link, link);
@@ -4333,6 +4333,7 @@ static int link_create(union bpf_attr *attr, bpfptr_t=
 uattr)
 #endif
 =09case BPF_PROG_TYPE_PERF_EVENT:
 =09case BPF_PROG_TYPE_TRACEPOINT:
+=09=09BTF_TYPE_EMIT(struct bpf_perf_link);
 =09=09ret =3D bpf_perf_link_attach(attr, prog);
 =09=09break;
 =09case BPF_PROG_TYPE_KPROBE:
--
2.35.2


