Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC3940240B
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbhIGHVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239680AbhIGHVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:08 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40F3C0613CF;
        Tue,  7 Sep 2021 00:20:02 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u16so12932530wrn.5;
        Tue, 07 Sep 2021 00:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+UtgQWxRuRa4KqJ5d42yoDTYxOmZXpdqTSuXxXkZPMQ=;
        b=fjEaHN/8wB3AIUZBChjJUFktJFeM9cslWzi3MVoj1VWpWR2pZ7K21tsV2ZcFeejavy
         AxetM7FJYTzK5zieWJhKMUXKGJJoAhK7dvYjLjKz4rJPf5TsJZq0izq+e64Wp15WdGNu
         RwpP2hq7wGB8BbcgKim1z+V00gs2kMPCm1Zf+TaeCPgcMKCgN1NeX/YsmUzO/8Tam/cE
         0/Dxrwa31PgHPbWnS2koVj2+Gs8UAV8mTXQoDm64ElEgqCXaLt0WDkvsHF0V9j33xRAW
         X0sg51Qn+ypKvPnn5ogc7BYBRfcAvCv33hWtV94WgscnwISTFCKo85K7HWMhFmkMwbB8
         QjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UtgQWxRuRa4KqJ5d42yoDTYxOmZXpdqTSuXxXkZPMQ=;
        b=mxQO0pNvA/JtUtAi6OpsNJ4XQWH4/RbZkGvQu2LyPEsqKue60BQpeeEl62cAZNgcHL
         DWxhv6BJ+6hzwLYE7EqiRDOHvPcP3JAawpfOzNerZtibq5mjJ/CbXxHdQAnMe3TrB5eY
         T1v03r/Bxah6vy/nCaSZ4dsMK6z2gfHFyK7k6+JbFfhgP4cMvRLL4vld5iO1T9nCzH1E
         qbXgzGi+zQTyJOInxeQsfEme/rGw/P9qULR3Xywfm8kJCNPdklUpp9fh16OfYfFtmISV
         INz1Ve+EsBdZ3QaiyifKb3FHuYxX+NSbDFVyBNTWGeDm2Ydc8h+rKKIq7S4xe+/SRsQE
         9mqw==
X-Gm-Message-State: AOAM533qnc8dInlBLqHUTivEcEKDMeXogMCnewMa63J6/GRTIJ3a0pOJ
        EWi29nF2rvCQI7SLN3B5lbImX94P/vFYI880WVY=
X-Google-Smtp-Source: ABdhPJz+7RnhhcKTB7+IGJsHvKnQEymj4X7pxlIXVLD5Au0KpjQAKvMvTINdZn6Z8mU/onCWjmnWTA==
X-Received: by 2002:a5d:6e91:: with SMTP id k17mr17177349wrz.77.1630999201406;
        Tue, 07 Sep 2021 00:20:01 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:01 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 08/20] selftests: xsk: add use_poll to ifobject
Date:   Tue,  7 Sep 2021 09:19:16 +0200
Message-Id: <20210907071928.9750-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a use_poll option to the ifobject so that we do not need to use a
test specific if-statement in the test runner.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 5 ++++-
 tools/testing/selftests/bpf/xdpxceiver.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 8ef58081d4d2..9a98c45933c5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -393,6 +393,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 
 		ifobj->umem = &ifobj->umem_arr[0];
 		ifobj->xsk = &ifobj->xsk_arr[0];
+		ifobj->use_poll = false;
 
 		if (i == tx)
 			ifobj->fv.vector = tx;
@@ -684,7 +685,7 @@ static void send_pkts(struct ifobject *ifobject)
 	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
 		u32 sent;
 
-		if (test_type == TEST_TYPE_POLL) {
+		if (ifobject->use_poll) {
 			int ret;
 
 			ret = poll(fds, 1, POLL_TMOUT);
@@ -1071,6 +1072,8 @@ static void run_pkt_test(struct test_spec *test, int mode, int type)
 		testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_POLL:
+		test->ifobj_tx->use_poll = true;
+		test->ifobj_rx->use_poll = true;
 		test_spec_set_name(test, "POLL");
 		testapp_validate_traffic(test);
 		break;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 15eab31b3b32..e02a4dd71bfb 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -135,6 +135,7 @@ struct ifobject {
 	u32 src_ip;
 	u16 src_port;
 	u16 dst_port;
+	bool use_poll;
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
 };
-- 
2.29.0

