Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326989D3F0
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbfHZQZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:25:27 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:33452 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbfHZQZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:25:27 -0400
Received: by mail-pg1-f178.google.com with SMTP id n190so10929648pgn.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8MBb1j9PrRL5Q32BVVyjoPIVxdK/pWPaxnpIeQ11yLA=;
        b=HEzwBbLhezirzF5XIsphQOzd8b81Dzrpzziu+YL61hEZ8ofvgViGQfhu2SvavMBAsQ
         3mlTkVr5QKIpjN6hZ34QZRv+oQfs11XR7K/VqllN6mQLPs34lYA3YNQWUJ74Eb4Pnbqe
         nYKFRLWcOmHejRNJZTX+6DvMjC69YESYsAwpqn0r8QB1EUtmeC3svLEgwoO5pQjTdSAM
         v4hWrMwzslK5av8DnKH3/DLxfDsEXGvMI6X1bji0NSdEaJu9gpNznjFH7qAeRgoysVt9
         qvsWb5f0O3tjN+rZoeXcy5fC5LdP22gUkMt9vrJWhzicAyHg6YQBCrJXUfGyfi/oYE/+
         Hfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8MBb1j9PrRL5Q32BVVyjoPIVxdK/pWPaxnpIeQ11yLA=;
        b=f7qpZop1IY+EGi0ah+Q/W25AREiVFFvz2ZWSVPV4Q1rBxDOCaC+87xkOBfUZyFOjaP
         U8fwGWFVYdGVOXJeqjEKQpQwH+ZfLmpXGgct7YzLMJMiC0+SDi4HZiFAOkeZYL20I5vB
         3uiBXHMnonaeVt/RVzvYf96iWIKYOfjt61ccbC9FTJhppnQOxiDeDCArF4ydC733iY64
         QRbEfLPLwS5Avng9CnMHATvWBgc4nHHQZ1kAj+Ns6x2rrhHWJpcSmaj1YuzgOMExktBn
         4FzlsGx9qN2+IJ0x6HJ/OOZhmXogw3Ymdp2Afj3t+XFJR5K+fo4SHo5X6ypBdREKSuFP
         QQGg==
X-Gm-Message-State: APjAAAUx1A5c6bjRDZTDopqIKgkjn54rKw7bN93mzdLUJcUrKcp0fSl4
        Bb09A4Pg8Zgq8UXKDOnDD0IwAQUZsA==
X-Google-Smtp-Source: APXvYqwAmOT8cUie7RMFelO3k9R8iOAihP31EpU7Aa8ns7dMPehZZUpJv1b+1aKbGG7gkdwRqK3unw==
X-Received: by 2002:a62:f94a:: with SMTP id g10mr4541881pfm.167.1566836726180;
        Mon, 26 Aug 2019 09:25:26 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.171])
        by smtp.gmail.com with ESMTPSA id g11sm10825700pgu.11.2019.08.26.09.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 09:25:24 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [bpf-next, v2] samples: bpf: add max_pckt_size option at xdp_adjust_tail
Date:   Tue, 27 Aug 2019 01:25:17 +0900
Message-Id: <20190826162517.8082-1-danieltimlee@gmail.com>
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
 samples/bpf/xdp_adjust_tail_user.c | 27 +++++++++++++++++++++------
 2 files changed, 40 insertions(+), 10 deletions(-)

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
index a3596b617c4c..29ade7caf841 100644
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
@@ -85,13 +86,14 @@ int main(int argc, char **argv)
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
 
@@ -110,6 +112,9 @@ int main(int argc, char **argv)
 		case 'T':
 			kill_after_s = atoi(optarg);
 			break;
+		case 'P':
+			max_pckt_size = atoi(optarg);
+			break;
 		case 'S':
 			xdp_flags |= XDP_FLAGS_SKB_MODE;
 			break;
@@ -150,12 +155,22 @@ int main(int argc, char **argv)
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

