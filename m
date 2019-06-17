Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EB84812A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfFQLp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:45:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfFQLp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 07:45:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1932C8E224;
        Mon, 17 Jun 2019 11:45:26 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (dhcp-192-180.str.redhat.com [10.33.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 12FE361369;
        Mon, 17 Jun 2019 11:45:21 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Joseph Myers <joseph@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
References: <20190319165123.3967889-1-arnd@arndb.de>
        <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
        <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
        <871s05fd8o.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
Date:   Mon, 17 Jun 2019 13:45:20 +0200
In-Reply-To: <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 7 Jun 2019 11:56:16 -0700")
Message-ID: <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 17 Jun 2019 11:45:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Linus Torvalds:

> On Fri, Jun 7, 2019 at 11:43 AM Florian Weimer <fweimer@redhat.com> wrote:
>>
>> On the glibc side, we nowadays deal with this by splitting headers
>> further.  (We used to suppress definitions with macros, but that tended
>> to become convoluted.)  In this case, moving the definition of
>> __kernel_long_t to its own header, so that
>> include/uapi/asm-generic/socket.h can include that should fix it.
>
> I think we should strive to do that on the kernel side too, since
> clearly we shouldn't expose that "val[]" thing in the core posix types
> due to namespace rules, but at the same time I think the patch to
> rename val[] is fundamentally broken too.
>
> Can you describe how you split things (perhaps even with a patch ;)?
> Is this literally the only issue you currently have? Because I'd
> expect similar issues to show up elsewhere too, but who knows.. You
> presumably do.

I wanted to introduce a new header, <asm/kernel_long_t.h>, and include
it where the definition of __kernel_long_t is needed, something like
this (incomplete, untested):

diff --git a/arch/sparc/include/uapi/asm/posix_types.h b/arch/sparc/include/uapi/asm/posix_types.h
index f139e0048628..6510d7538605 100644
--- a/arch/sparc/include/uapi/asm/posix_types.h
+++ b/arch/sparc/include/uapi/asm/posix_types.h
@@ -8,6 +8,8 @@
 #ifndef __SPARC_POSIX_TYPES_H
 #define __SPARC_POSIX_TYPES_H
 
+#include <asm/kernel_long_t.h>
+
 #if defined(__sparc__) && defined(__arch64__)
 /* sparc 64 bit */
 
@@ -19,10 +21,6 @@ typedef unsigned short         __kernel_old_gid_t;
 typedef int		       __kernel_suseconds_t;
 #define __kernel_suseconds_t __kernel_suseconds_t
 
-typedef long		__kernel_long_t;
-typedef unsigned long	__kernel_ulong_t;
-#define __kernel_long_t __kernel_long_t
-
 struct __kernel_old_timeval {
 	__kernel_long_t tv_sec;
 	__kernel_suseconds_t tv_usec;
diff --git a/arch/x86/include/uapi/asm/kernel_long_t.h b/arch/x86/include/uapi/asm/kernel_long_t.h
new file mode 100644
index 000000000000..ed3bff40e1e8
--- /dev/null
+++ b/arch/x86/include/uapi/asm/kernel_long_t.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __KERNEL__
+# ifdef defined(__x86_64__) && defined(__ILP32__)
+#  include <asm/kernel_long_t_x32.h>
+# else
+#  include <asm-generic/kernel_long_t.h>
+# endif
+#endif
diff --git a/arch/x86/include/uapi/asm/kernel_long_t_x32.h b/arch/x86/include/uapi/asm/kernel_long_t_x32.h
new file mode 100644
index 000000000000..a71cbce7e966
--- /dev/null
+++ b/arch/x86/include/uapi/asm/kernel_long_t_x32.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _ASM_X86_KERNEL_LONG_T_X32_H
+#define _ASM_X86_KERNEL_LONG_T_X32_H
+typedef long long __kernel_long_t;
+typedef unsigned long long __kernel_ulong_t;
+#endif /* _ASM_X86_KERNEL_LONG_T_X32_H */
diff --git a/arch/x86/include/uapi/asm/posix_types_x32.h b/arch/x86/include/uapi/asm/posix_types_x32.h
index f60479b07fc8..92c7af21da9e 100644
--- a/arch/x86/include/uapi/asm/posix_types_x32.h
+++ b/arch/x86/include/uapi/asm/posix_types_x32.h
@@ -11,10 +11,6 @@
  *
  */
 
-typedef long long __kernel_long_t;
-typedef unsigned long long __kernel_ulong_t;
-#define __kernel_long_t __kernel_long_t
-
 #include <asm/posix_types_64.h>
 
 #endif /* _ASM_X86_POSIX_TYPES_X32_H */
diff --git a/include/uapi/asm-generic/kernel_long_t.h b/include/uapi/asm-generic/kernel_long_t.h
new file mode 100644
index 000000000000..649a97a8c304
--- /dev/null
+++ b/include/uapi/asm-generic/kernel_long_t.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __ASM_GENERIC_KERNEL_LONG_T_H
+#define __ASM_GENERIC_KERNEL_LONG_T_H
+
+typedef long		__kernel_long_t;
+typedef unsigned long	__kernel_ulong_t;
+
+#endif /* __ASM_GENERIC_POSIX_TYPES_H */
diff --git a/include/uapi/asm-generic/posix_types.h b/include/uapi/asm-generic/posix_types.h
index f0733a26ebfc..2715ba4599bd 100644
--- a/include/uapi/asm-generic/posix_types.h
+++ b/include/uapi/asm-generic/posix_types.h
@@ -11,10 +11,7 @@
  * architectures, so that you can override them.
  */
 
-#ifndef __kernel_long_t
-typedef long		__kernel_long_t;
-typedef unsigned long	__kernel_ulong_t;
-#endif
+#include <asm/kernel_long_t.h>
 
 #ifndef __kernel_ino_t
 typedef __kernel_ulong_t __kernel_ino_t;

Additional architectures need conversion as well, but I think this
suggests where this is going.  Would that be acceptable?

A different approach would rename <asm/posix_types.h> to something more
basic, exclude the two structs, and move all internal #includes which do
need the structs to the new header.  A new <asm/posix_types.h> would
include the renamed header and add back the two structs, for
compatibility.

For a less strict definition of compatibility, it would also be possible
to introduce <asm/fsid_t.h> (for __kernel_fsid_t) and <linux/fd_set.h>
(for __kernel_fd_set), and remove the definition of those from
<asm/posix_types.h>.

The other question is whether this __kernel_long_t dependency in
<asm/socket.h> is even valid because it makes the constants SO_RCVTIMEO
etc. unusable in a preprocessor expression (although POSIX does not make
such a requirement as far as I can see).

Thanks,
Florian
