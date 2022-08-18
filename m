Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFD1597D63
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiHREYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 00:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240529AbiHREYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 00:24:22 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC6A2B61A;
        Wed, 17 Aug 2022 21:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660796662; x=1692332662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tBYj04p+1NTMnmMFtrEgds0B+Cse8fOYaKZsgEk7tQ8=;
  b=FNY3N+iKS7dKAejwZuKVQq1Qhk5tIZHVjHpifzh7aabQvtOko3LVKg38
   3gTBhpXGr0WqroR96+rMJqiJYmlyE5veKCZDcnsgCoiDacY8Gnmf4dUt0
   Em2sKyqRsYw2HqjTCt9tPh8tGOUB11cxLd6gHdtS/Hdv4xQplDi+mxqhi
   k=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="250097222"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:24:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com (Postfix) with ESMTPS id 10B9544ACC;
        Thu, 18 Aug 2022 04:24:19 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 04:24:18 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.158) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 04:24:16 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 bpf 2/4] bpf: Fix data-races around bpf_jit_harden.
Date:   Wed, 17 Aug 2022 21:23:37 -0700
Message-ID: <20220818042339.82992-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818042339.82992-1-kuniyu@amazon.com>
References: <20220818042339.82992-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D43UWC002.ant.amazon.com (10.43.162.172) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading bpf_jit_harden, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 4f3446bb809f ("bpf: add generic constant blinding for use in jits")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/filter.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index ce8072626ccf..09566ad211bd 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1090,6 +1090,8 @@ static inline bool bpf_prog_ebpf_jited(const struct bpf_prog *fp)
 
 static inline bool bpf_jit_blinding_enabled(struct bpf_prog *prog)
 {
+	int jit_harden = READ_ONCE(bpf_jit_harden);
+
 	/* These are the prerequisites, should someone ever have the
 	 * idea to call blinding outside of them, we make sure to
 	 * bail out.
@@ -1098,9 +1100,9 @@ static inline bool bpf_jit_blinding_enabled(struct bpf_prog *prog)
 		return false;
 	if (!prog->jit_requested)
 		return false;
-	if (!bpf_jit_harden)
+	if (!jit_harden)
 		return false;
-	if (bpf_jit_harden == 1 && capable(CAP_SYS_ADMIN))
+	if (jit_harden == 1 && capable(CAP_SYS_ADMIN))
 		return false;
 
 	return true;
@@ -1111,7 +1113,7 @@ static inline bool bpf_jit_kallsyms_enabled(void)
 	/* There are a couple of corner cases where kallsyms should
 	 * not be enabled f.e. on hardening.
 	 */
-	if (bpf_jit_harden)
+	if (READ_ONCE(bpf_jit_harden))
 		return false;
 	if (!bpf_jit_kallsyms)
 		return false;
-- 
2.30.2

