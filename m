Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4665855ED6B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbiF1TBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiF1TAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:37 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CD92BB02;
        Tue, 28 Jun 2022 12:00:28 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id cf14so18904716edb.8;
        Tue, 28 Jun 2022 12:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3wM+AAPg0fMa6Fj0T71qjnkW5yN4Xjg32c+zeSafwBs=;
        b=PHSfZerw82V4+1DQTeiMISRQ9mIWdIE4OM6Me9pIAzN/y5UfzqumbtiwzOwFPqhxzC
         bP/uyZ99M9AHuAoZipAavRa1zIwPGcicvOpE9n2fGIH+OeNVGouKeONEvUuWIvdG2T/+
         EP+4zj9Ummc+p636HT8P7khy8FPaMiL0j6wNfBJNtiVRy3hXH7dQGU2fTpO+EliUZXUd
         XI8tu96X+gSbA+PJSuDJPIhBcnWsYUu7Yv5NgUvl/fd/M+K9I+oq6WFAVPdtEIMxxc0Q
         xKK0+rElC/e3h0uGBomk/nN/rH6lWdS6adN7v3XBFrcd0C//7X6H6umGA5jWQe2BEFyd
         19Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3wM+AAPg0fMa6Fj0T71qjnkW5yN4Xjg32c+zeSafwBs=;
        b=3F+XYOAHCQCc/wBJjNmHWTaLIoeCtX2xhI6KJXk/blFL7vrkGNYFoyqMTs5khyxAZZ
         si46TVr9mFLohgjo6jwYLlKDv085ptdgPljGqczXBdIEwC0msYYERp4xC37qSsuMk592
         5SB4baZM5efsPgq5To7DCTBIAvhBgr2JqejyzswupQXhQaCAc2NZLk6UAo2WRwTrWWL6
         Np6CCpBHBSurDOc8evKqwQu+7OmUjnXCJ+hnkn3blCnLnYCUEesNYlbRZ1rC5htsBzrb
         0IMOrszAwP4nJxKuAJOntRgdtPY3aoifCEnjBLCWVXx5SH6s+H9rchy+qs7hXJ7OO6nF
         o8Ag==
X-Gm-Message-State: AJIora+cN0wHGtK+Itctzfy2bFFPoCO+2Y8YZoe9IOV54njZ2zkyqYCc
        jterDqXYu0sOtAHEN4H6e8t7r6KUH5VVew==
X-Google-Smtp-Source: AGRyM1tAeHOF38BE2E3VpdvoBLjtyJKFDrp4p6AX6fn4bp2xtPdH1n1HDBEYcXB8zH8n8qP4ZFJ0Eg==
X-Received: by 2002:a05:6402:400c:b0:437:d11f:f7d3 with SMTP id d12-20020a056402400c00b00437d11ff7d3mr153788eda.256.1656442827246;
        Tue, 28 Jun 2022 12:00:27 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 29/29] selftests/io_uring: test zerocopy send
Date:   Tue, 28 Jun 2022 19:56:51 +0100
Message-Id: <6dd1916dfb3c474e951ea83895ce41778dd1e508.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests for io_uring zerocopy sends and io_uring's notification
infrastructure. It's largely influenced by msg_zerocopy and uses it on
the receive side.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 605 ++++++++++++++++++
 .../selftests/net/io_uring_zerocopy_tx.sh     | 131 ++++
 3 files changed, 737 insertions(+)
 create mode 100644 tools/testing/selftests/net/io_uring_zerocopy_tx.c
 create mode 100755 tools/testing/selftests/net/io_uring_zerocopy_tx.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 464df13831f2..f33a626220eb 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -60,6 +60,7 @@ TEST_GEN_FILES += cmsg_sender
 TEST_GEN_FILES += stress_reuseport_listen
 TEST_PROGS += test_vxlan_vnifiltering.sh
 TEST_GEN_FILES += bind_bhash_test
