Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C95F41430C
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhIVH6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbhIVH6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B2BC061757;
        Wed, 22 Sep 2021 00:56:53 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t18so4315694wrb.0;
        Wed, 22 Sep 2021 00:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ueYsUSfRFTo33DFlEoZeE/qfyQ01ZhcGNmq2f3Ugjyo=;
        b=U/f1xqAEROx2U9/bOFO/ZqrM0Uy2z9tIYP12Z7uEKrGKAunZSQ1qWnCweLwiqEN8NY
         Xip7ZhLiWf0drSxqny0Q8JtJJQb7/iOtOOcKwMw4Uy/uUvFkNbv23XB9sMkz+hTTVW/P
         suLtkHFOp1d5/nGp4DKqpsEUYNmd4RCjN0atXtsv6vLxc0IoV7CebpYlQeJMc+0MWfPz
         rT7FHGGTWoj7j5Zr1T05OxLDqqgnZNbouMiIv/iwTixWwpGl5g3k/kyujhX1HLHKZ4AM
         yYu8OLLuldhjx0wwCX/mr1XVGWrJa3sKvgoMV2q2T6QxivsqcSv4vxyDQiRgSU1rsPPB
         d82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ueYsUSfRFTo33DFlEoZeE/qfyQ01ZhcGNmq2f3Ugjyo=;
        b=TLBx6pmtFveKYoyNvu+en0EUf7QS7lDpayTqJ2FwdkRrxFjros7vZBjLZ5x0NnQY2i
         wrqS1QcFWTBMACi1UhG+CoQXccnAwVtaxStwNKKd7z4BJ9jHYPgQfIrRkxS1SeCuisfO
         MFUnGIw/0RARWKvtOCoZl2IAh9L92WO74aNkI1A1TrevSSVkbgmU8XM56U2jXNPtF37V
         4PYLekboOYM1SboyC+q1EHvooxVvDVzg0Rexj3IM2xPOGY6gKbRbuYNaHhBBGnoCG77U
         R5OQxlLHYn7Dk+l9albOrW+EUViiEiNwag/7Er/lmq0dDFLz2BdOHcosv+B1uUuAsf0T
         W46g==
X-Gm-Message-State: AOAM533mxhBFnW11ZZmaw0VcpmWbEl/oXuQNe+zXaJwWNvAnHSfCPOWT
        RDiNd5pv8MgToa+L1h/xACw=
X-Google-Smtp-Source: ABdhPJyQMWzRONbILvrMgXoa9tcIAFFMa6CNsEFxzgA+FCWMbJh1gjmV823CKwGM7FUcRfuP3Zx65w==
X-Received: by 2002:a5d:5986:: with SMTP id n6mr39321392wri.75.1632297411664;
        Wed, 22 Sep 2021 00:56:51 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:51 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 07/13] selftests: xsk: fix missing initialization
Date:   Wed, 22 Sep 2021 09:56:07 +0200
Message-Id: <20210922075613.12186-8-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix missing initialization of the member rx_pkt_nb in the packet
stream. This leads to some tests declaring success too early as the
test thought all packets had already been received.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 127bcde06c86..97591e2a69f7 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -445,6 +445,12 @@ static void test_spec_set_name(struct test_spec *test, const char *name)
 	strncpy(test->name, name, MAX_TEST_NAME_SIZE);
 }
 
+static void pkt_stream_reset(struct pkt_stream *pkt_stream)
+{
+	if (pkt_stream)
+		pkt_stream->rx_pkt_nb = 0;
+}
+
 static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
 {
 	if (pkt_nb >= pkt_stream->nb_pkts)
@@ -1032,6 +1038,7 @@ static void testapp_validate_traffic(struct test_spec *test)
 		exit_with_error(errno);
 
 	test->current_step++;
+	pkt_stream_reset(ifobj_rx->pkt_stream);
 
 	/*Spawn RX thread */
 	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
-- 
2.29.0

