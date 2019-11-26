Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409BA109BEB
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfKZKJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:50 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:46821 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbfKZKJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:49 -0500
Received: by mail-pj1-f68.google.com with SMTP id a16so8057974pjs.13;
        Tue, 26 Nov 2019 02:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zk3sW22S1vh0AAHBme1qJ6RZt3yGG+m+CCZCVNC9O+U=;
        b=i+EvPSxfehY7pdZKrtOH/92CceCXUXqxQNHLS8Dgi76SvXlg05ezIAKQ4FdC4oJRA+
         vkIRYqqni/0dSQQeSIisOK9PmMqJEgS8HBbC5oAS1K4Uogo9Std2Szp8RPbhFubRLtWa
         GAXaGUhUjWJzY99ZSABBweLRJ3wy66M7ruI46vL6dB8E6ZUse7Ub9ld8rb+k1+hnefYS
         Lt/XYCNpBDHO399apLSYB4kp81Zz1DYQ9MVL5fQ+E6xSj57jgVaqCw1zZFeGxt2KCgKi
         KQ+8dAkH6CzVS39i6plLht441sTUmKWtdf7AhRHO7SrQC/HcuCz7Iur7n3eP/5PfybuL
         Oj3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zk3sW22S1vh0AAHBme1qJ6RZt3yGG+m+CCZCVNC9O+U=;
        b=WSfuNASXqicEzKBWmKKf8lfQ0HPMWvpycnEKQ3BMYdkEVQe7XmQlKuvxwnwk04I0Gh
         FpRVnZyVPqmwitc1vN5l6QWb+rlDl7Cc+XIpAUDi3gpi3+QszNPmAS8xgWVF5QeRK7OB
         MJ702lfW/W+4WaVJUMx2O9Fy8qOiJXIaLNmeQjkr9d5kZXiYEAVA9p/X/bkHA3m3nUCr
         tesOUNIXfsJ2SizsiFdcqNPW/DWQ8Qn/2WXj1aUZ6DnNxGNN/+1uMvltJoE3RiL7AIJ+
         eqmrNIqnV2xBxfHSs1igsqc+++BbygnV9wEXMETCfDsXo2pXjVKn42NHbxnXQZ5vFMl8
         SCRg==
X-Gm-Message-State: APjAAAX31EE0jDPXGQtuyYf1trlBK9YCmngLqSBBsW/eGzKfDJah9Vhp
        UyOuRw6l6t7zD6AcK7MibOc=
X-Google-Smtp-Source: APXvYqzFyFh+pbLegLoH9n9d2gmpHvn7dEVY5afqLnbUM7fE1SOq8IDt/3EeOo1AM4jKJu5rmRGdoA==
X-Received: by 2002:a17:902:8f81:: with SMTP id z1mr32304035plo.228.1574762987931;
        Tue, 26 Nov 2019 02:09:47 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:47 -0800 (PST)
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
Subject: [RFC net-next 17/18] virtio_net: implment XDP map offload functionality
Date:   Tue, 26 Nov 2019 19:07:43 +0900
Message-Id: <20191126100744.5083-18-prashantbhole.linux@gmail.com>
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

This patch implements:
* Handling of BPF_OFFLOAD_MAP_ALLOC, BPF_OFFLOAD_MAP_FREE:
  Allocate driver specific map data structure. Set up struct
  virtio_net_ctrl_ebpf_map and send the control buffer to Qemu with
  class VIRTIO_NET_CTRL_EBPF, cmd VIRTIO_NET_CTRL_EBPF_MAP. The cmd
  in the control buffer is set to VIRTIO_NET_BPF_CMD_CREATE_MAP. The
  expected behavior from Qemu is that it should perform the action
  as per command and return the status (and map data). In case of
  create map command, Qemu should set the map_fd in the control buffer

* bpf_map_dev_ops operations:
  Common map operations are implemented with use of above mentioned
  struct virtio_net_ctrl_ebpf_map. This control buffer has space for
  storing: key + key or key + value.

