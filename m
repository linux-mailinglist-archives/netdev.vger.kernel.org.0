Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FD9F92B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfD3MqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 08:46:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37804 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfD3MqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 08:46:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id g3so7003307pfi.4;
        Tue, 30 Apr 2019 05:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rxiz1tDxW5mERLcRrtbwZALJkTADZZgmZO2MQv28/jw=;
        b=gSj0TSb1I44dmKGum/JtUA1e9f/bvR+7I1LUPHebDo1FON1njvuZD4kUFpms9CYWJ9
         cLm3H295y2eUjicgWqbDlwRh1ZbujS7PNSJRAKUL10ShlJTFRhlnhmoMSZLDSPoWTfzx
         EdMHSq7WsyN4IadQeRUVOdm0DiVW6fxuMBzwffwIi3wLAC5cmiZ2LddfeTLDzcUu09Ic
         NArKzrYiFMdQtLZ0hgjnbIRg9Xg28Vg0XtEJGV/W2i1Qv9rR9ec7kulliQsaKdwpFShU
         raBJlCsSI4Y4gaLU7Vp8hBD0FZPqz+f/Z0FbB6yi/VXVdu7nIUln/2IMIiDGkXkiOpg3
         F13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rxiz1tDxW5mERLcRrtbwZALJkTADZZgmZO2MQv28/jw=;
        b=UA7cy24bYXJ9MQA8zUrejOLtZW8Dv8Ht/r3ymPtEkY6yuiWP4Dp8lAr4w1MndWuX0E
         TX4JsuBvh5tbt2cHNx5oJdsQoPVJC2Q1Asn2lrESOhEJxDjifez4ZNC7y7cy4ndU5u5B
         cCQjGQjWhVLkj71MJO5G0a52HujDjPKgdNl58sSmwNBVmmUsgRqnxKBRjRfRkUR37PM5
         giy0goDC6EJslAemmf0x9yoHWhL1SEH99fcHlIE2djQnMax7XGveC3iLBtKGCCT90wjy
         nnpVAND3L2k2tGMXrqQUx12Eqpnj0t6xoaUX8l+jVhHF3J/Ev3j21LLo2a3wqug66PFZ
         2XLg==
X-Gm-Message-State: APjAAAWEToEgRPEDCeDWA5D6dX7ooFxfludba2ZoKx3MjejzR4IAD3BJ
        AeGo53yTsRO1eCswBfqQv7y4kDcr+3N1wA==
X-Google-Smtp-Source: APXvYqwKEtgVaDe7dfSNx9Dbet020BC6IFou4UlAMakit/2UPrHsRTCMUFA+KuZA2dhr1qNJPile5g==
X-Received: by 2002:a65:62d2:: with SMTP id m18mr14850500pgv.122.1556628370634;
        Tue, 30 Apr 2019 05:46:10 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id u5sm52334523pfa.169.2019.04.30.05.46.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 05:46:10 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, u9012063@gmail.com
Subject: [PATCH bpf 1/2] libbpf: fix invalid munmap call
Date:   Tue, 30 Apr 2019 14:45:35 +0200
Message-Id: <20190430124536.7734-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430124536.7734-1-bjorn.topel@gmail.com>
References: <20190430124536.7734-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

When unmapping the AF_XDP memory regions used for the rings, an
invalid address was passed to the munmap() calls. Instead of passing
the beginning of the memory region, the descriptor region was passed
to munmap.

When the userspace application tried to tear down an AF_XDP socket,
the operation failed and the application would still have a reference
to socket it wished to get rid of.

Reported-by: William Tu <u9012063@gmail.com>
Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 77 +++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 8d0078b65486..af5f310ecca1 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -248,8 +248,7 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
 	return 0;
 
 out_mmap:
-	munmap(umem->fill,
-	       off.fr.desc + umem->config.fill_size * sizeof(__u64));
+	munmap(map, off.fr.desc + umem->config.fill_size * sizeof(__u64));
 out_socket:
 	close(umem->fd);
 out_umem_alloc:
