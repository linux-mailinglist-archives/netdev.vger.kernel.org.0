Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94D349AF43
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455847AbiAYJHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454705AbiAYJAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:00:47 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF83BC067A64;
        Tue, 25 Jan 2022 00:30:27 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id s18so18326131wrv.7;
        Tue, 25 Jan 2022 00:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=65AyqxsMKVhK+2JQ2G27qDwqRoWd4NOpyeaNyfa+oqw=;
        b=aUgC/TUa8aeXbmtzJY5vbwHgIXQC2NioIzll6Ka/kasNF3cx8TXU8ak3dFC2zX3fuv
         qOcMZjaiOcl2/4ABkRlRxV1l+8dLwTYapAPq5wTNRj8IdBS93Ltk8s2hoAEnOOZIMUwi
         OinNc05Emm5I7Ou0B4eDXXa2Ko+KrqPRqpAW/8lyJgmbK4PmCJJ/yvzH9Hd0hV+U/Src
         dJICbg+zl3BLfvz8AfRXDb8Osgp3V/tKgSW2ghoH3tGqK8tVpnTLZZ7g0GEIRXJQZ8dk
         +uOBKT/rBPSqSX0xjg8qyKXZps43+OTxb8T3hGeBQTa8JYVItW/gFL6Jr7X0P3KaHpkK
         UCQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=65AyqxsMKVhK+2JQ2G27qDwqRoWd4NOpyeaNyfa+oqw=;
        b=qWD8Kho9WMctgcX8S/uo7QYLxpBZ73pi746EjB3kgXQzGFkw1+cd+8BGW38a/BZAwL
         TikUxguGCd4MOOgbbr5ANiXK6rfIIMVq9MM6MG4xFkqol1T1PFaEtYpGqma7txOE4Qa6
         2p+U20d1MVWby8m0IFc69QvJPvgcTPlqNvBh7UHnq9YRiqJ4hIonM38RxYQHAqvfa0jP
         vBywKLrShR6n2AjMx641T9eOZYiNJt/t3stNwqjEBBiMqfjsLaBs0ugFENyj+0LlAuid
         rRSwjgD44w8lHYdI4/dVdZ0DOnbXUx8xZHMyZr4L0bmDBOy1ZREtqTH8Lcm3qjk52+gz
         pClA==
X-Gm-Message-State: AOAM533dXsyBCKNf4PEU+k0so1ogxAIwOkJBQ39incnc7nE1E6gb5gHi
        a1qFLo4OFHKIFMfVrC+rndVKOVIJKTsXB68Q
X-Google-Smtp-Source: ABdhPJzIRA9ZpvmEBrd9UmnkC+j2nX/lU/VqwbDJSfmda3ymd9HsOwdSBicpWjaGER6v/FOL+J4Gcw==
X-Received: by 2002:adf:f7cd:: with SMTP id a13mr1966256wrq.517.1643099426230;
        Tue, 25 Jan 2022 00:30:26 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id f13sm1753792wmq.29.2022.01.25.00.30.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 00:30:25 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next] selftests: xsk: fix bpf_res cleanup test
Date:   Tue, 25 Jan 2022 09:29:45 +0100
Message-Id: <20220125082945.26179-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

After commit 710ad98c363a ("veth: Do not record rx queue hint in
veth_xmit"), veth no longer receives traffic on the same queue as it
was sent on. This breaks the bpf_res test for the AF_XDP selftests as
the socket tied to queue 1 will not receive traffic anymore. Modify
the test so that two sockets are tied to queue id 0 using a shared
umem instead. When killing the first socket enter the second socket
into the xskmap so that traffic will flow to it. This will still test
that the resources are not cleaned up until after the second socket
dies, without having to rely on veth supporting rx_queue hints.

Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 80 +++++++++++++++---------
 tools/testing/selftests/bpf/xdpxceiver.h |  2 +-
 2 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index ffa5502ad95e..5f8296d29e77 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -266,22 +266,24 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
 }
 
 static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem,
-				struct ifobject *ifobject, u32 qid)
+				struct ifobject *ifobject, bool shared)
 {
-	struct xsk_socket_config cfg;
+	struct xsk_socket_config cfg = {};
 	struct xsk_ring_cons *rxr;
 	struct xsk_ring_prod *txr;
 
 	xsk->umem = umem;
 	cfg.rx_size = xsk->rxqsize;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
-	cfg.libbpf_flags = 0;
+	cfg.libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD;
 	cfg.xdp_flags = ifobject->xdp_flags;
 	cfg.bind_flags = ifobject->bind_flags;
+	if (shared)
+		cfg.bind_flags |= XDP_SHARED_UMEM;
 
 	txr = ifobject->tx_on ? &xsk->tx : NULL;
 	rxr = ifobject->rx_on ? &xsk->rx : NULL;
-	return xsk_socket__create(&xsk->xsk, ifobject->ifname, qid, umem->umem, rxr, txr, &cfg);
+	return xsk_socket__create(&xsk->xsk, ifobject->ifname, 0, umem->umem, rxr, txr, &cfg);
 }
 
 static struct option long_options[] = {
@@ -387,7 +389,6 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 	for (i = 0; i < MAX_INTERFACES; i++) {
 		struct ifobject *ifobj = i ? ifobj_rx : ifobj_tx;
 
-		ifobj->umem = &ifobj->umem_arr[0];
 		ifobj->xsk = &ifobj->xsk_arr[0];
 		ifobj->use_poll = false;
 		ifobj->pacing_on = true;
@@ -401,11 +402,12 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 			ifobj->tx_on = false;
 		}
 
+		memset(ifobj->umem, 0, sizeof(*ifobj->umem));
+		ifobj->umem->num_frames = DEFAULT_UMEM_BUFFERS;
+		ifobj->umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
+
 		for (j = 0; j < MAX_SOCKETS; j++) {
-			memset(&ifobj->umem_arr[j], 0, sizeof(ifobj->umem_arr[j]));
 			memset(&ifobj->xsk_arr[j], 0, sizeof(ifobj->xsk_arr[j]));
-			ifobj->umem_arr[j].num_frames = DEFAULT_UMEM_BUFFERS;
-			ifobj->umem_arr[j].frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 			ifobj->xsk_arr[j].rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 		}
 	}
