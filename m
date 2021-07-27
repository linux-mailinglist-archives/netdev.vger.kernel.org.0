Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011523D75D0
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhG0NSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbhG0NS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C3FC06179B;
        Tue, 27 Jul 2021 06:18:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j2so15143297wrx.9;
        Tue, 27 Jul 2021 06:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t5RWs8vZAU+/Um0yFAtE4HXGCWPZdEksqOpGUduLBlw=;
        b=vL/5R6lUyLfWJaW0PDYp8gSx7yGrQ93fWoxT2F5f0LaGSdNlIiZveeHuJ/jg5EylUN
         jCs2V3dwxThltXlPKASjhAnP1KZbWq2UAjeosYkLh6T3iCZ7lGwqe3Xef/annNNPRnVB
         dFWxMIB9Hp5cuFhqvHM/dnl0XyZqTJtD4R1WqmwZycy8XNBlyH+Z3IOHtvQygfNAKJwG
         FqkZXcg+KcLPESEfPI/DOhrBxHtCghNnnMRn7dzYmqb0GYlFL5bJGqjQGej4+al0gWzx
         96QjNGSTDTXjpeLUebXJDANwuIgXu+2wEXnUAwk2tUfgt2edbNvjal6lcB2rnmu0m5Fe
         qFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t5RWs8vZAU+/Um0yFAtE4HXGCWPZdEksqOpGUduLBlw=;
        b=bgCYrlr6Cq9G4NZwltQMxPwYveuAo5IvLMJbkHOHv5aho4GzUV4vHM2EbpatcqXKjU
         tUrI2adKirxgW5olchYSRvw3rgRBRpo0vl1XbGjVebJ8mf39WwyrS6UQ06ignrYirUK6
         K6yOknAT7xYXmPPcU35k9lFYvPa0XR/CAAldzan/s6Nkc7VyoL4vtcs0OZGLNCg4a8oY
         shvgxCXhCaYz+qEuRdaSTEjN0SsKW3+PEnsgUGrfVxP7ajRnMtmXuUh7PQuhMlnp0R5t
         NRoo3//k0uTbuW8N0ZQ3hs+x+r3eLZNDSiwjl5DTOkC5V5YcnU0U0PxAsyxRvPukewTz
         Yx7Q==
X-Gm-Message-State: AOAM53238f5Gqc4xMtUugSNSbJxevBJijF46Y0mIR4Rt4tTvPOwc8Uq3
        pOUlxCZ4Vvu/5Us7YSquvIE=
X-Google-Smtp-Source: ABdhPJwkKFM2u4LdGUnPw/aSk7R9l+aNhMy77qxbrs56d6mxUSPPYXONUahPW8gK9/ASBG2UeoX8kw==
X-Received: by 2002:a5d:4812:: with SMTP id l18mr25052099wrq.68.1627391905389;
        Tue, 27 Jul 2021 06:18:25 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:24 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 11/17] selftests: xsk: validate tx stats on tx thread
Date:   Tue, 27 Jul 2021 15:17:47 +0200
Message-Id: <20210727131753.10924-12-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Validate the tx stats on the Tx thread instead of the Rx
tread. Depending on your settings, you might not be allowed to query
the statistics of a socket you do not own, so better to do this on the
correct thread to start with.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 55 ++++++++++++++++++------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index cbd6739faeb5..327129f83fef 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -647,23 +647,22 @@ static void tx_only_all(struct ifobject *ifobject)
 	complete_tx_only_all(ifobject);
 }
 
-static void stats_validate(struct ifobject *ifobject)
+static bool rx_stats_are_valid(struct ifobject *ifobject)
 {
+	u32 xsk_stat = 0, expected_stat = opt_pkt_count;
+	struct xsk_socket *xsk = ifobject->xsk->xsk;
+	int fd = xsk_socket__fd(xsk);
 	struct xdp_statistics stats;
 	socklen_t optlen;
 	int err;
-	struct xsk_socket *xsk = stat_test_type == STAT_TEST_TX_INVALID ?
-							ifdict[!ifobject->ifdict_index]->xsk->xsk :
-							ifobject->xsk->xsk;
-	int fd = xsk_socket__fd(xsk);
-	unsigned long xsk_stat = 0, expected_stat = opt_pkt_count;
-
-	sigvar = 0;
 
 	optlen = sizeof(stats);
 	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
-	if (err)
-		return;
+	if (err) {
+		ksft_test_result_fail("ERROR: [%s] getsockopt(XDP_STATISTICS) error %u %s\n",
+				      __func__, -err, strerror(-err));
+		return true;
+	}
 
 	if (optlen == sizeof(struct xdp_statistics)) {
 		switch (stat_test_type) {
@@ -671,8 +670,7 @@ static void stats_validate(struct ifobject *ifobject)
 			xsk_stat = stats.rx_dropped;
 			break;
 		case STAT_TEST_TX_INVALID:
-			xsk_stat = stats.tx_invalid_descs;
-			break;
+			return true;
 		case STAT_TEST_RX_FULL:
 			xsk_stat = stats.rx_ring_full;
 			expected_stat -= RX_FULL_RXQSIZE;
@@ -685,8 +683,33 @@ static void stats_validate(struct ifobject *ifobject)
 		}
 
 		if (xsk_stat == expected_stat)
-			sigvar = 1;
+			return true;
+	}
+
+	return false;
+}
+
+static void tx_stats_validate(struct ifobject *ifobject)
+{
+	struct xsk_socket *xsk = ifobject->xsk->xsk;
+	int fd = xsk_socket__fd(xsk);
+	struct xdp_statistics stats;
+	socklen_t optlen;
+	int err;
+
+	optlen = sizeof(stats);
+	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
+	if (err) {
+		ksft_test_result_fail("ERROR: [%s] getsockopt(XDP_STATISTICS) error %u %s\n",
+				      __func__, -err, strerror(-err));
+		return;
 	}
+
+	if (stats.tx_invalid_descs == opt_pkt_count)
+		return;
+
+	ksft_test_result_fail("ERROR: [%s] tx_invalid_descs incorrect. Got [%u] expected [%u]\n",
+			      __func__, stats.tx_invalid_descs, opt_pkt_count);
 }
 
 static void thread_common_ops(struct ifobject *ifobject, void *bufs)
@@ -772,6 +795,9 @@ static void *worker_testapp_validate_tx(void *arg)
 	print_verbose("Sending %d packets on interface %s\n", opt_pkt_count, ifobject->ifname);
 	tx_only_all(ifobject);
 
+	if (stat_test_type == STAT_TEST_TX_INVALID)
+		tx_stats_validate(ifobject);
+
 	testapp_cleanup_xsk_res(ifobject);
 	pthread_exit(NULL);
 }
@@ -797,7 +823,8 @@ static void *worker_testapp_validate_rx(void *arg)
 		if (test_type != TEST_TYPE_STATS) {
 			rx_pkt(ifobject->xsk, fds);
 		} else {
-			stats_validate(ifobject);
+			if (rx_stats_are_valid(ifobject))
+				break;
 		}
 		if (sigvar)
 			break;
-- 
2.29.0

