Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF2109BF7
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfKZKKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:10:23 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:38634 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbfKZKKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:10:18 -0500
Received: by mail-pj1-f47.google.com with SMTP id f7so8072638pjw.5;
        Tue, 26 Nov 2019 02:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=izpU3FP4fxkkqeoLGSB6k8qMmojNU/Dikc5DKXQ0xHU=;
        b=Uq/ahqOAzTEUkTwsljpwIkyrGPqH/evKDEDersVK+mnaWbVNUkIthOWiLU+OXtLUvU
         EOw+sFAxx99LvFjbn0xvlUFZ5J3TEpxJkoyjlF2msZFo/LOeVoj6IkxWSzwwvLF/GaO4
         LV0VhZdKKH/GmYoyD3t6ep/62dQSmfaGEgWoU9yvfU7Rgusygl34frWANucKte7c05BM
         V5fH+YZvdKIZB7KcK8MgdI3YFmWqAtKSVQ2oidAApxjtHLUjzcKonWljChWnfE+ng/+x
         lioML1DyLTJ9oTbXDsRF4zQN7TE/MgG5O/maBRtCNJrC7VQNXshM+DqgYTr9+KMSBVLC
         NAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=izpU3FP4fxkkqeoLGSB6k8qMmojNU/Dikc5DKXQ0xHU=;
        b=kUZ18381yin/thuOPac1UYSaQR6+Z8a5PdJuZO/cwCVRq3oW37OXaHf/tbOuHjZBd7
         jkEQRP/3bqH0ppXrUc+dpZXOUOnNsB5onRUcF3hu4hdKsKjU921sLoEaWkByRYYdKh/D
         2532hq2UfzOE6H7QbHFdDLJ63y0uFjVOTDkmJcOmqIm+jg6+3QzlMDALSI/OyrxfWS3t
         93V1eCDGT2O4BPQvlbGqfqUxRubwX8GH/hzWFFV9+57qFqT7w80f2FZs3omhNfLmbo6l
         X6GYye67QNFjr3dTDq2ZlWSnxduKtQtQELmEID5fmmeqk+T48WoMDD/rdvMqU0tSlIc2
         E+Pw==
X-Gm-Message-State: APjAAAVR5BWde5LHvbI+y8Zw0TaiPGyHrjMWZsUfVaOKn7G/xgkcy/a+
        ZC+/NQYumNuM33AJs1uoPBg=
X-Google-Smtp-Source: APXvYqytegqONiYQJkp3D/RPNSJspi2nkwoVBXcgZu7C3Ai2QAmscJb++iOInjMbvENLHy/9nfJw7g==
X-Received: by 2002:a17:902:fe06:: with SMTP id g6mr16749434plj.52.1574763017372;
        Tue, 26 Nov 2019 02:10:17 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id h9sm12059065pgk.84.2019.11.26.02.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:10:16 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC 2/3] virtio-net: add support for offloading XDP program
Date:   Tue, 26 Nov 2019 19:09:13 +0900
Message-Id: <20191126100914.5150-3-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100914.5150-1-prashantbhole.linux@gmail.com>
References: <20191126100914.5150-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

This feature involves offloading of XDP program and ebpf map from
the guest to the host. This patch takes care of offloadin of program.

A handler for VIRTIO_NET_CTRL_EBPF command is added in virtio-net.
The control buffer consist of struct virtio_net_ctrl_ebpf_prog and
followed by an ebpf program instructions. An array of bpf_insn is
prepared and passed to libbpf API bpf_load_program. The program fd is
retuned by the API is then attached to tap fd using TUNSETOFFLOADEDXDP
ioctl command.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 hw/net/virtio-net.c                         | 69 +++++++++++++++++++++
 include/net/tap.h                           |  2 +
 include/standard-headers/linux/virtio_net.h | 27 ++++++++
 net/Makefile.objs                           |  1 +
 net/tap-bsd.c                               |  5 ++
 net/tap-linux.c                             | 48 ++++++++++++++
 net/tap-linux.h                             |  1 +
 net/tap-solaris.c                           |  5 ++
 net/tap-stub.c                              |  5 ++
 net/tap.c                                   |  7 +++
 net/tap_int.h                               |  1 +
 11 files changed, 171 insertions(+)

diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 97a5113f7e..7cc1bd1654 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -43,6 +43,11 @@
 #include "monitor/qdev.h"
 #include "hw/pci/pci.h"
 
+#ifdef CONFIG_LIBBPF
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#endif
+
 #define VIRTIO_NET_VM_VERSION    11
 
 #define MAC_TABLE_ENTRIES    64
@@ -628,6 +633,21 @@ static int peer_attach(VirtIONet *n, int index)
     return tap_enable(nc->peer);
 }
 
+static int peer_attach_ebpf(VirtIONet *n, int len, void *insns, uint8_t gpl)
+{
+    NetClientState *nc = qemu_get_subqueue(n->nic, 0);
+
+    if (!nc->peer) {
+        return 0;
+    }
+
+    if (nc->peer->info->type != NET_CLIENT_DRIVER_TAP) {
+        return 0;
+    }
+
+    return tap_attach_ebpf(nc->peer, len, insns, gpl);
+}
+
 static int peer_detach(VirtIONet *n, int index)
 {
     NetClientState *nc = qemu_get_subqueue(n->nic, index);
@@ -991,6 +1011,53 @@ static int virtio_net_handle_offloads(VirtIONet *n, uint8_t cmd,
     }
 }
 
+static int virtio_net_handle_ebpf_prog(VirtIONet *n, struct iovec *iov,
+                                       unsigned int iov_cnt)
+{
+#ifdef CONFIG_LIBBPF
+    struct bpf_insn prog[4096];
+    struct virtio_net_ctrl_ebpf_prog ctrl;
+    size_t s;
+    int err = VIRTIO_NET_ERR;
+
+    s = iov_to_buf(iov, iov_cnt, 0, &ctrl, sizeof(ctrl));
+    if (s != sizeof(ctrl)) {
+        error_report("Invalid ebpf prog control buffer");
+        goto err;
+    }
+
+    if (ctrl.cmd == VIRTIO_NET_BPF_CMD_SET_OFFLOAD) {
+        s = iov_to_buf(iov, iov_cnt, sizeof(ctrl), prog, sizeof(prog));
+        if (s != ctrl.len) {
+            error_report("Invalid ebpf prog control buffer");
+            goto err;
+        }
+
+        err = peer_attach_ebpf(n, s, prog, ctrl.gpl_compatible);
+            if (err) {
+                error_report("Failed to attach XDP program");
+                goto err;
+            }
+    } else if (ctrl.cmd == VIRTIO_NET_BPF_CMD_UNSET_OFFLOAD) {
+        err = peer_attach_ebpf(n, 0, NULL, 0);
+    }
+err:
+    return err ? VIRTIO_NET_ERR : VIRTIO_NET_OK;
+#else
+    return VIRTIO_NET_ERR;
+#endif
+}
+
+static int virtio_net_handle_ebpf(VirtIONet *n, uint8_t cmd,
+                                  struct iovec *iov, unsigned int iov_cnt)
+{
+    if (cmd == VIRTIO_NET_CTRL_EBPF_PROG) {
+        return virtio_net_handle_ebpf_prog(n, iov, iov_cnt);
+    }
+
+    return VIRTIO_NET_ERR;
+}
+
 static int virtio_net_handle_mac(VirtIONet *n, uint8_t cmd,
                                  struct iovec *iov, unsigned int iov_cnt)
 {
@@ -1208,6 +1275,8 @@ static void virtio_net_handle_ctrl(VirtIODevice *vdev, VirtQueue *vq)
             status = virtio_net_handle_mq(n, ctrl.cmd, iov, iov_cnt);
         } else if (ctrl.class == VIRTIO_NET_CTRL_GUEST_OFFLOADS) {
             status = virtio_net_handle_offloads(n, ctrl.cmd, iov, iov_cnt);
+        } else if (ctrl.class == VIRTIO_NET_CTRL_EBPF) {
+            status = virtio_net_handle_ebpf(n, ctrl.cmd, iov, iov_cnt);
         }
 
         s = iov_from_buf(elem->in_sg, elem->in_num, 0, &status, sizeof(status));
