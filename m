Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D2766AFAF
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjAOHSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjAOHRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:17:04 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA60B47F;
        Sat, 14 Jan 2023 23:16:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id 20so68754plo.3;
        Sat, 14 Jan 2023 23:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Kn0HqKH1woDv5zNrRXar4SWzT3i9nml5kDUW9Kqf18=;
        b=SXd6WJj3uOl8pUbpCk3tCYfUCNcoO2k7cM07KjMCG6Uxe1v4lVFvt94/VR9lz4Cpdj
         7M5/KwowqM4xuml+/CSfnlkJszEOvRC4ZRLD2IREylZqG2ZecXM2nlaWaoRw9A3tUfzQ
         oe1X2quyAEhz2mxmkU/fjpWecgOmFOrxyl/ax9Fkjn05pKuz9g9r1m4KUUmbEpvsbKIq
         y2fNJOtmy0XaHdPdMO8Ny/unuCE3ClLR/qbgrmXPaOmYqHPt34htioHuGRGbsxc+F1Fc
         OAKFQknwB6otIVBsA/ItLYfVpGz3FGDdhC78UbybNLocJ5KfekgqVfn3Fv355k96tCDi
         KAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Kn0HqKH1woDv5zNrRXar4SWzT3i9nml5kDUW9Kqf18=;
        b=Y0T6DAW73lHErUlvBE1cGFqtEGaXfyRtS+XxbARqXK3nwWjLTrK9h+9hIzKcXx/0fk
         qalju8cgJq/CQcqQ+b58cKVTtOs2rLVNFaWL8bxEHUDukz1TCNHa4gooX3ZRYsECS7h8
         ZocHiygO2SmFG+11YvGCXD98rzY7umgJqzrhJRTvX0aAAhHB2mpjTQQQd73r/XkgHAzG
         BmutR3oxtBlKi+mnqzRSlaZ50XfhcQU+HqiBLqpShfRWLeMtjx4AIJXcldwomEWpcSK1
         GbScEuMVtaaxHcTFcIQpulfCcp09M4kcNsxRg0cc9aA4hdOpvA94+9OI5eJW6Y0Q3IFu
         ba2w==
X-Gm-Message-State: AFqh2krMOmVm1NLGFNO0fOkwOgnoAGHOpHo+j5rb4rkd39C4uiCijH04
        epNVBNJzfGxkXPB1eRRKYg==
X-Google-Smtp-Source: AMrXdXvlnrhtceuZL/iqISGKSDBCb3L/8L7I63OT5O2jZntP+W29SiZTzRBi8N9kBhBFwrbJG8VCKA==
X-Received: by 2002:a05:6a20:2d1f:b0:ac:9d6b:c1f0 with SMTP id g31-20020a056a202d1f00b000ac9d6bc1f0mr109316512pzl.40.1673767009058;
        Sat, 14 Jan 2023 23:16:49 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:48 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 08/10] samples/bpf: replace BPF programs header with net_shared.h
Date:   Sun, 15 Jan 2023 16:16:11 +0900
Message-Id: <20230115071613.125791-9-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit applies "net_shared.h" to BPF programs to remove existing
network related header dependencies. Also, this commit removes
unnecessary headers before applying "vmlinux.h" to the BPF programs.

Mostly, endianness conversion function has been applied to the source.
In addition, several macros have been defined to fulfill the INET,
TC-related constants.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/net_shared.h         |  6 ++++++
 samples/bpf/sock_flags_kern.c    | 10 +++++-----
 samples/bpf/test_cgrp2_tc_kern.c |  6 ++----
 samples/bpf/test_lwt_bpf.c       |  3 ++-
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/net_shared.h b/samples/bpf/net_shared.h
index 04b29b217d25..e9429af9aa44 100644
--- a/samples/bpf/net_shared.h
+++ b/samples/bpf/net_shared.h
@@ -2,6 +2,9 @@
 #ifndef _NET_SHARED_H
 #define _NET_SHARED_H
 
+#define AF_INET		2
+#define AF_INET6	10
+
 #define ETH_ALEN 6
 #define ETH_P_802_3_MIN 0x0600
 #define ETH_P_8021Q 0x8100
@@ -11,6 +14,9 @@
 #define ETH_P_ARP 0x0806
 #define IPPROTO_ICMPV6 58
 