+TEST_GEN_FILES += io_uring_zerocopy_tx
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.c b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
new file mode 100644
index 000000000000..899ddc84f8a9
--- /dev/null
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
@@ -0,0 +1,605 @@
+/* SPDX-License-Identifier: MIT */
+/* based on linux-kernel/tools/testing/selftests/net/msg_zerocopy.c */
+#include <assert.h>
+#include <errno.h>
+#include <error.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <arpa/inet.h>
+#include <linux/errqueue.h>
+#include <linux/if_packet.h>
+#include <linux/io_uring.h>
+#include <linux/ipv6.h>
+#include <linux/socket.h>
+#include <linux/sockios.h>
+#include <net/ethernet.h>
+#include <net/if.h>
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+#include <netinet/udp.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/resource.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/un.h>
+#include <sys/wait.h>
+
+#define NOTIF_TAG 0xfffffffULL
+#define NONZC_TAG 0
+#define ZC_TAG 1
+
+enum {
+	MODE_NONZC	= 0,
+	MODE_ZC		= 1,
+	MODE_ZC_FIXED	= 2,
+	MODE_MIXED	= 3,
+};
+
+static bool cfg_flush		= false;
+static bool cfg_cork		= false;
+static int  cfg_mode		= MODE_ZC_FIXED;
+static int  cfg_nr_reqs		= 8;
+static int  cfg_family		= PF_UNSPEC;
+static int  cfg_payload_len;
+static int  cfg_port		= 8000;
+static int  cfg_runtime_ms	= 4200;
+
+static socklen_t cfg_alen;
+static struct sockaddr_storage cfg_dst_addr;
+
+static char payload[IP_MAXPACKET] __attribute__((aligned(4096)));
+
+struct io_sq_ring {
+	unsigned *head;
+	unsigned *tail;
+	unsigned *ring_mask;
+	unsigned *ring_entries;
+	unsigned *flags;
+	unsigned *array;
+};
+
+struct io_cq_ring {
+	unsigned *head;
+	unsigned *tail;
+	unsigned *ring_mask;
+	unsigned *ring_entries;
+	struct io_uring_cqe *cqes;
+};
+
+struct io_uring_sq {
+	unsigned *khead;
+	unsigned *ktail;
+	unsigned *kring_mask;
+	unsigned *kring_entries;
+	unsigned *kflags;
+	unsigned *kdropped;
+	unsigned *array;
+	struct io_uring_sqe *sqes;
+
+	unsigned sqe_head;
+	unsigned sqe_tail;
+
+	size_t ring_sz;
+};
+
+struct io_uring_cq {
+	unsigned *khead;
+	unsigned *ktail;
+	unsigned *kring_mask;
+	unsigned *kring_entries;
+	unsigned *koverflow;
+	struct io_uring_cqe *cqes;
+
+	size_t ring_sz;
+};
+
+struct io_uring {
+	struct io_uring_sq sq;
+	struct io_uring_cq cq;
+	int ring_fd;
+};
+
+#ifdef __alpha__
+# ifndef __NR_io_uring_setup
+#  define __NR_io_uring_setup		535
+# endif
+# ifndef __NR_io_uring_enter
+#  define __NR_io_uring_enter		536
+# endif
+# ifndef __NR_io_uring_register
+#  define __NR_io_uring_register	537
+# endif
+#else /* !__alpha__ */
+# ifndef __NR_io_uring_setup
+#  define __NR_io_uring_setup		425
+# endif
+# ifndef __NR_io_uring_enter
+#  define __NR_io_uring_enter		426
+# endif
+# ifndef __NR_io_uring_register
+#  define __NR_io_uring_register	427
+# endif
+#endif
+
+#if defined(__x86_64) || defined(__i386__)
+#define read_barrier()	__asm__ __volatile__("":::"memory")
+#define write_barrier()	__asm__ __volatile__("":::"memory")
+#else
+
+#define read_barrier()	__sync_synchronize()
+#define write_barrier()	__sync_synchronize()
+#endif
+
+static int io_uring_setup(unsigned int entries, struct io_uring_params *p)
+{
+	return syscall(__NR_io_uring_setup, entries, p);
+}
+
+static int io_uring_enter(int fd, unsigned int to_submit,
+			  unsigned int min_complete,
+			  unsigned int flags, sigset_t *sig)
+{
+	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
+			flags, sig, _NSIG / 8);
+}
+
+static int io_uring_register_buffers(struct io_uring *ring,
+				     const struct iovec *iovecs,
+				     unsigned nr_iovecs)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_register, ring->ring_fd,
+		      IORING_REGISTER_BUFFERS, iovecs, nr_iovecs);
+	return (ret < 0) ? -errno : ret;
+}
+
+static int io_uring_register_notifications(struct io_uring *ring,
+					   unsigned nr,
+					   struct io_uring_notification_slot *slots)
+{
+	int ret;
+	struct io_uring_notification_register r = {
+		.nr_slots = nr,
+		.data = (unsigned long)slots,
+	};
+
+	ret = syscall(__NR_io_uring_register, ring->ring_fd,
+		      IORING_REGISTER_NOTIFIERS, &r, sizeof(r));
+	return (ret < 0) ? -errno : ret;
+}
+
+static int io_uring_mmap(int fd, struct io_uring_params *p,
+			 struct io_uring_sq *sq, struct io_uring_cq *cq)
+{
+	size_t size;
+	void *ptr;
+	int ret;
+
+	sq->ring_sz = p->sq_off.array + p->sq_entries * sizeof(unsigned);
+	ptr = mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
+		   MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQ_RING);
+	if (ptr == MAP_FAILED)
+		return -errno;
+	sq->khead = ptr + p->sq_off.head;
+	sq->ktail = ptr + p->sq_off.tail;
+	sq->kring_mask = ptr + p->sq_off.ring_mask;
+	sq->kring_entries = ptr + p->sq_off.ring_entries;
+	sq->kflags = ptr + p->sq_off.flags;
+	sq->kdropped = ptr + p->sq_off.dropped;
+	sq->array = ptr + p->sq_off.array;
+
+	size = p->sq_entries * sizeof(struct io_uring_sqe);
+	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
+			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQES);
+	if (sq->sqes == MAP_FAILED) {
+		ret = -errno;
+err:
+		munmap(sq->khead, sq->ring_sz);
+		return ret;
+	}
+
+	cq->ring_sz = p->cq_off.cqes + p->cq_entries * sizeof(struct io_uring_cqe);
+	ptr = mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
+			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_CQ_RING);
+	if (ptr == MAP_FAILED) {
+		ret = -errno;
+		munmap(sq->sqes, p->sq_entries * sizeof(struct io_uring_sqe));
+		goto err;
+	}
+	cq->khead = ptr + p->cq_off.head;
+	cq->ktail = ptr + p->cq_off.tail;
+	cq->kring_mask = ptr + p->cq_off.ring_mask;
+	cq->kring_entries = ptr + p->cq_off.ring_entries;
+	cq->koverflow = ptr + p->cq_off.overflow;
+	cq->cqes = ptr + p->cq_off.cqes;
+	return 0;
+}
+
+static int io_uring_queue_init(unsigned entries, struct io_uring *ring,
+			       unsigned flags)
+{
+	struct io_uring_params p;
+	int fd, ret;
+
+	memset(ring, 0, sizeof(*ring));
+	memset(&p, 0, sizeof(p));
+	p.flags = flags;
+
+	fd = io_uring_setup(entries, &p);
+	if (fd < 0)
+		return fd;
+	ret = io_uring_mmap(fd, &p, &ring->sq, &ring->cq);
+	if (!ret)
+		ring->ring_fd = fd;
+	else
+		close(fd);
+	return ret;
+}
+
+static int io_uring_submit(struct io_uring *ring)
+{
+	struct io_uring_sq *sq = &ring->sq;
+	const unsigned mask = *sq->kring_mask;
+	unsigned ktail, submitted, to_submit;
+	int ret;
+
+	read_barrier();
+	if (*sq->khead != *sq->ktail) {
+		submitted = *sq->kring_entries;
+		goto submit;
+	}
+	if (sq->sqe_head == sq->sqe_tail)
+		return 0;
+
+	ktail = *sq->ktail;
+	to_submit = sq->sqe_tail - sq->sqe_head;
+	for (submitted = 0; submitted < to_submit; submitted++) {
+		read_barrier();
+		sq->array[ktail++ & mask] = sq->sqe_head++ & mask;
+	}
+	if (!submitted)
+		return 0;
+
+	if (*sq->ktail != ktail) {
+		write_barrier();
+		*sq->ktail = ktail;
+		write_barrier();
+	}
+submit:
+	ret = io_uring_enter(ring->ring_fd, submitted, 0,
+				IORING_ENTER_GETEVENTS, NULL);
+	return ret < 0 ? -errno : ret;
+}
+
+static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
+				      const void *buf, size_t len, int flags)
+{
+	memset(sqe, 0, sizeof(*sqe));
+	sqe->opcode = (__u8) IORING_OP_SEND;
+	sqe->fd = sockfd;
+	sqe->addr = (unsigned long) buf;
+	sqe->len = len;
+	sqe->msg_flags = (__u32) flags;
+}
+
+static inline void io_uring_prep_sendzc(struct io_uring_sqe *sqe, int sockfd,
+				        const void *buf, size_t len, int flags,
+				        unsigned slot_idx, unsigned zc_flags)
+{
+	io_uring_prep_send(sqe, sockfd, buf, len, flags);
+	sqe->opcode = (__u8) IORING_OP_SENDZC;
+	sqe->notification_idx = slot_idx;
+	sqe->ioprio = zc_flags;
+}
+
+static struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
+{
+	struct io_uring_sq *sq = &ring->sq;
+
+	if (sq->sqe_tail + 1 - sq->sqe_head > *sq->kring_entries)
+		return NULL;
+	return &sq->sqes[sq->sqe_tail++ & *sq->kring_mask];
+}
+
+static int io_uring_wait_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr)
+{
+	struct io_uring_cq *cq = &ring->cq;
+	const unsigned mask = *cq->kring_mask;
+	unsigned head = *cq->khead;
+	int ret;
+
+	*cqe_ptr = NULL;
+	do {
+		read_barrier();
+		if (head != *cq->ktail) {
+			*cqe_ptr = &cq->cqes[head & mask];
+			break;
+		}
+		ret = io_uring_enter(ring->ring_fd, 0, 1,
+					IORING_ENTER_GETEVENTS, NULL);
+		if (ret < 0)
+			return -errno;
+	} while (1);
+
+	return 0;
+}
+
+static inline void io_uring_cqe_seen(struct io_uring *ring)
+{
+	*(&ring->cq)->khead += 1;
+	write_barrier();
+}
+
+static unsigned long gettimeofday_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
+}
+
+static void do_setsockopt(int fd, int level, int optname, int val)
+{
+	if (setsockopt(fd, level, optname, &val, sizeof(val)))
+		error(1, errno, "setsockopt %d.%d: %d", level, optname, val);
+}
+
+static int do_setup_tx(int domain, int type, int protocol)
+{
+	int fd;
+
+	fd = socket(domain, type, protocol);
+	if (fd == -1)
+		error(1, errno, "socket t");
+
+	do_setsockopt(fd, SOL_SOCKET, SO_SNDBUF, 1 << 21);
+
+	if (connect(fd, (void *) &cfg_dst_addr, cfg_alen))
+		error(1, errno, "connect");
+	return fd;
+}
+
+static void do_tx(int domain, int type, int protocol)
+{
+	struct io_uring_notification_slot b[1] = {{.tag = NOTIF_TAG}};
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	unsigned long packets = 0, bytes = 0;
+	struct io_uring ring;
+	struct iovec iov;
+	uint64_t tstop;
+	int i, fd, ret;
+	int compl_cqes = 0;
+
+	fd = do_setup_tx(domain, type, protocol);
+
+	ret = io_uring_queue_init(512, &ring, 0);
+	if (ret)
+		error(1, ret, "io_uring: queue init");
+
+	ret = io_uring_register_notifications(&ring, 1, b);
+	if (ret)
+		error(1, ret, "io_uring: tx ctx registration");
+
+	iov.iov_base = payload;
+	iov.iov_len = cfg_payload_len;
+
+	ret = io_uring_register_buffers(&ring, &iov, 1);
+	if (ret)
+		error(1, ret, "io_uring: buffer registration");
+
+	tstop = gettimeofday_ms() + cfg_runtime_ms;
+	do {
+		if (cfg_cork)
+			do_setsockopt(fd, IPPROTO_UDP, UDP_CORK, 1);
+
+		for (i = 0; i < cfg_nr_reqs; i++) {
+			unsigned zc_flags = 0;
+			unsigned buf_idx = 0;
+			unsigned slot_idx = 0;
+			unsigned mode = cfg_mode;
+			unsigned msg_flags = 0;
+
+			if (cfg_mode == MODE_MIXED)
+				mode = rand() % 3;
+
+			sqe = io_uring_get_sqe(&ring);
+
+			if (mode == MODE_NONZC) {
+				io_uring_prep_send(sqe, fd, payload,
+						   cfg_payload_len, msg_flags);
+				sqe->user_data = NONZC_TAG;
+			} else {
+				if (cfg_flush) {
+					zc_flags |= IORING_SENDZC_FLUSH;
+					compl_cqes++;
+				}
+				io_uring_prep_sendzc(sqe, fd, payload,
+						     cfg_payload_len,
+						     msg_flags, slot_idx, zc_flags);
+				if (mode == MODE_ZC_FIXED) {
+					sqe->ioprio |= IORING_SENDZC_FIXED_BUF;
+					sqe->buf_index = buf_idx;
+				}
+				sqe->user_data = ZC_TAG;
+			}
+		}
+
+		ret = io_uring_submit(&ring);
+		if (ret != cfg_nr_reqs)
+			error(1, ret, "submit");
+
+		for (i = 0; i < cfg_nr_reqs; i++) {
+			ret = io_uring_wait_cqe(&ring, &cqe);
+			if (ret)
+				error(1, ret, "wait cqe");
+
+			if (cqe->user_data == NOTIF_TAG) {
+				compl_cqes--;
+				i--;
+			} else if (cqe->user_data != NONZC_TAG &&
+				   cqe->user_data != ZC_TAG) {
+				error(1, cqe->res, "invalid user_data");
+			} else if (cqe->res <= 0 && cqe->res != -EAGAIN) {
+				error(1, cqe->res, "send failed");
+			} else {
+				if (cqe->res > 0) {
+					packets++;
+					bytes += cqe->res;
+				}
+				/* failed requests don't flush */
+				if (cfg_flush &&
+				    cqe->res <= 0 &&
+				    cqe->user_data == ZC_TAG)
+					compl_cqes--;
+			}
+			io_uring_cqe_seen(&ring);
+		}
+		if (cfg_cork)
+			do_setsockopt(fd, IPPROTO_UDP, UDP_CORK, 0);
+	} while (gettimeofday_ms() < tstop);
+
+	if (close(fd))
+		error(1, errno, "close");
+
+	fprintf(stderr, "tx=%lu (MB=%lu), tx/s=%lu (MB/s=%lu)\n",
+			packets, bytes >> 20,
+			packets / (cfg_runtime_ms / 1000),
+			(bytes >> 20) / (cfg_runtime_ms / 1000));
+
+	while (compl_cqes) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret)
+			error(1, ret, "wait cqe");
+		io_uring_cqe_seen(&ring);
+		compl_cqes--;
+	}
+}
+
+static void do_test(int domain, int type, int protocol)
+{
+	int i;
+
+	for (i = 0; i < IP_MAXPACKET; i++)
+		payload[i] = 'a' + (i % 26);
+	do_tx(domain, type, protocol);
+}
+
+static void usage(const char *filepath)
+{
+	error(1, 0, "Usage: %s [-f] [-n<N>] [-z0] [-s<payload size>] "
+		    "(-4|-6) [-t<time s>] -D<dst_ip> udp", filepath);
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	const int max_payload_len = sizeof(payload) -
+				    sizeof(struct ipv6hdr) -
+				    sizeof(struct tcphdr) -
+				    40 /* max tcp options */;
+	struct sockaddr_in6 *addr6 = (void *) &cfg_dst_addr;
+	struct sockaddr_in *addr4 = (void *) &cfg_dst_addr;
+	char *daddr = NULL;
+	int c;
+
+	if (argc <= 1)
+		usage(argv[0]);
+	cfg_payload_len = max_payload_len;
+
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:fc:m:")) != -1) {
+		switch (c) {
+		case '4':
+			if (cfg_family != PF_UNSPEC)
+				error(1, 0, "Pass one of -4 or -6");
+			cfg_family = PF_INET;
+			cfg_alen = sizeof(struct sockaddr_in);
+			break;
+		case '6':
+			if (cfg_family != PF_UNSPEC)
+				error(1, 0, "Pass one of -4 or -6");
+			cfg_family = PF_INET6;
+			cfg_alen = sizeof(struct sockaddr_in6);
+			break;
+		case 'D':
+			daddr = optarg;
+			break;
+		case 'p':
+			cfg_port = strtoul(optarg, NULL, 0);
+			break;
+		case 's':
+			cfg_payload_len = strtoul(optarg, NULL, 0);
+			break;
+		case 't':
+			cfg_runtime_ms = 200 + strtoul(optarg, NULL, 10) * 1000;
+			break;
+		case 'n':
+			cfg_nr_reqs = strtoul(optarg, NULL, 0);
+			break;
+		case 'f':
+			cfg_flush = 1;
+			break;
+		case 'c':
+			cfg_cork = strtol(optarg, NULL, 0);
+			break;
+		case 'm':
+			cfg_mode = strtol(optarg, NULL, 0);
+			break;
+		}
+	}
+
+	switch (cfg_family) {
+	case PF_INET:
+		memset(addr4, 0, sizeof(*addr4));
+		addr4->sin_family = AF_INET;
+		addr4->sin_port = htons(cfg_port);
+		if (daddr &&
+		    inet_pton(AF_INET, daddr, &(addr4->sin_addr)) != 1)
+			error(1, 0, "ipv4 parse error: %s", daddr);
+		break;
+	case PF_INET6:
+		memset(addr6, 0, sizeof(*addr6));
+		addr6->sin6_family = AF_INET6;
+		addr6->sin6_port = htons(cfg_port);
+		if (daddr &&
+		    inet_pton(AF_INET6, daddr, &(addr6->sin6_addr)) != 1)
+			error(1, 0, "ipv6 parse error: %s", daddr);
+		break;
+	default:
+		error(1, 0, "illegal domain");
+	}
+
+	if (cfg_payload_len > max_payload_len)
+		error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
+	if (cfg_mode == MODE_NONZC && cfg_flush)
+		error(1, 0, "-f: only zerocopy modes support notifications");
+	if (optind != argc - 1)
+		usage(argv[0]);
+}
+
+int main(int argc, char **argv)
+{
+	const char *cfg_test = argv[argc - 1];
+
+	parse_opts(argc, argv);
+
+	if (!strcmp(cfg_test, "tcp"))
+		do_test(cfg_family, SOCK_STREAM, 0);
+	else if (!strcmp(cfg_test, "udp"))
+		do_test(cfg_family, SOCK_DGRAM, 0);
+	else
+		error(1, 0, "unknown cfg_test %s", cfg_test);
+	return 0;
+}
diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
new file mode 100755
index 000000000000..6a65e4437640
--- /dev/null
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
@@ -0,0 +1,131 @@
+#!/bin/bash
+#
+# Send data between two processes across namespaces
+# Run twice: once without and once with zerocopy
+
+set -e
+
+readonly DEV="veth0"
+readonly DEV_MTU=65535
+readonly BIN_TX="./io_uring_zerocopy_tx"
+readonly BIN_RX="./msg_zerocopy"
+
+readonly RAND="$(mktemp -u XXXXXX)"
+readonly NSPREFIX="ns-${RAND}"
+readonly NS1="${NSPREFIX}1"
+readonly NS2="${NSPREFIX}2"
+
+readonly SADDR4='192.168.1.1'
+readonly DADDR4='192.168.1.2'
+readonly SADDR6='fd::1'
+readonly DADDR6='fd::2'
+
+readonly path_sysctl_mem="net.core.optmem_max"
+
+# No arguments: automated test
+if [[ "$#" -eq "0" ]]; then
+	IPs=( "4" "6" )
+	protocols=( "tcp" "udp" )
+
+	for IP in "${IPs[@]}"; do
+		for proto in "${protocols[@]}"; do
+			for mode in $(seq 1 3); do
+				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32
+				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32 -f
+				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32 -c -f
+			done
+		done
+	done
+
+	echo "OK. All tests passed"
+	exit 0
+fi
+
+# Argument parsing
+if [[ "$#" -lt "2" ]]; then
+	echo "Usage: $0 [4|6] [tcp|udp|raw|raw_hdrincl|packet|packet_dgram] <args>"
+	exit 1
+fi
+
+readonly IP="$1"
+shift
+readonly TXMODE="$1"
+shift
+readonly EXTRA_ARGS="$@"
+
+# Argument parsing: configure addresses
+if [[ "${IP}" == "4" ]]; then
+	readonly SADDR="${SADDR4}"
+	readonly DADDR="${DADDR4}"
+elif [[ "${IP}" == "6" ]]; then
+	readonly SADDR="${SADDR6}"
+	readonly DADDR="${DADDR6}"
+else
+	echo "Invalid IP version ${IP}"
+	exit 1
+fi
+
+# Argument parsing: select receive mode
+#
+# This differs from send mode for
+# - packet:	use raw recv, because packet receives skb clones
+# - raw_hdrinc: use raw recv, because hdrincl is a tx-only option
+case "${TXMODE}" in
+'packet' | 'packet_dgram' | 'raw_hdrincl')
+	RXMODE='raw'
+	;;
+*)
+	RXMODE="${TXMODE}"
+	;;
+esac
+
+# Start of state changes: install cleanup handler
+save_sysctl_mem="$(sysctl -n ${path_sysctl_mem})"
+
+cleanup() {
+	ip netns del "${NS2}"
+	ip netns del "${NS1}"
+	sysctl -w -q "${path_sysctl_mem}=${save_sysctl_mem}"
+}
+
+trap cleanup EXIT
+
+# Configure system settings
+sysctl -w -q "${path_sysctl_mem}=1000000"
+
+# Create virtual ethernet pair between network namespaces
+ip netns add "${NS1}"
+ip netns add "${NS2}"
+
+ip link add "${DEV}" mtu "${DEV_MTU}" netns "${NS1}" type veth \
+  peer name "${DEV}" mtu "${DEV_MTU}" netns "${NS2}"
+
+# Bring the devices up
+ip -netns "${NS1}" link set "${DEV}" up
+ip -netns "${NS2}" link set "${DEV}" up
+
+# Set fixed MAC addresses on the devices
+ip -netns "${NS1}" link set dev "${DEV}" address 02:02:02:02:02:02
+ip -netns "${NS2}" link set dev "${DEV}" address 06:06:06:06:06:06
+
+# Add fixed IP addresses to the devices
+ip -netns "${NS1}" addr add 192.168.1.1/24 dev "${DEV}"
+ip -netns "${NS2}" addr add 192.168.1.2/24 dev "${DEV}"
+ip -netns "${NS1}" addr add       fd::1/64 dev "${DEV}" nodad
+ip -netns "${NS2}" addr add       fd::2/64 dev "${DEV}" nodad
+
+# Optionally disable sg or csum offload to test edge cases
+# ip netns exec "${NS1}" ethtool -K "${DEV}" sg off
+
+do_test() {
+	local readonly ARGS="$1"
+
+	echo "ipv${IP} ${TXMODE} ${ARGS}"
+	ip netns exec "${NS2}" "${BIN_RX}" "-${IP}" -t 2 -C 2 -S "${SADDR}" -D "${DADDR}" -r "${RXMODE}" &
+	sleep 0.2
+	ip netns exec "${NS1}" "${BIN_TX}" "-${IP}" -t 1 -D "${DADDR}" ${ARGS} "${TXMODE}"
+	wait
+}
+
+do_test "${EXTRA_ARGS}"
+echo ok
-- 
2.36.1