diff --git a/include/net/tap.h b/include/net/tap.h
index 5d585515f9..19c507a1c2 100644
--- a/include/net/tap.h
+++ b/include/net/tap.h
@@ -33,6 +33,8 @@ int tap_disable(NetClientState *nc);
 
 int tap_get_fd(NetClientState *nc);
 
+int tap_attach_ebpf(NetClientState *nc, int len, void *insns, uint8_t gpl);
+
 struct vhost_net;
 struct vhost_net *tap_get_vhost_net(NetClientState *nc);
 
diff --git a/include/standard-headers/linux/virtio_net.h b/include/standard-headers/linux/virtio_net.h
index 260c3681d7..83292c81bc 100644
--- a/include/standard-headers/linux/virtio_net.h
+++ b/include/standard-headers/linux/virtio_net.h
@@ -261,4 +261,31 @@ struct virtio_net_ctrl_mq {
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
 
+/*
+ * Control XDP offloads offloads
+ *
+ * When guest wants to offload XDP program to tap device, it calls
+ * VIRTIO_NET_CTRL_EBPF_PROG along with VIRTIO_NET_BPF_CMD_SET_OFFLOAD
+ * subcommands. When offloading is successful, the tap device run offloaded
+ * XDP program for each packet before sending it to the guest.
+ *
+ * VIRTIO_NET_BPF_CMD_UNSET_OFFLOAD removes the the offloaded program from
+ * the tap device, if exists.
+ */
+
+struct virtio_net_ctrl_ebpf_prog {
+	/* program length in bytes */
+	__virtio32 len;
+	__virtio16 cmd;
+	__virtio16 gpl_compatible;
+	uint8_t insns[0];
+};
+
+#define VIRTIO_NET_CTRL_EBPF 	6
+ #define VIRTIO_NET_CTRL_EBPF_PROG 1
+
+/* Commands for VIRTIO_NET_CTRL_EBPF_PROG */
+#define VIRTIO_NET_BPF_CMD_SET_OFFLOAD 1
+#define VIRTIO_NET_BPF_CMD_UNSET_OFFLOAD 2
+
 #endif /* _LINUX_VIRTIO_NET_H */
diff --git a/net/Makefile.objs b/net/Makefile.objs
index c5d076d19c..e7645225be 100644
--- a/net/Makefile.objs
+++ b/net/Makefile.objs
@@ -28,5 +28,6 @@ common-obj-$(CONFIG_POSIX) += tap.o $(tap-obj-y)
 common-obj-$(CONFIG_WIN32) += tap-win32.o
 
 vde.o-libs = $(VDE_LIBS)
+tap-linux.o-libs = $(LIBBPF_LIBS)
 
 common-obj-$(CONFIG_CAN_BUS) += can/
diff --git a/net/tap-bsd.c b/net/tap-bsd.c
index a5c3707f80..e4e2a5c799 100644
--- a/net/tap-bsd.c
+++ b/net/tap-bsd.c
@@ -259,3 +259,8 @@ int tap_fd_get_ifname(int fd, char *ifname)
 {
     return -1;
 }
+
+int tap_fd_attach_ebpf(int fd, int len, void *insns, uint8_t gpl)
+{
+    return -EINVAL;
+}
diff --git a/net/tap-linux.c b/net/tap-linux.c
index e0dd442ee3..3ff806bf4f 100644
--- a/net/tap-linux.c
+++ b/net/tap-linux.c
@@ -31,6 +31,8 @@
 
 #include <net/if.h>
 #include <sys/ioctl.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 
 #include "qapi/error.h"
 #include "qemu/error-report.h"
@@ -314,3 +316,49 @@ int tap_fd_get_ifname(int fd, char *ifname)
     pstrcpy(ifname, sizeof(ifr.ifr_name), ifr.ifr_name);
     return 0;
 }
