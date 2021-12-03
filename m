Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B65467E82
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 20:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353712AbhLCT7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:59:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:25892 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353652AbhLCT7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 14:59:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="297844602"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="297844602"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 11:55:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="478440007"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 03 Dec 2021 11:55:32 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B3JtUVM022961;
        Fri, 3 Dec 2021 19:55:31 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH bpf 1/2] samples: bpf: fix xdp_sample_user.o linking with Clang
Date:   Fri,  3 Dec 2021 20:50:03 +0100
Message-Id: <20211203195004.5803-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211203195004.5803-1-alexandr.lobakin@intel.com>
References: <20211203195004.5803-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang (13) doesn't get the jokes about specifying libraries to link in
cclags of individual .o objects:

clang-13: warning: -lm: 'linker' input unused [-Wunused-command-line-argument]
[ ... ]
  LD  samples/bpf/xdp_redirect_cpu
  LD  samples/bpf/xdp_redirect_map_multi
  LD  samples/bpf/xdp_redirect_map
  LD  samples/bpf/xdp_redirect
  LD  samples/bpf/xdp_monitor
/usr/bin/ld: samples/bpf/xdp_sample_user.o: in function `sample_summary_print':
xdp_sample_user.c:(.text+0x84c): undefined reference to `floor'
/usr/bin/ld: xdp_sample_user.c:(.text+0x870): undefined reference to `ceil'
/usr/bin/ld: xdp_sample_user.c:(.text+0x8cf): undefined reference to `floor'
/usr/bin/ld: xdp_sample_user.c:(.text+0x8f3): undefined reference to `ceil'
[ more ]

Specify '-lm' as ldflags for all xdp_sample_user.o users in the main
Makefile and remove it from ccflags of ^ in Makefile.target -- just
like it's done for all other samples. This works with all compilers.

Fixes: 6e1051a54e31 ("samples: bpf: Convert xdp_monitor to XDP samples helper")
Fixes: b926c55d856c ("samples: bpf: Convert xdp_redirect to XDP samples helper")
Fixes: e531a220cc59 ("samples: bpf: Convert xdp_redirect_cpu to XDP samples helper")
Fixes: bbe65865aa05 ("samples: bpf: Convert xdp_redirect_map to XDP samples helper")
Fixes: 594a116b2aa1 ("samples: bpf: Convert xdp_redirect_map_multi to XDP samples helper")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 samples/bpf/Makefile        | 5 +++++
 samples/bpf/Makefile.target | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index a886dff1ba89..e5b049ad5447 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -215,6 +215,11 @@ TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
 endif
 
 TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz
+TPROGLDLIBS_xdp_monitor		+= -lm
+TPROGLDLIBS_xdp_redirect	+= -lm
+TPROGLDLIBS_xdp_redirect_cpu	+= -lm
+TPROGLDLIBS_xdp_redirect_map	+= -lm
+TPROGLDLIBS_xdp_redirect_map_multi += -lm
 TPROGLDLIBS_tracex4		+= -lrt
 TPROGLDLIBS_trace_output	+= -lrt
 TPROGLDLIBS_map_perf_test	+= -lrt
diff --git a/samples/bpf/Makefile.target b/samples/bpf/Makefile.target
index 5a368affa038..379560f11db4 100644
--- a/samples/bpf/Makefile.target
+++ b/samples/bpf/Makefile.target
@@ -76,7 +76,7 @@ $(tprog-cobjs): $(obj)/%.o: $(src)/%.c FORCE
 
 # Override includes for xdp_sample_user.o because $(srctree)/usr/include in
 # TPROGS_CFLAGS causes conflicts
-XDP_SAMPLE_CFLAGS += -Wall -O2 -lm \
+XDP_SAMPLE_CFLAGS += -Wall -O2 \
 		     -I./tools/include \
 		     -I./tools/include/uapi \
 		     -I./tools/lib \
-- 
2.33.1

