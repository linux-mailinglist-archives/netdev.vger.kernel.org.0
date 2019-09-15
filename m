Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD4FB2FFA
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 14:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbfIOMrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 08:47:42 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:37063 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfIOMrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 08:47:42 -0400
Received: by mail-pf1-f169.google.com with SMTP id y5so18029143pfo.4;
        Sun, 15 Sep 2019 05:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9cKpo2atFWyqBHpc2cxgu7VaMRZO+Pk0zK/K0/RiF8w=;
        b=BHxwoID37nKLzNLJ/kBCTTh1k6uPVBYcvPj6AgsBUUket/4QeeHBMIfeAmxwYqzU7R
         2fXtZhGBqpdsy3AIsXud6jqufBQl3pr19ByGbOyMHxtV/B4koqTSqXVVi5w9Y1PzXCB4
         UXmI+kF+W0+mbVMYgTNQEvHPqYSiv777OjKyUEq/5P4RsmWMw2WEaYc6Yw1Obl8OGGYh
         l5XD0dYuquu6jHm3AdDYAKXDk6a3WrCMWYs4B5GA3t6XiDpJvbGDhBt3i6/DQq0q30vf
         ixefoB0HietoC+fjSUqDcIJAmmHQpW7Pd3WfkZXt8AY4vaO+3ifQu35UdSNxmeL2PPeB
         FePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9cKpo2atFWyqBHpc2cxgu7VaMRZO+Pk0zK/K0/RiF8w=;
        b=Py9eXRJtNlFLFYc8sJPhudH0y+DB6azGTlbfK8v9iQljbTnEvLK3RyB/OucqDsZi2C
         taMVi+H1utNsx6hVr5alqp63VMRHwZWm4Fp92D3jYp+43L5jxx6oNvS0zIxxn6qfA5Wa
         Sk/aBbCtMWW0aKLejlWcvqY2uQXBFGGTuAJozRxV5aMrCjoh5xBGd+8SZh5ru6JQAueQ
         0UUfgiayCTUiT59n3czUnLuNWnwkogNkpyNnjTO8h4qfp19N16lPf4pbJn2+97n3jdxu
         UGAxD9yCOv8Nmp1dvVzjnbDtZJU+cTvxYJftQT9foBTSm6wGnWx9iX6XOvDvzA5uPqAE
         agyQ==
X-Gm-Message-State: APjAAAXH9/VMdkTWSYt+odlDFdPNBl/Oc6eDgpfeVYVwjQToGXeeWJhw
        tGVY3KN/CbOG3VkAibt48g==
X-Google-Smtp-Source: APXvYqxdsfCHywBxyg1nqTHuoRgfAjG0UQS1lpLIs4kvR/r1GsGnaXP0E+ZyprkS879x61BeqA0WZA==
X-Received: by 2002:a63:1d0e:: with SMTP id d14mr52060279pgd.324.1568551660912;
        Sun, 15 Sep 2019 05:47:40 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f14sm45561019pfq.187.2019.09.15.05.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2019 05:47:40 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [bpf-next,v4] samples: bpf: add max_pckt_size option at xdp_adjust_tail
Date:   Sun, 15 Sep 2019 21:47:33 +0900
Message-Id: <20190915124733.31134-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
to 600. To make this size flexible, a new map 'pcktsz' is added.

By updating new packet size to this map from the userland,
xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.

If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
will be 600 as a default.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in v4:
    - make pckt_size no less than ICMP_TOOBIG_SIZE
    - Fix code style
Changes in v2:
    - Change the helper to fetch map from 'bpf_map__next' to 
    'bpf_object__find_map_fd_by_name'.

 samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
 samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
index 411fdb21f8bc..8869bbb160d2 100644
--- a/samples/bpf/xdp_adjust_tail_kern.c
+++ b/samples/bpf/xdp_adjust_tail_kern.c
@@ -25,6 +25,13 @@
 #define ICMP_TOOBIG_SIZE 98
 #define ICMP_TOOBIG_PAYLOAD_SIZE 92
 
+struct bpf_map_def SEC("maps") pcktsz = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 1,
+};
+
 struct bpf_map_def SEC("maps") icmpcnt = {
 	.type = BPF_MAP_TYPE_ARRAY,
 	.key_size = sizeof(__u32),
@@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
 	*csum = csum_fold_helper(*csum);
 }
 
-static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
+static __always_inline int send_icmp4_too_big(struct xdp_md *xdp,
+					      __u32 max_pckt_size)
 {
 	int headroom = (int)sizeof(struct iphdr) + (int)sizeof(struct icmphdr);
 
@@ -92,7 +100,7 @@ static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
 	orig_iph = data + off;
 	icmp_hdr->type = ICMP_DEST_UNREACH;
 	icmp_hdr->code = ICMP_FRAG_NEEDED;
-	icmp_hdr->un.frag.mtu = htons(MAX_PCKT_SIZE-sizeof(struct ethhdr));
+	icmp_hdr->un.frag.mtu = htons(max_pckt_size - sizeof(struct ethhdr));
 	icmp_hdr->checksum = 0;
 	ipv4_csum(icmp_hdr, ICMP_TOOBIG_PAYLOAD_SIZE, &csum);
 	icmp_hdr->checksum = csum;
@@ -118,14 +126,21 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 {
 	void *data_end = (void *)(long)xdp->data_end;
 	void *data = (void *)(long)xdp->data;
+	__u32 max_pckt_size = MAX_PCKT_SIZE;
 	int pckt_size = data_end - data;
+	__u32 *pckt_sz;
+	__u32 key = 0;
 	int offset;
 
-	if (pckt_size > MAX_PCKT_SIZE) {
+	pckt_sz = bpf_map_lookup_elem(&pcktsz, &key);
+	if (pckt_sz && *pckt_sz)
+		max_pckt_size = *pckt_sz;
+
+	if (pckt_size > max(max_pckt_size, ICMP_TOOBIG_SIZE)) {
 		offset = pckt_size - ICMP_TOOBIG_SIZE;
 		if (bpf_xdp_adjust_tail(xdp, 0 - offset))
 			return XDP_PASS;
-		return send_icmp4_too_big(xdp);
+		return send_icmp4_too_big(xdp, max_pckt_size);
 	}
 	return XDP_PASS;
 }
diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
index a3596b617c4c..99e965c68054 100644
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
+	__u32 max_pckt_size = 0;
+	__u32 key = 0;
 	unsigned int kill_after_s = 0;
 	int i, prog_fd, map_fd, opt;
 	struct bpf_object *obj;
-	struct bpf_map *map;
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
@@ -150,12 +156,22 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
 
-	map = bpf_map__next(NULL, obj);
-	if (!map) {
-		printf("finding a map in obj file failed\n");
+	/* update pcktsz map */
+	if (max_pckt_size) {
+		map_fd = bpf_object__find_map_fd_by_name(obj, "pcktsz");
+		if (map_fd < 0) {
+			printf("finding a pcktsz map in obj file failed\n");
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
-	map_fd = bpf_map__fd(map);
 
 	if (!prog_fd) {
 		printf("load_bpf_file: %s\n", strerror(errno));
-- 
2.20.1

