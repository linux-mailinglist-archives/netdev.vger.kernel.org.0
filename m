Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481C67AB29
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfG3Oib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:38:31 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36373 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfG3Oib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:38:31 -0400
Received: by mail-qt1-f196.google.com with SMTP id z4so63310178qtc.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=U+kNY13E4nMS8YNtGI8GJ0mR5QEAcj0xcC78q4GiXCc=;
        b=C4pTnNOCGcKdVPXm6CU8M500z498Pf6HiQ0i/wlBxQBcUvYWkXF/8fC73WFPcEnG7+
         Z4/VcgdvmmTuRonLwQTQBRSKdy/BrfaYRkgRqPyF35OmKzELH7HNBkEcCUYqa1sme+vD
         q8grQ0rjgD22dJvnvESMOgO2ejDiRfbl5tdTBmnQcBrwYLgrMLeZMZylVAeOrftBr8uc
         jcgvlZLJ/aItrOJyb24PbA6U66fug3YU8nqqd7JVsHMFhaUQCNvOhxFnepj3LxHC9R/y
         kcMHjkp6ZGlEBUG2OO9s72vvOW3RRIPNmwI+iVmJZ24XV0ax6oSynNauIdC7/henJWEK
         QxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U+kNY13E4nMS8YNtGI8GJ0mR5QEAcj0xcC78q4GiXCc=;
        b=khkYgh73S5wCfmYL2jYWTyd8mXRPH+7U2QsaQjysn2tItUH3kZqaX7RblKxdrzk2rl
         Az9GVZG/pvV1zkwD8pSKgEvF22fbqu/6Qi1MJTVMT0fH3Ws4TT7RWa30nKpRtBugxAZq
         dbqJmZAA0vonDDbv+Kj51Eg2ewQopCww5gIqBFzUbq+Q51/UwDqjeQKYjTX/FeZcBCdi
         +u5eoTrdctgXNyXodv0HXK4R21kzP9PiKiQZuFpRXrBAR3AId3VKvRHBZw0nkcgImkbF
         YPSLkl+O3ri7MgRYsnvks/ucU0o4KXlhMI2Qlyr68Q797LfCBk4pPlcx1Mc+8tR5e+Ik
         kG4w==
X-Gm-Message-State: APjAAAW1ty/LO2qGp04B/UrvxseQDKXshq+9Dfsi8LHW+Y8FWXveabJo
        G5i/6iRhAy6doQQ+syuZ1q8dtUgn8djF2A==
X-Google-Smtp-Source: APXvYqxJtLeFd8TsumdqCstZOMEgyVGIBGrJl8qsoxVai6muZPW1JDQ+pLuFVrX+kfrYTZUaOnXXcg==
X-Received: by 2002:ac8:66ce:: with SMTP id m14mr39393107qtp.206.1564497509555;
        Tue, 30 Jul 2019 07:38:29 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j22sm27387430qtp.0.2019.07.30.07.38.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:38:28 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, David.Laight@ACULAB.COM,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH v2] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Date:   Tue, 30 Jul 2019 10:38:08 -0400
Message-Id: <1564497488-3030-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In file included from ./include/linux/sctp.h:42,
                 from net/core/skbuff.c:47:
./include/uapi/linux/sctp.h:395:1: warning: alignment 4 of 'struct
sctp_paddr_change' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:728:1: warning: alignment 4 of 'struct
sctp_setpeerprim' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:727:26: warning: 'sspp_addr' offset 4 in
'struct sctp_setpeerprim' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage sspp_addr;
                          ^~~~~~~~~
./include/uapi/linux/sctp.h:741:1: warning: alignment 4 of 'struct
sctp_prim' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:740:26: warning: 'ssp_addr' offset 4 in
'struct sctp_prim' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage ssp_addr;
                          ^~~~~~~~
./include/uapi/linux/sctp.h:792:1: warning: alignment 4 of 'struct
sctp_paddrparams' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:784:26: warning: 'spp_address' offset 4 in
'struct sctp_paddrparams' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage spp_address;
                          ^~~~~~~~~~~
./include/uapi/linux/sctp.h:905:1: warning: alignment 4 of 'struct
sctp_paddrinfo' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:899:26: warning: 'spinfo_address' offset 4
in 'struct sctp_paddrinfo' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage spinfo_address;
                          ^~~~~~~~~~~~~~

This is because the commit 20c9c825b12f ("[SCTP] Fix SCTP socket options
to work with 32-bit apps on 64-bit kernels.") added "packed, aligned(4)"
GCC attributes to some structures but one of the members, i.e, "struct
sockaddr_storage" in those structures has the attribute,
"aligned(__alignof__ (struct sockaddr *)" which is 8-byte on 64-bit
systems, so the commit overwrites the designed alignments for
"sockaddr_storage".

To fix this, "struct sockaddr_storage" needs to be aligned to 4-byte as
it is only used in those packed sctp structure which is part of UAPI,
and "struct __kernel_sockaddr_storage" is used in some other
places of UAPI that need not to change alignments in order to not
breaking userspace.

Use an implicit alignment for "struct __kernel_sockaddr_storage" so it
can keep the same alignments as a member in both packed and un-packed
structures without breaking UAPI.

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Qian Cai <cai@lca.pw>
---

v2: Use an implicit alignment for "struct __kernel_sockaddr_storage".

 include/uapi/linux/socket.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index 8eb96021709c..caf6c4d5f6ad 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -6,17 +6,20 @@
  * Desired design of maximum size and alignment (see RFC2553)
  */
 #define _K_SS_MAXSIZE	128	/* Implementation specific max size */
-#define _K_SS_ALIGNSIZE	(__alignof__ (struct sockaddr *))
-				/* Implementation specific desired alignment */
 
 typedef unsigned short __kernel_sa_family_t;
 
 struct __kernel_sockaddr_storage {
-	__kernel_sa_family_t	ss_family;		/* address family */
-	/* Following field(s) are implementation specific */
-	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
+	union {
+		void *__align; /* implementation specific desired alignment */
+		struct {
+			__kernel_sa_family_t	ss_family; /* address family */
+			/* Following field(s) are implementation specific */
+			char __data[_K_SS_MAXSIZE - sizeof(unsigned short)];
 				/* space to achieve desired size, */
 				/* _SS_MAXSIZE value minus size of ss_family */
-} __attribute__ ((aligned(_K_SS_ALIGNSIZE)));	/* force desired alignment */
+			};
+		};
+};
 
 #endif /* _UAPI_LINUX_SOCKET_H */
-- 
1.8.3.1

