Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD471501EA8
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347332AbiDNWtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347310AbiDNWtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:49:41 -0400
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F51C8BF1
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 15:47:14 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:47:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976433;
        bh=THMmkXXMS2lPNNZpAKvu3GAAetFAVRpTegVE6Ot/KkU=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=OXkMtj7iaWudLwGUwWTU7oX0NF7hArQWxhthVlcg3TIgPYTx8RSG42gqGiU0Cve2y
         BYUA9IRlAcKYpB5XNnNj4k722gX0u+C8vCyNGLg7RNfRkuQHvESq2c5D/kPWDzUDYX
         A/XxycqH1wvrAZuxlVmH94RVwUOQpoiaEIwfXOhor/M9wvCZfKI2z6k1RuLbsF7P8Q
         PwsttRM3exP3+TixGhFGgbb4dIM1Y7iyQ+f3v9LpeadgCzMQ+EDKRN71eUoZA+PsFQ
         DH7TZBmw8kyGraPfnf+/a1OXNifL7FRvUSS78NRqVmrT2SuuXgab8WjmEUww+SeRvE
         iiARFXOmOeWiw==
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
Subject: [PATCH bpf-next 10/11] samples: bpf: fix -Wsequence-point
Message-ID: <20220414223704.341028-11-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-1-alobakin@pm.me>
References: <20220414223704.341028-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some libc implementations, CPU_SET() may utilize its first
argument several times. When combined with a post-increment, it
leads to:

samples/bpf/test_lru_dist.c:233:36: warning: operation on 'next_to_try' may=
 be undefined [-Wsequence-point]
  233 |                 CPU_SET(next_to_try++, &cpuset);
      |                                    ^

Split the sentence into two standalone operations to fix this.

Fixes: 5db58faf989f ("bpf: Add tests for the LRU bpf_htab")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/test_lru_dist.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
index be98ccb4952f..191643ec501e 100644
--- a/samples/bpf/test_lru_dist.c
+++ b/samples/bpf/test_lru_dist.c
@@ -229,7 +229,8 @@ static int sched_next_online(int pid, int next_to_try)

 =09while (next_to_try < nr_cpus) {
 =09=09CPU_ZERO(&cpuset);
-=09=09CPU_SET(next_to_try++, &cpuset);
+=09=09CPU_SET(next_to_try, &cpuset);
+=09=09next_to_try++;
 =09=09if (!sched_setaffinity(pid, sizeof(cpuset), &cpuset))
 =09=09=09break;
 =09}
--
2.35.2


