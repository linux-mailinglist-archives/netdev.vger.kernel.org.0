Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370228B811
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfHMMH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:59 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:39315 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHMMH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:58 -0400
Received: by mail-pf1-f170.google.com with SMTP id f17so47506987pfn.6;
        Tue, 13 Aug 2019 05:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kX9zyB70W2FSoQFqbjQbosXPW34+UsdRCkbTPZUG+Y=;
        b=j5uwJuKs0Or8iyIvNCoQGRgkS3CRUVlLAp24x9+JupBlSVMRkGXq9L1X3mDNBvLCq/
         8Se8MEMT9PIamCdXf1G1nUyvduf/sJGwok7cLbErm6wOBgaOc6tg/EgYbdWv/7tWsYYm
         mWuss3vUUdEYZTUEO82frHqqzQ6vH6HXq1xBkkzMpUiEG2wFmmPwJZaBZ/FvZC4/IK4W
         yvSZFDLTplHBb8nuk69tpwL0/sTZrUOVc8HCCwzdaAEZZfn92cBUpd4TKcClSFBBOV3K
         mWZObYO47Z+TNs6XyTkK6NKY9YMcp32Glb3/EWcNROG13msYoRrczZ0LePHA32RLpcip
         GI0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kX9zyB70W2FSoQFqbjQbosXPW34+UsdRCkbTPZUG+Y=;
        b=RyF8nVcT3LJwiGLcu4GxgvsmEIEzNkOTSVTtX8sxduqMRTcDLF2FnkLVstZvbkN0q3
         WqZWwhx0g15odNNgJuPceb6FqqY0+hE9KxmphKG564xYBFzwm/vdeSTxOK7NWFygLluV
         bPLFN6T6rpLAIV7tPujuZbLQZTvp71wWndAuebwMtQkNaaUnnQ1N4iGLIeXiKPyHxDD9
         nKNo2F7I38Tf/AVd/EXAJHeUfVlakXJLEBRDmWQG/UuSAGzJgIdbsBWqy9TWm6zgXk7k
         dUug8k/GibHjbr2fJrZrTge42guU+WORlYrA2kTD0l1Xv9ACxknmaGsogmB73w/Cyan3
         oXHQ==
X-Gm-Message-State: APjAAAWQWu0ebvKSQDofHFUeeMQeBy1ABBKYW1DsTASn+9EmdKui3yGm
        M0bwYqNZw10Qk2NfxEUuzH8=
X-Google-Smtp-Source: APXvYqyFkW0YBv8JwjRSU5NgoWrFIwS3jgAMcAWIvx5WDH8c0WkVK09rO2JSPeDr65K21JNLr0G+/Q==
X-Received: by 2002:aa7:9ab8:: with SMTP id x24mr7167121pfi.98.1565698077763;
        Tue, 13 Aug 2019 05:07:57 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:57 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 10/14] xdp_flow: Implement redirect action
Date:   Tue, 13 Aug 2019 21:05:54 +0900
Message-Id: <20190813120558.6151-11-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a devmap for XDP_REDIRECT and use it for redirect action.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/umh_bpf.h           |   1 +
 net/xdp_flow/xdp_flow_kern_bpf.c |  14 +++-
 net/xdp_flow/xdp_flow_kern_mod.c |   3 +
 net/xdp_flow/xdp_flow_umh.c      | 164 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 175 insertions(+), 7 deletions(-)

diff --git a/net/xdp_flow/umh_bpf.h b/net/xdp_flow/umh_bpf.h
index 4e4633f..a279d0a1 100644
--- a/net/xdp_flow/umh_bpf.h
+++ b/net/xdp_flow/umh_bpf.h
@@ -4,6 +4,7 @@
 
 #include "msgfmt.h"
 
+#define MAX_PORTS 65536
 #define MAX_FLOWS 1024
 #define MAX_FLOW_MASKS 255
 #define FLOW_MASKS_TAIL 255
