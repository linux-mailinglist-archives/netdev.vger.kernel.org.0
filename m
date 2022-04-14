Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178B2501E94
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347274AbiDNWsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiDNWsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:48:41 -0400
X-Greylist: delayed 92 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 14 Apr 2022 15:46:15 PDT
Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E9DC6B76;
        Thu, 14 Apr 2022 15:46:15 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:46:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976373;
        bh=+DkRIXJc5M3gz3F1I0xigPA/k06QlcMXGhroeUqQePw=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=HQiMjgfKOjR3X8TVweXIVyu1t4Gd2yBQvkpZ6YSQzI+fFkGQoNk7nXgVD2uZ4EXNT
         eo3BJ/Xd/bWnrp/ClkfhLYLMO2GoXnTWE9gvTnCv6qf8ceUb6jJE1+lKhJ1LONCpxy
         ELnrljzwRInDfLKRtetJn7/Y4YBka9BOd4B5EeDJaDIM+mtxVHHBQO7D/933Hj9Z91
         Ea7hngMlNPpGn4g4EizCKziBbiPYdnbdv/YiIR7zzgV3hk4zo0v0HEOyUquzjzIO+O
         8d7ZdZLYnTtFuHzvzi+WsZx8plerCzOqB6eqW30tVoPH8mDFimIu7dBPyyjVb8uYFo
         4me2Zigwe515w==
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
Subject: [PATCH bpf-next 06/11] tools, bpf: fix fcntl.h include in bpftool
Message-ID: <20220414223704.341028-7-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-1-alobakin@pm.me>
References: <20220414223704.341028-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following (on some libc implementations):

  CC      tracelog.o
In file included from tracelog.c:12:
include/sys/fcntl.h:1:2: warning: #warning redirecting incorrect #include <=
sys/fcntl.h> to <fcntl.h> [-Wcpp]
    1 | #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h>
      |  ^~~~~~~

<sys/fcntl.h> is anyway just a wrapper over <fcntl.h> (backcomp
stuff).

Fixes: 30da46b5dc3a ("tools: bpftool: add a command to dump the trace pipe"=
)
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 tools/bpf/bpftool/tracelog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/tracelog.c b/tools/bpf/bpftool/tracelog.c
index e80a5c79b38f..bf1f02212797 100644
--- a/tools/bpf/bpftool/tracelog.c
+++ b/tools/bpf/bpftool/tracelog.c
@@ -9,7 +9,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <linux/magic.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 #include <sys/vfs.h>

 #include "main.h"
--
2.35.2


