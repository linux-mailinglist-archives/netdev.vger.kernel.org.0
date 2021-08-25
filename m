Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592313F71ED
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbhHYJjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239840AbhHYJiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:55 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E886FC06129E;
        Wed, 25 Aug 2021 02:38:07 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so3818385wme.1;
        Wed, 25 Aug 2021 02:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FkJ6l/1JcnDsZ1+j4Ei1va5lDdBESZYy8Ogo4L7H+ew=;
        b=D50PUZQr9xjQW+vSdPF3qIh8SrofbvQLqaR0P0sWlMutvfYYFN+mOpgzf6E4ovFam4
         O5RyrHxXP3oNpjC9cAfS6IcDF7KD4pohfxhMp3miYRJv2FzHMiZgIzMGjXTXqJl8jRhn
         Uzkiz9Tw35wvZFuD3Jq7y9KNaCBg6Br6AuzZPMpeg9TujBlAOB2kIR4QFsOG/XQHzY6X
         eW/tIx3H7QsZBEoE2K4r+EmA1oWSGpPh5psy54XohHSOsB+EPWhAVGjAm7X46joPS6aX
         SAQNM5kxyRThw3gUWRxSZpZ/WdeZvdu3YeFHYv7EKRg6RdsvysmN4zX9jS/op+86iLeW
         YrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FkJ6l/1JcnDsZ1+j4Ei1va5lDdBESZYy8Ogo4L7H+ew=;
        b=iJ987Kgu9gbXNiAGzW/PPHn7HSU/8kJn/vTSCoGIUW+mxJdyJCy/NAeXyqiRhxYlxr
         i8qppzpyQv0gYCOV5HRx4d1YTvXxs91Yz6eYkC2FdBuaWKM+ZGpTKxpJcXQq+dp53KqX
         8T5DLapyVUhdIFju6SHEgIHgjM1y68t4K+re3RyvXX86/53twaKP2yhSO34jpQhwpG0h
         voPO56g5nlMOJCBGSRt3cWHP3lY2VdBBq/dlmt5BjhBcnq964m8XvdQ1YdL0SZWamwaF
         wjxusNladTeB+8odebZN2kP7RHt/DgwpFCocOLntjDdZR9XNVGCPCLEl1JaVItDbXCvA
         hthg==
X-Gm-Message-State: AOAM533OH1irertCIV/Gs0Y/HTNpSzEh9ecgSviI8vD+l3CjC71wQFAG
        UZrD6C71sE8xKwV7NYYasR4=
X-Google-Smtp-Source: ABdhPJz9WLs7JI/Y3G04g7mVh8j/2GNNwqxwhzIs92IUVlWj078q9w8ze+U+hD2kvpXbNSFeL67XMA==
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr5180584wmg.108.1629884286532;
        Wed, 25 Aug 2021 02:38:06 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.38.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:38:06 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 10/16] selftests: xsk: validate tx stats on tx thread
Date:   Wed, 25 Aug 2021 11:37:16 +0200
Message-Id: <20210825093722.10219-11-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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

