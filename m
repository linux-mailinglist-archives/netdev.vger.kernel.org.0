Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A193EE9D9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbhHQJaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239540AbhHQJ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:52 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB0EC0612A3;
        Tue, 17 Aug 2021 02:29:09 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v4so20436413wro.12;
        Tue, 17 Aug 2021 02:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FkJ6l/1JcnDsZ1+j4Ei1va5lDdBESZYy8Ogo4L7H+ew=;
        b=B1BNanuh/JAJd8etUfKXIcG+Lu87FXn+7UHdyBomwQ29wBvMO/wc4tWQrV7HcKkSKJ
         202EVecVizoxAJOfVfKJRrCVqa7yQgSDfnOtBwlaWSghg1GbI1e3OMDJu3RVGWLEdeOd
         NtG8rS3RdXnZm/p5//27m4be/DPBdYHJzxw7r0UxqI4fODUCwzBqWgArWtkP42VYvqjL
         Blg3H7WXjKLAnf+4TFqtCXvXNlm7SXwzT8N/l+01NaBzCWV8xgXsDLojiYahji8nFz+A
         TQygXX1QBK5hfTQa+sddGZMaQobtWSLEVhbrsx6XZt4LlGpskk2RM5dDeg5+KNHRM66g
         yK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FkJ6l/1JcnDsZ1+j4Ei1va5lDdBESZYy8Ogo4L7H+ew=;
        b=GIfJpLwEOH76Tro4uM5UfCfc3CHpLyVoOct+Dpc/BFiJ5Bfss3LNdBiO9qivF1F+ZZ
         BkOr//nisv1p6AQaGesdiAQaxuzxXMa2hvSuvWik0kLK+lpwkjYPpA61/eHiOUqHCsoh
         oqJ/7sUR3pPE9liR0qFUaIBDnDULiMLhTW9rGbfLhk3++NaM2ik6vQ0FO1QaTw39HjAC
         XFB1EEewE4MoacBwYnKRtj/700ckZ3q4yv5xjz4pKnZCYYo4lq55lgHwr0N4M+Gzw8Bs
         ogIJuFKScBAH/1g+fnxJJ/QsQspsHWrMZP2E9sjJjyRpKzurbobycl/sjQLZxt8JG/iz
         ZuhA==
X-Gm-Message-State: AOAM533uoKiLoJjN4Ug+9U4uULJzTyy6OwNOQLz4gjtTEcO8OocHJOqK
        l5RSGPTOuYXtbdjFvmYNreo=
X-Google-Smtp-Source: ABdhPJykQcYExAMLeVzjkCY0KJv5RI4xtENcp1aLNdDsRuX6M/E9YkbQ4Zu41lTYsIpkalRzYpkYzw==
X-Received: by 2002:a05:6000:184a:: with SMTP id c10mr2894425wri.26.1629192548020;
        Tue, 17 Aug 2021 02:29:08 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:07 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 10/16] selftests: xsk: validate tx stats on tx thread
Date:   Tue, 17 Aug 2021 11:27:23 +0200
Message-Id: <20210817092729.433-11-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
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
index fe3d281a0575..8ff24472ef1e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -642,23 +642,22 @@ static void tx_only_all(struct ifobject *ifobject)
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
@@ -666,8 +665,7 @@ static void stats_validate(struct ifobject *ifobject)
 			xsk_stat = stats.rx_dropped;
 			break;
 		case STAT_TEST_TX_INVALID:
-			xsk_stat = stats.tx_invalid_descs;
-			break;
+			return true;
 		case STAT_TEST_RX_FULL:
 			xsk_stat = stats.rx_ring_full;
 			expected_stat -= RX_FULL_RXQSIZE;
@@ -680,8 +678,33 @@ static void stats_validate(struct ifobject *ifobject)
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
@@ -767,6 +790,9 @@ static void *worker_testapp_validate_tx(void *arg)
 	print_verbose("Sending %d packets on interface %s\n", opt_pkt_count, ifobject->ifname);
 	tx_only_all(ifobject);
 
+	if (stat_test_type == STAT_TEST_TX_INVALID)
+		tx_stats_validate(ifobject);
+
 	testapp_cleanup_xsk_res(ifobject);
 	pthread_exit(NULL);
 }
@@ -792,7 +818,8 @@ static void *worker_testapp_validate_rx(void *arg)
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

