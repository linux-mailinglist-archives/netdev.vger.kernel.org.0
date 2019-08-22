Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200149903B
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732796AbfHVKAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:00:45 -0400
Received: from mga12.intel.com ([192.55.52.136]:1799 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732735AbfHVKAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:00:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 03:00:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,416,1559545200"; 
   d="scan'208";a="180336823"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by fmsmga007.fm.intel.com with ESMTP; 22 Aug 2019 03:00:40 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v5 07/11] libbpf: add flags to umem config
Date:   Thu, 22 Aug 2019 01:44:23 +0000
Message-Id: <20190822014427.49800-8-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190822014427.49800-1-kevin.laatz@intel.com>
References: <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190822014427.49800-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a 'flags' field to the umem_config and umem_reg structs.
This will allow for more options to be added for configuring umems.

The first use for the flags field is to add a flag for unaligned chunks
mode. These flags can either be user-provided or filled with a default.

Since we change the size of the xsk_umem_config struct, we need to version
the ABI. This patch includes the ABI versioning for xsk_umem__create. The
Makefile was also updated to handle multiple function versions in
check-abi.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>

---
v2:
  - Removed the headroom check from this patch. It has moved to the
    previous patch.

v4:
  - Modified chunk flag define.

v5:
  - Added ABI versioning for xsk_umem__create().
  - Updated Makefile to handle multiple function versions.
  - Removed bitfields from xdp_umem_reg
  - Fix conflicts after 'bpf-af-xdp-wakeup' was merged
---
 tools/include/uapi/linux/if_xdp.h |  9 +++++++++
 tools/lib/bpf/Makefile            |  5 ++++-
 tools/lib/bpf/libbpf.map          |  1 +
 tools/lib/bpf/xsk.c               | 33 ++++++++++++++++++++++++++++---
 tools/lib/bpf/xsk.h               | 27 +++++++++++++++++++++++++
 5 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index 62b80d57b72a..be328c59389d 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -26,6 +26,9 @@
  */
 #define XDP_USE_NEED_WAKEUP (1 << 3)
 
+/* Flags for xsk_umem_config flags */
+#define XDP_UMEM_UNALIGNED_CHUNK_FLAG (1 << 0)
+
 struct sockaddr_xdp {
 	__u16 sxdp_family;
 	__u16 sxdp_flags;
@@ -66,6 +69,7 @@ struct xdp_umem_reg {
 	__u64 len; /* Length of packet data area */
 	__u32 chunk_size;
 	__u32 headroom;
+	__u32 flags;
 };
 
 struct xdp_statistics {
@@ -87,6 +91,11 @@ struct xdp_options {
 #define XDP_UMEM_PGOFF_FILL_RING	0x100000000ULL
 #define XDP_UMEM_PGOFF_COMPLETION_RING	0x180000000ULL
 
+/* Masks for unaligned chunks mode */
+#define XSK_UNALIGNED_BUF_OFFSET_SHIFT 48
+#define XSK_UNALIGNED_BUF_ADDR_MASK \
+	((1ULL << XSK_UNALIGNED_BUF_OFFSET_SHIFT) - 1)
+
 /* Rx/Tx descriptor */
 struct xdp_desc {
 	__u64 addr;
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 613acb93b144..c6f94cffe06e 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -134,7 +134,9 @@ LIB_FILE	:= $(addprefix $(OUTPUT),$(LIB_FILE))
 PC_FILE		:= $(addprefix $(OUTPUT),$(PC_FILE))
 
 GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN) | \
-			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {s++} END{print s}')
+			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
+			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
+			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
@@ -201,6 +203,7 @@ check_abi: $(OUTPUT)libbpf.so
 		     "Please make sure all LIBBPF_API symbols are"	 \
 		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
 		readelf -s --wide $(OUTPUT)libbpf-in.o |		 \
+		    cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |	 \
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf -s --wide $(OUTPUT)libbpf.so |			 \
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 664ce8e7a60e..d04c7cb623ed 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -183,6 +183,7 @@ LIBBPF_0.0.4 {
 		perf_buffer__new;
 		perf_buffer__new_raw;
 		perf_buffer__poll;
+		xsk_umem__create;
 } LIBBPF_0.0.3;
 
 LIBBPF_0.0.5 {
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 12ad78510147..842c4fd55859 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -99,6 +99,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
 		cfg->comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 		cfg->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 		cfg->frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
+		cfg->flags = XSK_UMEM__DEFAULT_FLAGS;
 		return;
 	}
 
@@ -106,6 +107,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
 	cfg->comp_size = usr_cfg->comp_size;
 	cfg->frame_size = usr_cfg->frame_size;
 	cfg->frame_headroom = usr_cfg->frame_headroom;
+	cfg->flags = usr_cfg->flags;
 }
 
 static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
@@ -132,9 +134,10 @@ static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
 	return 0;
 }
 
-int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
-		     struct xsk_ring_prod *fill, struct xsk_ring_cons *comp,
-		     const struct xsk_umem_config *usr_config)
+int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
+			    __u64 size, struct xsk_ring_prod *fill,
+			    struct xsk_ring_cons *comp,
+			    const struct xsk_umem_config *usr_config)
 {
 	struct xdp_mmap_offsets off;
 	struct xdp_umem_reg mr;
@@ -165,6 +168,7 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
 	mr.len = size;
 	mr.chunk_size = umem->config.frame_size;
 	mr.headroom = umem->config.frame_headroom;
+	mr.flags = umem->config.flags;
 
 	err = setsockopt(umem->fd, SOL_XDP, XDP_UMEM_REG, &mr, sizeof(mr));
 	if (err) {
@@ -238,6 +242,29 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
 	return err;
 }
 
+struct xsk_umem_config_v1 {
+	__u32 fill_size;
+	__u32 comp_size;
+	__u32 frame_size;
+	__u32 frame_headroom;
+};
+
+int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
+			    __u64 size, struct xsk_ring_prod *fill,
+			    struct xsk_ring_cons *comp,
+			    const struct xsk_umem_config *usr_config)
+{
+	struct xsk_umem_config config;
+
+	memcpy(&config, usr_config, sizeof(struct xsk_umem_config_v1));
+	config.flags = 0;
+
+	return xsk_umem__create_v0_0_4(umem_ptr, umem_area, size, fill, comp,
+					&config);
+}
+asm(".symver xsk_umem__create_v0_0_2, xsk_umem__create@LIBBPF_0.0.2");
+asm(".symver xsk_umem__create_v0_0_4, xsk_umem__create@@LIBBPF_0.0.4");
+
 static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 {
 	static const int log_buf_size = 16 * 1024;
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index aa1d6122b7db..584f6820a639 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -168,6 +168,21 @@ static inline void *xsk_umem__get_data(void *umem_area, __u64 addr)
 	return &((char *)umem_area)[addr];
 }
 