* map_fd replacement in a copy of the program:
  Since map are created before the verification of program begins,
  we have map fds from the host side for each offloaded map when
  program verification begins. map fds in the copy of the program are
  replaced with map fds from host side. This copy of program is used
  for offloading.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/virtio_net.c        | 241 ++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_net.h |  23 +++
 2 files changed, 264 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index dddfbb2a2075..91a94b787c64 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -238,6 +238,7 @@ struct virtnet_info {
 	struct bpf_offload_dev *bpf_dev;
 
 	struct list_head bpf_bound_progs;
+	struct list_head map_list;
 };
 
 struct padded_vnet_hdr {
@@ -275,6 +276,13 @@ struct virtnet_bpf_bound_prog {
 
 #define VIRTNET_EA(extack, msg)	NL_SET_ERR_MSG_MOD((extack), msg)
 
+struct virtnet_bpf_map {
+	struct bpf_offloaded_map *offmap;
+	struct virtnet_info *vi;
+	struct virtio_net_ctrl_ebpf_map *ctrl;
+	struct list_head list;
+};
+
 /* Converting between virtqueue no. and kernel tx/rx queue no.
  * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
  */
@@ -2528,6 +2536,19 @@ static int virtnet_xdp_set(struct net_device *dev, struct netdev_bpf *bpf)
 	return err;
 }
 
+static struct virtnet_bpf_map *virtnet_get_bpf_map(struct virtnet_info *vi,
+						   struct bpf_map *map)
+{
+	struct virtnet_bpf_map *virtnet_map;
+
+	list_for_each_entry(virtnet_map, &vi->map_list, list) {
+		if (&virtnet_map->offmap->map == map)
+			return virtnet_map;
+	}
+
+	return NULL;
+}
+
 static int virtnet_bpf_verify_insn(struct bpf_verifier_env *env, int insn_idx,
 				   int prev_insn)
 {
@@ -2623,11 +2644,194 @@ static int virtnet_xdp_set_offload(struct virtnet_info *vi,
 	return err;
 }
 
+static int virtnet_bpf_ctrl_map(struct bpf_offloaded_map *offmap,
+				int cmd, u8 *key, u8 *value, u64 flags,
+				u8 *out_key, u8 *out_value)
+{
+	struct virtio_net_ctrl_ebpf_map *ctrl;
+	struct virtnet_bpf_map *virtnet_map;
+	struct bpf_map *map = &offmap->map;
+	unsigned char *keyptr, *valptr;
+	struct virtnet_info *vi;
+	struct scatterlist sg;
+
+	virtnet_map = offmap->dev_priv;
+	vi = virtnet_map->vi;
+	ctrl = virtnet_map->ctrl;
+
+	keyptr = ctrl->buf;
+	valptr = ctrl->buf + ctrl->key_size;
+
+	if (key)
+		memcpy(keyptr, key, map->key_size);
+	if (value)
+		memcpy(valptr, value, map->value_size);
+
+	ctrl->cmd = cpu_to_virtio32(vi->vdev, cmd);
+	ctrl->flags = cpu_to_virtio64(vi->vdev, flags);
+
+	sg_init_one(&sg, ctrl, sizeof(*ctrl) + ctrl->buf_len);
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_EBPF,
+				  VIRTIO_NET_CTRL_EBPF_MAP,
+				  &sg))
+		return -EFAULT;
+
+	if (out_key)
+		memcpy(out_key, valptr, map->key_size);
+	if (out_value)
+		memcpy(out_value, valptr, map->value_size);
+	return 0;
+}
+
+static int virtnet_bpf_map_update_entry(struct bpf_offloaded_map *offmap,
+					void *key, void *value, u64 flags)
+{
+	return virtnet_bpf_ctrl_map(offmap,
+				    VIRTIO_NET_BPF_CMD_UPDATE_ELEM,
+				    key, value, flags, NULL, NULL);
+}
+
+static int virtnet_bpf_map_delete_elem(struct bpf_offloaded_map *offmap,
+				       void *key)
+{
+	return virtnet_bpf_ctrl_map(offmap,
+				    VIRTIO_NET_BPF_CMD_DELETE_ELEM,
+				    key, NULL, 0, NULL, NULL);
+}
+
+static int virtnet_bpf_map_lookup_entry(struct bpf_offloaded_map *offmap,
+					void *key, void *value)
+{
+	return virtnet_bpf_ctrl_map(offmap,
+				    VIRTIO_NET_BPF_CMD_LOOKUP_ELEM,
+				    key, NULL, 0, NULL, value);
+}
+
+static int virtnet_bpf_map_get_first_key(struct bpf_offloaded_map *offmap,
+					 void *next_key)
+{
+	return virtnet_bpf_ctrl_map(offmap,
+				    VIRTIO_NET_BPF_CMD_GET_FIRST,
+				    NULL, NULL, 0, next_key, NULL);
+}
+
+static int virtnet_bpf_map_get_next_key(struct bpf_offloaded_map *offmap,
+					void *key, void *next_key)
+{
+	if (!key)
+		return virtnet_bpf_map_get_first_key(offmap, next_key);
+
+	return virtnet_bpf_ctrl_map(offmap,
+				    VIRTIO_NET_BPF_CMD_GET_NEXT,
+				    key, NULL, 0, next_key, NULL);
+}
+
+static const struct bpf_map_dev_ops virtnet_bpf_map_ops = {
+	.map_get_next_key	= virtnet_bpf_map_get_next_key,
+	.map_lookup_elem	= virtnet_bpf_map_lookup_entry,
+	.map_update_elem	= virtnet_bpf_map_update_entry,
+	.map_delete_elem	= virtnet_bpf_map_delete_elem,
+};
+
+static int virtnet_bpf_map_alloc(struct virtnet_info *vi,
+				 struct bpf_offloaded_map *offmap)
+{
+	struct virtnet_bpf_map *virtnet_map = NULL;
+	struct virtio_net_ctrl_ebpf_map *ctrl = NULL;
+	struct bpf_map *map = &offmap->map;
+	struct scatterlist sg;
+	int buf_len;
+
+	if (map->map_type != BPF_MAP_TYPE_ARRAY &&
+	    map->map_type != BPF_MAP_TYPE_HASH)
+		goto err;
+
+	virtnet_map = kzalloc(sizeof(*virtnet_map), GFP_KERNEL);
+	if (!virtnet_map)
+		goto err;
+
+	/* allocate buffer size to fit
+	 * - sizeof (struct virio_net_ctrl_map_buf)
+	 * - key_size
+	 * - max(key_size + value_size, key_size + key_size)
+	 */
+	buf_len = map->key_size;
+	buf_len += (map->key_size > map->value_size) ?
+		  map->key_size : map->value_size;
+	ctrl = kzalloc(sizeof(*ctrl) + buf_len, GFP_KERNEL);
+	if (!ctrl)
+		goto err;
+
+	ctrl->buf_len = cpu_to_virtio32(vi->vdev, buf_len);
+	ctrl->key_size = cpu_to_virtio32(vi->vdev, map->key_size);
+	ctrl->value_size = cpu_to_virtio32(vi->vdev, map->value_size);
+	ctrl->max_entries = cpu_to_virtio32(vi->vdev, map->max_entries);
+	ctrl->map_type = cpu_to_virtio32(vi->vdev, map->map_type);
+	ctrl->map_flags = 0;
+	ctrl->cmd = cpu_to_virtio32(vi->vdev, VIRTIO_NET_BPF_CMD_CREATE_MAP);
+
+	sg_init_one(&sg, ctrl, sizeof(*ctrl) + ctrl->buf_len);
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_EBPF,
+				  VIRTIO_NET_CTRL_EBPF_MAP,
+				  &sg)) {
+		dev_warn(&vi->vdev->dev, "Failed to create ebpf map\n");
+		goto err;
+	}
+
+	offmap->dev_ops = &virtnet_bpf_map_ops;
+	offmap->dev_priv = virtnet_map;
+
+	virtnet_map->offmap = offmap;
+	virtnet_map->vi = vi;
+	virtnet_map->ctrl = ctrl;
+
+	list_add_tail(&virtnet_map->list, &vi->map_list);
+
+	return 0;
+err:
+	kfree(virtnet_map);
+	kfree(ctrl);
+	return -EFAULT;
+}
+
+static int virtnet_bpf_map_free(struct virtnet_info *vi,
+				struct bpf_offloaded_map *offmap)
+{
+	struct bpf_map *map = &offmap->map;
+	struct virtnet_bpf_map *virtnet_map = virtnet_get_bpf_map(vi, map);
+	struct virtio_net_ctrl_ebpf_map *ctrl = virtnet_map->ctrl;
+	struct scatterlist sg;
+
+	if (!virtnet_map)
+		return -EINVAL;
+
+	ctrl->cmd = cpu_to_virtio32(vi->vdev, VIRTIO_NET_BPF_CMD_FREE_MAP);
+
+	sg_init_one(&sg, ctrl, sizeof(*ctrl) + ctrl->buf_len);
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_EBPF,
+				  VIRTIO_NET_CTRL_EBPF_MAP,
+				  &sg)) {
+		dev_warn(&vi->vdev->dev, "Failed to free ebpf map\n");
+		return -EFAULT;
+	}
+
+	list_del(&virtnet_map->list);
+	kfree(virtnet_map->ctrl);
+	kfree(virtnet_map);
+	return 0;
+}
+
 static int virtnet_bpf_verifier_setup(struct bpf_prog *prog)
 {
 	struct virtnet_info *vi = netdev_priv(prog->aux->offload->netdev);
 	size_t insn_len = prog->len * sizeof(struct bpf_insn);
 	struct virtnet_bpf_bound_prog *state;
+	struct virtnet_bpf_map *virtnet_map;
+	struct bpf_map *map;
+	struct fd mapfd;
+	int i, err = 0;
 
 	state = kzalloc(sizeof(*state) + insn_len, GFP_KERNEL);
 	if (!state)
@@ -2639,11 +2843,43 @@ static int virtnet_bpf_verifier_setup(struct bpf_prog *prog)
 	state->prog = prog;
 	state->len = prog->len;
 
+	for (i = 0; i < state->len; i++) {
+		struct bpf_insn *insn = &state->insnsi[i];
+
+		if (insn->code != (BPF_LD | BPF_IMM | BPF_DW))
+			continue;
+
+		mapfd = fdget(insn->imm);
+		map = __bpf_map_get(mapfd);
+		if (IS_ERR(map)) {
+			pr_warn("fd %d is not pointing to valid bpf_map\n",
+				insn->imm);
+			err = -EINVAL;
+			goto err_replace;
+		}
+
+		virtnet_map = virtnet_get_bpf_map(vi, map);
+		if (!virtnet_map) {
+			pr_warn("could not get a offloaded map fd %d\n",
+				insn->imm);
+			err = -EINVAL;
+			goto err_replace;
+		}
+
+		/* Note: no need of virtio32_to_cpu */
+		insn->imm = virtnet_map->ctrl->map_fd;
+		fdput(mapfd);
+	}
+
 	list_add_tail(&state->list, &vi->bpf_bound_progs);
 
 	prog->aux->offload->dev_priv = state;
 
 	return 0;
+
+err_replace:
+	kfree(state);
+	return err;
 }
 
 static int virtnet_bpf_verifier_prep(struct bpf_prog *prog)
