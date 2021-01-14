Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952E82F631C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbhANO2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbhANO23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:28:29 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A483C0613CF;
        Thu, 14 Jan 2021 06:27:49 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id r4so2962241pls.11;
        Thu, 14 Jan 2021 06:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3tjg1sCd9HYmDi86Tv1DwDq1PcJ3N28HEi6QsYGm5U0=;
        b=ly7xUCIxdMBsZsn9oP9g4wOHOgqP5MCuqAVy2eWlhQgY7aT0coyGcgmQrW8L9rlzB1
         kuhu7LPiL9jZ6CLzLFJiGCAQJ8LJq30724UOdhXJxHc7wVZWoI7jVsn1ZDDKoTmlcsoq
         oYerc3xxv5U5fmfussc792y1as8tmCWX8heOqwXsLQgBRv3Vmi7tx5OUKndePxabWWuS
         a+9qNdrGI+215e65Tjg8d1RhgeTfFFoWP9EzFstvXNlv4MGGPUSv0A5Sw33RnPM18+eC
         up2y+WodxwWrCVb197hc7xq5e56J0DGA2GnmTCGjL53rdRI3UXyNpg6qXRLiXq2qOn7p
         oz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3tjg1sCd9HYmDi86Tv1DwDq1PcJ3N28HEi6QsYGm5U0=;
        b=VuvtKv0f7JdVQGE3soh1ayB5XVEz0VAf0tNr/lsGoRPocrW2L5a2GDe2p8f7PCJ1/s
         DfgQ0W3gvv9NPmFndf8obAKvI6ISzKZHic47TZxC1e3krHFVbGDOb9B4sCu2oV01t+p7
         UZyrS9IvPoJzgxp8FF4KtthkIa1843f/PImigqcJT565f6lTtRq0nWSvk9zxO5JXCU4y
         QEfyROnrXL2q1U1SKlahovMl1QyPBC/6bThprPGNeyjCeiw01oAkLAoLlKMNKGvMT0w/
         RsfcwZDh9ko+NTuCPjdCJo3lhe0Cyly+FifOapI8Mgw7atZS6PqXPNu3x8nnJc7pk29p
         cIww==
X-Gm-Message-State: AOAM532QfEFKLHvWl4CH++AfJRitOvrHr8gYO5D4usO51TcRX+36L/Em
        C9yGRbHJiSkCv3AFwwiJskjSvgmbCYLOS6LM
X-Google-Smtp-Source: ABdhPJxkQccP84q1LMmrKZBZF3H/eyQpAYZBsRr8a5lrHwUSeAqylxjmTT9i/hub1XvHqtLqvOzOyg==
X-Received: by 2002:a17:902:523:b029:dc:1aa4:28e7 with SMTP id 32-20020a1709020523b02900dc1aa428e7mr7846931plf.4.1610634468859;
        Thu, 14 Jan 2021 06:27:48 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b188sm1682435pfg.68.2021.01.14.06.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:27:48 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv6 bpf-next] samples/bpf: add xdp program on egress for xdp_redirect_map
Date:   Thu, 14 Jan 2021 22:27:32 +0800
Message-Id: <20210114142732.2595651-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201211024049.1444017-1-liuhangbin@gmail.com>
References: <20201211024049.1444017-1-liuhangbin@gmail.com>
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
 samples/bpf/xdp_redirect_map_kern.c |  75 ++++++++++++++--
 samples/bpf/xdp_redirect_map_user.c | 135 +++++++++++++++++++++++-----
 2 files changed, 184 insertions(+), 26 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
index 6489352ab7a4..8b8e73d25ad6 100644
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
 
+/* map to stroe egress interface mac address */
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
@@ -73,13 +90,59 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
 
 	/* count packet in global counter */
 	value = bpf_map_lookup_elem(&rxcnt, &key);
