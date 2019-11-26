Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F648109BE6
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfKZKJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:43 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39264 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbfKZKJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:41 -0500
Received: by mail-pg1-f193.google.com with SMTP id b137so6441846pga.6;
        Tue, 26 Nov 2019 02:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iF2Qj2HQU3QXOgxa/8KPlCCJG4r2E8XApomblPiSB8E=;
        b=D0UYZK0RE+Et5nv6Qca/F1vgfk1JQVgqSzdMnDmmjurIApyqdCxw6DeQsL8FYTA6u/
         KwVzke5RnI0wtXSENtsBmA8wDFxTd6hG+npLFS8bRPb9ugm3/hVV5z8O1I9WDK95KvSE
         kH3jNxWjPH+jsjkKFHaRrfhsgjCVFwLsD7LNo1xglTVJoWhF1DhwV1ZhDxH5TPdVm/1r
         XDIiXt1wqIwi3UvE8SfYxp70qrphSnVs70SuuC1ugFHwVuJoBJppJ8Kw/nBjLSqSmkeJ
         uR01Y6/l83pYdXi8KDjWnm48kQRtavKWqtKuyKEs9AlkD1GFUuFo21izmbRfYwC46KKt
         Emag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iF2Qj2HQU3QXOgxa/8KPlCCJG4r2E8XApomblPiSB8E=;
        b=ca5kDjmlSZyQZvDtvnApy6FXPLL9i8IYrrBmu0nPBE/liTu2amYigwAjzV9uZJ+oAg
         tYN/XMfwqsTam25rFRQFFtX2xn/KriVsMPM6KDM7r1SGM79+4yA6CAMXwrQ4D1cBpKHg
         H8WgMgxu5BQLsKvnv3B3PZT4YPJ+2cEkBOP9fCv0CerlD2DV4OpFuT9k8Uv6OTZl/3S4
         jwBHd+GlxDZ9WyQ5gib9xps++E2hOAe4Roxy8PTUbDWjiFatfW8adpENvyEZrYrmhXdH
         WBe/rCdWqkmXLhRbN3B9qUjOb9YbvGPV83JVSm1+UKGBQ0elcVxkabdzjlCL5WjyKk7R
         BQBw==
X-Gm-Message-State: APjAAAWbfbLF8Vw9PIXkkQEtPvJjAkrp+5ceUk6c91q2AVyXxcJg5Vdz
        gsPyT6zCgs8ZHV7vg/YA2k4=
X-Google-Smtp-Source: APXvYqz+uMctIG2ZIs56c5eSzst4/2rCLxB7JzbDXh2IKeUxkAbdP3247ZE0k9PRARnctTS5VQGjqQ==
X-Received: by 2002:a63:e647:: with SMTP id p7mr38714558pgj.47.1574762980220;
        Tue, 26 Nov 2019 02:09:40 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:39 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 15/18] virtio_net: implement XDP prog offload functionality
Date:   Tue, 26 Nov 2019 19:07:41 +0900
Message-Id: <20191126100744.5083-16-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

This patch implements bpf_prog_offload_ops callbacks and adds handling
for XDP_SETUP_PROG_HW. Handling of XDP_SETUP_PROG_HW involves setting
up struct virtio_net_ctrl_ebpf_prog and appending program instructions
to it. This control buffer is sent to Qemu with class
VIRTIO_NET_CTRL_EBPF and command VIRTIO_NET_BPF_CMD_SET_OFFLOAD.
The expected behavior from Qemu is that it should try to load the
program in host os and report the status.

It also adds restriction to have either driver or offloaded program
at a time. This restriction can be removed later after proper testing.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/virtio_net.c        | 114 +++++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_net.h |  27 ++++++++
 2 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a1088d0114f2..dddfbb2a2075 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -169,6 +169,7 @@ struct control_buf {
 	u8 allmulti;
 	__virtio16 vid;
 	__virtio64 offloads;
+	struct virtio_net_ctrl_ebpf_prog prog_ctrl;
 };
 
 struct virtnet_info {
@@ -272,6 +273,8 @@ struct virtnet_bpf_bound_prog {
 	struct bpf_insn insnsi[0];
 };
 
+#define VIRTNET_EA(extack, msg)	NL_SET_ERR_MSG_MOD((extack), msg)
+
 /* Converting between virtqueue no. and kernel tx/rx queue no.
  * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
  */
@@ -2427,6 +2430,11 @@ static int virtnet_xdp_set(struct net_device *dev, struct netdev_bpf *bpf)
 	if (!xdp_attachment_flags_ok(&vi->xdp, bpf))
 		return -EBUSY;
 
+	if (rtnl_dereference(vi->offload_xdp_prog)) {
+		VIRTNET_EA(bpf->extack, "program already attached in offload mode");
+		return -EINVAL;
+	}
+
 	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)
 	    && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
