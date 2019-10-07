Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC72DCEA80
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfJGRVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:21:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34619 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfJGRVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 13:21:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id k7so7193581pll.1;
        Mon, 07 Oct 2019 10:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BAkDTsaT4pqzjP72lQaqIaOktikei1udLeGkVUvLMGI=;
        b=fibAwMiY2x7P19N68woA02XOjS5jkFTQS/dctR3F1z0okOVMuRMfY3C5HlzaWfXUWl
         efwKbCswSd/ufmcegOHwHB1eODcVdUMwMhgPLGHXyZoxMSjsG8PXGIJSzsmArstPHiXO
         yeCnUvHlo01n3PXVa1XsB0AW783oad2eOprhxqHSByJW1ki36g27dZrVUxuaY6oYZ09d
         9EiGFvP4Aa6LoXlNTPS7xO7fV09Hnlez7DcMcce04FaHzpiY7gX4FQwt39146xv7yK/O
         PLjLNFNjN+6LsXsOleTokqILaq5MOMsgj+Op1eD8Bnh7Xi8KVz5wXQyKIknowbzW3bIb
         TMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BAkDTsaT4pqzjP72lQaqIaOktikei1udLeGkVUvLMGI=;
        b=nJkxJY9nfPeNEYPleOO6zjCRhA0pS5Z4Qwc8n8IafG/+N2HeJ6+MPKqfMXbon6wDuH
         y3K1y9hio0F/loNEDg33EQI12CSfedNn0VOyj2yA9K28nkCY5XBN6a96G1NnyzJYM/I0
         jq+50DXeUfgn9QfiaZ7LwcDIpMpFV1O50xWj0m2B5Owguc0ZKLsQvqrvW8QJQIfJIrcf
         2DGOp/VO2irDIq/bVUO2uyeyxWY5DuMk2OKB5dK315YrcnDxlRLoBCzkCXyQF0sKhFMI
         ZuKgpA1mJSX1ElY7VGw22idyuocm+zSNMg60VoQA2RZdrF8t1u3DqQPxairrcySpGkiH
         DTOA==
X-Gm-Message-State: APjAAAVDzt96T2Lq6vbKunCipenMdttvwnhlMY6ODVp8CYYd/6809j5i
        1vpefkb+8wiogIHUNBPDtw==
X-Google-Smtp-Source: APXvYqyS/PCvG0JngaiPE/000+OvPwCZs+NGDFJIKH1SIFVxyWDm+2ymEQyr6RtIxLvJOYNsoiczCQ==
X-Received: by 2002:a17:902:6b45:: with SMTP id g5mr16188222plt.336.1570468889565;
        Mon, 07 Oct 2019 10:21:29 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 6sm19461374pfa.162.2019.10.07.10.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 10:21:29 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Yonghong Song <yhs@fb.com>, Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH bpf-next v7] samples: bpf: add max_pckt_size option at xdp_adjust_tail
Date:   Tue,  8 Oct 2019 02:21:17 +0900
Message-Id: <20191007172117.3916-1-danieltimlee@gmail.com>
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

For clarity, change the helper to fetch map from 'bpf_map__next'
to 'bpf_object__find_map_fd_by_name'. Also, changed the way to
test prog_fd, map_fd from '!= 0' to '< 0', since fd could be 0
when stdin is closed.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in v6:
    - Remove redundant error message
Changes in v5:
    - Change pcktsz map to static global variable
Changes in v4:
    - make pckt_size no less than ICMP_TOOBIG_SIZE
    - Fix code style

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

