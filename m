Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3010346794
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhCWS0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:26:35 -0400
Received: from outpost17.zedat.fu-berlin.de ([130.133.4.110]:36475 "EHLO
        outpost17.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231670AbhCWS0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:26:01 -0400
Received: from relay1.zedat.fu-berlin.de ([130.133.4.67])
          by outpost.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1lOliw-0029Ar-GN; Tue, 23 Mar 2021 19:25:50 +0100
Received: from mx.physik.fu-berlin.de ([160.45.64.218])
          by relay1.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_DHE_RSA_WITH_AES_128_CBC_SHA
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1lOliw-0041zB-Dd; Tue, 23 Mar 2021 19:25:50 +0100
Received: from epyc.physik.fu-berlin.de ([160.45.64.180])
        by mx.physik.fu-berlin.de with esmtps (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <glaubitz@physik.fu-berlin.de>)
        id 1lOlik-0000xE-0j; Tue, 23 Mar 2021 19:25:38 +0100
Received: from glaubitz by epyc.physik.fu-berlin.de with local (Exim 4.94 #2 (Debian))
        id 1lOlij-003bOF-O9; Tue, 23 Mar 2021 19:25:37 +0100
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] tools: Remove duplicate definition of ia64_mf() on ia64
Date:   Tue, 23 Mar 2021 19:25:19 +0100
Message-Id: <20210323182520.858611-1-glaubitz@physik.fu-berlin.de>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
X-Originating-IP: 160.45.64.218
X-ZEDAT-Hint: RV
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ia64_mf() macro defined in tools/arch/ia64/include/asm/barrier.h
is already defined in <asm/gcc_intrin.h> on ia64 which causes libbpf
failing to build:

  CC       /usr/src/linux/tools/bpf/bpftool//libbpf/staticobjs/libbpf.o
In file included from /usr/src/linux/tools/include/asm/barrier.h:24,
                 from /usr/src/linux/tools/include/linux/ring_buffer.h:4,
                 from libbpf.c:37:
/usr/src/linux/tools/include/asm/../../arch/ia64/include/asm/barrier.h:43: error: "ia64_mf" redefined [-Werror]
   43 | #define ia64_mf()       asm volatile ("mf" ::: "memory")
      |
In file included from /usr/include/ia64-linux-gnu/asm/intrinsics.h:20,
                 from /usr/include/ia64-linux-gnu/asm/swab.h:11,
                 from /usr/include/linux/swab.h:8,
                 from /usr/include/linux/byteorder/little_endian.h:13,
                 from /usr/include/ia64-linux-gnu/asm/byteorder.h:5,
                 from /usr/src/linux/tools/include/uapi/linux/perf_event.h:20,
                 from libbpf.c:36:
/usr/include/ia64-linux-gnu/asm/gcc_intrin.h:382: note: this is the location of the previous definition
  382 | #define ia64_mf() __asm__ volatile ("mf" ::: "memory")
      |
cc1: all warnings being treated as errors

Thus, remove the definition from tools/arch/ia64/include/asm/barrier.h.

Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
---
 tools/arch/ia64/include/asm/barrier.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/arch/ia64/include/asm/barrier.h b/tools/arch/ia64/include/asm/barrier.h
index 4d471d9511a5..6fffe5682713 100644
--- a/tools/arch/ia64/include/asm/barrier.h
+++ b/tools/arch/ia64/include/asm/barrier.h
@@ -39,9 +39,6 @@
  * sequential memory pages only.
  */
 
-/* XXX From arch/ia64/include/uapi/asm/gcc_intrin.h */
-#define ia64_mf()       asm volatile ("mf" ::: "memory")
-
 #define mb()		ia64_mf()
 #define rmb()		mb()
 #define wmb()		mb()
-- 
2.31.0

