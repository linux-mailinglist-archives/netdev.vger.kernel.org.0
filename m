Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469E02FEB21
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbhAUNHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731699AbhAUNHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:07:38 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1E0C061757;
        Thu, 21 Jan 2021 05:06:57 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id e9so1271555plh.3;
        Thu, 21 Jan 2021 05:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2QTdNpLm5R6YeiRFmf9bmhVF/qNNKjt7x7a1oorq3/U=;
        b=M8TrvneaxLIfxLXAykFA/qfTWaPhjPR0hp7zKyhJ4l8HzPP9i/My/GIorTDOdUCgRO
         /GorYEQocaID5ksOf1gs5AiymFnv3+qGQ4GWbcSD68sAFRvGp54AgPKLfpg3u0ERNrUr
         LdGRSZSZyZiu4veRgAJ45uj9PBkj0q7f7sEOkHWUViJX7Hxvw977nUb0hFM7mCyvFz0w
         B2ejyM4KFO8QI9tjfo0IcviDZ9D5jy+ufy4L62OxQU7vaUg2gb6Htq/N6eni1EmBAZ+M
         KDDoK073M5RyHHp09+t9tWuZWs7YgXs5N9VDzjz9fChoMOutsL4tGFJl72tYPu98mWbj
         qvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2QTdNpLm5R6YeiRFmf9bmhVF/qNNKjt7x7a1oorq3/U=;
        b=kMYfQwamJfEYUkV71hlTqqESdLoaRenA2UqPr0LgLabkISqNj9FqZbXYKE9KrvJaas
         hFffSmaG4foTMAUF+F/1BAGLjWeVOeFG1/wO+UuHwSx03RZsBb8wpNWnNbq77uzcm5T2
         k6az182rnaMQuaDIBzi3T323LDQoI6V8OIIyQBZUBNqkdiOb7XinIla/lN0mPEqDQlvd
         N5txvk3QH8W+UgHDlzhOLJeLg0bgN2oiO4TTZjt1uaDkFylH7wMw6Ife1gGEHnwuUcv4
         OpH/SgxhI84QGHzH1rB6KNTZZJ2G1wF3+fa/mVwIEXuKMoaXnQEvaTJO9wIeLDB2a4Ni
         UmLg==
X-Gm-Message-State: AOAM5304XIFjgqHAzPpp2D3Phcn9khRvXOFS9uiyaYMJfIGFhH1rOa4L
        Vf/nmM3icYuhcTF4gzB6rpIGtmQA4GYPM6cY
X-Google-Smtp-Source: ABdhPJyPfHLYOqNGAJ7IAmT/CyNvkXmkebFV5kNcJX9sYPoMJp/Di7izaASE6v+MhBIW+Ze4BatRqA==
X-Received: by 2002:a17:902:9f87:b029:de:9e09:ee94 with SMTP id g7-20020a1709029f87b02900de9e09ee94mr15008179plq.29.1611234417093;
        Thu, 21 Jan 2021 05:06:57 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d16sm5603667pfn.160.2021.01.21.05.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 05:06:56 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv9 bpf-next] samples/bpf: add xdp program on egress for xdp_redirect_map
Date:   Thu, 21 Jan 2021 21:06:42 +0800
Message-Id: <20210121130642.2943811-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119031207.2813215-1-liuhangbin@gmail.com>
References: <20210119031207.2813215-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a xdp program on egress to show that we can modify
the packet on egress. In this sample we will set the pkt's src
mac to egress's mac address. The xdp_prog will be attached when
-X option supplied.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v9:
roll back to just set src mac to egress interface mac on 2nd xdp prog,
this could avoid packet reorder introduce in patch v6.

v8: Fix some checkpatch issues.

v7:
a) use bpf_object__find_program_by_name() instad of
   bpf_object__find_program_by_title()
b) set default devmap fd to 0

v6: no code update, only rebase the code on latest bpf-next

v5:
a) close fd when err out in get_mac_addr()
b) exit program when both -S and -X supplied.

v4:
a) Update get_mac_addr socket create
b) Load dummy prog regardless of 2nd xdp prog on egress

v3:
a) modify the src mac address based on egress mac

