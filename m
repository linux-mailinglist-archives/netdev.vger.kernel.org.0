Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8E8470BE
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 17:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfFOPPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 11:15:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45518 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOPPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 11:15:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id bi6so2241469plb.12
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 08:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AP/dsp8YZswKO8Y0EsuLtxpPgBF2AJhv2A3krPXj6Gs=;
        b=oygvkmYW8MYPCdKH6V3oJc6Q+txFz9nijHgcwLrarfOqCJJz8AmD0Oaycq3IZQAyKK
         vyUgjKwo2yhZNgU8yYnLIGDcw9alM44kGBrNpbYSZEzCDJv0MJ3P6PPj/sVatX2NHwjH
         UEa37LYCJKDctVJxsGjWCE47RQTcEYwF1a9WyidZeO5/02/M9AA1/84dfdkckjBvsarm
         2FkuJU4ta/khA6UwpsrpFdNgxMuao6Q84kdurPFfDgSyOcuLiqd1OAcAjV1l7Wuy8DXm
         Q8fQReqH+/TCJCxijJHmvxj0KNpi1sbOUQH0XhopUwphuiB4KmD+dhVKoQK3/Lx4OwQx
         wjzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AP/dsp8YZswKO8Y0EsuLtxpPgBF2AJhv2A3krPXj6Gs=;
        b=uIK9dg20wAGhIpp6Gm6UqNXq3i2fwXRY+CY2l/I2+PTvf/Pxl51jWL33A1T+LY7lu7
         CGyEXybLLKgo6sYfaB1UtxGug9fkH202FCKVZBPWdM/s0p08XzfX1ezfU3EL+P+gw7Wh
         14HaK1lWq7cxi2bfeABelm9hfP9DWOJQCXD5tkW3oVmrZHsItW25gG4lLjh/BvtYxtv0
         9dlbwY07ScvGxUlwkLBDFAjXmmabyyQ1sH1IBM4epKrxSzAaSvXddCUFlfXSA2olK0C1
         AbCdL1yra8e22EwW4SD5+fZg3T9S6Bd2LQ1e81vE6eCcKLZ5i7ggGZWH+32IT1GJAtbh
         BSnA==
X-Gm-Message-State: APjAAAVdxXI9iMHGXkTxBAeOajz2CnhHx5UsMc8eaJxVWk2EowDomFqf
        rFcpN4r/9a2srRwWqeWbnA==
X-Google-Smtp-Source: APXvYqzpoUPVbIXaFOaXPbm4AynNscwTpQqlAYBFUqahQ+KlDYSbu7/woe8izUAVSJqJ5VDAMHEcPw==
X-Received: by 2002:a17:902:1e6:: with SMTP id b93mr55283427plb.295.1560611701079;
        Sat, 15 Jun 2019 08:15:01 -0700 (PDT)
Received: from localhost.localdomain ([111.118.56.180])
        by smtp.gmail.com with ESMTPSA id y22sm6158557pfm.70.2019.06.15.08.14.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 08:15:00 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 2/2] samples: bpf: refactor header include path
Date:   Sun, 16 Jun 2019 00:14:47 +0900
Message-Id: <20190615151447.10546-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190615151447.10546-1-danieltimlee@gmail.com>
References: <20190615151447.10546-1-danieltimlee@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, header inclusion in each file is inconsistent.
For example, "libbpf.h" header is included as multiple ways.

    #include "bpf/libbpf.h"
    #include "libbpf.h"

