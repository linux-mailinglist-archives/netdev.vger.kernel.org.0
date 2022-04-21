Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F750944B
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383555AbiDUAmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383578AbiDUAmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:42:43 -0400
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F024DFC8;
        Wed, 20 Apr 2022 17:39:55 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:39:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501593;
        bh=J9EMLBfyl6d0EbP75AQ2MnE0hjjzekwUZInxavmwZss=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=qJARHcrj6Hh60qCbLVmoEFR3CuENFViDy1rPraIGl/Az3GCz8Aq5S8KZV8rEkoWYR
         dJfIfBrVytWgcc6VZqf0UtjCpqkv6GIdxsYDouYrxXM4+3XoG+QEsL3uwZMsVK6PQw
         wYw9PVFhvkocayxI26r/CLtEAbjIRj9wJiMgnL1AS3kldqrU4k48s9n+FvYx9hPLs/
         cdD9roNtSs5MYXw33n//IppafEWUhRy6dTwD07lLXeigM/5EwMVcAYxqbnajpFJhiQ
         b2yTZGosWBP4bfVmBEJY5FYXZ8WbirlecCte/6otmdjkan8EZPZ5HkNgElhVcKKQnq
         fUtpFql4HMDhg==
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
Subject: [PATCH v2 bpf 09/11] samples/bpf: fix include order for non-Glibc environments
Message-ID: <20220421003152.339542-10-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/task_fd_query_user.c | 2 +-
 samples/bpf/xdpsock_user.c       | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_u=
ser.c
index c9a0ca8351fd..c0ecca01d890 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -9,11 +9,11 @@
 #include <stdint.h>
 #include <fcntl.h>
 #include <linux/bpf.h>
+#include <linux/perf_event.h>
 #include <sys/ioctl.h>
 #include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <linux/perf_event.h>

 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 6f3fe30ad283..9747d47a0a8f 100644
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
2.36.0


