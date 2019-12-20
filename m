Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9FF127794
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfLTIzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:55:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:34862 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727346AbfLTIzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:55:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 00:55:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="218434387"
Received: from unknown (HELO localhost.localdomain) ([10.190.210.212])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2019 00:55:13 -0800
Received: from localhost.localdomain (localhost [127.0.0.1])
        by localhost.localdomain (8.15.2/8.15.2/Debian-10) with ESMTPS id xBK8tZOG005052
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 14:25:35 +0530
Received: (from root@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id xBK8tZoI005051;
        Fri, 20 Dec 2019 14:25:35 +0530
From:   Jay Jayatheerthan <jay.jayatheerthan@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        Jay Jayatheerthan <jay.jayatheerthan@intel.com>
Subject: [PATCH bpf-next 5/6] samples/bpf: xdpsock: Add option to specify tx packet size
Date:   Fri, 20 Dec 2019 14:25:29 +0530
Message-Id: <20191220085530.4980-6-jay.jayatheerthan@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
References: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New option '-s' or '--tx-pkt-size' has been added to specify the transmit
packet size. The packet size ranges from 47 to 4096 bytes. When this
option is not provided, it defaults to 64 byte packet.

The code uses struct ethhdr, struct iphdr and struct udphdr to form the
transmit packet. The MAC address, IP address and UDP ports are set to default
values.

The code calculates IP and UDP checksums before sending the packet.
Checksum calculation code in Linux kernel is used for this purpose.
The Ethernet FCS is not filled by the code.

Signed-off-by: Jay Jayatheerthan <jay.jayatheerthan@intel.com>
---
 samples/bpf/xdpsock_user.c | 276 +++++++++++++++++++++++++++++++++++--
 1 file changed, 265 insertions(+), 11 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index f96ce3055d46..2297158a32bd 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -10,6 +10,9 @@
 #include <linux/if_link.h>
 #include <linux/if_xdp.h>
 #include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <arpa/inet.h>
 #include <locale.h>
 #include <net/ethernet.h>
 #include <net/if.h>
@@ -45,11 +48,14 @@
 #endif
 
 #define NUM_FRAMES (4 * 1024)
+#define MIN_PKT_SIZE 64
 
 #define DEBUG_HEXDUMP 0
 
 typedef __u64 u64;
 typedef __u32 u32;
+typedef __u16 u16;
+typedef __u8  u8;
 
 static unsigned long prev_time;
 
@@ -69,6 +75,8 @@ static unsigned long start_time;
 static bool benchmark_done;
 static u32 opt_batch_size = 64;
 static int opt_pkt_count;
+static u16 opt_pkt_size = MIN_PKT_SIZE;
+static u32 pkt_fill_pattern = 0x12345678;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
@@ -238,12 +246,6 @@ static void __exit_with_error(int error, const char *file, const char *func,
 
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, \
 						 __LINE__)
-static const char pkt_data[] =
-	"\x3c\xfd\xfe\x9e\x7f\x71\xec\xb1\xd7\x98\x3a\xc0\x08\x00\x45\x00"
-	"\x00\x2e\x00\x00\x00\x00\x40\x11\x88\x97\x05\x08\x07\x08\xc8\x14"
-	"\x1e\x04\x10\x92\x10\x92\x00\x1a\x6d\xa3\x34\x33\x1f\x69\x40\x6b"
-	"\x54\x59\xb6\x14\x2d\x11\x44\xbf\xaf\xd9\xbe\xaa";
-
 static void swap_mac_addresses(void *data)
 {
 	struct ether_header *eth = (struct ether_header *)data;
@@ -291,10 +293,243 @@ static void hex_dump(void *pkt, size_t length, u64 addr)
 	printf("\n");
 }
 
+static void *memset32_htonl(void *dest, u32 val, u32 size)
+{
+	u32 *ptr = (u32 *)dest;
+	int i;
+
+	val = htonl(val);
+
+	for (i = 0; i < (size & (~0x3)); i += 4)
+		ptr[i >> 2] = val;
+
+	for (; i < size; i++)
+		((char *)dest)[i] = ((char *)&val)[i & 3];
+
+	return dest;
+}
+
+/*
+ * This function code has been taken from
+ * Linux kernel lib/checksum.c
+ */
+static inline unsigned short from32to16(unsigned int x)
+{
+	/* add up 16-bit and 16-bit for 16+c bit */
+	x = (x & 0xffff) + (x >> 16);
+	/* add up carry.. */
+	x = (x & 0xffff) + (x >> 16);
+	return x;
+}
+
+/*
+ * This function code has been taken from
+ * Linux kernel lib/checksum.c
+ */
+static unsigned int do_csum(const unsigned char *buff, int len)
+{
+	unsigned int result = 0;
+	int odd;
+
+	if (len <= 0)
+		goto out;
+	odd = 1 & (unsigned long)buff;
+	if (odd) {
+#ifdef __LITTLE_ENDIAN
+		result += (*buff << 8);
+#else
+		result = *buff;
+#endif
+		len--;
+		buff++;
+	}
+	if (len >= 2) {
+		if (2 & (unsigned long)buff) {
+			result += *(unsigned short *)buff;
+			len -= 2;
+			buff += 2;
+		}
+		if (len >= 4) {
+			const unsigned char *end = buff +
+						   ((unsigned int)len & ~3);
+			unsigned int carry = 0;
+
+			do {
+				unsigned int w = *(unsigned int *)buff;
+
+				buff += 4;
+				result += carry;
+				result += w;
+				carry = (w > result);
+			} while (buff < end);
+			result += carry;
+			result = (result & 0xffff) + (result >> 16);
+		}
+		if (len & 2) {
+			result += *(unsigned short *)buff;
+			buff += 2;
+		}
+	}
+	if (len & 1)
+#ifdef __LITTLE_ENDIAN
+		result += *buff;
+#else
+		result += (*buff << 8);
+#endif
+	result = from32to16(result);
+	if (odd)
+		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
+out:
+	return result;
+}
+
+__sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+
+/*
+ *	This is a version of ip_compute_csum() optimized for IP headers,
+ *	which always checksum on 4 octet boundaries.
+ *	This function code has been taken from
+ *	Linux kernel lib/checksum.c
+ */
+__sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+{
+	return (__force __sum16)~do_csum(iph, ihl * 4);
+}
+
+/*
+ * Fold a partial checksum
+ * This function code has been taken from
+ * Linux kernel include/asm-generic/checksum.h
+ */
+static inline __sum16 csum_fold(__wsum csum)
+{
+	u32 sum = (__force u32)csum;
+
+	sum = (sum & 0xffff) + (sum >> 16);
+	sum = (sum & 0xffff) + (sum >> 16);
+	return (__force __sum16)~sum;
+}
+
+/*
+ * This function code has been taken from
+ * Linux kernel lib/checksum.c
+ */
+static inline u32 from64to32(u64 x)
+{
+	/* add up 32-bit and 32-bit for 32+c bit */
+	x = (x & 0xffffffff) + (x >> 32);
+	/* add up carry.. */
+	x = (x & 0xffffffff) + (x >> 32);
+	return (u32)x;
+}
+
+__wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
+			  __u32 len, __u8 proto, __wsum sum);
+
+/*
+ * This function code has been taken from
+ * Linux kernel lib/checksum.c
+ */
+__wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
+			  __u32 len, __u8 proto, __wsum sum)
+{
+	unsigned long long s = (__force u32)sum;
+
+	s += (__force u32)saddr;
+	s += (__force u32)daddr;
+#ifdef __BIG_ENDIAN__
+	s += proto + len;
+#else
+	s += (proto + len) << 8;
+#endif
+	return (__force __wsum)from64to32(s);
+}
+
+/*
+ * This function has been taken from
+ * Linux kernel include/asm-generic/checksum.h
+ */
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, __u32 len,
+		  __u8 proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+static inline u16 udp_csum(u32 saddr, u32 daddr, u32 len,
+			   u8 proto, u16 *udp_pkt)
+{
+	u32 csum = 0;
+	u32 cnt = 0;
+
+	/* udp hdr and data */
+	for (; cnt < len; cnt += 2)
+		csum += udp_pkt[cnt >> 1];
+
+	return csum_tcpudp_magic(saddr, daddr, len, proto, csum);
+}
+
+#define ETH_FCS_SIZE 4
+
+#define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
+		      sizeof(struct udphdr))
+
+#define PKT_SIZE		(opt_pkt_size - ETH_FCS_SIZE)
+#define IP_PKT_SIZE		(PKT_SIZE - sizeof(struct ethhdr))
+#define UDP_PKT_SIZE		(IP_PKT_SIZE - sizeof(struct iphdr))
+#define UDP_PKT_DATA_SIZE	(UDP_PKT_SIZE - sizeof(struct udphdr))
+
+static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
+
+static void gen_eth_hdr_data(void)
+{
+	struct udphdr *udp_hdr = (struct udphdr *)(pkt_data +
+						   sizeof(struct ethhdr) +
+						   sizeof(struct iphdr));
+	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data +
+						sizeof(struct ethhdr));
+	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
+
+	/* ethernet header */
+	memcpy(eth_hdr->h_dest, "\x3c\xfd\xfe\x9e\x7f\x71", ETH_ALEN);
+	memcpy(eth_hdr->h_source, "\xec\xb1\xd7\x98\x3a\xc0", ETH_ALEN);
+	eth_hdr->h_proto = htons(ETH_P_IP);
+
+	/* IP header */
+	ip_hdr->version = IPVERSION;
+	ip_hdr->ihl = 0x5; /* 20 byte header */
+	ip_hdr->tos = 0x0;
+	ip_hdr->tot_len = htons(IP_PKT_SIZE);
+	ip_hdr->id = 0;
+	ip_hdr->frag_off = 0;
+	ip_hdr->ttl = IPDEFTTL;
+	ip_hdr->protocol = IPPROTO_UDP;
+	ip_hdr->saddr = htonl(0x0a0a0a10);
+	ip_hdr->daddr = htonl(0x0a0a0a20);
+
+	/* IP header checksum */
+	ip_hdr->check = 0;
+	ip_hdr->check = ip_fast_csum((const void *)ip_hdr, ip_hdr->ihl);
+
+	/* UDP header */
+	udp_hdr->source = htons(0x1000);
+	udp_hdr->dest = htons(0x1000);
+	udp_hdr->len = htons(UDP_PKT_SIZE);
+
+	/* UDP data */
+	memset32_htonl(pkt_data + PKT_HDR_SIZE, pkt_fill_pattern,
+		       UDP_PKT_DATA_SIZE);
+
+	/* UDP header checksum */
+	udp_hdr->check = 0;
+	udp_hdr->check = udp_csum(ip_hdr->saddr, ip_hdr->daddr, UDP_PKT_SIZE,
+				  IPPROTO_UDP, (u16 *)udp_hdr);
+}
+
 static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 {
 	memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data,
-	       sizeof(pkt_data) - 1);
+	       PKT_SIZE);
 }
 
 static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