Due to commit b552d33c80a9 ("samples/bpf: fix include path
in Makefile"), $(srctree)/tools/lib/bpf/ path had been included
during build, path "bpf/" in header isn't necessary anymore.

This commit removes path "bpf/" in header inclusion.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/fds_example.c           | 2 +-
 samples/bpf/hbm.c                   | 4 ++--
 samples/bpf/ibumad_user.c           | 2 +-
 samples/bpf/sockex1_user.c          | 2 +-
 samples/bpf/sockex2_user.c          | 2 +-
 samples/bpf/xdp1_user.c             | 4 ++--
 samples/bpf/xdp_adjust_tail_user.c  | 4 ++--
 samples/bpf/xdp_fwd_user.c          | 2 +-
 samples/bpf/xdp_redirect_cpu_user.c | 2 +-
 samples/bpf/xdp_redirect_map_user.c | 2 +-
 samples/bpf/xdp_redirect_user.c     | 2 +-
 samples/bpf/xdp_router_ipv4_user.c  | 2 +-
 samples/bpf/xdp_rxq_info_user.c     | 4 ++--
 samples/bpf/xdp_tx_iptunnel_user.c  | 2 +-
 samples/bpf/xdpsock_user.c          | 4 ++--
 15 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/samples/bpf/fds_example.c b/samples/bpf/fds_example.c
index e51eb060244e..2d4b717726b6 100644
--- a/samples/bpf/fds_example.c
+++ b/samples/bpf/fds_example.c
@@ -14,7 +14,7 @@
 
 #include <bpf/bpf.h>
 
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 #include "bpf_insn.h"
 #include "sock_example.h"
 
diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index bdfce592207a..b905b32ff185 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -50,8 +50,8 @@
 #include "cgroup_helpers.h"
 #include "hbm.h"
 #include "bpf_util.h"
-#include "bpf/bpf.h"
-#include "bpf/libbpf.h"
+#include "bpf.h"
+#include "libbpf.h"
 
 bool outFlag = true;
 int minRate = 1000;		/* cgroup rate limit in Mbps */
diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
index 097d76143363..cb5a8f994849 100644
--- a/samples/bpf/ibumad_user.c
+++ b/samples/bpf/ibumad_user.c
@@ -25,7 +25,7 @@
 
 #include "bpf_load.h"
 #include "bpf_util.h"
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 
 static void dump_counts(int fd)
 {
diff --git a/samples/bpf/sockex1_user.c b/samples/bpf/sockex1_user.c
index 7f90796ae15a..a219442afbee 100644
--- a/samples/bpf/sockex1_user.c
+++ b/samples/bpf/sockex1_user.c
@@ -3,7 +3,7 @@
 #include <assert.h>
 #include <linux/bpf.h>
 #include <bpf/bpf.h>
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 #include "sock_example.h"
 #include <unistd.h>
 #include <arpa/inet.h>
diff --git a/samples/bpf/sockex2_user.c b/samples/bpf/sockex2_user.c
index bc257333ad92..6de383ddd08b 100644
--- a/samples/bpf/sockex2_user.c
+++ b/samples/bpf/sockex2_user.c
@@ -3,7 +3,7 @@
 #include <assert.h>
 #include <linux/bpf.h>
 #include <bpf/bpf.h>
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 #include "sock_example.h"
 #include <unistd.h>
 #include <arpa/inet.h>
diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index 6a64e93365e1..ae34caa2b22e 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -18,8 +18,8 @@
 #include <net/if.h>
 
 #include "bpf_util.h"
-#include "bpf/bpf.h"
-#include "bpf/libbpf.h"
+#include "bpf.h"
+#include "libbpf.h"
 
 static int ifindex;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
index 07e1b9269e49..586ff751aba9 100644
--- a/samples/bpf/xdp_adjust_tail_user.c
+++ b/samples/bpf/xdp_adjust_tail_user.c
@@ -18,8 +18,8 @@
 #include <netinet/ether.h>
 #include <unistd.h>
 #include <time.h>
-#include "bpf/bpf.h"
-#include "bpf/libbpf.h"
+#include "bpf.h"
+#include "libbpf.h"
 
 #define STATS_INTERVAL_S 2U
 
diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index f88e1d7093d6..5b46ee12c696 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -24,7 +24,7 @@
 #include <fcntl.h>
 #include <libgen.h>
 
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 #include <bpf/bpf.h>
 
 
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 586b294d72d3..f5dc7e1f8bc6 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -25,7 +25,7 @@ static const char *__doc__ =
 #define MAX_PROG 6
 
 #include <bpf/bpf.h>
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 
 #include "bpf_util.h"
 
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 1dbe7fd3a1a8..2bfd624069f3 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -24,7 +24,7 @@
 
 #include "bpf_util.h"
 #include <bpf/bpf.h>
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 
 static int ifindex_in;
 static int ifindex_out;
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index e9054c0269ff..fc725eb4674a 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -24,7 +24,7 @@
 
 #include "bpf_util.h"
 #include <bpf/bpf.h>
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 
 static int ifindex_in;
 static int ifindex_out;
diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index 79fe7bc26ab4..097a7ee564dc 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -24,7 +24,7 @@
 #include <sys/ioctl.h>
 #include <sys/syscall.h>
 #include "bpf_util.h"
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 #include <sys/resource.h>
 #include <libgen.h>
 
diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index 1210f3b170f0..c7e4e45d824a 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -22,8 +22,8 @@ static const char *__doc__ = " XDP RX-queue info extract example\n\n"
 #include <arpa/inet.h>
 #include <linux/if_link.h>
 
-#include "bpf/bpf.h"
-#include "bpf/libbpf.h"
+#include "bpf.h"
+#include "libbpf.h"
 #include "bpf_util.h"
 
 static int ifindex = -1;
diff --git a/samples/bpf/xdp_tx_iptunnel_user.c b/samples/bpf/xdp_tx_iptunnel_user.c
index 4a1511eb7812..d9a5617fe872 100644
--- a/samples/bpf/xdp_tx_iptunnel_user.c
+++ b/samples/bpf/xdp_tx_iptunnel_user.c
@@ -17,7 +17,7 @@
 #include <netinet/ether.h>
 #include <unistd.h>
 #include <time.h>
-#include "bpf/libbpf.h"
+#include "libbpf.h"
 #include <bpf/bpf.h>
 #include "bpf_util.h"
 #include "xdp_tx_iptunnel_common.h"
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index d08ee1ab7bb4..0f5eb0d7f2df 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -27,8 +27,8 @@
 #include <time.h>
 #include <unistd.h>
 
-#include "bpf/libbpf.h"
-#include "bpf/xsk.h"
+#include "libbpf.h"
+#include "xsk.h"
 #include <bpf/bpf.h>
 
 #ifndef SOL_XDP
-- 
2.17.1

