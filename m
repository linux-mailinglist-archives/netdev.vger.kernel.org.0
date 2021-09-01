Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A3B3FD81E
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbhIAKtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239191AbhIAKtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:19 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A73C0612E7;
        Wed,  1 Sep 2021 03:48:22 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t15so3777315wrg.7;
        Wed, 01 Sep 2021 03:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hbt0Mg2tvtnST2dzdC4XVYXjIBjQHSXwsVrLWYPs1i4=;
        b=fSxAuXxEap6HoQREhMh2T3AMHb+8NzyHVhVeNXtzIbIhLzi7NaetZhCHnJpponozkK
         6CxYJzSJHXIyWXi7ejtjqokPNNJIXd+8myAtrSB8rFoSOPyDxAuu4aTqkmzLkhGnUGm1
         JqxhPSbO5LPyluFfHhjPUXUXsk/u5ArSIvKvuuGwdkzXezF172+74F9L+VS3qjv14ash
         29eRimf0Gagu4l7CfMa7K+GwqUaVC2zeHcQMdthdKO0j54f75QyVB6H4R+7laRc42YoJ
         NqHGajqURqPRtP9p9NVqN0On1KkO+Wu89O7A33nMddvfo5xhxdJn8rwDhdWsSOkfEq3i
         JTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hbt0Mg2tvtnST2dzdC4XVYXjIBjQHSXwsVrLWYPs1i4=;
        b=ZhQrJ5Hckgn4skEytEu41TETaWB7QorKB6S6FBYXioiGAxiUjNZcYy+tSat+kWwpkJ
         mKBvdHghLLhyq9Mh9efN4c6NXnvRqmuqg/4JRHR5e9r8n/FDfzpwFCt+3FufUWQOiv7h
         WXvg6eVitdExowYCs/7BtXY8MpesPsHFyjV+DDec/jr4SbDYzPtsEQ3THgUgjza/pm2N
         tQPHbAHizsHLKZ5LGE5CRmAXL+OQsGj7EgXPo5G1nfNUQmfaflwvnLpxNtdJ1A6wwiop
         Sl7nkIg6VbAwCIwBJvQOFFivQKX6UUyZhP9wd/djB2r98SlDr/p0QaJe6Dub0t1F8mIZ
         OO0w==
X-Gm-Message-State: AOAM532ysptxnOfB55EETRiUtL7eczida7FzdRzqFb8+WsRVy8sekG6s
        cy1KBTE9oJbQSB/GsNUPfiY=
X-Google-Smtp-Source: ABdhPJx5BUIrwF/xFjhTlPtPWRyZGbt38WJD+A7ivvwvAP7j9hZX10Qz2DmxN+wlgBPaBAe5lID+JA==
X-Received: by 2002:adf:916f:: with SMTP id j102mr32752402wrj.422.1630493300965;
        Wed, 01 Sep 2021 03:48:20 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:20 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 15/20] selftests: xsk: allow for invalid packets
Date:   Wed,  1 Sep 2021 12:47:27 +0200
Message-Id: <20210901104732.10956-16-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Allow for invalid packets to be sent. These are verified by the Rx
thread not to be received. Or put in another way, if they are
received, the test will fail. This feature will be used to eliminate
an if statement for a stats test and will also be used by other tests
in later patches. The previous code could only deal with valid
packets.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 16 ++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h |  1 +
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 0fb5cae974de..09d2854c10e6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -473,6 +473,11 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size;
 		pkt_stream->pkts[i].len = pkt_len;
 		pkt_stream->pkts[i].payload = i;
+
+		if (pkt_len > umem->frame_size)
+			pkt_stream->pkts[i].valid = false;
+		else
+			pkt_stream->pkts[i].valid = true;
 	}
 
 	return pkt_stream;
@@ -658,7 +663,7 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 static u32 __send_pkts(struct ifobject *ifobject, u32 pkt_nb)
 {
 	struct xsk_socket_info *xsk = ifobject->xsk;
-	u32 i, idx;
+	u32 i, idx, valid_pkts = 0;
 
 	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE)
 		complete_pkts(xsk, BATCH_SIZE);
@@ -673,14 +678,13 @@ static u32 __send_pkts(struct ifobject *ifobject, u32 pkt_nb)
 		tx_desc->addr = pkt->addr;
 		tx_desc->len = pkt->len;
 		pkt_nb++;
+		if (pkt->valid)
+			valid_pkts++;
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, i);
-	if (stat_test_type != STAT_TEST_TX_INVALID)
-		xsk->outstanding_tx += i;
-	else if (xsk_ring_prod__needs_wakeup(&xsk->tx))
-		kick_tx(xsk);
-	complete_pkts(xsk, i);
+	xsk->outstanding_tx += valid_pkts;
+	complete_pkts(xsk, BATCH_SIZE);
 
 	return i;
 }
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 1e9a563380c8..c5baa7c5f560 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -96,6 +96,7 @@ struct pkt {
 	u64 addr;
 	u32 len;
 	u32 payload;
+	bool valid;
 };
 
 struct pkt_stream {
-- 
2.29.0