+#define TC_ACT_OK		0
+#define TC_ACT_SHOT		2
+
 #if defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
 	__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 #define bpf_ntohs(x)		__builtin_bswap16(x)
diff --git a/samples/bpf/sock_flags_kern.c b/samples/bpf/sock_flags_kern.c
index 1d58cb9b6fa4..84837ed48eb3 100644
--- a/samples/bpf/sock_flags_kern.c
+++ b/samples/bpf/sock_flags_kern.c
@@ -1,5 +1,5 @@
+#include "net_shared.h"
 #include <uapi/linux/bpf.h>
-#include <linux/socket.h>
 #include <linux/net.h>
 #include <uapi/linux/in.h>
 #include <uapi/linux/in6.h>
@@ -17,10 +17,10 @@ int bpf_prog1(struct bpf_sock *sk)
 	bpf_trace_printk(fmt, sizeof(fmt), sk->family, sk->type, sk->protocol);
 	bpf_trace_printk(fmt2, sizeof(fmt2), uid, gid);
 
-	/* block PF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6 sockets
+	/* block AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6 sockets
 	 * ie., make ping6 fail
 	 */
-	if (sk->family == PF_INET6 &&
+	if (sk->family == AF_INET6 &&
 	    sk->type == SOCK_DGRAM   &&
 	    sk->protocol == IPPROTO_ICMPV6)
 		return 0;
@@ -35,10 +35,10 @@ int bpf_prog2(struct bpf_sock *sk)
 
 	bpf_trace_printk(fmt, sizeof(fmt), sk->family, sk->type, sk->protocol);
 
-	/* block PF_INET, SOCK_DGRAM, IPPROTO_ICMP sockets
+	/* block AF_INET, SOCK_DGRAM, IPPROTO_ICMP sockets
 	 * ie., make ping fail
 	 */
-	if (sk->family == PF_INET &&
+	if (sk->family == AF_INET &&
 	    sk->type == SOCK_DGRAM  &&
 	    sk->protocol == IPPROTO_ICMP)
 		return 0;
diff --git a/samples/bpf/test_cgrp2_tc_kern.c b/samples/bpf/test_cgrp2_tc_kern.c
index 737ce3eb8944..45a2f01d2029 100644
--- a/samples/bpf/test_cgrp2_tc_kern.c
+++ b/samples/bpf/test_cgrp2_tc_kern.c
@@ -5,10 +5,8 @@
  * License as published by the Free Software Foundation.
  */
 #define KBUILD_MODNAME "foo"
-#include <uapi/linux/if_ether.h>
-#include <uapi/linux/in6.h>
+#include "net_shared.h"
 #include <uapi/linux/ipv6.h>
-#include <uapi/linux/pkt_cls.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
@@ -42,7 +40,7 @@ int handle_egress(struct __sk_buff *skb)
 	if (data + sizeof(*eth) + sizeof(*ip6h) > data_end)
 		return TC_ACT_OK;
 
-	if (eth->h_proto != htons(ETH_P_IPV6) ||
+	if (eth->h_proto != bpf_htons(ETH_P_IPV6) ||
 	    ip6h->nexthdr != IPPROTO_ICMPV6) {
 		bpf_trace_printk(dont_care_msg, sizeof(dont_care_msg),
 				 eth->h_proto, ip6h->nexthdr);
diff --git a/samples/bpf/test_lwt_bpf.c b/samples/bpf/test_lwt_bpf.c
index f53dab88d231..fc093fbc760a 100644
--- a/samples/bpf/test_lwt_bpf.c
+++ b/samples/bpf/test_lwt_bpf.c
@@ -10,6 +10,7 @@
  * General Public License for more details.
  */
 
+#include "net_shared.h"
 #include <stdint.h>
 #include <stddef.h>
 #include <linux/bpf.h>
@@ -176,7 +177,7 @@ static inline int __do_push_ll_and_redirect(struct __sk_buff *skb)
 		printk("skb_change_head() failed: %d", ret);
 	}
 
-	ehdr.h_proto = __constant_htons(ETH_P_IP);
+	ehdr.h_proto = bpf_htons(ETH_P_IP);
 	memcpy(&ehdr.h_source, &smac, 6);
 	memcpy(&ehdr.h_dest, &dmac, 6);
 
-- 
2.34.1

