Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2441C109BE0
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfKZKJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:38 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38312 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfKZKJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:37 -0500
Received: by mail-pg1-f196.google.com with SMTP id t3so8308787pgl.5;
        Tue, 26 Nov 2019 02:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L8/5aZaE5i5lcakkRBtwP3FriVl4GQ+xN5YrOjIUlCM=;
        b=fRo5+9ZKWTD3s5uJLU9TNtKkQVCRPVzYcxVxl6Lb9D5Sflcesxx6GY10RfAqq10k3L
         2dKkTp08HPOBLdXS0wZZPqLpVXU51DY9oXE2b9DC9UxnCDjdvcM1IukuHoVC1n4l7jyy
         ic145rX5r2EoWdTs4R+LaZL+vi+pwlT7G0BG07erZKekmBETQ63fioUFdc3gK1FBFBVl
         0TnAFzy1s0cYyK+PPgWGbwH9g275XIrgsW06CMWNnSW9E8TnlJnbcCnYK2GVgBWiFkNI
         7otab7zMtDrWC6ZLW4+mk7e6VL4XojLzPtRhSIbukm9LRqIKdMUAAATJq1dn7YseW9QI
         I8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L8/5aZaE5i5lcakkRBtwP3FriVl4GQ+xN5YrOjIUlCM=;
        b=TxGFq6/WDGnC6xCBdSmMRw7BOrpqy8GGzYxkNLo7bBLibZXie5XruAd0aHhZ3q2ZnT
         Zk7lYlRV09gjUzusoqtk1MlsWHlvIIxTNugjaxNVscjhr4JANGK4Z+lYH7/94VHI/EVT
         QbvS87ExJcuz99FPIhuvMq46chLhaLVr2pEevRXjRcblQY5sV0NFiEN4GY5oHu8fRvNX
         EfvdJAF5SCsnas/FAWcpRNaP2C7QatL0O0P5pGbe9hoEmXuGw1+FVJKMRD9NCoUsz3LE
         uvgRP8hRskeq6s+duSHg0IX5yH85bmE6j0S1Gsp0FIZJuWoBDnpriD6dkIh9YLs0D7Vc
         XT/Q==
X-Gm-Message-State: APjAAAWTenG4hAP250zK0h8MZbzMaFuni5X4gV4PzDDeaO8Bjtptzlqm
        kSiZs+opJcthdtc4ndxdq18=
X-Google-Smtp-Source: APXvYqwM6Ee33ApLWb/jq6ETiPN5BAkCEQ3rIFbqFuJ25Hzp+y84mxjBl6KWK1nKTl45ek26gmxnEQ==
X-Received: by 2002:aa7:90d0:: with SMTP id k16mr40811463pfk.131.1574762976474;
        Tue, 26 Nov 2019 02:09:36 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:35 -0800 (PST)
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
Subject: [RFC net-next 14/18] virtio_net: add XDP prog offload infrastructure
Date:   Tue, 26 Nov 2019 19:07:40 +0900
Message-Id: <20191126100744.5083-15-prashantbhole.linux@gmail.com>
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

This patch prepares virtio_net of XDP offloading. It adds data
structures, blank callback implementations for bpf_prog_offload_ops.
It also implements ndo_init, ndo_uninit operations for setting up
offload related data structures.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/virtio_net.c | 103 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cee5c2b15c62..a1088d0114f2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -229,8 +229,14 @@ struct virtnet_info {
 	struct failover *failover;
 
 	struct bpf_prog __rcu *xdp_prog;
+	struct bpf_prog __rcu *offload_xdp_prog;
 
 	struct xdp_attachment_info xdp;
+	struct xdp_attachment_info xdp_hw;
+
+	struct bpf_offload_dev *bpf_dev;
+
+	struct list_head bpf_bound_progs;
 };
 
 struct padded_vnet_hdr {
@@ -258,6 +264,14 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
 	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
 }
 
+struct virtnet_bpf_bound_prog {
+	struct virtnet_info *vi;
+	struct bpf_prog *prog;
+	struct list_head list;
+	u32 len;
+	struct bpf_insn insnsi[0];
+};
+
 /* Converting between virtqueue no. and kernel tx/rx queue no.
  * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
  */
@@ -2506,13 +2520,63 @@ static int virtnet_xdp_set(struct net_device *dev, struct netdev_bpf *bpf)
 	return err;
 }
 
+static int virtnet_bpf_verify_insn(struct bpf_verifier_env *env, int insn_idx,
+				   int prev_insn)
+{
+	return 0;
+}
+
+static void virtnet_bpf_destroy_prog(struct bpf_prog *prog)
+{
+}
+
+static int virtnet_xdp_set_offload(struct virtnet_info *vi,
+				   struct netdev_bpf *bpf)
+{
+	return -EBUSY;
+}
+
+static int virtnet_bpf_verifier_setup(struct bpf_prog *prog)
+{
+	return -ENOMEM;
+}
+
+static int virtnet_bpf_verifier_prep(struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int virtnet_bpf_translate(struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int virtnet_bpf_finalize(struct bpf_verifier_env *env)
+{
+	return 0;
+}
+
+static const struct bpf_prog_offload_ops virtnet_bpf_dev_ops = {
+	.setup		= virtnet_bpf_verifier_setup,
+	.prepare	= virtnet_bpf_verifier_prep,
+	.insn_hook	= virtnet_bpf_verify_insn,
+	.finalize	= virtnet_bpf_finalize,
+	.translate	= virtnet_bpf_translate,
+	.destroy	= virtnet_bpf_destroy_prog,
+};
+
 static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
+	struct virtnet_info *vi = netdev_priv(dev);
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return virtnet_xdp_set(dev, xdp);
 	case XDP_QUERY_PROG:
 		return xdp_attachment_query(&vi->xdp, xdp);
+	case XDP_SETUP_PROG_HW:
+		return virtnet_xdp_set_offload(vi, xdp);
+	case XDP_QUERY_PROG_HW:
+		return xdp_attachment_query(&vi->xdp_hw, xdp);
 	default:
 		return -EINVAL;
 	}
@@ -2559,7 +2623,46 @@ static int virtnet_set_features(struct net_device *dev,
 	return 0;
 }
 
+static int virtnet_bpf_init(struct virtnet_info *vi)
+{
+	int err;
+
+	vi->bpf_dev = bpf_offload_dev_create(&virtnet_bpf_dev_ops, NULL);
+	err = PTR_ERR_OR_ZERO(vi->bpf_dev);
+	if (err)
+		return err;
+
+	err = bpf_offload_dev_netdev_register(vi->bpf_dev, vi->dev);
+	if (err)
+		goto err_netdev_register;
+
+	INIT_LIST_HEAD(&vi->bpf_bound_progs);
+
+	return 0;
+
+err_netdev_register:
+	bpf_offload_dev_destroy(vi->bpf_dev);
+	return err;
+}
+
+static int virtnet_init(struct net_device *dev)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	return virtnet_bpf_init(vi);
+}
+
+static void virtnet_uninit(struct net_device *dev)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	bpf_offload_dev_netdev_unregister(vi->bpf_dev, vi->dev);
+	bpf_offload_dev_destroy(vi->bpf_dev);
+}
+
 static const struct net_device_ops virtnet_netdev = {
+	.ndo_init            = virtnet_init,
+	.ndo_uninit          = virtnet_uninit,
 	.ndo_open            = virtnet_open,
 	.ndo_stop   	     = virtnet_close,
 	.ndo_start_xmit      = start_xmit,
-- 
2.20.1