v2:
a) use pkt counter instead of IP ttl modification on egress program
b) make the egress program selectable by option -X
---
 samples/bpf/xdp_redirect_map_kern.c |  60 +++++++++++++--
 samples/bpf/xdp_redirect_map_user.c | 112 +++++++++++++++++++++++-----
 2 files changed, 147 insertions(+), 25 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
index 6489352ab7a4..35ce5e26bbe5 100644
--- a/samples/bpf/xdp_redirect_map_kern.c
+++ b/samples/bpf/xdp_redirect_map_kern.c
@@ -19,12 +19,22 @@
 #include <linux/ipv6.h>
 #include <bpf/bpf_helpers.h>
 
+/* The 2nd xdp prog on egress does not support skb mode, so we define two
+ * maps, tx_port_general and tx_port_native.
+ */
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
 	__uint(key_size, sizeof(int));
 	__uint(value_size, sizeof(int));
 	__uint(max_entries, 100);
-} tx_port SEC(".maps");
+} tx_port_general SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__uint(max_entries, 100);
+} tx_port_native SEC(".maps");
 
 /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
  * feedback.  Redirect TX errors can be caught via a tracepoint.
@@ -36,6 +46,14 @@ struct {
 	__uint(max_entries, 1);
 } rxcnt SEC(".maps");
 
+/* map to store egress interface mac address */
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, __be64);
+	__uint(max_entries, 1);
+} tx_mac SEC(".maps");
+
 static void swap_src_dst_mac(void *data)
 {
 	unsigned short *p = data;
@@ -52,17 +70,16 @@ static void swap_src_dst_mac(void *data)
 	p[5] = dst[2];
 }
 
-SEC("xdp_redirect_map")
-int xdp_redirect_map_prog(struct xdp_md *ctx)
+static int xdp_redirect_map(struct xdp_md *ctx, void *redirect_map)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data = (void *)(long)ctx->data;
 	struct ethhdr *eth = data;
 	int rc = XDP_DROP;
-	int vport, port = 0, m = 0;
 	long *value;
 	u32 key = 0;
 	u64 nh_off;
+	int vport;
 
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
@@ -79,7 +96,40 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
 	swap_src_dst_mac(data);
 
 	/* send packet out physical port */
-	return bpf_redirect_map(&tx_port, vport, 0);
+	return bpf_redirect_map(redirect_map, vport, 0);
+}
+
+SEC("xdp_redirect_general")
+int xdp_redirect_map_general(struct xdp_md *ctx)
+{
+	return xdp_redirect_map(ctx, &tx_port_general);
+}
+
+SEC("xdp_redirect_native")
+int xdp_redirect_map_native(struct xdp_md *ctx)
+{
+	return xdp_redirect_map(ctx, &tx_port_native);
+}
+
+SEC("xdp_devmap/map_prog")
+int xdp_redirect_map_egress(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	__be64 *mac;
+	u32 key = 0;
+	u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	mac = bpf_map_lookup_elem(&tx_mac, &key);
+	if (mac)
+		__builtin_memcpy(eth->h_source, mac, ETH_ALEN);
+
+	return XDP_PASS;
 }
 
 /* Redirect require an XDP bpf_prog loaded on the TX device */
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 31131b6e7782..0e8192688dfc 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -14,6 +14,10 @@
 #include <unistd.h>
 #include <libgen.h>
 #include <sys/resource.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
 
 #include "bpf_util.h"
 #include <bpf/bpf.h>
@@ -22,6 +26,7 @@
 static int ifindex_in;
 static int ifindex_out;
 static bool ifindex_out_xdp_dummy_attached = true;
+static bool xdp_devmap_attached;
 static __u32 prog_id;
 static __u32 dummy_prog_id;
 
@@ -83,6 +88,32 @@ static void poll_stats(int interval, int ifindex)
 	}
 }
 
