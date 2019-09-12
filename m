Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA7B1264
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 17:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733008AbfILPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 11:44:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:55653 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732715AbfILPoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 11:44:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 08:44:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="197265840"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga002.jf.intel.com with ESMTP; 12 Sep 2019 08:44:51 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next] libbpf: add xsk_umem__adjust_offset
Date:   Thu, 12 Sep 2019 07:28:40 +0000
Message-Id: <20190912072840.20947-1-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, xsk_umem_adjust_offset exists as a kernel internal function.
This patch adds xsk_umem__adjust_offset to libbpf so that it can be used
from userspace. This will take the responsibility of properly storing the
offset away from the application, making it less error prone.

Since xsk_umem__adjust_offset is called on a per-packet basis, we need to
inline the function to avoid any performance regressions.  In order to
inline xsk_umem__adjust_offset, we need to add it to xsk.h. Unfortunately
this means that we can't dereference the xsk_umem_config struct directly
since it is defined only in xsk.c. We therefore add an extra API to return
the flags field to the user from the structure, and have the inline
function use this flags field directly.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
---
 tools/lib/bpf/libbpf.map |  1 +
 tools/lib/bpf/xsk.c      |  5 +++++
 tools/lib/bpf/xsk.h      | 14 ++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d04c7cb623ed..760350c9b81c 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -189,4 +189,5 @@ LIBBPF_0.0.4 {
 LIBBPF_0.0.5 {
 	global:
 		bpf_btf_get_next_id;
+		xsk_umem__get_flags;
 } LIBBPF_0.0.4;
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 842c4fd55859..a4250a721ea6 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -84,6 +84,11 @@ int xsk_socket__fd(const struct xsk_socket *xsk)
 	return xsk ? xsk->fd : -EINVAL;
 }
 
+__u32 xsk_umem__get_flags(struct xsk_umem *umem)
+{
+	return umem->config.flags;
+}
+
 static bool xsk_page_aligned(void *buffer)
 {
 	unsigned long addr = (unsigned long)buffer;
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 584f6820a639..bf782facb274 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -183,8 +183,22 @@ static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
 	return xsk_umem__extract_addr(addr) + xsk_umem__extract_offset(addr);
 }
 
+/* Handle the offset appropriately depending on aligned or unaligned mode.
+ * For unaligned mode, we store the offset in the upper 16-bits of the address.
+ * For aligned mode, we simply add the offset to the address.
+ */
+static inline __u64 xsk_umem__adjust_offset(__u32 umem_flags, __u64 addr,
+					    __u64 offset)
+{
+	if (umem_flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG)
+		return addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+	else
+		return addr + offset;
+}
+
 LIBBPF_API int xsk_umem__fd(const struct xsk_umem *umem);
 LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
+LIBBPF_API __u32 xsk_umem__get_flags(struct xsk_umem *umem);
 
 #define XSK_RING_CONS__DEFAULT_NUM_DESCS      2048
 #define XSK_RING_PROD__DEFAULT_NUM_DESCS      2048
-- 
2.17.1

