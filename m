Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFCF61A65E
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 01:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKEARh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 20:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKEARg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 20:17:36 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A372422BF6;
        Fri,  4 Nov 2022 17:17:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667607450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OJdjdyVf9Uq+xOkb747aw1OkaxGvEF2tcnRsP+zxycY=;
        b=TjsN+tWedu8K6t5g8Y+mHQlvX9w6Y48hbjEzkMDGbT1Oh5t8knXlHZsABGXEsu5g35J3WJ
        qWiB4DsZK17ERRxu9lah+tqOjdjUFbFWFPhqrZdksXHKOK1kXvw1AgSAqYJ4gENlqBfktf
        Q9Mj0kd9gqokx97FaioMD7tzZ0KVcmk=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 3/3] selftests/bpf: Test skops->skb_hwtstamp
Date:   Fri,  4 Nov 2022 17:17:13 -0700
Message-Id: <20221105001713.1347122-4-martin.lau@linux.dev>
In-Reply-To: <20221105001713.1347122-1-martin.lau@linux.dev>
References: <20221105001713.1347122-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch tests reading the skops->skb_hwtstamp field.

A local test was also done such that the shinfo hwtstamp was temporary
set to a non zero value in the kernel bpf_skops_parse_hdr()
and the same value can be read by the skops test.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c      | 2 ++
 tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index 57191773572a..5cf85d0f9827 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -505,6 +505,8 @@ static void misc(void)
 
 	ASSERT_EQ(misc_skel->bss->nr_fin, 1, "unexpected nr_fin");
 
+	ASSERT_EQ(misc_skel->bss->nr_hwtstamp, 0, "nr_hwtstamp");
+
 check_linum:
 	ASSERT_FALSE(check_error_linum(&sk_fds), "check_error_linum");
 	sk_fds_close(&sk_fds);
diff --git a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
index 2c121c5d66a7..d487153a839d 100644
--- a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
@@ -27,6 +27,7 @@ unsigned int nr_pure_ack = 0;
 unsigned int nr_data = 0;
 unsigned int nr_syn = 0;
 unsigned int nr_fin = 0;
+unsigned int nr_hwtstamp = 0;
 
 /* Check the header received from the active side */
 static int __check_active_hdr_in(struct bpf_sock_ops *skops, bool check_syn)
@@ -146,6 +147,9 @@ static int check_active_hdr_in(struct bpf_sock_ops *skops)
 	if (th->ack && !th->fin && tcp_hdrlen(th) == skops->skb_len)
 		nr_pure_ack++;
 
+	if (skops->skb_hwtstamp)
+		nr_hwtstamp++;
+
 	return CG_OK;
 }
 
-- 
2.30.2

