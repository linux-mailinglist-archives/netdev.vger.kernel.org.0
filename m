Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A265E402409
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbhIGHVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239792AbhIGHVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:10 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FF4C061796;
        Tue,  7 Sep 2021 00:20:04 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n14-20020a05600c3b8e00b002f8bd2f8ab6so987624wms.5;
        Tue, 07 Sep 2021 00:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sxkrSYD9cgbDYCmPJ3kUKrpYLNcLTg8gLS7WNJCmpuA=;
        b=gIka95ViF4uxeTGQNA8iWtKTpxg2UsrQzGQ9sImr2Z/Q8yClsunHt0cI87H23rdOP2
         UW/bqaGpSWYHQ+sFxac+RrA654oapp1axe9s0ZcLPY5jZRnN9kPYre1ppr11YOQrQDj8
         UhN6KdTeL8bWejKwH8miChXmpwAyLTMgY3OzC86UlHAIekDsXFqLyFdnq7SwRI/QERo6
         TZgi8UTo837o94eISh4VDLiLigfEOX6qNrQZdhLYn5edYe7kjp0RKh3WOQE/xq9xMlA3
         tQjeNQxSt1LWB0X282lmFXQoaig5rr5Dk5TGcfUT/ho956egEV8A/7HGGeCzljgo5cWs
         0cFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sxkrSYD9cgbDYCmPJ3kUKrpYLNcLTg8gLS7WNJCmpuA=;
        b=EnsepqxEKzONiqGIWjHDQKqXVtLB37C+blHTLnswP3zmgxTW2kTBKSOkh86txRYTcW
         /fywoEFSR17vVo1Y/jkLi2aE6yONPf4Lvzurzuh3reyvmZdoELyNMVGc9o4YDVKuVyAR
         CH3AY75dysZH/pbZILnUzGPJfATeHL72+IeAQPOprdqKRo33ewSOyznRVwZlP+PHUcPG
         4E2IO11j2QuZtqdD9a35qcqNLRch2AonlTm168FOT9+fbsIVGhQWFbyAaREKjFcSiQig
         7HPdVyklP6E7POEcgnliK8UxmcGsFP2pcqclVGOxgamRqjgIYxWsZ+uqtuMs6LP/maS3
         w8Cg==
X-Gm-Message-State: AOAM530xnCoJbYevO54izrWXFxfOBgbR0mccIXWWw+/+fdO4KR96mjCF
        dfI+P0MucM1fn8AJlIcdZIk=
X-Google-Smtp-Source: ABdhPJy36tCGZ9KWhWOEgloj8u8OcW2PWjfC3kKQR5eYAhPrpCrxBx6lTFgpuLOoIDupiBBKB5ThiA==
X-Received: by 2002:a7b:c1cf:: with SMTP id a15mr2443424wmj.85.1630999202977;
        Tue, 07 Sep 2021 00:20:02 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:02 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 09/20] selftests: xsk: introduce rx_on and tx_on in ifobject
Date:   Tue,  7 Sep 2021 09:19:17 +0200
Message-Id: <20210907071928.9750-10-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce rx_on and tx_on in the ifobject so that we can describe if
the thread should create a socket with only tx, rx, or both. This
eliminates some test specific if statements from the code. We can also
eliminate the flow vector structure now as this is fully specified
by the tx_on and rx_on variables.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 34 ++++++++++--------------
 tools/testing/selftests/bpf/xdpxceiver.h | 10 ++-----
 2 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 9a98c45933c5..a896d5845c0e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -278,14 +278,8 @@ static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_inf
 	cfg.xdp_flags = xdp_flags;
 	cfg.bind_flags = xdp_bind_flags;
 
-	if (test_type != TEST_TYPE_BIDI) {
-		rxr = (ifobject->fv.vector == rx) ? &xsk->rx : NULL;
-		txr = (ifobject->fv.vector == tx) ? &xsk->tx : NULL;
-	} else {
-		rxr = &xsk->rx;
-		txr = &xsk->tx;
-	}
-
+	txr = ifobject->tx_on ? &xsk->tx : NULL;
+	rxr = ifobject->rx_on ? &xsk->rx : NULL;
 	return xsk_socket__create(&xsk->xsk, ifobject->ifname, qid, umem->umem, rxr, txr, &cfg);
 }
 
