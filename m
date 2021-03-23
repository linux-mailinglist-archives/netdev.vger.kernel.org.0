Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23D034672E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhCWSHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:07:31 -0400
Received: from outpost17.zedat.fu-berlin.de ([130.133.4.110]:44989 "EHLO
        outpost17.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhCWSHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:07:13 -0400
Received: from relay1.zedat.fu-berlin.de ([130.133.4.67])
          by outpost.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1lOlQj-0024FS-LY; Tue, 23 Mar 2021 19:07:01 +0100
Received: from mx.physik.fu-berlin.de ([160.45.64.218])
          by relay1.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_DHE_RSA_WITH_AES_128_CBC_SHA
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1lOlQj-003wmA-IR; Tue, 23 Mar 2021 19:07:01 +0100
Received: from epyc.physik.fu-berlin.de ([160.45.64.180])
        by mx.physik.fu-berlin.de with esmtps (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <glaubitz@physik.fu-berlin.de>)
        id 1lOlQW-0000VE-3G; Tue, 23 Mar 2021 19:06:48 +0100
Received: from glaubitz by epyc.physik.fu-berlin.de with local (Exim 4.94 #2 (Debian))
        id 1lOlQV-003aeH-QQ; Tue, 23 Mar 2021 19:06:47 +0100
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH, v2] tools: Remove inclusion of ia64-specific version of errno.h header
Date:   Tue, 23 Mar 2021 19:04:28 +0100
Message-Id: <20210323180428.855488-1-glaubitz@physik.fu-berlin.de>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
X-Originating-IP: 160.45.64.218
X-ZEDAT-Hint: RV
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no longer an ia64-specific version of the errno.h header
below arch/ia64/include/uapi/asm/, so trying to build tools/bpf
fails with:

  CC       /usr/src/linux/tools/bpf/bpftool/btf_dumper.o
In file included from /usr/src/linux/tools/include/linux/err.h:8,
                 from btf_dumper.c:11:
/usr/src/linux/tools/include/uapi/asm/errno.h:13:10: fatal error: ../../../arch/ia64/include/uapi/asm/errno.h: No such file or directory
   13 | #include "../../../arch/ia64/include/uapi/asm/errno.h"
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.

Thus, just remove the inclusion of the ia64-specific errno.h so that
the build will use the generic errno.h header on this target which was
used there anyway as the ia64-specific errno.h was just a wrapper for
the generic header.

Fixes: c25f867ddd00 ("ia64: remove unneeded uapi asm-generic wrappers")
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
---
 tools/include/uapi/asm/errno.h | 2 --
 1 file changed, 2 deletions(-)

 v2:
 - Rephrase summary

diff --git a/tools/include/uapi/asm/errno.h b/tools/include/uapi/asm/errno.h
index 637189ec1ab9..d30439b4b8ab 100644
--- a/tools/include/uapi/asm/errno.h
+++ b/tools/include/uapi/asm/errno.h
@@ -9,8 +9,6 @@
 #include "../../../arch/alpha/include/uapi/asm/errno.h"
 #elif defined(__mips__)
 #include "../../../arch/mips/include/uapi/asm/errno.h"
-#elif defined(__ia64__)
-#include "../../../arch/ia64/include/uapi/asm/errno.h"
 #elif defined(__xtensa__)
 #include "../../../arch/xtensa/include/uapi/asm/errno.h"
 #else
-- 
2.31.0