@@ -950,7 +952,10 @@ static void tx_stats_validate(struct ifobject *ifobject)
 
 static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 {
+	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
+	int ret, ifindex;
+	void *bufs;
 	u32 i;
 
 	ifobject->ns_fd = switch_namespace(ifobject->nsname);
@@ -958,23 +963,20 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (ifobject->umem->unaligned_mode)
 		mmap_flags |= MAP_HUGETLB;
 
-	for (i = 0; i < test->nb_sockets; i++) {
-		u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
-		u32 ctr = 0;
-		void *bufs;
-		int ret;
+	bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
+	if (bufs == MAP_FAILED)
+		exit_with_error(errno);
 
-		bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
-		if (bufs == MAP_FAILED)
-			exit_with_error(errno);
+	ret = xsk_configure_umem(ifobject->umem, bufs, umem_sz);
+	if (ret)
+		exit_with_error(-ret);
 
-		ret = xsk_configure_umem(&ifobject->umem_arr[i], bufs, umem_sz);
-		if (ret)
-			exit_with_error(-ret);
+	for (i = 0; i < test->nb_sockets; i++) {
+		u32 ctr = 0;
 
 		while (ctr++ < SOCK_RECONF_CTR) {
-			ret = xsk_configure_socket(&ifobject->xsk_arr[i], &ifobject->umem_arr[i],
-						   ifobject, i);
+			ret = xsk_configure_socket(&ifobject->xsk_arr[i], ifobject->umem,
+						   ifobject, !!i);
 			if (!ret)
 				break;
 
@@ -985,8 +987,22 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 		}
 	}
 
-	ifobject->umem = &ifobject->umem_arr[0];
 	ifobject->xsk = &ifobject->xsk_arr[0];
+
+	if (!ifobject->rx_on)
+		return;
+
+	ifindex = if_nametoindex(ifobject->ifname);
+	if (!ifindex)
+		exit_with_error(errno);
+
+	ret = xsk_setup_xdp_prog(ifindex, &ifobject->xsk_map_fd);
+	if (ret)
+		exit_with_error(-ret);
+
+	ret = xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
+	if (ret)
+		exit_with_error(-ret);
 }
 
 static void testapp_cleanup_xsk_res(struct ifobject *ifobj)
@@ -1142,14 +1158,16 @@ static void testapp_bidi(struct test_spec *test)
 
 static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx)
 {
+	int ret;
+
 	xsk_socket__delete(ifobj_tx->xsk->xsk);
-	xsk_umem__delete(ifobj_tx->umem->umem);
 	xsk_socket__delete(ifobj_rx->xsk->xsk);
-	xsk_umem__delete(ifobj_rx->umem->umem);
-	ifobj_tx->umem = &ifobj_tx->umem_arr[1];
 	ifobj_tx->xsk = &ifobj_tx->xsk_arr[1];
-	ifobj_rx->umem = &ifobj_rx->umem_arr[1];
 	ifobj_rx->xsk = &ifobj_rx->xsk_arr[1];
+
+	ret = xsk_socket__update_xskmap(ifobj_rx->xsk->xsk, ifobj_rx->xsk_map_fd);
+	if (ret)
+		exit_with_error(-ret);
 }
 
 static void testapp_bpf_res(struct test_spec *test)
@@ -1408,13 +1426,13 @@ static struct ifobject *ifobject_create(void)
 	if (!ifobj->xsk_arr)
 		goto out_xsk_arr;
 
-	ifobj->umem_arr = calloc(MAX_SOCKETS, sizeof(*ifobj->umem_arr));
-	if (!ifobj->umem_arr)
-		goto out_umem_arr;
+	ifobj->umem = calloc(1, sizeof(*ifobj->umem));
+	if (!ifobj->umem)
+		goto out_umem;
 
 	return ifobj;
 
-out_umem_arr:
+out_umem:
 	free(ifobj->xsk_arr);
 out_xsk_arr:
 	free(ifobj);
@@ -1423,7 +1441,7 @@ static struct ifobject *ifobject_create(void)
 
 static void ifobject_delete(struct ifobject *ifobj)
 {
-	free(ifobj->umem_arr);
+	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
 }
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 2f705f44b748..62a3e6388632 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -125,10 +125,10 @@ struct ifobject {
 	struct xsk_socket_info *xsk;
 	struct xsk_socket_info *xsk_arr;
 	struct xsk_umem_info *umem;
-	struct xsk_umem_info *umem_arr;
 	thread_func_t func_ptr;
 	struct pkt_stream *pkt_stream;
 	int ns_fd;
+	int xsk_map_fd;
 	u32 dst_ip;
 	u32 src_ip;
 	u32 xdp_flags;

base-commit: 74bb0f0c299cdc9c68cb3bc8f452e5812aa9eab0
-- 
2.34.1

