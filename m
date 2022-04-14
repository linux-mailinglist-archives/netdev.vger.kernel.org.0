Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7851501E96
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347238AbiDNWsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347253AbiDNWsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:48:30 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BEAC6EF0;
        Thu, 14 Apr 2022 15:45:59 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:45:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976355;
        bh=4UBxbz5wf4h5VLr17g7++AvyCOaKrTuecaQ7HkJeJ4c=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=MooR0+CEAV4XbA72GQZXTEX0qrP/7bHt4An7MuN15EsMiCeJbogR0SuNVdOa0OE6z
         i5+DpHyyLJJ93Op7sWb/op+qLU0EmssLRgsQvozEzp9XCuYj6OxIshSNSU9RqC/0Oh
         rUaMn5VIHKUuG4Vr7yn/ye0MEfT3ZHK0QwLU+Z3HP7UjnJLtV8rbSCsNs2o9lknyl3
         zDaxvV7foY/Do1y9UGcYfDuYlthxRsfNMA15DpXT7vIEl4izRnpnOpeCivqxQ1q0Ma
         f68vfMrSc7K+gHtcmWUFMHgeMGPcdlBaL1OiaRrmvwFuNffHMfOdFLnVH4nCscDzqr
         +qg809I6lI6qQ==
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
Subject: [PATCH bpf-next 05/11] samples: bpf: use host bpftool to generate vmlinux.h, not target
Message-ID: <20220414223704.341028-6-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-1-alobakin@pm.me>
References: <20220414223704.341028-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the host build of bpftool (bootstrap) instead of the target one
to generate vmlinux.h/skeletons for the BPF samples. Otherwise, when
host !=3D target, samples compilation fails with:

/bin/sh: line 1: samples/bpf/bpftool/bpftool: failed to exec: Exec
format error

Fixes: 384b6b3bbf0d ("samples: bpf: Add vmlinux.h generation support")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 97203c0de252..02f999a8ef84 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -291,12 +291,13 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_S=
RC)/Makefile) | $(LIBBPF_OU

 BPFTOOLDIR :=3D $(TOOLS_PATH)/bpf/bpftool
 BPFTOOL_OUTPUT :=3D $(abspath $(BPF_SAMPLES_PATH))/bpftool
-BPFTOOL :=3D $(BPFTOOL_OUTPUT)/bpftool
+BPFTOOL :=3D $(BPFTOOL_OUTPUT)/bootstrap/bpftool
 $(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefi=
le) | $(BPFTOOL_OUTPUT)
 =09    $(MAKE) -C $(BPFTOOLDIR) srctree=3D$(BPF_SAMPLES_PATH)/../../ \
 =09=09OUTPUT=3D$(BPFTOOL_OUTPUT)/ \
 =09=09LIBBPF_OUTPUT=3D$(LIBBPF_OUTPUT)/ \
-=09=09LIBBPF_DESTDIR=3D$(LIBBPF_DESTDIR)/
+=09=09LIBBPF_DESTDIR=3D$(LIBBPF_DESTDIR)/ \
+=09=09bootstrap

 $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
 =09$(call msg,MKDIR,$@)
--
2.35.2


