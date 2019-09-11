Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDCEB045E
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 21:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbfIKTDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 15:03:00 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:46056 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfIKTDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 15:03:00 -0400
Received: by mail-pf1-f177.google.com with SMTP id y72so14249854pfb.12;
        Wed, 11 Sep 2019 12:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ZzYVQmwjph7D99XrncLI3k6B0fYteXj1VXuw5UiTIU=;
        b=HW+zaOypEhqwYnNlSvX0iyuAPkwYHrP5paA0m+ITCOYN1MLq9FjMKAYYAFhdvBFFzJ
         dFFO9y6+nEXcaJNWTAB1gKlbcOlPCyuBDYvnqVEAUtBIzAXnFRY9ywSivpKhyRsBjqq2
         /OL/P/0Hfxeozo167nyKE4QrWLvlej3h2pWar7jHQHXlFc1MINIE5DLsGGz/izWQDEi2
         1Tfv97BZ93S/s9HAQyrPZjQh41P5eGp+vqsW/z6nG/DJyVhFfPW5/t2wFD3WD1aPA1Ac
         0sKUwttmdpIZXjfBebYZgQCrz9Rcg+cm07l28n1XnlyzB2SmWF5oHTwUH/hLu43UPKCA
         uxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ZzYVQmwjph7D99XrncLI3k6B0fYteXj1VXuw5UiTIU=;
        b=JY28Gp4QXbRQDjNUg/eoIAFz5ADxr3KlQJQWesaSt+SqsZ57aRToV5mOyJzmKS8ScM
         HcLbWhAcY3aHdgM62oqtVa1WfLXOQy4uyRn4SIF9VUczb390cnb4Xjd8rEmHpNfgEPrI
         OS7xibxuetSuVV2VQ619Ss0IlmJHXgp/HwraF6sc59355B0TJrTX+13ip/rfZohSN6rs
         OlQkhYqmBPSRBnb3b1hgUSwmlhHnTo2dGXCQN6nF69ABb6cBR/gFekXc4SQiKQ/id6Kz
         KWGF6KXJyXgszS+5ehYSZnsswrcQ+52PIpb3br5RzxPhlwVjfaJx2lorGifKEvfS8mAA
         B75w==
X-Gm-Message-State: APjAAAW71VXpMakC3EhQVqdvBDlUmq3Yh7Kz5Q7OIn9Ih57Jom0rUHT8
        Bk7ANuYeeIi/vW7zdvTdiQ==
X-Google-Smtp-Source: APXvYqzfczUGJjVyG7bhzY8usbw4AA2NmTQOkVVP+ghPm3YeDxtlRq9O6utrHXnDAwgi5FpJ4LB9CQ==
X-Received: by 2002:a17:90a:e397:: with SMTP id b23mr7011757pjz.140.1568228578765;
        Wed, 11 Sep 2019 12:02:58 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id k36sm19885028pgl.42.2019.09.11.12.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 12:02:58 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [bpf-next,v3] samples: bpf: add max_pckt_size option at xdp_adjust_tail
Date:   Thu, 12 Sep 2019 04:02:18 +0900
Message-Id: <20190911190218.22628-1-danieltimlee@gmail.com>
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
Changes in v2:
    - Change the helper to fetch map from 'bpf_map__next' to 
    'bpf_object__find_map_fd_by_name'.
 
 samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
 samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
index 411fdb21f8bc..d6d84ffe6a7a 100644
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
+	__u32 *pckt_sz;
+	__u32 key = 0;
 	int pckt_size = data_end - data;
 	int offset;
 
-	if (pckt_size > MAX_PCKT_SIZE) {
+	pckt_sz = bpf_map_lookup_elem(&pcktsz, &key);
+	if (pckt_sz && *pckt_sz)
+		max_pckt_size = *pckt_sz;
+
+	if (pckt_size > max_pckt_size) {
 		offset = pckt_size - ICMP_TOOBIG_SIZE;
 		if (bpf_xdp_adjust_tail(xdp, 0 - offset))
 			return XDP_PASS;
-		return send_icmp4_too_big(xdp);
+		return send_icmp4_too_big(xdp, max_pckt_size);
 	}
 	return XDP_PASS;
 }
diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
index a3596b617c4c..aef6c69a48a7 100644
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
+		if (!map_fd) {
+			printf("finding a pcktsz map in obj file failed\n");
+			return 1;
+		}
+		bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
+	}
+
+	/* fetch icmpcnt map */
+	map_fd = bpf_object__find_map_fd_by_name(obj, "icmpcnt");
+	if (!map_fd) {
+		printf("finding a icmpcnt map in obj file failed\n");
 		return 1;
 	}
-	map_fd = bpf_map__fd(map);
 
 	if (!prog_fd) {
 		printf("load_bpf_file: %s\n", strerror(errno));
-- 
2.20.1

