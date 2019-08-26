Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E6C9CCE8
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 11:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbfHZJ5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 05:57:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40954 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731165AbfHZJ5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 05:57:31 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so11472381pfn.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 02:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W15uTVRC8HJTDsw08p1lLu32MvTlp69JaLWxEjC2+G0=;
        b=egLxOxA6rsODToPvT2xryRh1i4OQAyEpWMD+KsXNrUnrg4zgbvo7rKgN6heHhd/9+a
         hI/C2xzdCndkvMBdur2kpeVZZh0GTGXxnTIYHkqylvy4V4subTrCA3ekxubflzni+Y3a
         f0CrjML81UY18IR6wf4KE+MM3c/AvbecEdMyyqQABQc4AL0oUY4nslKFQd1uRayUD/0/
         MM1T8mB+3dCyjHN6Pygq70RBFNQSMRK832Sf/euWKLgx5TaXIGg/bI8dIYLURO9cGZ/o
         uJwNnLsEXDByzdl5jbH1jY6lVfhWlVUqRG1uydv9ISLhCRT8zXRxdsC0KqCdJUj7WT/z
         rRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W15uTVRC8HJTDsw08p1lLu32MvTlp69JaLWxEjC2+G0=;
        b=UxlOLTBW1N8UeSd4MuHuBIzZNfirZJgeqMpv4FKoWXyyctuf7SLh6ObCCjO4E6e+6Y
         E3iqBNknCTSohBC73EzJA1S6WzP7UXUHaHMDvpI78IR3hTKan+W9jalilGTpQsl/EvFQ
         Y1OoAsNnUvNCfVtWow+Lc6rrjFQ340SByy7UhjBONwAmouQlJsWNs1H5nMqUdnqNMZvl
         5RestvFjoSCod6lhpAg/D6CAIfrEUr9uBErq+2LHngk8acIPJEm4RCk2+DINxFLLR3dN
         Fi54uqRqnvoQh5y0V1/6/MKn6yN1W7kfL9IRy/phRJJT9B+NmbKbeui13NAodwT8IujJ
         +i9g==
X-Gm-Message-State: APjAAAXaYEH7ar970YrY8zFEIsuR2bHlu00s67D/GkGi2vQP663VJb/Z
        2JjWGQZ4dNQjqfuVwj3+JQ==
X-Google-Smtp-Source: APXvYqy6WcrvtlH5zWQzF/yaB3AqB1+FU+kaZyoan0SE6WevM5vRbXIk/O0PQutQFXIWk/lH/7KRbw==
X-Received: by 2002:a17:90a:3646:: with SMTP id s64mr19169343pjb.44.1566813449875;
        Mon, 26 Aug 2019 02:57:29 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 21sm4118011pfb.96.2019.08.26.02.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 02:57:29 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] samples: bpf: add max_pckt_size option at xdp_adjust_tail
Date:   Mon, 26 Aug 2019 18:57:22 +0900
Message-Id: <20190826095722.28229-1-danieltimlee@gmail.com>
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
 samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
 samples/bpf/xdp_adjust_tail_user.c | 21 +++++++++++++++++++--
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
index 411fdb21f8bc..4d53af370b68 100644
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
index a3596b617c4c..dd3befa5e1fe 100644
--- a/samples/bpf/xdp_adjust_tail_user.c
+++ b/samples/bpf/xdp_adjust_tail_user.c
@@ -72,6 +72,7 @@ static void usage(const char *cmd)
 	printf("Usage: %s [...]\n", cmd);
 	printf("    -i <ifname|ifindex> Interface\n");
 	printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
+	printf("    -P <MAX_PCKT_SIZE> Default: 600\n");
 	printf("    -S use skb-mode\n");
 	printf("    -N enforce native mode\n");
 	printf("    -F force loading prog\n");
@@ -85,9 +86,11 @@ int main(int argc, char **argv)
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
@@ -150,9 +156,20 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
 
+	/* update pcktsz map */
 	map = bpf_map__next(NULL, obj);
 	if (!map) {
-		printf("finding a map in obj file failed\n");
+		printf("finding a pcktsz map in obj file failed\n");
+		return 1;
+	}
+	map_fd = bpf_map__fd(map);
+	if (max_pckt_size)
+		bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
+
+	/* fetch icmpcnt map */
+	map = bpf_map__next(map, obj);
+	if (!map) {
+		printf("finding a icmpcnt map in obj file failed\n");
 		return 1;
 	}
 	map_fd = bpf_map__fd(map);
-- 
2.20.1