@@ -395,10 +389,13 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		ifobj->xsk = &ifobj->xsk_arr[0];
 		ifobj->use_poll = false;
 
-		if (i == tx)
-			ifobj->fv.vector = tx;
-		else
-			ifobj->fv.vector = rx;
+		if (i == 0) {
+			ifobj->rx_on = false;
+			ifobj->tx_on = true;
+		} else {
+			ifobj->rx_on = true;
+			ifobj->tx_on = false;
+		}
 
 		for (j = 0; j < MAX_SOCKETS; j++) {
 			memset(&ifobj->umem_arr[j], 0, sizeof(ifobj->umem_arr[j]));
@@ -923,14 +920,10 @@ static void testapp_teardown(struct test_spec *test)
 static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
 {
 	thread_func_t tmp_func_ptr = (*ifobj1)->func_ptr;
-	enum fvector tmp_vector = (*ifobj1)->fv.vector;
 	struct ifobject *tmp_ifobj = (*ifobj1);
 
 	(*ifobj1)->func_ptr = (*ifobj2)->func_ptr;
-	(*ifobj1)->fv.vector = (*ifobj2)->fv.vector;
-
 	(*ifobj2)->func_ptr = tmp_func_ptr;
-	(*ifobj2)->fv.vector = tmp_vector;
 
 	*ifobj1 = *ifobj2;
 	*ifobj2 = tmp_ifobj;
@@ -939,6 +932,8 @@ static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
 static void testapp_bidi(struct test_spec *test)
 {
 	test_spec_set_name(test, "BIDIRECTIONAL");
+	test->ifobj_tx->rx_on = true;
+	test->ifobj_rx->tx_on = true;
 	for (int i = 0; i < MAX_BIDI_ITER; i++) {
 		print_verbose("Creating socket\n");
 		testapp_validate_traffic(test);
@@ -1012,7 +1007,7 @@ static void testapp_stats(struct test_spec *test)
 
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
 		       const char *dst_ip, const char *src_ip, const u16 dst_port,
-		       const u16 src_port, enum fvector vector, thread_func_t func_ptr)
+		       const u16 src_port, thread_func_t func_ptr)
 {
 	struct in_addr ip;
 
@@ -1028,7 +1023,6 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 	ifobj->dst_port = dst_port;
 	ifobj->src_port = src_port;
 
-	ifobj->fv.vector = vector;
 	ifobj->func_ptr = func_ptr;
 }
 
@@ -1144,9 +1138,9 @@ int main(int argc, char **argv)
 		ksft_exit_xfail();
 	}
 
-	init_iface(ifobj_tx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx,
+	init_iface(ifobj_tx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2,
 		   worker_testapp_validate_tx);
-	init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx,
+	init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
 		   worker_testapp_validate_rx);
 
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index e02a4dd71bfb..03ff52897d7b 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -100,13 +100,6 @@ struct xsk_socket_info {
 	u32 rxqsize;
 };
 
-struct flow_vector {
-	enum fvector {
-		tx,
-		rx,
-	} vector;
-};
-
 struct pkt {
 	u64 addr;
 	u32 len;
@@ -127,7 +120,6 @@ struct ifobject {
 	struct xsk_socket_info *xsk_arr;
 	struct xsk_umem_info *umem;
 	struct xsk_umem_info *umem_arr;
-	struct flow_vector fv;
 	thread_func_t func_ptr;
 	struct pkt_stream *pkt_stream;
 	int ns_fd;
@@ -135,6 +127,8 @@ struct ifobject {
 	u32 src_ip;
 	u16 src_port;
 	u16 dst_port;
+	bool tx_on;
+	bool rx_on;
 	bool use_poll;
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
-- 
2.29.0