@@ -523,11 +522,11 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		       struct xsk_ring_cons *rx, struct xsk_ring_prod *tx,
 		       const struct xsk_socket_config *usr_config)
 {
+	void *rx_map = NULL, *tx_map = NULL;
 	struct sockaddr_xdp sxdp = {};
 	struct xdp_mmap_offsets off;
 	struct xsk_socket *xsk;
 	socklen_t optlen;
-	void *map;
 	int err;
 
 	if (!umem || !xsk_ptr || !rx || !tx)
@@ -593,40 +592,40 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	}
 
 	if (rx) {
-		map = xsk_mmap(NULL, off.rx.desc +
-			       xsk->config.rx_size * sizeof(struct xdp_desc),
-			       PROT_READ | PROT_WRITE,
-			       MAP_SHARED | MAP_POPULATE,
-			       xsk->fd, XDP_PGOFF_RX_RING);
-		if (map == MAP_FAILED) {
+		rx_map = xsk_mmap(NULL, off.rx.desc +
+				  xsk->config.rx_size * sizeof(struct xdp_desc),
+				  PROT_READ | PROT_WRITE,
+				  MAP_SHARED | MAP_POPULATE,
+				  xsk->fd, XDP_PGOFF_RX_RING);
+		if (rx_map == MAP_FAILED) {
 			err = -errno;
 			goto out_socket;
 		}
 
 		rx->mask = xsk->config.rx_size - 1;
 		rx->size = xsk->config.rx_size;
-		rx->producer = map + off.rx.producer;
-		rx->consumer = map + off.rx.consumer;
-		rx->ring = map + off.rx.desc;
+		rx->producer = rx_map + off.rx.producer;
+		rx->consumer = rx_map + off.rx.consumer;
+		rx->ring = rx_map + off.rx.desc;
 	}
 	xsk->rx = rx;
 
 	if (tx) {
-		map = xsk_mmap(NULL, off.tx.desc +
-			       xsk->config.tx_size * sizeof(struct xdp_desc),
-			       PROT_READ | PROT_WRITE,
-			       MAP_SHARED | MAP_POPULATE,
-			       xsk->fd, XDP_PGOFF_TX_RING);
-		if (map == MAP_FAILED) {
+		tx_map = xsk_mmap(NULL, off.tx.desc +
+				  xsk->config.tx_size * sizeof(struct xdp_desc),
+				  PROT_READ | PROT_WRITE,
+				  MAP_SHARED | MAP_POPULATE,
+				  xsk->fd, XDP_PGOFF_TX_RING);
+		if (tx_map == MAP_FAILED) {
 			err = -errno;
 			goto out_mmap_rx;
 		}
 
 		tx->mask = xsk->config.tx_size - 1;
 		tx->size = xsk->config.tx_size;
-		tx->producer = map + off.tx.producer;
-		tx->consumer = map + off.tx.consumer;
-		tx->ring = map + off.tx.desc;
+		tx->producer = tx_map + off.tx.producer;
+		tx->consumer = tx_map + off.tx.consumer;
+		tx->ring = tx_map + off.tx.desc;
 		tx->cached_cons = xsk->config.tx_size;
 	}
 	xsk->tx = tx;
@@ -653,13 +652,11 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
 out_mmap_tx:
 	if (tx)
-		munmap(xsk->tx,
-		       off.tx.desc +
+		munmap(tx_map, off.tx.desc +
 		       xsk->config.tx_size * sizeof(struct xdp_desc));
 out_mmap_rx:
 	if (rx)
-		munmap(xsk->rx,
-		       off.rx.desc +
+		munmap(rx_map, off.rx.desc +
 		       xsk->config.rx_size * sizeof(struct xdp_desc));
 out_socket:
 	if (--umem->refcount)
@@ -684,10 +681,12 @@ int xsk_umem__delete(struct xsk_umem *umem)
 	optlen = sizeof(off);
 	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
 	if (!err) {
-		munmap(umem->fill->ring,
-		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
-		munmap(umem->comp->ring,
-		       off.cr.desc + umem->config.comp_size * sizeof(__u64));
+		(void)munmap(umem->fill->ring - off.fr.desc,
+			     off.fr.desc +
+			     umem->config.fill_size * sizeof(__u64));
+		(void)munmap(umem->comp->ring - off.cr.desc,
+			     off.cr.desc +
+			     umem->config.comp_size * sizeof(__u64));
 	}
 
 	close(umem->fd);
@@ -698,6 +697,7 @@ int xsk_umem__delete(struct xsk_umem *umem)
 
 void xsk_socket__delete(struct xsk_socket *xsk)
 {
+	size_t desc_sz = sizeof(struct xdp_desc);
 	struct xdp_mmap_offsets off;
 	socklen_t optlen;
 	int err;
@@ -710,14 +710,17 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	optlen = sizeof(off);
 	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
 	if (!err) {
-		if (xsk->rx)
-			munmap(xsk->rx->ring,
-			       off.rx.desc +
-			       xsk->config.rx_size * sizeof(struct xdp_desc));
-		if (xsk->tx)
-			munmap(xsk->tx->ring,
-			       off.tx.desc +
-			       xsk->config.tx_size * sizeof(struct xdp_desc));
+		if (xsk->rx) {
+			(void)munmap(xsk->rx->ring - off.rx.desc,
+				     off.rx.desc +
+				     xsk->config.rx_size * desc_sz);
+		}
+		if (xsk->tx) {
+			(void)munmap(xsk->tx->ring - off.tx.desc,
+				     off.tx.desc +
+				     xsk->config.tx_size * desc_sz);
+		}
+
 	}
 
 	xsk->umem->refcount--;
-- 
2.20.1