@@ -394,6 +629,7 @@ static struct option long_options[] = {
 	{"duration", required_argument, 0, 'd'},
 	{"batch-size", required_argument, 0, 'b'},
 	{"tx-pkt-count", required_argument, 0, 'C'},
+	{"tx-pkt-size", required_argument, 0, 's'},
 	{0, 0, 0, 0}
 };
 
@@ -424,9 +660,14 @@ static void usage(const char *prog)
 		"			packets. Default: %d\n"
 		"  -C, --tx-pkt-count=n	Number of packets to send.\n"
 		"			Default: Continuous packets.\n"
+		"  -s, --tx-pkt-size=n	Transmit packet size.\n"
+		"			(Default: %d bytes)\n"
+		"			Min size: %d, Max size %d.\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
-		opt_batch_size);
+		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
+		XSK_UMEM__DEFAULT_FRAME_SIZE);
+
 	exit(EXIT_FAILURE);
 }
 
@@ -437,7 +678,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -505,6 +746,16 @@ static void parse_command_line(int argc, char **argv)
 		case 'C':
 			opt_pkt_count = atoi(optarg);
 			break;
+		case 's':
+			opt_pkt_size = atoi(optarg);
+			if (opt_pkt_size > (XSK_UMEM__DEFAULT_FRAME_SIZE) ||
+			    opt_pkt_size < MIN_PKT_SIZE) {
+				fprintf(stderr,
+					"ERROR: Invalid frame size %d\n",
+					opt_pkt_size);
+				usage(basename(argv[0]));
+			}
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -679,7 +930,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch_size)
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
 								  idx + i);
 		tx_desc->addr = (frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
-		tx_desc->len = sizeof(pkt_data) - 1;
+		tx_desc->len = PKT_SIZE;
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
@@ -916,9 +1167,12 @@ int main(int argc, char **argv)
 	for (i = 0; i < opt_num_xsks; i++)
 		xsks[num_socks++] = xsk_configure_socket(umem, rx, tx);
 
-	if (opt_bench == BENCH_TXONLY)
+	if (opt_bench == BENCH_TXONLY) {
+		gen_eth_hdr_data();
+
 		for (i = 0; i < NUM_FRAMES; i++)
 			gen_eth_frame(umem, i * opt_xsk_frame_size);
+	}
 
 	if (opt_num_xsks > 1 && opt_bench != BENCH_TXONLY)
 		enter_xsks_into_map(obj);
-- 
2.17.1

