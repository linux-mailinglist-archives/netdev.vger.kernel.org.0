Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52C2467E84
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 20:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382909AbhLCT7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:59:04 -0500
Received: from mga05.intel.com ([192.55.52.43]:21039 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353675AbhLCT7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 14:59:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="323301133"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="323301133"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 11:55:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="501312024"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 03 Dec 2021 11:55:33 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B3JtUVN022961;
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
Subject: [PATCH bpf 2/2] samples: bpf: fix 'unknown warning group' build warning on Clang
Date:   Fri,  3 Dec 2021 20:50:04 +0100
Message-Id: <20211203195004.5803-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211203195004.5803-1-alexandr.lobakin@intel.com>
References: <20211203195004.5803-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang doesn't have 'stringop-truncation' group like GCC does, and
complains about it when building samples which use xdp_sample_user
infra:

 samples/bpf/xdp_sample_user.h:48:32: warning: unknown warning group '-Wstringop-truncation', ignored [-Wunknown-warning-option]
 #pragma GCC diagnostic ignored "-Wstringop-truncation"
                                ^
[ repeat ]

Those are harmless, but avoidable when guarding it with ifdef.
I could guard push/pop as well, but this would require one more
ifdef cruft around a single line which I don't think is reasonable.

Fixes: 156f886cf697 ("samples: bpf: Add basic infrastructure for XDP samples")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 samples/bpf/xdp_sample_user.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index d97465ff8c62..5f44b877ecf5 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -45,7 +45,9 @@ const char *get_driver_name(int ifindex);
 int get_mac_addr(int ifindex, void *mac_addr);
 
 #pragma GCC diagnostic push
+#ifndef __clang__
 #pragma GCC diagnostic ignored "-Wstringop-truncation"
+#endif
 __attribute__((unused))
 static inline char *safe_strncpy(char *dst, const char *src, size_t size)
 {
-- 
2.33.1

