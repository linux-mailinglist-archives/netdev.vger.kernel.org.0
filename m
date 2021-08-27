Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF193F951A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbhH0HaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:30:11 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43978 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244426AbhH0H3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 03:29:52 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 14EC6222EE;
        Fri, 27 Aug 2021 07:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630049340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=d3NbyDPPFSBrjV+S1BKlkMfLhsDNl8MMVaC+wVMU/B8=;
        b=bDezurcq3+3gYRybXfuSvp3XCW0BZcbsgHWqFXiPxJy6WIBivN9Nn5BfT0jCGUp3Mqlg89
        kKfa1EAbPhrax+t/kpkumpu2AhnsIpcEAVCx2jR5Tgi0fsoykNO0eb64gmiu7UTnddIVjg
        kDvWB3Gy8uJ7d4RGjvkkgr79JpjYFnQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630049340;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=d3NbyDPPFSBrjV+S1BKlkMfLhsDNl8MMVaC+wVMU/B8=;
        b=/g3qxJ7SX6+tVlwGYYVzzsA+2mw5fhrd+r+RrfaSzUz8Sye7Ff/5Uvq4LvxXlQygX7o7Ir
        W1LIiSNmU8QjN+Dw==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        by relay2.suse.de (Postfix) with ESMTP id E06D7A3B92;
        Fri, 27 Aug 2021 07:28:59 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick McCarty <patrick.mccarty@intel.com>,
        Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH] libbpf: Fix build with latest gcc/binutils with LTO
Date:   Fri, 27 Aug 2021 09:28:55 +0200
Message-Id: <20210827072855.3664-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrick McCarty <patrick.mccarty@intel.com>

After updating to binutils 2.35, the build began to fail with an
assembler error. A bug was opened on the Red Hat Bugzilla a few days
later for the same issue.

Work around the problem by using the new `symver` attribute (introduced
in GCC 10) as needed, instead of the `COMPAT_VERSION` and
`DEFAULT_VERSION` macros, which expand to assembler directives.

Fixes: https://github.com/libbpf/libbpf/issues/338
Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1863059
Fixes: https://bugzilla.opensuse.org/show_bug.cgi?id=1188749
Signed-off-by: Patrick McCarty <patrick.mccarty@intel.com>
Make the change conditional on GCC version
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 tools/lib/bpf/libbpf_internal.h | 23 +++++++++++++++++------
 tools/lib/bpf/xsk.c             |  4 ++--
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 016ca7cb4f8a..af0f3fb102c0 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -86,20 +86,31 @@
 	(offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
 #endif
 
+#ifdef __GNUC__
+# if __GNUC__ >= 10
+#  define DEFAULT_VERSION(internal_name, api_name, version) \
+__attribute__((__symver__(#api_name "@@" #version)))
+#  define COMPAT_VERSION(internal_name, api_name, version) \
+__attribute__((__symver__(#api_name "@" #version)))
+# endif
+#endif
+
+#if !defined(COMPAT_VERSION) || !defined(DEFAULT_VERSION)
 /* Symbol versioning is different between static and shared library.
  * Properly versioned symbols are needed for shared library, but
  * only the symbol of the new version is needed for static library.
  */
-#ifdef SHARED
-# define COMPAT_VERSION(internal_name, api_name, version) \
+# ifdef SHARED
+#  define COMPAT_VERSION(internal_name, api_name, version) \
 	asm(".symver " #internal_name "," #api_name "@" #version);
-# define DEFAULT_VERSION(internal_name, api_name, version) \
+#  define DEFAULT_VERSION(internal_name, api_name, version) \
 	asm(".symver " #internal_name "," #api_name "@@" #version);
-#else
-# define COMPAT_VERSION(internal_name, api_name, version)
-# define DEFAULT_VERSION(internal_name, api_name, version) \
+# else
+#  define COMPAT_VERSION(internal_name, api_name, version)
+#  define DEFAULT_VERSION(internal_name, api_name, version) \
 	extern typeof(internal_name) api_name \
 	__attribute__((alias(#internal_name)));
+# endif
 #endif
 
 extern void libbpf_print(enum libbpf_print_level level,
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index e9b619aa0cdf..a2111696ba91 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -281,6 +281,7 @@ static int xsk_create_umem_rings(struct xsk_umem *umem, int fd,
 	return err;
 }
 
+DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
 int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 			    __u64 size, struct xsk_ring_prod *fill,
 			    struct xsk_ring_cons *comp,
@@ -345,6 +346,7 @@ struct xsk_umem_config_v1 {
 	__u32 frame_headroom;
 };
 
+COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
 int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
 			    __u64 size, struct xsk_ring_prod *fill,
 			    struct xsk_ring_cons *comp,
@@ -358,8 +360,6 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
 	return xsk_umem__create_v0_0_4(umem_ptr, umem_area, size, fill, comp,
 					&config);
 }
-COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
-DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
 
 static enum xsk_prog get_xsk_prog(void)
 {
-- 
2.31.1