+
+int tap_fd_attach_ebpf(int fd, int len, void *insns, uint8_t gpl)
+{
+#ifdef CONFIG_LIBBPF
+    struct bpf_insn *prog = (struct bpf_insn *)insns;
+    static char log_buf[65536];
+    char license[16] = {0};
+    int num_insn;
+    int bpf_fd;
+    int ret;
+
+    if (!prog) {
+        bpf_fd = -1;
+        ret = ioctl(fd, TUNSETOFFLOADEDXDP, &bpf_fd);
+        if (ret) {
+            error_report("Failed to remove offloaded XDP: %s", strerror(errno));
+            return -EFAULT;
+        }
+        return ret;
+    }
+
+    num_insn = len / sizeof(prog[0]);
+    if (gpl) {
+        strncpy(license, "GPL", sizeof(license));
+    }
+
+    bpf_fd = bpf_load_program(BPF_PROG_TYPE_XDP, prog, num_insn, license,
+                              0, log_buf, sizeof(log_buf));
+    if (bpf_fd < 0) {
+        error_report("Failed to load XDP program: %s", strerror(errno));
+        error_report("ebpf verifier log: %s", log_buf);
+        return -EFAULT;
+    }
+
+    ret = ioctl(fd, TUNSETOFFLOADEDXDP, &bpf_fd);
+    if (ret) {
+        error_report("Failed to set offloaded XDP: %s", strerror(errno));
+        return -EFAULT;
+    }
+    close(bpf_fd);
+
+    return ret;
+#else
+    return -EINVAL;
+#endif
+}
diff --git a/net/tap-linux.h b/net/tap-linux.h
index 2f36d100fc..791aeaebc4 100644
--- a/net/tap-linux.h
+++ b/net/tap-linux.h
@@ -31,6 +31,7 @@
 #define TUNSETQUEUE  _IOW('T', 217, int)
 #define TUNSETVNETLE _IOW('T', 220, int)
 #define TUNSETVNETBE _IOW('T', 222, int)
+#define TUNSETOFFLOADEDXDP _IOW('T', 228, int)
 
 #endif
 
diff --git a/net/tap-solaris.c b/net/tap-solaris.c
index 4725d2314e..38b9136b5f 100644
--- a/net/tap-solaris.c
+++ b/net/tap-solaris.c
@@ -254,3 +254,8 @@ int tap_fd_get_ifname(int fd, char *ifname)
 {
     return -1;
 }
+
+int tap_fd_attach_ebpf(int fd, int len, void *insns, uint8_t gpl)
+{
+    return -EINVAL;
+}
diff --git a/net/tap-stub.c b/net/tap-stub.c
index a9ab8f8293..5f4161b390 100644
--- a/net/tap-stub.c
+++ b/net/tap-stub.c
@@ -85,3 +85,8 @@ int tap_fd_get_ifname(int fd, char *ifname)
 {
     return -1;
 }
+
+int tap_fd_attach_ebpf(int fd, int len, void *insns, uint8_t gpl)
+{
+    return -EINVAL;
+}
diff --git a/net/tap.c b/net/tap.c
index 6207f61f84..3dba8eacb1 100644
--- a/net/tap.c
+++ b/net/tap.c
@@ -971,6 +971,13 @@ int tap_enable(NetClientState *nc)
     }
 }
 
+int tap_attach_ebpf(NetClientState *nc, int len, void *insns, uint8_t gpl)
+{
+    TAPState *s = DO_UPCAST(TAPState, nc, nc);
+
+    return tap_fd_attach_ebpf(s->fd, len, insns, gpl);
+}
+
 int tap_disable(NetClientState *nc)
 {
     TAPState *s = DO_UPCAST(TAPState, nc, nc);
diff --git a/net/tap_int.h b/net/tap_int.h
index e3194b23f4..af641607e2 100644
--- a/net/tap_int.h
+++ b/net/tap_int.h
@@ -44,5 +44,6 @@ int tap_fd_set_vnet_be(int fd, int vnet_is_be);
 int tap_fd_enable(int fd);
 int tap_fd_disable(int fd);
 int tap_fd_get_ifname(int fd, char *ifname);
+int tap_fd_attach_ebpf(int fd, int len, void *insns, uint8_t gpl);
 
 #endif /* NET_TAP_INT_H */
-- 
2.20.1

