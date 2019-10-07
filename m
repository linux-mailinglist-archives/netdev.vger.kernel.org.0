Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63458CE89E
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfJGQGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:06:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35753 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbfJGQGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:06:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id p30so6408510pgl.2;
        Mon, 07 Oct 2019 09:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ehxiHsMQCyh5wZYAe/tjs04IMiaDtw5LmMLtgoz20eM=;
        b=h7M+L8WfVEe2t6GKGXhWgwXOYzg4Z0DZxcfkCXLD0//IaK540r6+s5QQuZuRae0sGS
         EZLC+/TkaFEHLEqEgPvlnV3SQnZYfFleluzjKoDG7Q+vpDDumc64/pCYFpRrGFzTrtRZ
         oW/7iO8dTIFn4smKFbIXriK54sn3wmtGoJds5j4/XMTuSyFwCah/ildIia8QxHu5Jkoo
         TOJySF+5ichxORndr0TVbIvBQGfndfJ2bacF9gNA49ToV3qiyPG+ofNTe8j2OLKAQ9Ff
         7D2VPYpuwBQi5dCumdxiEUwbSykvh7J9O3BguQDhswq+TR9gy0B8G8bL2U+qTa8UhAIg
         uvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ehxiHsMQCyh5wZYAe/tjs04IMiaDtw5LmMLtgoz20eM=;
        b=ipFlFFTrjK7zi0BkTspsanvRHJCTugW/WIoU8t3AYPUN0sOkL3AE3bcx5Q0ExDU1pE
         xGoGnlnm6tyBi+yWJJjzeZA9YN0VtmWk0BWZLK4A4mQiLYoadjpjM37emoEeY7D3kNHl
         LVGUFU7a/gvAG0eoJCegBz2c4K7iJ1vlmBqZimexXg1zRJ3UYnGAb7DGijoe+aaRwjLv
         7g0cG/uVhh6vyVryE4NNnGnV0eT0Z3BN0ec3vgP0gPyfGdoLlF8efiFnVFjrH0DjJ9rc
         JS//iujUy16oFxzXtm+zcPjr4Rs1p3B/uRklBKiYif1OZ4KCZQLphPx4117a/89wDpZR
         ddvg==
X-Gm-Message-State: APjAAAW0kcGQoh859N7idD5FWSyP5dV8h78sMaQiJil021fljC82eGqq
        CgQIqlwluujlwai6lYZPew==
X-Google-Smtp-Source: APXvYqzk6wJkMOlPma5mgBaurwelYUskqpd2a8htstH0bfJHWzn4nMJi4vyIu20/VMFR6/dvn78ItQ==
X-Received: by 2002:a63:d846:: with SMTP id k6mr31189632pgj.378.1570464406125;
        Mon, 07 Oct 2019 09:06:46 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id g202sm20223900pfb.155.2019.10.07.09.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:06:44 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Yonghong Song <yhs@fb.com>, Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH bpf-next v6] samples: bpf: add max_pckt_size option at xdp_adjust_tail
Date:   Tue,  8 Oct 2019 01:06:35 +0900
Message-Id: <20191007160635.1021-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
to 600. To make this size flexible, static global variable
'max_pcktsz' is added.

By updating new packet size from the user space, xdp_adjust_tail_kern.o
will use this value as a new max packet size.

This static global variable can be accesible from .data section with
bpf_object__find_map* from user space, since it is considered as
internal map (accessible with .bss/.data/.rodata suffix).

If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
will be 600 as a default.

Changed the way to test prog_fd, map_fd from '!= 0' to '< 0',
since fd could be 0 when stdin is closed.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in v6:
    - Remove redundant error message
Changes in v5:
    - Change pcktsz map to static global variable
Changes in v4:
    - make pckt_size no less than ICMP_TOOBIG_SIZE
    - Fix code style
Changes in v2:
    - Change the helper to fetch map from 'bpf_map__next' to
    'bpf_object__find_map_fd_by_name'.

 samples/bpf/xdp_adjust_tail_kern.c |  7 +++++--
 samples/bpf/xdp_adjust_tail_user.c | 29 ++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
index 411fdb21f8bc..c616508befb9 100644
--- a/samples/bpf/xdp_adjust_tail_kern.c
+++ b/samples/bpf/xdp_adjust_tail_kern.c
@@ -25,6 +25,9 @@
 #define ICMP_TOOBIG_SIZE 98
 #define ICMP_TOOBIG_PAYLOAD_SIZE 92
 
