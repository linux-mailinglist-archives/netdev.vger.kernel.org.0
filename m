Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D4240241C
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241232AbhIGHWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241391AbhIGHV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:27 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3D2C061757;
        Tue,  7 Sep 2021 00:20:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so1423350wmq.0;
        Tue, 07 Sep 2021 00:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DlpVZM8uiBlJyho+kwTYtqYib8TzCwXtFSvdxGitErU=;
        b=qQRklgUotdF4k2DD+a7GoaKjQRzwMCZMPP5tDbSL6TmhmIKLHxs9cIZ6Ad39sw9zcu
         AXeo6SE922hJg9rQDuX5cSt15P8/Zky1N76og9jNgb1nLVHd98fBJmm97utmLO7poP1W
         zNXaysGrbi3jj9zLukZbaO4huys8Ln3oy4BOmKg0DEK1IgjfUbedRPIiXBXxwXYxRENo
         Kh4BmMmi9IRFnIxbjtZASul593v7RS7cpI4sGFFIzhhV7TkAqi7TYw2DcFqJI0cNlpFj
         sn5kipAKUbQquyqk8c6MAJUWXz2Vv8aRXxAPzKwcp6WqzML0WXwt0Mn31sR6TnyypKtA
         kUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DlpVZM8uiBlJyho+kwTYtqYib8TzCwXtFSvdxGitErU=;
        b=bXLZYv4/zuR+w7AoAYjV/8r+oh6Ud5thz7RskSpoC2F1kFBDX0nLS6Zxax0tK8BZ0h
         ROUo1l2L3oW9930xlsiVmuklEqmiP0tnuppcHpN8ecTsEW1W7/9WMmWmhe5u9TigFxsO
         DQ3ZLD7shd8Popgkp8F55vnUjyDA0QspyfvfOKlKrMxTLzTUJGPTVu65OasetHLYjHR8
         WsnLQuOXmKNL9/A0K89QpK/jn9pQetV+Ze1u78IQCjOUNCya+HzlBMYMwHLxVJY8dzGU
         GQ1zc19ZUZXbTLmnt4b+SRGrT3Tfp2MTBli9sVKxLQbK4EHO33zaH3VwFaaguEdsOCq7
         pLDA==
X-Gm-Message-State: AOAM5332Yo9xMx2ABmpaNOmhjuo/QXa43Z13Knw1IEUWRH51h9DV/mNj
        xzcBq+tczoCYeQ9M9hXtTSo=
X-Google-Smtp-Source: ABdhPJx7F9mWXUZoV7CQJYXeQRKDsY+ueXF3UdQgANx4TalYFgUZ4zYcEsOHCcekRlhpWWs8A09/5g==
X-Received: by 2002:a05:600c:230a:: with SMTP id 10mr2390640wmo.79.1630999219650;
        Tue, 07 Sep 2021 00:20:19 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:19 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 20/20] selftests: xsk: add tests for 2K frame size
Date:   Tue,  7 Sep 2021 09:19:28 +0200
Message-Id: <20210907071928.9750-21-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add tests for 2K frame size. Both a standard send and receive test and
one testing for invalid descriptors when the frame size is 2K.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 23 +++++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1a03f7941bb8..127bcde06c86 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -48,6 +48,7 @@
  *    g. unaligned mode
  *    h. tests for invalid and corner case Tx descriptors so that the correct ones
  *       are discarded and let through, respectively.
+ *    i. 2K frame size tests
  *
  * Total tests: 12
  *
@@ -1205,6 +1206,8 @@ static void testapp_invalid_desc(struct test_spec *test)
 		{UMEM_SIZE - PKT_SIZE / 2, PKT_SIZE, 0, false},
 		/* Straddle a page boundrary */
 		{0x3000 - PKT_SIZE / 2, PKT_SIZE, 0, false},
+		/* Straddle a 2K boundrary */
+		{0x3800 - PKT_SIZE / 2, PKT_SIZE, 0, true},
 		/* Valid packet for synch so that something is received */
 		{0x4000, PKT_SIZE, 0, true}};
 
@@ -1212,6 +1215,11 @@ static void testapp_invalid_desc(struct test_spec *test)
 		/* Crossing a page boundrary allowed */
 		pkts[6].valid = true;
 	}
+	if (test->ifobj_tx->umem->frame_size == XSK_UMEM__DEFAULT_FRAME_SIZE / 2) {
+		/* Crossing a 2K frame size boundrary not allowed */
+		pkts[7].valid = false;
+	}
+
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
 	pkt_stream_restore_default(test);
@@ -1262,6 +1270,15 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test_spec_set_name(test, "RUN_TO_COMPLETION");
 		testapp_validate_traffic(test);
 		break;
+	case TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME:
+		test_spec_set_name(test, "RUN_TO_COMPLETION_2K_FRAME_SIZE");
+		test->ifobj_tx->umem->frame_size = 2048;
+		test->ifobj_rx->umem->frame_size = 2048;
+		pkt_stream_replace(test, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
+		testapp_validate_traffic(test);
+
+		pkt_stream_restore_default(test);
+		break;
 	case TEST_TYPE_POLL:
 		test->ifobj_tx->use_poll = true;
 		test->ifobj_rx->use_poll = true;
@@ -1272,6 +1289,12 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test_spec_set_name(test, "ALIGNED_INV_DESC");
 		testapp_invalid_desc(test);
 		break;
+	case TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME:
+		test_spec_set_name(test, "ALIGNED_INV_DESC_2K_FRAME_SIZE");
+		test->ifobj_tx->umem->frame_size = 2048;
+		test->ifobj_rx->umem->frame_size = 2048;
+		testapp_invalid_desc(test);
+		break;
 	case TEST_TYPE_UNALIGNED_INV_DESC:
 		test_spec_set_name(test, "UNALIGNED_INV_DESC");
 		test->ifobj_tx->umem->unaligned_mode = true;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 2d9efb89ea28..5ac4a5e64744 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -54,9 +54,11 @@ enum test_mode {
 
 enum test_type {
 	TEST_TYPE_RUN_TO_COMPLETION,
+	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
 	TEST_TYPE_POLL,
 	TEST_TYPE_UNALIGNED,
 	TEST_TYPE_ALIGNED_INV_DESC,
+	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
 	TEST_TYPE_UNALIGNED_INV_DESC,
 	TEST_TYPE_TEARDOWN,
 	TEST_TYPE_BIDI,
-- 
2.29.0

