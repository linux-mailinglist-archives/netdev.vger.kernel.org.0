Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A656F2FAF0D
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 04:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394848AbhASDNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 22:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389203AbhASDNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 22:13:02 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA050C061573;
        Mon, 18 Jan 2021 19:12:21 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id x20so5811938pjh.3;
        Mon, 18 Jan 2021 19:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J1FIAoE0SD0OvPeskH2l2MZdQXwX0oX0DZ9L/sMPp5c=;
        b=uxh2n6QTbG/hJMhR6wK/Dpvl3EE6Sof+7OF4zscHIULKIc2GCqeI6luCVzDRkwQ+/a
         OTqKc8nIWqjD2f/FHbHXUUYtOm4n+Q33kssTJfsfkyd/hbRBjmgbRCAjrzx0YnPz+WUu
         Ak+2uC59WvlgwBYIJbOR3GRUnnN4CbxUIrqWRpUkmW0LqMANfrny94izsSjbHf5Eu/wz
         yuoEXWg5bMgLXMGlM0n0y4NwKOq1nYT0haSaBIQ7jQSyMXXwDTgq5b/HXHcVPb6FFinC
         MzpK2i/qzbZgyjOM51WVPQS6U0jguVs4dICe8fEGxMj6PensCJ7Vu0J0B5jpCV5loeRB
         EiVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J1FIAoE0SD0OvPeskH2l2MZdQXwX0oX0DZ9L/sMPp5c=;
        b=GYqiVL5NBVMohETCy0AMUi17JaLTEYHEfng9Cq2omiEYf3CAsSu5hBFQcWoXQqngW+
         2+GTMvpqeWOWaJUunf7ArbBci9WFlPqq7nHr0FdgNa2f5vSn97N3dQfcKwc8ziTC8Taq
         QyZ/m+or2/lVWjwtIi/s0+keHufbCcN9950TMbdThEEh2j0gViyC2Opk2cwGpP1Sw3yQ
         2oZCgx/FTM3m+EuGRmNXB3yvJWwHxjvulZr7ChsuGLjtVNB2YwrndTQBJ7p/DWRMa4YV
         lsIoR+6UpXFotvGHwBYoRmpEiyqb87H6D/oUKWB9WBRHWUdFqnYNMydFcKUMtcLlgmiN
         C/VA==
X-Gm-Message-State: AOAM532GiOQp9TWcp2Wz6zFx/kLKmDsT+DuKMXosNK48nr3K3a5EV0bL
        vzZYIFcXNsGyPpkyhSsgsVx7awdNCoUrbg==
X-Google-Smtp-Source: ABdhPJz8DohGRTjC/tTBeOgmOClKZXs1rKRymJG+oLU5XuIhK1LMDNbwFBrBAwICib8RascIednrRg==
X-Received: by 2002:a17:90a:c84:: with SMTP id v4mr71205pja.228.1611025940806;
        Mon, 18 Jan 2021 19:12:20 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x63sm511989pfc.145.2021.01.18.19.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 19:12:20 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv8 bpf-next] samples/bpf: add xdp program on egress for xdp_redirect_map
Date:   Tue, 19 Jan 2021 11:12:07 +0800
Message-Id: <20210119031207.2813215-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115062433.2624893-1-liuhangbin@gmail.com>
References: <20210115062433.2624893-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a xdp program on egress to show that we can modify
the packet on egress. In this sample we will set the pkt's src
mac to egress's mac address. The xdp_prog will be attached when
-X option supplied.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
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
 samples/bpf/xdp_redirect_map_kern.c |  79 ++++++++++++++--
 samples/bpf/xdp_redirect_map_user.c | 140 ++++++++++++++++++++++++----
 2 files changed, 193 insertions(+), 26 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
index 6489352ab7a4..e5c0d07a82d8 100644
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
@@ -73,13 +90,63 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
 
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
+/* This program will set src mac to 00:00:00:00:00:01 */
+SEC("xdp_devmap/map_prog_0")
+int xdp_redirect_map_egress_0(struct xdp_md *ctx)
+{
+	unsigned char mac[6] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x1};
+
+	return xdp_redirect_map_egress(ctx, mac);
+}
+
+/* This program will set src mac to 00:00:00:00:01:01 */
+SEC("xdp_devmap/map_prog_1")
+int xdp_redirect_map_egress_1(struct xdp_md *ctx)
+{
+	unsigned char mac[6] = {0x0, 0x0, 0x0, 0x0, 0x1, 0x1};
+
+	return xdp_redirect_map_egress(ctx, mac);
 }
 
 /* Redirect require an XDP bpf_prog loaded on the TX device */
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 31131b6e7782..99c3bdea3e49 100644
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
+	int devmap_prog_fd_0 = 0, devmap_prog_fd_1 = 0;
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
+		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_general");
+		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_general");
+	} else {
+		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_native");
+		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_native");
 	}
-	/* bpf_prog_load_xattr gives us the pointer to first prog's fd,
-	 * so we're missing only the fd for dummy prog
-	 */
+	dummy_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_dummy_prog");
+	if (!prog || dummy_prog < 0 || tx_port_map_fd < 0) {
+		printf("finding prog/dummy_prog/tx_port_map in obj file failed\n");
+		goto out;
+	}
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
@@ -199,11 +244,66 @@ int main(int argc, char **argv)
 	}
 	dummy_prog_id = info.id;
 
+	/* Load 2nd xdp prog on egress. */
+	if (xdp_devmap_attached) {
+		unsigned char mac_addr[6];
+
+		devmap_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_egress_0");
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
+		devmap_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_egress_1");
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
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
-	/* populate virtual to physical port map */
-	ret = bpf_map_update_elem(tx_port_map_fd, &key, &ifindex_out, 0);
+	/* devmap prog 0 will set src mac to 00:00:00:00:00:01
+	 * if 2nd xdp prog attached on egress
+	 */
+	key = 0;
+	devmap_val.ifindex = ifindex_out;
+	devmap_val.bpf_prog.fd = devmap_prog_fd_0;
+	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
+	if (ret) {
+		perror("bpf_update_elem");
+		goto out;
+	}
+
+	/* devmap prog 1 will set src mac to 00:00:00:00:01:01
+	 * if 2nd xdp prog attached on egress
+	 */
+	key = 1;
+	devmap_val.ifindex = ifindex_out;
+	devmap_val.bpf_prog.fd = devmap_prog_fd_1;
+	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
 	if (ret) {
 		perror("bpf_update_elem");
 		goto out;
-- 
2.26.2