+static int get_mac_addr(unsigned int ifindex_out, void *mac_addr)
+{
+	char ifname[IF_NAMESIZE];
+	struct ifreq ifr;
+	int fd, ret = -1;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (fd < 0)
+		return ret;
+
+	if (!if_indextoname(ifindex_out, ifname))
+		goto err_out;
+
+	strcpy(ifr.ifr_name, ifname);
+
+	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
+		goto err_out;
+
+	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
+	ret = 0;
+
+err_out:
+	close(fd);
+	return ret;
+}
+
 static void usage(const char *prog)
 {
 	fprintf(stderr,
@@ -90,24 +121,26 @@ static void usage(const char *prog)
 		"OPTS:\n"
 		"    -S    use skb-mode\n"
 		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -X    load xdp program on egress\n",
 		prog);
 }
 
 int main(int argc, char **argv)
 {
 	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type	= BPF_PROG_TYPE_XDP,
+		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
-	struct bpf_program *prog, *dummy_prog;
+	struct bpf_program *prog, *dummy_prog, *devmap_prog;
+	int prog_fd, dummy_prog_fd, devmap_prog_fd = 0;
+	int tx_port_map_fd, tx_mac_map_fd;
+	struct bpf_devmap_val devmap_val;
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
-	int prog_fd, dummy_prog_fd;
-	const char *optstr = "FSN";
+	const char *optstr = "FSNX";
 	struct bpf_object *obj;
 	int ret, opt, key = 0;
 	char filename[256];
-	int tx_port_map_fd;
 
 	while ((opt = getopt(argc, argv, optstr)) != -1) {
 		switch (opt) {
@@ -120,14 +153,21 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'X':
+			xdp_devmap_attached = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
 		}
 	}
 
-	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE)) {
 		xdp_flags |= XDP_FLAGS_DRV_MODE;
+	} else if (xdp_devmap_attached) {
+		printf("Load xdp program on egress with SKB mode not supported yet\n");
+		return 1;
+	}
 
 	if (optind == argc) {
 		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
@@ -150,24 +190,28 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
 
-	prog = bpf_program__next(NULL, obj);
-	dummy_prog = bpf_program__next(prog, obj);
-	if (!prog || !dummy_prog) {
-		printf("finding a prog in obj file failed\n");
-		return 1;
+	if (xdp_flags & XDP_FLAGS_SKB_MODE) {
+		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_general");
+		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_general");
+	} else {
+		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_native");
+		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_native");
+	}
+	dummy_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_dummy_prog");
+	if (!prog || dummy_prog < 0 || tx_port_map_fd < 0) {
+		printf("finding prog/dummy_prog/tx_port_map in obj file failed\n");
+		goto out;
 	}
-	/* bpf_prog_load_xattr gives us the pointer to first prog's fd,
-	 * so we're missing only the fd for dummy prog
-	 */
+	prog_fd = bpf_program__fd(prog);
 	dummy_prog_fd = bpf_program__fd(dummy_prog);
-	if (prog_fd < 0 || dummy_prog_fd < 0) {
+	if (prog_fd < 0 || dummy_prog_fd < 0 || tx_port_map_fd < 0) {
 		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
 		return 1;
 	}
 
-	tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port");
+	tx_mac_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_mac");
 	rxcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
-	if (tx_port_map_fd < 0 || rxcnt_map_fd < 0) {
+	if (tx_mac_map_fd < 0 || rxcnt_map_fd < 0) {
 		printf("bpf_object__find_map_fd_by_name failed\n");
 		return 1;
 	}
@@ -199,11 +243,39 @@ int main(int argc, char **argv)
 	}
 	dummy_prog_id = info.id;
 
+	/* Load 2nd xdp prog on egress. */
+	if (xdp_devmap_attached) {
+		unsigned char mac_addr[6];
+
+		devmap_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_egress");
+		if (!devmap_prog) {
+			printf("finding devmap_prog in obj file failed\n");
+			goto out;
+		}
+		devmap_prog_fd = bpf_program__fd(devmap_prog);
+		if (devmap_prog_fd < 0) {
+			printf("finding devmap_prog fd failed\n");
+			goto out;
+		}
+
+		if (get_mac_addr(ifindex_out, mac_addr) < 0) {
+			printf("get interface %d mac failed\n", ifindex_out);
+			goto out;
+		}
+
+		ret = bpf_map_update_elem(tx_mac_map_fd, &key, mac_addr, 0);
+		if (ret) {
+			perror("bpf_update_elem tx_mac_map_fd");
+			goto out;
+		}
+	}
+
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	/* populate virtual to physical port map */
-	ret = bpf_map_update_elem(tx_port_map_fd, &key, &ifindex_out, 0);
+	devmap_val.ifindex = ifindex_out;
+	devmap_val.bpf_prog.fd = devmap_prog_fd;
+	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
 	if (ret) {
 		perror("bpf_update_elem");
 		goto out;
-- 
2.26.2

