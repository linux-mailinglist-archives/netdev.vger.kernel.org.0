Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407F0450502
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhKONLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:11:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:35959 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhKONLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:11:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="230894609"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="230894609"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 05:08:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535501157"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 05:08:05 -0800
Received: from alobakin-mobl.ger.corp.intel.com (aglaza-mobl1.ger.corp.intel.com [10.213.5.121])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AFD82pd021961;
        Mon, 15 Nov 2021 13:08:02 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH bpf] samples: bpf: fix build error due to -isystem removal
Date:   Mon, 15 Nov 2021 14:07:41 +0100
Message-Id: <20211115130741.3584-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since recent Kbuild updates we no longer include files from compiler
directories. However, samples/bpf/hbm_kern.h hasn't been tuned for
this (LLVM 13):

  CLANG-bpf  samples/bpf/hbm_out_kern.o
In file included from samples/bpf/hbm_out_kern.c:55:
samples/bpf/hbm_kern.h:12:10: fatal error: 'stddef.h' file not found
         ^~~~~~~~~~
1 error generated.
  CLANG-bpf  samples/bpf/hbm_edt_kern.o
In file included from samples/bpf/hbm_edt_kern.c:53:
samples/bpf/hbm_kern.h:12:10: fatal error: 'stddef.h' file not found
         ^~~~~~~~~~
1 error generated.

It is enough to just drop both stdbool.h and stddef.h from includes
to fix those.

Fixes: 04e85bbf71c9 ("isystem: delete global -isystem compile option")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 samples/bpf/hbm_kern.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index 722b3fadb467..1752a46a2b05 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -9,8 +9,6 @@
  * Include file for sample Host Bandwidth Manager (HBM) BPF programs
  */
 #define KBUILD_MODNAME "foo"
-#include <stddef.h>
-#include <stdbool.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/if_ether.h>
 #include <uapi/linux/if_packet.h>
-- 
2.33.1