@@ -2528,17 +2536,114 @@ static int virtnet_bpf_verify_insn(struct bpf_verifier_env *env, int insn_idx,
 
 static void virtnet_bpf_destroy_prog(struct bpf_prog *prog)
 {
+	struct virtnet_bpf_bound_prog *state;
+
+	state = prog->aux->offload->dev_priv;
+	list_del(&state->list);
+	kfree(state);
+}
+
+static int virtnet_xdp_offload_check(struct virtnet_info *vi,
+				     struct netdev_bpf *bpf)
+{
+	if (!bpf->prog)
+		return 0;
+
+	if (!bpf->prog->aux->offload) {
+		VIRTNET_EA(bpf->extack, "xdpoffload of non-bound program");
+		return -EINVAL;
+	}
+	if (bpf->prog->aux->offload->netdev != vi->dev) {
+		VIRTNET_EA(bpf->extack, "program bound to different dev");
+		return -EINVAL;
+	}
+
+	if (rtnl_dereference(vi->xdp_prog)) {
+		VIRTNET_EA(bpf->extack, "program already attached in driver mode");
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int virtnet_xdp_set_offload(struct virtnet_info *vi,
 				   struct netdev_bpf *bpf)
 {
-	return -EBUSY;
+	struct virtio_net_ctrl_ebpf_prog *ctrl;
+	struct virtnet_bpf_bound_prog *bound_prog = NULL;
+	struct virtio_device *vdev = vi->vdev;
+	struct bpf_prog *prog = bpf->prog;
+	void *ctrl_buf = NULL;
+	struct scatterlist sg;
+	int prog_len;
+	int err = 0;
+
+	if (!xdp_attachment_flags_ok(&vi->xdp_hw, bpf))
+		return -EBUSY;
+
+	if (prog) {
+		if (prog->type != BPF_PROG_TYPE_XDP)
+			return -EOPNOTSUPP;
+		bound_prog = prog->aux->offload->dev_priv;
+		prog_len = prog->len * sizeof(bound_prog->insnsi[0]);
+
+		ctrl_buf = kmalloc(GFP_KERNEL, sizeof(*ctrl) + prog_len);
+		if (!ctrl_buf)
+			return -ENOMEM;
+		ctrl = ctrl_buf;
+		ctrl->cmd = cpu_to_virtio32(vi->vdev,
+					    VIRTIO_NET_BPF_CMD_SET_OFFLOAD);
+		ctrl->len = cpu_to_virtio32(vi->vdev, prog_len);
+		ctrl->gpl_compatible = cpu_to_virtio16(vi->vdev,
+						       prog->gpl_compatible);
+		memcpy(ctrl->insns, bound_prog->insnsi,
+		       prog->len * sizeof(bound_prog->insnsi[0]));
+		sg_init_one(&sg, ctrl_buf, sizeof(*ctrl) + prog_len);
+	} else {
+		ctrl = &vi->ctrl->prog_ctrl;
+		ctrl->cmd  = cpu_to_virtio32(vi->vdev,
+					     VIRTIO_NET_BPF_CMD_UNSET_OFFLOAD);
+		sg_init_one(&sg, ctrl, sizeof(*ctrl));
+	}
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_EBPF,
+				  VIRTIO_NET_CTRL_EBPF_PROG,
+				  &sg)) {
+		dev_warn(&vdev->dev, "Failed to set bpf offload prog\n");
+		err = -EFAULT;
+		goto out;
+	}
+
+	rcu_assign_pointer(vi->offload_xdp_prog, prog);
+
+	xdp_attachment_setup(&vi->xdp_hw, bpf);
+
+out:
+	kfree(ctrl_buf);
+	return err;
 }
 
 static int virtnet_bpf_verifier_setup(struct bpf_prog *prog)
 {
-	return -ENOMEM;
+	struct virtnet_info *vi = netdev_priv(prog->aux->offload->netdev);
+	size_t insn_len = prog->len * sizeof(struct bpf_insn);
+	struct virtnet_bpf_bound_prog *state;
+
+	state = kzalloc(sizeof(*state) + insn_len, GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	memcpy(&state->insnsi[0], prog->insnsi, insn_len);
+
+	state->vi = vi;
+	state->prog = prog;
+	state->len = prog->len;
+
+	list_add_tail(&state->list, &vi->bpf_bound_progs);
+
+	prog->aux->offload->dev_priv = state;
+
+	return 0;
 }
 
 static int virtnet_bpf_verifier_prep(struct bpf_prog *prog)
@@ -2568,12 +2673,17 @@ static const struct bpf_prog_offload_ops virtnet_bpf_dev_ops = {
 static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
+	int err;
+
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return virtnet_xdp_set(dev, xdp);
 	case XDP_QUERY_PROG:
 		return xdp_attachment_query(&vi->xdp, xdp);
 	case XDP_SETUP_PROG_HW:
+		err = virtnet_xdp_offload_check(vi, xdp);
+		if (err)
+			return err;
 		return virtnet_xdp_set_offload(vi, xdp);
 	case XDP_QUERY_PROG_HW:
 		return xdp_attachment_query(&vi->xdp_hw, xdp);
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index a3715a3224c1..0ea2f7910a5a 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -261,4 +261,31 @@ struct virtio_net_ctrl_mq {
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
 
+/*
+ * Control XDP offloads offloads
+ *
+ * When guest wants to offload XDP program to the device, it calls
+ * VIRTIO_NET_CTRL_EBPF_PROG along with VIRTIO_NET_BPF_CMD_SET_OFFLOAD
+ * subcommands. When offloading is successful, the device runs offloaded
+ * XDP program for each packet before sending it to the guest.
+ *
+ * VIRTIO_NET_BPF_CMD_UNSET_OFFLOAD removes the the offloaded program from
+ * the device, if exists.
+ */
+
+struct virtio_net_ctrl_ebpf_prog {
+	/* program length in bytes */
+	__virtio32 len;
+	__virtio16 cmd;
+	__virtio16 gpl_compatible;
+	__u8 insns[0];
+};
+
+#define VIRTIO_NET_CTRL_EBPF 6
+ #define VIRTIO_NET_CTRL_EBPF_PROG 1
+
+/* Commands for VIRTIO_NET_CTRL_EBPF_PROG */
+#define VIRTIO_NET_BPF_CMD_SET_OFFLOAD 1
+#define VIRTIO_NET_BPF_CMD_UNSET_OFFLOAD 2
+
 #endif /* _UAPI_LINUX_VIRTIO_NET_H */
-- 
2.20.1