@@ -2676,6 +2912,10 @@ static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	int err;
 
 	switch (xdp->command) {
+	case BPF_OFFLOAD_MAP_ALLOC:
+		return virtnet_bpf_map_alloc(vi, xdp->offmap);
+	case BPF_OFFLOAD_MAP_FREE:
+		return virtnet_bpf_map_free(vi, xdp->offmap);
 	case XDP_SETUP_PROG:
 		return virtnet_xdp_set(dev, xdp);
 	case XDP_QUERY_PROG:
@@ -2747,6 +2987,7 @@ static int virtnet_bpf_init(struct virtnet_info *vi)
 		goto err_netdev_register;
 
 	INIT_LIST_HEAD(&vi->bpf_bound_progs);
+	INIT_LIST_HEAD(&vi->map_list);
 
 	return 0;
 
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 0ea2f7910a5a..1d330a0883ac 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -281,11 +281,34 @@ struct virtio_net_ctrl_ebpf_prog {
 	__u8 insns[0];
 };
 
+struct virtio_net_ctrl_ebpf_map {
+	__virtio32 buf_len;
+	__virtio32 cmd;
+	__virtio32 map_type;
+	__virtio32 key_size;
+	__virtio32 value_size;
+	__virtio32 max_entries;
+	__virtio32 map_flags;
+	__virtio32 map_fd;
+	__virtio64 flags;
+	__u8 buf[0];
+};
+
 #define VIRTIO_NET_CTRL_EBPF 6
  #define VIRTIO_NET_CTRL_EBPF_PROG 1
+ #define VIRTIO_NET_CTRL_EBPF_MAP 2
 
 /* Commands for VIRTIO_NET_CTRL_EBPF_PROG */
 #define VIRTIO_NET_BPF_CMD_SET_OFFLOAD 1
 #define VIRTIO_NET_BPF_CMD_UNSET_OFFLOAD 2
 
+/* Commands for VIRTIO_NET_CTRL_EBPF_MAP */
+#define VIRTIO_NET_BPF_CMD_CREATE_MAP 1
+#define VIRTIO_NET_BPF_CMD_FREE_MAP 2
+#define VIRTIO_NET_BPF_CMD_UPDATE_ELEM 3
+#define VIRTIO_NET_BPF_CMD_LOOKUP_ELEM 4
+#define VIRTIO_NET_BPF_CMD_DELETE_ELEM 5
+#define VIRTIO_NET_BPF_CMD_GET_FIRST 6
+#define VIRTIO_NET_BPF_CMD_GET_NEXT 7
+
 #endif /* _UAPI_LINUX_VIRTIO_NET_H */
-- 
2.20.1