-	if (value)
+	if (value) {
 		*value += 1;
+		if (*value % 2 == 1)
+			vport = 1;
+	}
 
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
+static int xdp_redirect_map_egress(struct xdp_md *ctx, unsigned char *mac)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	u32 key = 0;
+	u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	__builtin_memcpy(eth->h_source, mac, ETH_ALEN);
+
+	return XDP_PASS;
+}
+
+SEC("xdp_devmap/map_prog_0")
+int xdp_redirect_map_egress_0(struct xdp_md *ctx)
+{
+	unsigned char mac[6] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x1};
+	return xdp_redirect_map_egress(ctx, mac);
+}
+
+SEC("xdp_devmap/map_prog_1")
+int xdp_redirect_map_egress_1(struct xdp_md *ctx)
+{
+	unsigned char mac[6] = {0x0, 0x0, 0x0, 0x0, 0x1, 0x1};
+	return xdp_redirect_map_egress(ctx, mac);
 }
 
 /* Redirect require an XDP bpf_prog loaded on the TX device */
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 31131b6e7782..9a778f7c45ff 100644
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
+static bool xdp_devmap_attached = false;
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
@@ -90,24 +121,27 @@ static void usage(const char *prog)
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
+	int devmap_prog_fd_0 = -1, devmap_prog_fd_1 = -1;
+	int prog_fd, dummy_prog_fd;
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
@@ -120,14 +154,21 @@ int main(int argc, char **argv)
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
@@ -150,24 +191,28 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
 
-	prog = bpf_program__next(NULL, obj);
-	dummy_prog = bpf_program__next(prog, obj);
-	if (!prog || !dummy_prog) {
-		printf("finding a prog in obj file failed\n");
-		return 1;
+	if (xdp_flags & XDP_FLAGS_SKB_MODE) {
+		prog = bpf_object__find_program_by_title(obj, "xdp_redirect_general");
+		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_general");
+	} else {
+		prog = bpf_object__find_program_by_title(obj, "xdp_redirect_native");
+		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_native");
+	}
+	dummy_prog = bpf_object__find_program_by_title(obj, "xdp_redirect_dummy");
+	if (!prog || dummy_prog < 0 || tx_port_map_fd < 0) {
+		printf("finding prog/tx_port_map in obj file failed\n");
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
@@ -199,11 +244,61 @@ int main(int argc, char **argv)
 	}
 	dummy_prog_id = info.id;
 
+	/* Load 2nd xdp prog on egress. */
+	if (xdp_devmap_attached) {
+		unsigned char mac_addr[6];
+
+		devmap_prog = bpf_object__find_program_by_title(obj, "xdp_devmap/map_prog_0");
+		if (!devmap_prog) {
+			printf("finding devmap_prog in obj file failed\n");
+			goto out;
+		}
+		devmap_prog_fd_0 = bpf_program__fd(devmap_prog);
+		if (devmap_prog_fd_0 < 0) {
+			printf("finding devmap_prog fd failed\n");
+			goto out;
+		}
+
+		devmap_prog = bpf_object__find_program_by_title(obj, "xdp_devmap/map_prog_1");
+		if (!devmap_prog) {
+			printf("finding devmap_prog in obj file failed\n");
+			goto out;
+		}
+		devmap_prog_fd_1 = bpf_program__fd(devmap_prog);
+		if (devmap_prog_fd_1 < 0) {
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
+
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	/* populate virtual to physical port map */
-	ret = bpf_map_update_elem(tx_port_map_fd, &key, &ifindex_out, 0);
+	key = 0;
+	devmap_val.ifindex = ifindex_out;
+	devmap_val.bpf_prog.fd = devmap_prog_fd_0;
+	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
+	if (ret) {
+		perror("bpf_update_elem");
+		goto out;
+	}
+
+	key = 1;
+	devmap_val.ifindex = ifindex_out;
+	devmap_val.bpf_prog.fd = devmap_prog_fd_1;
+	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
 	if (ret) {
 		perror("bpf_update_elem");
 		goto out;
-- 
2.26.2