diff --git a/net/xdp_flow/xdp_flow_kern_bpf.c b/net/xdp_flow/xdp_flow_kern_bpf.c
index ceb8a92..8f3d359 100644
--- a/net/xdp_flow/xdp_flow_kern_bpf.c
+++ b/net/xdp_flow/xdp_flow_kern_bpf.c
@@ -22,6 +22,13 @@ struct bpf_map_def SEC("maps") debug_stats = {
 	.max_entries = 256,
 };
 
+struct bpf_map_def SEC("maps") output_map = {
+	.type = BPF_MAP_TYPE_DEVMAP,
+	.key_size = sizeof(int),
+	.value_size = sizeof(int),
+	.max_entries = MAX_PORTS,
+};
+
 struct bpf_map_def SEC("maps") flow_masks_head = {
 	.type = BPF_MAP_TYPE_ARRAY,
 	.key_size = sizeof(u32),
@@ -71,10 +78,13 @@ static inline int action_drop(void)
 
 static inline int action_redirect(struct xdp_flow_action *action)
 {
+	int tx_port;
+
 	account_action(XDP_FLOW_ACTION_REDIRECT);
 
-	// TODO: implement this
-	return XDP_ABORTED;
+	tx_port = action->ifindex;
+
+	return bpf_redirect_map(&output_map, tx_port, 0);
 }
 
 static inline int action_vlan_push(struct xdp_md *ctx,
diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
index 891b18c..caa4968 100644
--- a/net/xdp_flow/xdp_flow_kern_mod.c
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -51,6 +51,9 @@ static int xdp_flow_parse_actions(struct xdp_flow_actions *actions,
 			action->id = XDP_FLOW_ACTION_DROP;
 			break;
 		case FLOW_ACTION_REDIRECT:
+			action->id = XDP_FLOW_ACTION_REDIRECT;
+			action->ifindex = act->dev->ifindex;
+			break;
 		case FLOW_ACTION_VLAN_PUSH:
 		case FLOW_ACTION_VLAN_POP:
 		case FLOW_ACTION_VLAN_MANGLE:
diff --git a/net/xdp_flow/xdp_flow_umh.c b/net/xdp_flow/xdp_flow_umh.c
index 9a4769b..cbb766a 100644
--- a/net/xdp_flow/xdp_flow_umh.c
+++ b/net/xdp_flow/xdp_flow_umh.c
@@ -18,6 +18,7 @@
 extern char xdp_flow_bpf_start;
 extern char xdp_flow_bpf_end;
 int progfile_fd;
+int output_map_fd;
 
 #define zalloc(size) calloc(1, (size))
 
@@ -40,12 +41,22 @@ struct netdev_info {
 	struct netdev_info_key key;
 	struct hlist_node node;
 	struct bpf_object *obj;
+	int devmap_idx;
 	int free_slot_top;
 	int free_slots[MAX_FLOW_MASKS];
 };
 
 DEFINE_HASHTABLE(netdev_info_table, 16);
 
+struct devmap_idx_node {
+	int devmap_idx;
+	struct hlist_node node;
+};
+
+DEFINE_HASHTABLE(devmap_idx_table, 16);
+
+int max_devmap_idx;
+
 static int libbpf_err(int err, char *errbuf)
 {
 	libbpf_strerror(err, errbuf, ERRBUF_SIZE);
@@ -90,6 +101,15 @@ static int setup(void)
 		goto err;
 	}
 
+	output_map_fd = bpf_create_map(BPF_MAP_TYPE_DEVMAP, sizeof(int),
+				       sizeof(int), MAX_PORTS, 0);
+	if (output_map_fd < 0) {
+		err = -errno;
+		pr_err("map creation for output_map failed: %s\n",
+		       strerror(errno));
+		goto err;
+	}
+
 	return 0;
 err:
 	close(progfile_fd);
@@ -97,10 +117,23 @@ static int setup(void)
 	return err;
 }
 
-static int load_bpf(int ifindex, struct bpf_object **objp)
+static void delete_output_map_elem(int idx)
+{
+	char errbuf[ERRBUF_SIZE];
+	int err;
+
+	err = bpf_map_delete_elem(output_map_fd, &idx);
+	if (err) {
+		libbpf_err(err, errbuf);
+		pr_warn("Failed to delete idx %d from output_map: %s\n",
+			idx, errbuf);
+	}
+}
+
+static int load_bpf(int ifindex, int devmap_idx, struct bpf_object **objp)
 {
 	int prog_fd, flow_tables_fd, flow_meta_fd, flow_masks_head_fd, err;
-	struct bpf_map *flow_tables, *flow_masks_head;
+	struct bpf_map *output_map, *flow_tables, *flow_masks_head;
 	int zero = 0, flow_masks_tail = FLOW_MASKS_TAIL;
 	struct bpf_object_open_attr attr = {};
 	char path[256], errbuf[ERRBUF_SIZE];
@@ -133,6 +166,27 @@ static int load_bpf(int ifindex, struct bpf_object **objp)
 	bpf_object__for_each_program(prog, obj)
 		bpf_program__set_type(prog, attr.prog_type);
 
+	output_map = bpf_object__find_map_by_name(obj, "output_map");
+	if (!output_map) {
+		pr_err("Cannot find output_map\n");
+		err = -ENOENT;
+		goto err_obj;
+	}
+
+	err = bpf_map__reuse_fd(output_map, output_map_fd);
+	if (err) {
+		err = libbpf_err(err, errbuf);
+		pr_err("Failed to reuse output_map fd: %s\n", errbuf);
+		goto err_obj;
+	}
+
+	if (bpf_map_update_elem(output_map_fd, &devmap_idx, &ifindex, 0)) {
+		err = -errno;
+		pr_err("Failed to insert idx %d if %d into output_map: %s\n",
+		       devmap_idx, ifindex, strerror(errno));
+		goto err_obj;
+	}
+
 	flow_meta_fd = bpf_create_map(BPF_MAP_TYPE_HASH,
 				      sizeof(struct xdp_flow_key),
 				      sizeof(struct xdp_flow_actions),
@@ -222,6 +276,8 @@ static int load_bpf(int ifindex, struct bpf_object **objp)
 
 	return prog_fd;
 err:
+	delete_output_map_elem(devmap_idx);
+err_obj:
 	bpf_object__close(obj);
 	return err;
 }
@@ -272,6 +328,56 @@ static struct netdev_info *get_netdev_info(const struct mbox_request *req)
 	return netdev_info;
 }
 
+static struct devmap_idx_node *find_devmap_idx(int devmap_idx)
+{
+	struct devmap_idx_node *node;
+
+	hash_for_each_possible(devmap_idx_table, node, node, devmap_idx) {
+		if (node->devmap_idx == devmap_idx)
+			return node;
+	}
+
+	return NULL;
+}
+
+static int get_new_devmap_idx(void)
+{
+	int offset;
+
+	for (offset = 0; offset < MAX_PORTS; offset++) {
+		int devmap_idx = max_devmap_idx++;
+
+		if (max_devmap_idx >= MAX_PORTS)
+			max_devmap_idx -= MAX_PORTS;
+
+		if (!find_devmap_idx(devmap_idx)) {
+			struct devmap_idx_node *node;
+
+			node = malloc(sizeof(*node));
+			if (!node) {
+				pr_err("malloc for devmap_idx failed\n");
+				return -ENOMEM;
+			}
+			node->devmap_idx = devmap_idx;
+			hash_add(devmap_idx_table, &node->node, devmap_idx);
+
+			return devmap_idx;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+static void delete_devmap_idx(int devmap_idx)
+{
+	struct devmap_idx_node *node = find_devmap_idx(devmap_idx);
+
+	if (node) {
+		hash_del(&node->node);
+		free(node);
+	}
+}
+
 static void init_flow_masks_free_slot(struct netdev_info *netdev_info)
 {
 	int i;
@@ -325,11 +431,11 @@ static void delete_flow_masks_free_slot(struct netdev_info *netdev_info,
 
 static int handle_load(const struct mbox_request *req, __u32 *prog_id)
 {
+	int err, prog_fd, devmap_idx = -1;
 	struct netdev_info *netdev_info;
 	struct bpf_prog_info info = {};
 	struct netdev_info_key key;
 	__u32 len = sizeof(info);
-	int err, prog_fd;
 
 	err = get_netdev_info_key(req, &key);
 	if (err)
@@ -346,12 +452,19 @@ static int handle_load(const struct mbox_request *req, __u32 *prog_id)
 	}
 	netdev_info->key.ifindex = key.ifindex;
 
+	devmap_idx = get_new_devmap_idx();
+	if (devmap_idx < 0) {
+		err = devmap_idx;
+		goto err_netdev_info;
+	}
+	netdev_info->devmap_idx = devmap_idx;
+
 	init_flow_masks_free_slot(netdev_info);
 
-	prog_fd = load_bpf(req->ifindex, &netdev_info->obj);
+	prog_fd = load_bpf(req->ifindex, devmap_idx, &netdev_info->obj);
 	if (prog_fd < 0) {
 		err = prog_fd;
-		goto err_netdev_info;
+		goto err_devmap_idx;
 	}
 
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &len);
@@ -366,6 +479,8 @@ static int handle_load(const struct mbox_request *req, __u32 *prog_id)
 	return 0;
 err_obj:
 	bpf_object__close(netdev_info->obj);
+err_devmap_idx:
+	delete_devmap_idx(devmap_idx);
 err_netdev_info:
 	free(netdev_info);
 
@@ -382,12 +497,45 @@ static int handle_unload(const struct mbox_request *req)
 
 	hash_del(&netdev_info->node);
 	bpf_object__close(netdev_info->obj);
+	delete_output_map_elem(netdev_info->devmap_idx);
+	delete_devmap_idx(netdev_info->devmap_idx);
 	free(netdev_info);
 	pr_debug("XDP program for if %d was closed\n", req->ifindex);
 
 	return 0;
 }
 
+static int convert_ifindex_to_devmap_idx(struct mbox_request *req)
+{
+	int i;
+
+	for (i = 0; i < req->flow.actions.num_actions; i++) {
+		struct xdp_flow_action *action = &req->flow.actions.actions[i];
+
+		if (action->id == XDP_FLOW_ACTION_REDIRECT) {
+			struct netdev_info *netdev_info;
+			struct netdev_info_key key;
+			int err;
+
+			err = get_netdev_info_key(req, &key);
+			if (err)
+				return err;
+			key.ifindex = action->ifindex;
+
+			netdev_info = find_netdev_info(&key);
+			if (!netdev_info) {
+				pr_err("Cannot redirect to ifindex %d. Please setup xdp_flow on ifindex %d in advance.\n",
+				       key.ifindex, key.ifindex);
+				return -ENOENT;
+			}
+
+			action->ifindex = netdev_info->devmap_idx;
+		}
+	}
+
+	return 0;
+}
+
 static int get_table_fd(const struct netdev_info *netdev_info,
 			const char *table_name)
 {
@@ -784,6 +932,11 @@ static int handle_replace(struct mbox_request *req)
 	if (IS_ERR(netdev_info))
 		return PTR_ERR(netdev_info);
 
+	/* TODO: Use XDP_TX for redirect action when possible */
+	err = convert_ifindex_to_devmap_idx(req);
+	if (err)
+		return err;
+
 	err = flow_table_insert_elem(netdev_info, &req->flow);
 	if (err)
 		return err;
@@ -875,6 +1028,7 @@ int main(void)
 		return -1;
 	loop();
 	close(progfile_fd);
+	close(output_map_fd);
 
 	return 0;
 }
-- 
1.8.3.1