+/* volatile to prevent compiler optimizations */
+static volatile __u32 max_pcktsz = MAX_PCKT_SIZE;
+
 struct bpf_map_def SEC("maps") icmpcnt = {
 	.type = BPF_MAP_TYPE_ARRAY,
 	.key_size = sizeof(__u32),
@@ -92,7 +95,7 @@ static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
 	orig_iph = data + off;
 	icmp_hdr->type = ICMP_DEST_UNREACH;
 	icmp_hdr->code = ICMP_FRAG_NEEDED;
-	icmp_hdr->un.frag.mtu = htons(MAX_PCKT_SIZE-sizeof(struct ethhdr));
+	icmp_hdr->un.frag.mtu = htons(max_pcktsz - sizeof(struct ethhdr));
 	icmp_hdr->checksum = 0;
 	ipv4_csum(icmp_hdr, ICMP_TOOBIG_PAYLOAD_SIZE, &csum);
 	icmp_hdr->checksum = csum;
@@ -121,7 +124,7 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 	int pckt_size = data_end - data;
 	int offset;
 
-	if (pckt_size > MAX_PCKT_SIZE) {
+	if (pckt_size > max(max_pcktsz, ICMP_TOOBIG_SIZE)) {
 		offset = pckt_size - ICMP_TOOBIG_SIZE;
 		if (bpf_xdp_adjust_tail(xdp, 0 - offset))
 			return XDP_PASS;
diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
index a3596b617c4c..d86e9ad0356b 100644
--- a/samples/bpf/xdp_adjust_tail_user.c
+++ b/samples/bpf/xdp_adjust_tail_user.c
@@ -23,6 +23,7 @@
 #include "libbpf.h"
 
 #define STATS_INTERVAL_S 2U
+#define MAX_PCKT_SIZE 600
 
 static int ifindex = -1;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
@@ -72,6 +73,7 @@ static void usage(const char *cmd)
 	printf("Usage: %s [...]\n", cmd);
 	printf("    -i <ifname|ifindex> Interface\n");
 	printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
+	printf("    -P <MAX_PCKT_SIZE> Default: %u\n", MAX_PCKT_SIZE);
 	printf("    -S use skb-mode\n");
 	printf("    -N enforce native mode\n");
 	printf("    -F force loading prog\n");
@@ -85,13 +87,14 @@ int main(int argc, char **argv)
 		.prog_type	= BPF_PROG_TYPE_XDP,
 	};
 	unsigned char opt_flags[256] = {};
-	const char *optstr = "i:T:SNFh";
+	const char *optstr = "i:T:P:SNFh";
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
 	unsigned int kill_after_s = 0;
 	int i, prog_fd, map_fd, opt;
 	struct bpf_object *obj;
-	struct bpf_map *map;
+	__u32 max_pckt_size = 0;
+	__u32 key = 0;
 	char filename[256];
 	int err;
 
@@ -110,6 +113,9 @@ int main(int argc, char **argv)
 		case 'T':
 			kill_after_s = atoi(optarg);
 			break;
+		case 'P':
+			max_pckt_size = atoi(optarg);
+			break;
 		case 'S':
 			xdp_flags |= XDP_FLAGS_SKB_MODE;
 			break;
@@ -150,15 +156,20 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
 
-	map = bpf_map__next(NULL, obj);
-	if (!map) {
-		printf("finding a map in obj file failed\n");
-		return 1;
+	/* static global var 'max_pcktsz' is accessible from .data section */
+	if (max_pckt_size) {
+		map_fd = bpf_object__find_map_fd_by_name(obj, "xdp_adju.data");
+		if (map_fd < 0) {
+			printf("finding a max_pcktsz map in obj file failed\n");
+			return 1;
+		}
+		bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
 	}
-	map_fd = bpf_map__fd(map);
 
-	if (!prog_fd) {
-		printf("load_bpf_file: %s\n", strerror(errno));
+	/* fetch icmpcnt map */
+	map_fd = bpf_object__find_map_fd_by_name(obj, "icmpcnt");
+	if (map_fd < 0) {
+		printf("finding a icmpcnt map in obj file failed\n");
 		return 1;
 	}
 
-- 
2.20.1

