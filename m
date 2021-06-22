Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0565E3B0A1A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhFVQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhFVQSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 12:18:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3F3C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 09:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=hal1z9SxKv6Or5898ik2qokIUvxAcvlc++PcRsn8RAI=; b=d2gN0AuRkR2veDC0WCjLNvKZkV
        a1gEgoAghuoCxR1C6ouCYp978bMB0LhOu7L0ilkxLDzj2ihePtbfS40+cfht6Fo2XHEOCmyTubIqP
        e+fodIbhc4Ic7sIG0V/etGG0I0uvGMnGEHzdFuQeWqmVw9Ao5bDXETNd6uHGAdoq4HWGIw3vKsts3
        4DOWnsM5yriwyjy/nEQM9oc34ajsVz1/jNtGm0bbGA2q68bNPVHkDXjEFDwG8DSUICLPKlHmr0PjE
        p1EVyKKVrLVGG3wIUFNCY+Uwfj0+TYMwqb5Xrp8rW4lkkcy+58n5Vj/XFMfMm+9N5ue41nrJtU8KD
        p0SGc/7Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvj3m-00ETxg-9C; Tue, 22 Jun 2021 16:15:49 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvj3l-00560J-Qf; Tue, 22 Jun 2021 17:15:33 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH v2 4/4] vhost_net: Add self test with tun device
Date:   Tue, 22 Jun 2021 17:15:33 +0100
Message-Id: <20210622161533.1214662-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622161533.1214662-1-dwmw2@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This creates a tun device and brings it up, then finds out the link-local
address the kernel automatically assigns to it.

It sends a ping to that address, from a fake LL address of its own, and
then waits for a response.

If the virtio_net_hdr stuff is all working correctly, it gets a response
and manages to understand it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/vhost/Makefile        |  16 +
 tools/testing/selftests/vhost/config          |   2 +
 .../testing/selftests/vhost/test_vhost_net.c  | 522 ++++++++++++++++++
 4 files changed, 541 insertions(+)
 create mode 100644 tools/testing/selftests/vhost/Makefile
 create mode 100644 tools/testing/selftests/vhost/config
 create mode 100644 tools/testing/selftests/vhost/test_vhost_net.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6c575cf34a71..300c03cfd0c7 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -71,6 +71,7 @@ TARGETS += user
 TARGETS += vDSO
 TARGETS += vm
 TARGETS += x86
+TARGETS += vhost
 TARGETS += zram
 #Please keep the TARGETS list alphabetically sorted
 # Run "make quicktest=1 run_tests" or
