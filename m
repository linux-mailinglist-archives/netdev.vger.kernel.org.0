Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55587597D43
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbiHREYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 00:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243264AbiHREYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 00:24:41 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0298E31DE8;
        Wed, 17 Aug 2022 21:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660796679; x=1692332679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xOACXq2DwWqPC931oHvOXlr7smPuDeluiES7aNAPrxc=;
  b=W/BO54iydJzhaduPd283TwfRx0a1oKwdkvUYIToGBzP2l+BIFFvkncdz
   3+76c9Wv5To+1FZVjuXPA50Dmj50T9TMSZLePm9SSzKGJjoGaZ/CPn3s+
   JIJ6uoe/fMF3oxnbG7g09eHNjhOQCzP7dyIemdDobt1tMwjWu/40+/3Y6
   U=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="120461401"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:24:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id 3B13B818EF;
        Thu, 18 Aug 2022 04:24:38 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 04:24:34 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.158) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 04:24:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 bpf 3/4] bpf: Fix data-races around bpf_jit_kallsyms.
Date:   Wed, 17 Aug 2022 21:23:38 -0700
Message-ID: <20220818042339.82992-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818042339.82992-1-kuniyu@amazon.com>
References: <20220818042339.82992-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D43UWC002.ant.amazon.com (10.43.162.172) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading bpf_jit_kallsyms, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 74451e66d516 ("bpf: make jited programs visible in traces")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/filter.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 09566ad211bd..35881fccce05 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1110,14 +1110,16 @@ static inline bool bpf_jit_blinding_enabled(struct bpf_prog *prog)
 
 static inline bool bpf_jit_kallsyms_enabled(void)
 {
+	int jit_kallsyms = READ_ONCE(bpf_jit_kallsyms);
+
 	/* There are a couple of corner cases where kallsyms should
 	 * not be enabled f.e. on hardening.
 	 */
 	if (READ_ONCE(bpf_jit_harden))
 		return false;
-	if (!bpf_jit_kallsyms)
+	if (!jit_kallsyms)
 		return false;
-	if (bpf_jit_kallsyms == 1)
+	if (jit_kallsyms == 1)
 		return true;
 
 	return false;
-- 
2.30.2

