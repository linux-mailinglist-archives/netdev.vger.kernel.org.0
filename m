Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A848EB48
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731791AbfHOMOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:14:32 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44556 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731755AbfHOMOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:14:30 -0400
Received: by mail-lf1-f68.google.com with SMTP id v16so1474690lfg.11
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U4bBImeq628Nz3uHByPC1jCfJS23IKHJ82E0OrJ4tyg=;
        b=Q2pGXx4pGEm+ED+Zw0z4LrMq/3hmJgwAD47DAyDDHHDPBwKDV/ZATZ1/6TUfm524ae
         8LwooppbfL6jV5goKikAx06W5XkEko79IMDjTSz9cIEXd9IUTviMyXuMTRIT0s3g87y2
         iVGSeIQe5cSW80XQ30F58QkdnzVQzQn/hhLr6R0yi6ruLiWW2s627mF8Uw10Rgbej5iq
         3ITbVakwo/Z54FsU0vUNOCdRp9SPdKfXVFsIAu2ZUa1cm876jjZyDZYyYMPDfXVHWoxZ
         3zd16deu+NV/KKMm87HFM65dHDulOEDXC54tgLaXqUsrS05k4xBOrTjlHva95aftpzPc
         LDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U4bBImeq628Nz3uHByPC1jCfJS23IKHJ82E0OrJ4tyg=;
        b=F7fXyb8HiR9kugQqv+iJapUBM+rCMKxibIkYweVbq/1eA/1MC55bOpfXolaux8vMe+
         ab3Zi/MueowtRcfDNwkKAH7kIbI+7DVK2qiMCQWJWmZeT4PwU+1jroLTfeXLsBvQZvmN
         aIAfCaVH6MT57NdKIe38IGVpTPNY6dmg2ewdi7EyGVb9w+EruL1e7jtSipkymrAoZ99c
         KJ4ALT5i8K0yo5xW3fXZKDNbQO3T3E8xASwMQUJCF0yHeXnXf3HXEKyfw9teGYLuctTx
         30Aq41PsrU7lDNPsOSpoaKingqtUVL1rFUqwKGoNwFMVY/Rdzm8cECJHO9GCnkYsB9ZT
         T4cg==
X-Gm-Message-State: APjAAAVmrncU3Q+ilrwmuGh/gc5wx6GVmeVWsAIiKAqTW9jap8/AoHU4
        SrCYd606dEZTkkJL/0Ex9vjP0Q==
X-Google-Smtp-Source: APXvYqzog6+Zoot/T2CF/gd3OHH1KBhSJI2WcOT2wsESPVK9HP52ORvBdR7Fdhihqg4M4yfHM3zLHg==
X-Received: by 2002:a19:9111:: with SMTP id t17mr2197405lfd.113.1565871267467;
        Thu, 15 Aug 2019 05:14:27 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id q25sm462060ljg.30.2019.08.15.05.14.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 05:14:26 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com
Cc:     davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        jlemon@flugsvamp.com, yhs@fb.com, andrii.nakryiko@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next v2 1/3] libbpf: use LFS (_FILE_OFFSET_BITS) instead of direct mmap2 syscall
Date:   Thu, 15 Aug 2019 15:13:54 +0300
Message-Id: <20190815121356.8848-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop __NR_mmap2 fork in flavor of LFS, that is _FILE_OFFSET_BITS=64
(glibc & bionic) / LARGEFILE64_SOURCE (for musl) decision. It allows
mmap() to use 64bit offset that is passed to mmap2 syscall. As result
pgoff is not truncated and no need to use direct access to mmap2 for
32 bits systems.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 tools/lib/bpf/Makefile |  1 +
 tools/lib/bpf/xsk.c    | 49 ++++++++++++------------------------------
 2 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 9312066a1ae3..844f6cd79c03 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -113,6 +113,7 @@ override CFLAGS += -Werror -Wall
 override CFLAGS += -fPIC
 override CFLAGS += $(INCLUDES)
 override CFLAGS += -fvisibility=hidden
+override CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 
 ifeq ($(VERBOSE),1)
   Q =
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 680e63066cf3..7392f428c07b 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -74,23 +74,6 @@ struct xsk_nl_info {
 	int fd;
 };
 
-/* For 32-bit systems, we need to use mmap2 as the offsets are 64-bit.
- * Unfortunately, it is not part of glibc.
- */
-static inline void *xsk_mmap(void *addr, size_t length, int prot, int flags,
-			     int fd, __u64 offset)
-{
-#ifdef __NR_mmap2
-	unsigned int page_shift = __builtin_ffs(getpagesize()) - 1;
-	long ret = syscall(__NR_mmap2, addr, length, prot, flags, fd,
-			   (off_t)(offset >> page_shift));
-
-	return (void *)ret;
-#else
-	return mmap(addr, length, prot, flags, fd, offset);
-#endif
-}
-
 int xsk_umem__fd(const struct xsk_umem *umem)
 {
 	return umem ? umem->fd : -EINVAL;
@@ -210,10 +193,9 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
 		goto out_socket;
 	}
 
-	map = xsk_mmap(NULL, off.fr.desc +
-		       umem->config.fill_size * sizeof(__u64),
-		       PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
-		       umem->fd, XDP_UMEM_PGOFF_FILL_RING);
+	map = mmap(NULL, off.fr.desc + umem->config.fill_size * sizeof(__u64),
+		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
+		   XDP_UMEM_PGOFF_FILL_RING);
 	if (map == MAP_FAILED) {
 		err = -errno;
 		goto out_socket;
@@ -227,10 +209,9 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
 	fill->ring = map + off.fr.desc;
 	fill->cached_cons = umem->config.fill_size;
 
-	map = xsk_mmap(NULL,
-		       off.cr.desc + umem->config.comp_size * sizeof(__u64),
-		       PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
-		       umem->fd, XDP_UMEM_PGOFF_COMPLETION_RING);
+	map = mmap(NULL, off.cr.desc + umem->config.comp_size * sizeof(__u64),
+		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
+		   XDP_UMEM_PGOFF_COMPLETION_RING);
 	if (map == MAP_FAILED) {
 		err = -errno;
 		goto out_mmap;
@@ -550,11 +531,10 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	}
 
 	if (rx) {
-		rx_map = xsk_mmap(NULL, off.rx.desc +
-				  xsk->config.rx_size * sizeof(struct xdp_desc),
-				  PROT_READ | PROT_WRITE,
-				  MAP_SHARED | MAP_POPULATE,
-				  xsk->fd, XDP_PGOFF_RX_RING);
+		rx_map = mmap(NULL, off.rx.desc +
+			      xsk->config.rx_size * sizeof(struct xdp_desc),
+			      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
+			      xsk->fd, XDP_PGOFF_RX_RING);
 		if (rx_map == MAP_FAILED) {
 			err = -errno;
 			goto out_socket;
@@ -569,11 +549,10 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	xsk->rx = rx;
 
 	if (tx) {
-		tx_map = xsk_mmap(NULL, off.tx.desc +
-				  xsk->config.tx_size * sizeof(struct xdp_desc),
-				  PROT_READ | PROT_WRITE,
-				  MAP_SHARED | MAP_POPULATE,
-				  xsk->fd, XDP_PGOFF_TX_RING);
+		tx_map = mmap(NULL, off.tx.desc +
+			      xsk->config.tx_size * sizeof(struct xdp_desc),
+			      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
+			      xsk->fd, XDP_PGOFF_TX_RING);
 		if (tx_map == MAP_FAILED) {
 			err = -errno;
 			goto out_mmap_rx;
-- 
2.17.1

