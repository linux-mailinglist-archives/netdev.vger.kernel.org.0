Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F8459EE88
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 23:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiHWV6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 17:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiHWV6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 17:58:43 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CEF959C;
        Tue, 23 Aug 2022 14:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661291922; x=1692827922;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P2sg/Y2ei1LJ5TOzsXWJG6dJ7t5e5k6b+DFks6T66ZI=;
  b=egqtrGlOdeCOyz1VycYEPRl9aBRn0ArUIfhu5qZNX3ygmWz9IvBboDAI
   omYCOegSU6AAci/yyfs4BQKeh7mD9AuVSTACJ3I7meJfROViIp2sZSX41
   FnLraZlMJJ+gEQFnyDdr7EQaIqlQuaaBokBFBFXy+Q49bLVVOKRs3NE5j
   Y=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="220438679"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 21:58:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com (Postfix) with ESMTPS id 78FD581A39;
        Tue, 23 Aug 2022 21:58:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 21:58:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 21:58:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf] bpf: Fix a data-race around bpf_jit_limit.
Date:   Tue, 23 Aug 2022 14:58:04 -0700
Message-ID: <20220823215804.2177-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D47UWC003.ant.amazon.com (10.43.162.70) To
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

While reading bpf_jit_limit, it can be changed concurrently via sysctl,
WRITE_ONCE() in __do_proc_doulongvec_minmax().  The size of bpf_jit_limit
is long, so we need to add a paired READ_ONCE() to avoid load-tearing.

Fixes: ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv allocations")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v3:
  * Update changelog to clarify paired WRITE_ONCE() and motivation
    as load-tearing.

v2: https://lore.kernel.org/netdev/20220823181247.90349-1-kuniyu@amazon.com/
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

