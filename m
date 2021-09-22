Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CD9414313
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbhIVH6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbhIVH6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:31 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EB5C0613DF;
        Wed, 22 Sep 2021 00:56:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d6so4018880wrc.11;
        Wed, 22 Sep 2021 00:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tBzKMAyVJb7YNM6Gm5Xf+XBoiFAs3cTnmjv86MR3naQ=;
        b=bjaxiGRjxfMFZ02bSC0igQ3URkBT4mALFICOcaHtVKrgzs4xLT+dPuKG50Gqhk4O0M
         16ou3YB9AYKN1WwZ9CFvLbCrIhFuxdCOkjQwCzPtHAfT1YR2zpJY720pASXBSi7lOZoF
         Xssi3eIpu+Tb8tAuLnVpxWVhV35of9Sx1ILg7w9QEdMNrTwRy6TK8fv7v6XApLupVAEv
         YAw3UbQwkMpuqWOf01A3FB3fT2g4xzkl5IcDkZoZH/bvDTTXKwXSJJIx4Uz5IIz4DFQm
         aFy4wBFK0Hlir7ag7Jl4Lw/wuF4StiBk/zEkoVpM53td3Ikg6zwDmK0GKivDcEoTLXaW
         eArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tBzKMAyVJb7YNM6Gm5Xf+XBoiFAs3cTnmjv86MR3naQ=;
        b=hqnrik4W1ybVwB1EmqMRCQEq46uKe3vvoIhUiaTRNmuEWE3p+hk22485RYWLFnDmr/
         o5JdSNOt1nuFFbXZ6pdT4Xsh+zDzCPPx3LCabzq8LIv1yJBxn9fkGGqCsjK/QQ8DTGD0
         BHDCvVz5IbMPFdi2fXXy4Gn20B9/puE2g8tB4mRSlU+kwbPrHqjN66hnZWj41F2aL7op
         Ev0b09f5GYqsiZ5T7QxDueRE0DpPsCF+ioRoki0SgbcH/PisbVNg1o/2mH1S4txiZZvM
         mek6amMeNb2URoJ48kaODnKkz4kvWQbNc9xaTUsnrpLuWU39NdHqfGgti/FT1tJNOwZ5
         YhSA==
X-Gm-Message-State: AOAM531KLQ0tuvoFECLdfwJsWqWDWKTmK97jzBeA0fSkReSbvAPseNeY
        o/hyEncJ+NAq9Qq9yyp8Cx0=
X-Google-Smtp-Source: ABdhPJwOrZQoysvFQu7Q4tsN4oyAmRsD/BzsBhq39109Ck4nOLYf6LH2/fljXEdCaCADRdu7rFAHVA==
X-Received: by 2002:a05:600c:3790:: with SMTP id o16mr8880604wmr.157.1632297417219;
        Wed, 22 Sep 2021 00:56:57 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:56 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 11/13] selftests: xsk: add single packet test
Date:   Wed, 22 Sep 2021 09:56:11 +0200
Message-Id: <20210922075613.12186-12-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a test where a single packet is sent and received. This might
sound like a silly test, but since many of the interfaces in xsk are
batched, it is important to be able to validate that we did not break
something as fundamental as just receiving single packets, instead of
batches of packets at high speed.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 13 +++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 597fbe206026..3beea7531c8e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1217,6 +1217,15 @@ static bool testapp_unaligned(struct test_spec *test)
 	return true;
 }
 
+static void testapp_single_pkt(struct test_spec *test)
+{
+	struct pkt pkts[] = {{0x1000, PKT_SIZE, 0, true}};
+
+	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
+	testapp_validate_traffic(test);
+	pkt_stream_restore_default(test);
+}
+
 static void testapp_invalid_desc(struct test_spec *test)
 {
 	struct pkt pkts[] = {
@@ -1298,6 +1307,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test_spec_set_name(test, "RUN_TO_COMPLETION");
 		testapp_validate_traffic(test);
 		break;
+	case TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT:
+		test_spec_set_name(test, "RUN_TO_COMPLETION_SINGLE_PKT");
+		testapp_single_pkt(test);
+		break;
 	case TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME:
 		test_spec_set_name(test, "RUN_TO_COMPLETION_2K_FRAME_SIZE");
 		test->ifobj_tx->umem->frame_size = 2048;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 00790c976f4f..d075192c95f8 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -55,6 +55,7 @@ enum test_mode {
 enum test_type {
 	TEST_TYPE_RUN_TO_COMPLETION,
 	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
+	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
 	TEST_TYPE_POLL,
 	TEST_TYPE_UNALIGNED,
 	TEST_TYPE_ALIGNED_INV_DESC,
-- 
2.29.0

