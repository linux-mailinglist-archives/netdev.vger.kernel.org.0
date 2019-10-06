Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB002CD1CE
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 13:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfJFL6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 07:58:25 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:34562 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfJFL6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 07:58:25 -0400
Received: by mail-pg1-f175.google.com with SMTP id y35so6524199pgl.1;
        Sun, 06 Oct 2019 04:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jtusd2e8pzBkQsAu63azV87Y10QhM0PvTVIOsSJOoI=;
        b=I5nO5Zjxe6YTD58+eTwLHmLzvBQaTS15xjCUUHj9nU4OyNyYFQF71WHK/H7fSkzOMu
         wmR4xaNQEy35LRtwjsYuUu906vd8V6QKAS5PjUkL3/W3xqr5fmtpDcGRtgE9KfzhCffs
         AYVlQXxf70J/WzAw8kOA36W3IMt1UtNsIS4uAWozn4LvayuT57nsmOFbQTWUnV13tQ5K
         TJIV4lmHwV6O2+MQbkQ3UoDmAYPspKAQ2AtWiQfDPBF26+/1utG2adjwv2UmNbcFOH2m
         VSfMlKHIL94Yvb6StNI1cQPlpwhNSWdK0p7HP9p577xH1HZnbK4b9vOPjwY/cmTUBAsc
         POIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jtusd2e8pzBkQsAu63azV87Y10QhM0PvTVIOsSJOoI=;
        b=pvtu6RgCu2bAOIPIMjHNFWIOYc+JYlI7mLRtrR63r1gH/hPBRVlCP9ZVTKFdLuP/ry
         sq0h3Xu8oEGYL4jPlGlUP0ULfh6ts/hvHQhLYF7WvI/bzr9xMyfVy6GNCjX3aGA/V0uf
         OcYj/zMTuODsBGZFddLkqJnNMRVddluzPb3aQP/DEfs+IugUmcksd2sx5pK0SLGXWfCT
         9eOBLEIbs96ccsj4HYcDAdFMeVsGi8vf/udQ3QFcciyUXtbnkYJpjBbwqIe1YWieA9nK
         GYv68NxC7JmjAD/r5hmQRyol5ezAt+8dGWzXdQbqDmtT54p49rSRIeHw6JKqFbnLAn1W
         89TA==
X-Gm-Message-State: APjAAAV+hsIuMmVgenuFfgBgi/jOX0PEeeavKURiiThjVqncKdqQ7oi5
        7pyGcowrqSbZZQ3kCbM6aw==
X-Google-Smtp-Source: APXvYqzh1zoALgta24J3bq8ETMMRW9TB2DvkP5oWZpBeuknXWW6KULOPxHggIHQlIjv/a1ZwkO/TIA==
X-Received: by 2002:a17:90a:cb07:: with SMTP id z7mr27277220pjt.67.1570363103763;
        Sun, 06 Oct 2019 04:58:23 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id h14sm12445559pfo.15.2019.10.06.04.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 04:58:23 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Yonghong Song <yhs@fb.com>, Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org
Subject: [bpf-next v5] samples: bpf: add max_pckt_size option at xdp_adjust_tail
Date:   Sun,  6 Oct 2019 20:58:15 +0900
Message-Id: <20191006115815.10292-1-danieltimlee@gmail.com>
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
Changes in v5:
    - Change pcktsz map to static global variable
Changes in v4:
    - make pckt_size no less than ICMP_TOOBIG_SIZE
    - Fix code style
Changes in v2:
    - Change the helper to fetch map from 'bpf_map__next' to
    'bpf_object__find_map_fd_by_name'.

 samples/bpf/xdp_adjust_tail_kern.c |  7 +++++--
 samples/bpf/xdp_adjust_tail_user.c | 32 ++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 10 deletions(-)

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
index a3596b617c4c..bcdebd3be83e 100644
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
@@ -150,15 +156,25 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
 
-	map = bpf_map__next(NULL, obj);
-	if (!map) {
-		printf("finding a map in obj file failed\n");
+	if (prog_fd < 0) {
+		printf("load_bpf_file: %s\n", strerror(errno));
 		return 1;
 	}
-	map_fd = bpf_map__fd(map);
 
-	if (!prog_fd) {
-		printf("load_bpf_file: %s\n", strerror(errno));
+	/* static global var 'max_pcktsz' is accessible from .data section */
+	if (max_pckt_size) {
+		map_fd = bpf_object__find_map_fd_by_name(obj, "xdp_adju.data");
+		if (map_fd < 0) {
+			printf("finding a max_pcktsz map in obj file failed\n");
+			return 1;
+		}
+		bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
+	}
+
+	/* fetch icmpcnt map */
+	map_fd = bpf_object__find_map_fd_by_name(obj, "icmpcnt");
+	if (map_fd < 0) {
+		printf("finding a icmpcnt map in obj file failed\n");
 		return 1;
 	}
 
-- 
2.20.1

