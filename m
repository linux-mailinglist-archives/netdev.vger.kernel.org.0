Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494B1644C95
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiLFTgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiLFTgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:36:05 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3838043AC9;
        Tue,  6 Dec 2022 11:36:02 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670355360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yMMtKBdV0J95lgoHU7VliiIOA0gLIbWHsNh/PRYE/TQ=;
        b=E7lwoR9MovF4nibq6ERUTZDoJQEO6DxgDgFGiA6ixvzgMWX5nqw1IezsrCl/hPlFaBXdsa
        HmCnHrNIyBOctjK6abQK07JMgG7k+/wv/ZRR6VeH2lSZUfUdVd+oVDWKvPunQ63yefTh1q
        eX46vQ8rC+q4YTcldKqogOMPC3LnCzU=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Allow building bpf tests with CONFIG_XFRM_INTERFACE=[m|n]
Date:   Tue,  6 Dec 2022 11:35:54 -0800
Message-Id: <20221206193554.1059757-1-martin.lau@linux.dev>
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

It is useful to use vmlinux.h in the xfrm_info test like other kfunc
tests do.  In particular, it is common for kfunc bpf prog that requires
to use other core kernel structures in vmlinux.h

Although vmlinux.h is preferred, it needs a ___local flavor of
struct bpf_xfrm_info in order to build the bpf selftests
when CONFIG_XFRM_INTERFACE=[m|n].

Cc: Eyal Birger <eyal.birger@gmail.com>
Fixes: 90a3a05eb33f ("selftests/bpf: add xfrm_info tests")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 tools/testing/selftests/bpf/progs/xfrm_info.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xfrm_info.c b/tools/testing/selftests/bpf/progs/xfrm_info.c
index 3acedcdd962d..f6a501fbba2b 100644
--- a/tools/testing/selftests/bpf/progs/xfrm_info.c
+++ b/tools/testing/selftests/bpf/progs/xfrm_info.c
@@ -3,18 +3,23 @@
 #include "bpf_tracing_net.h"
 #include <bpf/bpf_helpers.h>
 
+struct bpf_xfrm_info___local {
+	u32 if_id;
+	int link;
+} __attribute__((preserve_access_index));
+
 __u32 req_if_id;
 __u32 resp_if_id;
 
 int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
-			  const struct bpf_xfrm_info *from) __ksym;
+			  const struct bpf_xfrm_info___local *from) __ksym;
 int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx,
-			  struct bpf_xfrm_info *to) __ksym;
+			  struct bpf_xfrm_info___local *to) __ksym;
 
 SEC("tc")
 int set_xfrm_info(struct __sk_buff *skb)
 {
-	struct bpf_xfrm_info info = { .if_id = req_if_id };
+	struct bpf_xfrm_info___local info = { .if_id = req_if_id };
 
 	return bpf_skb_set_xfrm_info(skb, &info) ? TC_ACT_SHOT : TC_ACT_UNSPEC;
 }
@@ -22,7 +27,7 @@ int set_xfrm_info(struct __sk_buff *skb)
 SEC("tc")
 int get_xfrm_info(struct __sk_buff *skb)
 {
-	struct bpf_xfrm_info info = {};
+	struct bpf_xfrm_info___local info = {};
 
 	if (bpf_skb_get_xfrm_info(skb, &info) < 0)
 		return TC_ACT_SHOT;
-- 
2.30.2

