Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7AF799DD
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbfG2UYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:24:21 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:38098 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387528AbfG2UYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:24:20 -0400
Received: by mail-vk1-f196.google.com with SMTP id f68so12318853vkf.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 13:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=MdZSh5RxIzhkZKwZhPaXMDYMCWoc5OqdNfaSUD52NhE=;
        b=YxuOOl8UB79J8g6bZQA1PI0O/aX11tn1uzDGl5Kl698RmntxCh7SGe8lHUfyjZ+xpP
         /dST/nnVQOU7cNcZWA37Z0aTdUNU53IAOW2heHnR30Fxk9F4Q+IDAVCmWD9sli+Kc7eE
         JvpGkkfCfbHnqBwcWKL7SdC46rEca8jg+xXDVJX0JpWuCv4AdGmKzURYzUK7SuM5RnM4
         ove8m6d3s16Ur9ifPhMZesR9RVyKyK+1K6azj+phbjcbs98yxvzIzp5IA4va4PPHyv4l
         JWUFmx9VdAxIlKvEJsXwxxKvoxAHOcRcQ74lJGIV4JRZhUp99n0g7yWw1WSZIep02yVA
         p++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MdZSh5RxIzhkZKwZhPaXMDYMCWoc5OqdNfaSUD52NhE=;
        b=QICr4lBaaJz6eCV6csZKwWJCrw9dbbE5EIfw3rSwH6Do4hkYGJK0uRLuIV+g21RxA/
         itPHqdMb/r2xhP9StPJL4bowjOmx2J4xNAYAX0t8GAzqC8lNPX5d8pf8jmpewxOQBhDD
         /9vwRo8zUFhq8tKJYsk168fvCq0jAZvsfbinF6gX6d3+D3LK3qpLVQ1N2DIXvv/cmY0N
         zebeu0L9KfydtnrX+Po4CvtbeTu5deQMSH3+OyOMTqtWESkT2urdJMPLsWrUvrKJTyAv
         G+5FbJIrWfq08BvSWRWsygDpzbZ/GoGhZ9zOhY9MdRS63Towbz6MmAr78/4t6xPzwscu
         aKmA==
X-Gm-Message-State: APjAAAWavuB+aW7GaOY7iDs0ROEgENNwQTo63aTLZYHv+45A7egBk1I2
        9jSlg3+QtANbC/73m4Xd4G3ssw==
X-Google-Smtp-Source: APXvYqwj+GdgasqfsMhmo5I6aD70Un0lsre9nGEv9e8lbsyomLJE+3DtELV4/S7GNOeJ4tJVQWT8wg==
X-Received: by 2002:a1f:1e47:: with SMTP id e68mr27124799vke.37.1564431859760;
        Mon, 29 Jul 2019 13:24:19 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 142sm28599412vkc.40.2019.07.29.13.24.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 13:24:19 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Date:   Mon, 29 Jul 2019 16:23:58 -0400
Message-Id: <1564431838-23051-1-git-send-email-cai@lca.pw>
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

One option is use typedef between "sockaddr_storage" and
"__kernel_sockaddr_storage" but it needs to change 35 or 370 lines of
codes. The other option is to duplicate this simple 2-field structure to
have a separate "struct sockaddr_storage" so it can use a different
alignment than "__kernel_sockaddr_storage". Also the structure seems
stable enough, so it will be low-maintenance to update two structures in
the future in case of changes.

Signed-off-by: Qian Cai <cai@lca.pw>
---
 include/linux/socket.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 97523818cb14..301119657125 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -38,7 +38,13 @@ struct linger {
 	int		l_linger;	/* How long to linger for	*/
 };
 
-#define sockaddr_storage __kernel_sockaddr_storage
+struct sockaddr_storage {
+	__kernel_sa_family_t	ss_family;		/* address family */
+	/* Following field(s) are implementation specific */
+	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
+				/* space to achieve desired size, */
+				/* _SS_MAXSIZE value minus size of ss_family */
+} __aligned(4);			/* force desired alignment */
 
 /*
  *	As we do 4.4BSD message passing we use a 4.4BSD message passing
-- 
1.8.3.1