diff --git a/tools/testing/selftests/vhost/Makefile b/tools/testing/selftests/vhost/Makefile
new file mode 100644
index 000000000000..f5e565d80733
--- /dev/null
+++ b/tools/testing/selftests/vhost/Makefile
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+all:
+
+include ../lib.mk
+
+.PHONY: all clean
+
+BINARIES := test_vhost_net
+
+test_vhost_net: test_vhost_net.c ../kselftest.h ../kselftest_harness.h
+	$(CC) $(CFLAGS) -g $< -o $@
+
+TEST_PROGS += $(BINARIES)
+EXTRA_CLEAN := $(BINARIES)
+
+all: $(BINARIES)
diff --git a/tools/testing/selftests/vhost/config b/tools/testing/selftests/vhost/config
new file mode 100644
index 000000000000..6391c1f32c34
--- /dev/null
+++ b/tools/testing/selftests/vhost/config
@@ -0,0 +1,2 @@
+CONFIG_VHOST_NET=y
+CONFIG_TUN=y
diff --git a/tools/testing/selftests/vhost/test_vhost_net.c b/tools/testing/selftests/vhost/test_vhost_net.c
new file mode 100644
index 000000000000..14acf2c0e049
--- /dev/null
+++ b/tools/testing/selftests/vhost/test_vhost_net.c
@@ -0,0 +1,522 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+#include "../kselftest_harness.h"
+#include "../../../virtio/asm/barrier.h"
+
+#include <sys/eventfd.h>
+
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/wait.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <net/if.h>
+#include <sys/socket.h>
+
+#include <netinet/tcp.h>
+#include <netinet/ip.h>
+#include <netinet/ip_icmp.h>
+#include <netinet/ip6.h>
+#include <netinet/icmp6.h>
+
+#include <linux/if_tun.h>
+#include <linux/virtio_net.h>
+#include <linux/vhost.h>
+
+static unsigned char hexnybble(char hex)
+{
+	switch (hex) {
+	case '0'...'9':
+		return hex - '0';
+	case 'a'...'f':
+		return 10 + hex - 'a';
+	case 'A'...'F':
+		return 10 + hex - 'A';
+	default:
+		exit (KSFT_SKIP);
+	}
+}
+
+static unsigned char hexchar(char *hex)
+{
+	return (hexnybble(hex[0]) << 4) | hexnybble(hex[1]);
+}
+
+int open_tun(int vnet_hdr_sz, struct in6_addr *addr)
+{
+	int tun_fd = open("/dev/net/tun", O_RDWR);
+	if (tun_fd == -1)
+		return -1;
+
+	struct ifreq ifr = { 0 };
+
+	ifr.ifr_flags = IFF_TUN | IFF_NO_PI;
+	if (vnet_hdr_sz)
+		ifr.ifr_flags |= IFF_VNET_HDR;
+
+	if (ioctl(tun_fd, TUNSETIFF, (void *)&ifr) < 0)
+		goto out_tun;
+
+	if (vnet_hdr_sz &&
+	    ioctl(tun_fd, TUNSETVNETHDRSZ, &vnet_hdr_sz) < 0)
+		goto out_tun;
+
+	int sockfd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_IP);
+	if (sockfd == -1)
+		goto out_tun;
+
+	if (ioctl(sockfd, SIOCGIFFLAGS, (void *)&ifr) < 0)
+		goto out_sock;
+
+	ifr.ifr_flags |= IFF_UP;
+	if (ioctl(sockfd, SIOCSIFFLAGS, (void *)&ifr) < 0)
+		goto out_sock;
+
+	close(sockfd);
+
+	FILE *inet6 = fopen("/proc/net/if_inet6", "r");
+	if (!inet6)
+		goto out_tun;
+
+	char buf[80];
+	while (fgets(buf, sizeof(buf), inet6)) {
+		size_t len = strlen(buf), namelen = strlen(ifr.ifr_name);
+		if (!strncmp(buf, "fe80", 4) &&
+		    buf[len - namelen - 2] == ' ' &&
+		    !strncmp(buf + len - namelen - 1, ifr.ifr_name, namelen)) {
+			for (int i = 0; i < 16; i++) {
+				addr->s6_addr[i] = hexchar(buf + i*2);
+			}
+			fclose(inet6);
+			return tun_fd;
+		}
+	}
+	/* Not found */
+	fclose(inet6);
+ out_sock:
+	close(sockfd);
+ out_tun:
+	close(tun_fd);
+	return -1;
+}
+
+#define RING_SIZE 32
+#define RING_MASK(x) ((x) & (RING_SIZE-1))
+
+struct pkt_buf {
+	unsigned char data[2048];
+};
+
+struct test_vring {
+	struct vring_desc desc[RING_SIZE];
+	struct vring_avail avail;
+	__virtio16 avail_ring[RING_SIZE];
+	struct vring_used used;
+	struct vring_used_elem used_ring[RING_SIZE];
+	struct pkt_buf pkts[RING_SIZE];
+} rings[2];
+
+static int setup_vring(int vhost_fd, int tun_fd, int call_fd, int kick_fd, int idx)
+{
+	struct test_vring *vring = &rings[idx];
+	int ret;
+
+	memset(vring, 0, sizeof(vring));
+
+	struct vhost_vring_state vs = { };
+	vs.index = idx;
+	vs.num = RING_SIZE;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_NUM, &vs) < 0) {
+		perror("VHOST_SET_VRING_NUM");
+		return -1;
+	}
+
+	vs.num = 0;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_BASE, &vs) < 0) {
+		perror("VHOST_SET_VRING_BASE");
+		return -1;
+	}
+
+	struct vhost_vring_addr va = { };
+	va.index = idx;
+	va.desc_user_addr = (uint64_t)vring->desc;
+	va.avail_user_addr = (uint64_t)&vring->avail;
+	va.used_user_addr  = (uint64_t)&vring->used;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_ADDR, &va) < 0) {
+		perror("VHOST_SET_VRING_ADDR");
+		return -1;
+	}
+
+	struct vhost_vring_file vf = { };
+	vf.index = idx;
+	vf.fd = tun_fd;
+	if (ioctl(vhost_fd, VHOST_NET_SET_BACKEND, &vf) < 0) {
+		perror("VHOST_NET_SET_BACKEND");
+		return -1;
+	}
+
+	vf.fd = call_fd;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_CALL, &vf) < 0) {
+		perror("VHOST_SET_VRING_CALL");
+		return -1;
+	}
+
+	vf.fd = kick_fd;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_KICK, &vf) < 0) {
+		perror("VHOST_SET_VRING_KICK");
+		return -1;
+	}
+
+	return 0;
+}
+
+int setup_vhost(int vhost_fd, int tun_fd, int call_fd, int kick_fd, uint64_t want_features)
+{
+	int ret;
+
+	if (ioctl(vhost_fd, VHOST_SET_OWNER, NULL) < 0) {
+		perror("VHOST_SET_OWNER");
+		return -1;
+	}
+
+	uint64_t features;
+	if (ioctl(vhost_fd, VHOST_GET_FEATURES, &features) < 0) {
+		perror("VHOST_GET_FEATURES");
+		return -1;
+	}
+
+	if ((features & want_features) != want_features)
+		return KSFT_SKIP;
+
+	if (ioctl(vhost_fd, VHOST_SET_FEATURES, &want_features) < 0) {
+		perror("VHOST_SET_FEATURES");
+		return -1;
+	}
+
+	struct vhost_memory *vmem = alloca(sizeof(*vmem) + sizeof(vmem->regions[0]));
+
+	memset(vmem, 0, sizeof(*vmem) + sizeof(vmem->regions[0]));
+	vmem->nregions = 1;
+	/*
+	 * I just want to map the *whole* of userspace address space. But
+	 * from userspace I don't know what that is. On x86_64 it would be:
+	 *
+	 * vmem->regions[0].guest_phys_addr = 4096;
+	 * vmem->regions[0].memory_size = 0x7fffffffe000;
+	 * vmem->regions[0].userspace_addr = 4096;
+	 *
+	 * For now, just ensure we put everything inside a single BSS region.
+	 */
+	vmem->regions[0].guest_phys_addr = (uint64_t)&rings;
+	vmem->regions[0].userspace_addr = (uint64_t)&rings;
+	vmem->regions[0].memory_size = sizeof(rings);
+
+	if (ioctl(vhost_fd, VHOST_SET_MEM_TABLE, vmem) < 0) {
+		perror("VHOST_SET_MEM_TABLE");
+		return -1;
+	}
+
+	if (setup_vring(vhost_fd, tun_fd, call_fd, kick_fd, 0))
+		return -1;
+
+	if (setup_vring(vhost_fd, tun_fd, call_fd, kick_fd, 1))
+		return -1;
+
+	return 0;
+}
+
+
+static char ping_payload[16] = "VHOST TEST PACKT";
+
+static inline uint32_t csum_partial(uint16_t *buf, int nwords)
+{
+	uint32_t sum = 0;
+	for(sum=0; nwords>0; nwords--)
+		sum += ntohs(*buf++);
+	return sum;
+}
+
+static inline uint16_t csum_finish(uint32_t sum)
+{
+	sum = (sum >> 16) + (sum &0xffff);
+	sum += (sum >> 16);
+	return htons((uint16_t)(~sum));
+}
+
+static int create_icmp_echo(unsigned char *data, struct in6_addr *dst,
+			    struct in6_addr *src, uint16_t id, uint16_t seq)
+{
+	const int icmplen = ICMP_MINLEN + sizeof(ping_payload);
+	const int plen = sizeof(struct ip6_hdr) + icmplen;
+
+	struct ip6_hdr *iph = (void *)data;
+	struct icmp6_hdr *icmph = (void *)(data + sizeof(*iph));
+
+	/* IPv6 Header */
+	iph->ip6_flow = htonl((6 << 28) + /* version 6 */
+			      (0 << 20) + /* traffic class */
+			      (0 << 0));  /* flow ID  */
+	iph->ip6_nxt = IPPROTO_ICMPV6;
+	iph->ip6_plen = htons(icmplen);
+	iph->ip6_hlim = 128;
+	iph->ip6_src = *src;
+	iph->ip6_dst = *dst;
+
+	/* ICMPv6 echo request */
+	icmph->icmp6_type = ICMP6_ECHO_REQUEST;
+	icmph->icmp6_code = 0;
+	icmph->icmp6_data16[0] = htons(id);	/* ID */
+	icmph->icmp6_data16[1] = htons(seq);	/* sequence */
+
+	/* Some arbitrary payload */
+	memcpy(&icmph[1], ping_payload, sizeof(ping_payload));
+
+	/*
+	 * IPv6 upper-layer checksums include a pseudo-header
+	 * for IPv6 which contains the source address, the
+	 * destination address, the upper-layer packet length
+	 * and next-header field. See RFC8200 §8.1. The
+	 * checksum is as follows:
+	 *
+	 *   checksum 32 bytes of real IPv6 header:
+	 *     src addr (16 bytes)
+	 *     dst addr (16 bytes)
+	 *   8 bytes more:
+	 *     length of ICMPv6 in bytes (be32)
+	 *     3 bytes of 0
+	 *     next header byte (IPPROTO_ICMPV6)
+	 *   Then the actual ICMPv6 bytes
+	 */
+	uint32_t sum = csum_partial((uint16_t *)&iph->ip6_src, 8);      /* 8 uint16_t */
+	sum += csum_partial((uint16_t *)&iph->ip6_dst, 8);              /* 8 uint16_t */
+
+	/* The easiest way to checksum the following 8-byte
+	 * part of the pseudo-header without horridly violating
+	 * C type aliasing rules is *not* to build it in memory
+	 * at all. We know the length fits in 16 bits so the
+	 * partial checksum of 00 00 LL LL 00 00 00 NH ends up
+	 * being just LLLL + NH.
+	 */
+	sum += IPPROTO_ICMPV6;
+	sum += ICMP_MINLEN + sizeof(ping_payload);
+
+	sum += csum_partial((uint16_t *)icmph, icmplen / 2);
+	icmph->icmp6_cksum = csum_finish(sum);
+	return plen;
+}
+
+
+static int check_icmp_response(unsigned char *data, uint32_t len, struct in6_addr *dst, struct in6_addr *src)
+{
+	struct ip6_hdr *iph = (void *)data;
+	return ( len >= 41 && (ntohl(iph->ip6_flow) >> 28)==6 /* IPv6 header */
+		 && iph->ip6_nxt == IPPROTO_ICMPV6 /* IPv6 next header field = ICMPv6 */
+		 && !memcmp(&iph->ip6_src, src, 16) /* source == magic address */
+		 && !memcmp(&iph->ip6_dst, dst, 16) /* source == magic address */
+		 && len >= 40 + ICMP_MINLEN + sizeof(ping_payload) /* No short-packet segfaults */
+		 && data[40] == ICMP6_ECHO_REPLY /* ICMPv6 reply */
+		 && !memcmp(&data[40 + ICMP_MINLEN], ping_payload, sizeof(ping_payload)) /* Same payload in response */
+		 );
+
+}
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define vio16(x) (x)
+#define vio32(x) (x)
+#define vio64(x) (x)
+#else
+#define vio16(x) __builtin_bswap16(x)
+#define vio32(x) __builtin_bswap32(x)
+#define vio64(x) __builtin_bswap64(x)
+#endif
+
+
+int test_vhost(int vnet_hdr_sz, int xdp, uint64_t features)
+{
+	int call_fd = eventfd(0, EFD_CLOEXEC|EFD_NONBLOCK);
+	int kick_fd = eventfd(0, EFD_CLOEXEC|EFD_NONBLOCK);
+	int vhost_fd = open("/dev/vhost-net", O_RDWR);
+	int tun_fd = -1;
+	int ret = KSFT_SKIP;
+
+	if (call_fd < 0 || kick_fd < 0 || vhost_fd < 0)
+		goto err;
+
+	memset(rings, 0, sizeof(rings));
+
+	/* Pick up the link-local address that the kernel
+	 * assigns to the tun device. */
+	struct in6_addr tun_addr;
+	tun_fd = open_tun(vnet_hdr_sz, &tun_addr);
+	if (tun_fd < 0)
+		goto err;
+
+	if (features & (1ULL << VHOST_NET_F_VIRTIO_NET_HDR)) {
+		if (vnet_hdr_sz) {
+			ret = -1;
+			goto err;
+		}
+
+		vnet_hdr_sz = (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
+					   (1ULL << VIRTIO_F_VERSION_1))) ?
+			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
+			sizeof(struct virtio_net_hdr);
+	}
+
+	if (!xdp) {
+		int sndbuf = RING_SIZE * 2048;
+		if (ioctl(tun_fd, TUNSETSNDBUF, &sndbuf) < 0) {
+			perror("TUNSETSNDBUF");
+			ret = -1;
+			goto err;
+		}
+	}
+
+	ret = setup_vhost(vhost_fd, tun_fd, call_fd, kick_fd, features);
+	if (ret)
+		goto err;
+
+	/* A fake link-local address for the userspace end */
+	struct in6_addr local_addr = { 0 };
+	local_addr.s6_addr16[0] = htons(0xfe80);
+	local_addr.s6_addr16[7] = htons(1);
+
+	/* Set up RX and TX descriptors; the latter with ping packets ready to
+	 * send to the kernel, but don't actually send them yet. */
+	for (int i = 0; i < RING_SIZE; i++) {
+		struct pkt_buf *pkt = &rings[1].pkts[i];
+		int plen = create_icmp_echo(&pkt->data[vnet_hdr_sz], &tun_addr,
+					    &local_addr, 0x4747, i);
+
+		rings[1].desc[i].addr = vio64((uint64_t)pkt);
+		rings[1].desc[i].len = vio32(plen + vnet_hdr_sz);
+		rings[1].avail_ring[i] = vio16(i);
+
+
+		pkt = &rings[0].pkts[i];
+		rings[0].desc[i].addr = vio64((uint64_t)pkt);
+		rings[0].desc[i].len = vio32(sizeof(*pkt));
+		rings[0].desc[i].flags = vio16(VRING_DESC_F_WRITE);
+		rings[0].avail_ring[i] = vio16(i);
+	}
+	barrier();
+
+	rings[0].avail.idx = RING_SIZE;
+	rings[1].avail.idx = vio16(1);
+
+	barrier();
+	eventfd_write(kick_fd, 1);
+
+	uint16_t rx_seen_used = 0;
+	struct timeval tv = { 1, 0 };
+	while (1) {
+		fd_set rfds = { 0 };
+		FD_SET(call_fd, &rfds);
+
+		if (select(call_fd + 1, &rfds, NULL, NULL, &tv) <= 0) {
+			ret = -1;
+			goto err;
+		}
+
+		uint16_t rx_used_idx = vio16(rings[0].used.idx);
+		barrier();
+
+		while(rx_used_idx != rx_seen_used) {
+			uint32_t desc = vio32(rings[0].used_ring[RING_MASK(rx_seen_used)].id);
+			uint32_t len  = vio32(rings[0].used_ring[RING_MASK(rx_seen_used)].len);
+
+			if (desc >= RING_SIZE || len < vnet_hdr_sz)
+				return -1;
+
+			uint64_t addr = vio64(rings[0].desc[desc].addr);
+			if (!addr)
+				return -1;
+
+			if (check_icmp_response((void *)(addr + vnet_hdr_sz), len - vnet_hdr_sz,
+						&local_addr, &tun_addr)) {
+				ret = 0;
+				printf("Success (%d %d %llx)\n", vnet_hdr_sz, xdp, (unsigned long long)features);
+				goto err;
+			}
+			rx_seen_used++;
+
+			/* Give the same buffer back */
+			rings[0].avail.idx = vio16(rx_seen_used + RING_SIZE);
+			barrier();
+			eventfd_write(kick_fd, 1);
+		}
+
+		uint64_t ev_val;
+		eventfd_read(call_fd, &ev_val);
+	}
+
+ err:
+	if (call_fd != -1)
+		close(call_fd);
+	if (kick_fd != -1)
+		close(kick_fd);
+	if (vhost_fd != -1)
+		close(vhost_fd);
+	if (tun_fd != -1)
+		close(tun_fd);
+
+	return ret;
+}
+
+
+int main(void)
+{
+	int ret;
+
+	ret = test_vhost(0, 0, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
+				(1ULL << VIRTIO_F_VERSION_1)));
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+	ret = test_vhost(0, 1, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
+				(1ULL << VIRTIO_F_VERSION_1)));
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+	ret = test_vhost(0, 0, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR)));
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+	ret = test_vhost(0, 1, ((1ULL << VHOST_NET_F_VIRTIO_NET_HDR)));
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+	ret = test_vhost(10, 0, 0);
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+	ret = test_vhost(10, 1, 0);
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+#if 0 /* These ones will fail */
+	ret = test_vhost(0, 0, 0);
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+	ret = test_vhost(0, 1, 0);
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+	ret = test_vhost(12, 0, 0);
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+
+	ret = test_vhost(12, 1, 0);
+	if (ret && ret != KSFT_SKIP)
+		return ret;
+#endif
+
+	return ret;
+}
-- 
2.31.1