+static inline __u64 xsk_umem__extract_addr(__u64 addr)
+{
+	return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
+}
+
+static inline __u64 xsk_umem__extract_offset(__u64 addr)
+{
+	return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
+}
+
+static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
+{
+	return xsk_umem__extract_addr(addr) + xsk_umem__extract_offset(addr);
+}
+
 LIBBPF_API int xsk_umem__fd(const struct xsk_umem *umem);
 LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
 
@@ -176,12 +191,14 @@ LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
 #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
 #define XSK_UMEM__DEFAULT_FRAME_SIZE     (1 << XSK_UMEM__DEFAULT_FRAME_SHIFT)
 #define XSK_UMEM__DEFAULT_FRAME_HEADROOM 0
+#define XSK_UMEM__DEFAULT_FLAGS 0
 
 struct xsk_umem_config {
 	__u32 fill_size;
 	__u32 comp_size;
 	__u32 frame_size;
 	__u32 frame_headroom;
+	__u32 flags;
 };
 
 /* Flags for the libbpf_flags field. */
@@ -201,6 +218,16 @@ LIBBPF_API int xsk_umem__create(struct xsk_umem **umem,
 				struct xsk_ring_prod *fill,
 				struct xsk_ring_cons *comp,
 				const struct xsk_umem_config *config);
+LIBBPF_API int xsk_umem__create_v0_0_2(struct xsk_umem **umem,
+				       void *umem_area, __u64 size,
+				       struct xsk_ring_prod *fill,
+				       struct xsk_ring_cons *comp,
+				       const struct xsk_umem_config *config);
+LIBBPF_API int xsk_umem__create_v0_0_4(struct xsk_umem **umem,
+				       void *umem_area, __u64 size,
+				       struct xsk_ring_prod *fill,
+				       struct xsk_ring_cons *comp,
+				       const struct xsk_umem_config *config);
 LIBBPF_API int xsk_socket__create(struct xsk_socket **xsk,
 				  const char *ifname, __u32 queue_id,
 				  struct xsk_umem *umem,
-- 
2.17.1

