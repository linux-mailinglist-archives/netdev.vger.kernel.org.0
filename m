Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF013501EAB
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347345AbiDNWtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345500AbiDNWtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:49:31 -0400
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236C5C8BFD;
        Thu, 14 Apr 2022 15:47:02 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:46:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976420;
        bh=PEDAO2gdSiFRYDFQPzekiNHelP6dYcLV8W7h2o7bylk=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=QHoSlbFjf/Kt42k1QML0xtJ8oejvL8X+tAEFv/nsHe8Ff3PQZtHTi++9Iq/59YmQS
         1hDTnY12ldGaBakqr4D2UDRXQF7k6Z2xQC1OKyyExd2OINI7yc3czb+qPnHfpc/y1K
         jtMmDIyGRHjNUjk0UCdJQWl5TbEQ66u8D48Y585iGQ7ub2ue37KezYbyTwTYxyoYOb
         Dtj8qPuqHXVW6bsioTlJMuxWbUdxSIo6kyKln9JaBA4i/A9nuvFLOty4a/IpeUxrfG
         YuIroPBF0Jn9brL75ErSOdvivLhH2gHzVDyXFJSg/4vUUufqjTWCGOcgT6PE4Eb1Qw
         Xg8wGvE7ccFzg==
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
Subject: [PATCH bpf-next 09/11] samples: bpf: fix include order for non-Glibc environments
Message-ID: <20220414223704.341028-10-alobakin@pm.me>
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

Some standard C library implementations, e.g. Musl, ship the UAPI
definitions themselves to not be dependent on the UAPI headers and
their versions. Their kernel UAPI counterparts are usually guarded
with some definitions which the formers set in order to avoid
duplicate definitions.
In such cases, include order matters. Change it in two samples: in
the first, kernel UAPI ioctl definitions should go before the libc
ones, and the opposite story with the second, where the kernel
includes should go later to avoid struct redefinitions.

Fixes: b4b8faa1ded7 ("samples/bpf: sample application and documentation for=
 AF_XDP sockets")
Fixes: e55190f26f92 ("samples/bpf: Fix build for task_fd_query_user.c")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/task_fd_query_user.c | 2 +-
 samples/bpf/xdpsock_user.c       | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_u=
ser.c
index 424718c0872c..5d3a60547f9f 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -9,10 +9,10 @@
 #include <stdint.h>
 #include <fcntl.h>
 #include <linux/bpf.h>
+#include <linux/perf_event.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <linux/perf_event.h>

 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index be7d2572e3e6..399b999fcec2 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -7,14 +7,15 @@
 #include <linux/bpf.h>
 #include <linux/if_link.h>
 #include <linux/if_xdp.h>
-#include <linux/if_ether.h>
 #include <linux/ip.h>
 #include <linux/limits.h>
+#include <linux/net.h>
 #include <linux/udp.h>
 #include <arpa/inet.h>
 #include <locale.h>
 #include <net/ethernet.h>
 #include <netinet/ether.h>
+#include <linux/if_ether.h>
 #include <net/if.h>
 #include <poll.h>
 #include <pthread.h>
--
2.35.2


