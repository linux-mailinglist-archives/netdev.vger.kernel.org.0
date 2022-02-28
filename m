Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812744C60B5
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiB1B70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiB1B7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:59:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132613DA77
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 17:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DC90B80D0A
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941FCC340E9;
        Mon, 28 Feb 2022 01:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646013524;
        bh=pDu/xGTxLrBpe9yl4L0UDPiW0y3OjiKwno869CjuVHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3hgmOovCLMXq9Xdbi1G/w6z7lP4w4CAFxrrQGsLfAwZNXi2i/xFfNh6p3R7DpxpY
         muKaxMPi31RmiH6dHWy15leYlyqMqT+RXmAJwZAlSJz/mNkL9XM/xduPpe3sqjk7oU
         CVJoE1OmRSswz5folZCOIwN06iFZ9FHvMW2WkZnGyRH/7bG3UY80rUVvstf5qjSHYY
         Cuola4V6HcVs6WHZp1lPWnXRpdgTM4zJyg23ygCLx1GnP4CQ6fRhhw95N7LwNas2La
         kD+Xlv1H39Pzvorp25z4baIv3HKozz5FrzRxaqIakX62CfF/z8e2BxBAPSZoUyz/0p
         2X5zqB4Jgrm4A==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 2/3] bpf: Export bpf syscall wrapper
Date:   Sun, 27 Feb 2022 18:58:39 -0700
Message-Id: <20220228015840.1413-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220228015840.1413-1-dsahern@kernel.org>
References: <20220228015840.1413-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move bpf syscall wrapper to bpf_glue to make it available to libbpf
based functions.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/bpf_util.h |  2 ++
 lib/bpf_glue.c     | 13 +++++++++++++
 lib/bpf_legacy.c   | 12 ------------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/bpf_util.h b/include/bpf_util.h
index 53acc4106de8..abb9627556ef 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -287,6 +287,8 @@ int bpf_program_attach(int prog_fd, int target_fd, enum bpf_attach_type type);
 
 int bpf_dump_prog_info(FILE *f, uint32_t id);
 
+int bpf(int cmd, union bpf_attr *attr, unsigned int size);
+
 #ifdef HAVE_ELF
 int bpf_send_map_fds(const char *path, const char *obj);
 int bpf_recv_map_fds(const char *path, int *fds, struct bpf_map_aux *aux,
diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
index cc3015487c68..c1cf351b7359 100644
--- a/lib/bpf_glue.c
+++ b/lib/bpf_glue.c
@@ -4,13 +4,26 @@
  * Authors:	Hangbin Liu <haliu@redhat.com>
  *
  */
+#include <sys/syscall.h>
 #include <limits.h>
+#include <unistd.h>
 
 #include "bpf_util.h"
 #ifdef HAVE_LIBBPF
 #include <bpf/bpf.h>
 #endif
 
+int bpf(int cmd, union bpf_attr *attr, unsigned int size)
+{
+#ifdef __NR_bpf
+	return syscall(__NR_bpf, cmd, attr, size);
+#else
+	fprintf(stderr, "No bpf syscall, kernel headers too old?\n");
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
 int bpf_program_attach(int prog_fd, int target_fd, enum bpf_attach_type type)
 {
 #ifdef HAVE_LIBBPF
diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 3779ae90cc1c..9bf7c1c493b4 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -33,7 +33,6 @@
 #include <sys/un.h>
 #include <sys/vfs.h>
 #include <sys/mount.h>
-#include <sys/syscall.h>
 #include <sys/sendfile.h>
 #include <sys/resource.h>
 
@@ -134,17 +133,6 @@ static inline __u64 bpf_ptr_to_u64(const void *ptr)
 	return (__u64)(unsigned long)ptr;
 }
 
-static int bpf(int cmd, union bpf_attr *attr, unsigned int size)
-{
-#ifdef __NR_bpf
-	return syscall(__NR_bpf, cmd, attr, size);
-#else
-	fprintf(stderr, "No bpf syscall, kernel headers too old?\n");
-	errno = ENOSYS;
-	return -1;
-#endif
-}
-
 static int bpf_map_update(int fd, const void *key, const void *value,
 			  uint64_t flags)
 {
-- 
2.24.3 (Apple Git-128)

