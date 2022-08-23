Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831B959EC51
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiHWTbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiHWTa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:30:56 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8F8DB7DD;
        Tue, 23 Aug 2022 11:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661278892; x=1692814892;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n+mG2Qf5W8rDz33cIplaqij+OZcyCF2mnob3OKVLXm0=;
  b=KxdSraNriWDttOpNWfBEdiV8aX0/gOoaQfaAhQhSQ1EnzwH/AT69GUup
   J5T8g5nTRD6gfJde1u3/AXQ9Qc8Ku18w8SLCGgtmNORLEmWS+uDPy6ilQ
   1jtk5g/EGKPoemzj2wETBPyxJjXwZG/LNqc2THjQMIaO1W6ZSmikyUKck
   E=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="122554305"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 18:13:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com (Postfix) with ESMTPS id 9AD42C08C3;
        Tue, 23 Aug 2022 18:13:49 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 18:13:48 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 18:13:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf] bpf: Fix a data-race around bpf_jit_limit.
Date:   Tue, 23 Aug 2022 11:12:47 -0700
Message-ID: <20220823181247.90349-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB003.ant.amazon.com (10.43.161.106) To
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

While reading bpf_jit_limit, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv allocations")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v2:
  * Drop other 3 patches (No change for this patch)

v1: https://lore.kernel.org/bpf/20220818042339.82992-1-kuniyu@amazon.com/
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c1e10d088dbb..3d9eb3ae334c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -971,7 +971,7 @@ pure_initcall(bpf_jit_charge_init);
 
 int bpf_jit_charge_modmem(u32 size)
 {
-	if (atomic_long_add_return(size, &bpf_jit_current) > bpf_jit_limit) {
+	if (atomic_long_add_return(size, &bpf_jit_current) > READ_ONCE(bpf_jit_limit)) {
 		if (!bpf_capable()) {
 			atomic_long_sub(size, &bpf_jit_current);
 			return -EPERM;
-- 
2.30.2

