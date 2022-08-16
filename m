Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF28A595473
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiHPIDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiHPIDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:03:15 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3D46B8CE;
        Mon, 15 Aug 2022 22:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660627548; x=1692163548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XrgV6EQ8XJMC5f1RzoqpGGdrmJz1Ln9s247hdg2A8Ac=;
  b=Dx3iYhiieobQ931iuhXEr2SeHnQOQ6PxLTxJ4VGjzSYnky4V5DhJ7zKH
   mbERwC+I/Jaw5g6u0c3W/R+4TOV1jPrMG/dxv4Az3SIog6goWY/M1blpV
   xE6+HUm7SbIRpv/R3yZWjqlW3pu1H/38QnbzKNNV7HHaWFwsxDiA1m/ci
   M=;
X-IronPort-AV: E=Sophos;i="5.93,240,1654560000"; 
   d="scan'208";a="230039527"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:25:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com (Postfix) with ESMTPS id D8414C08A7;
        Tue, 16 Aug 2022 05:25:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 05:25:44 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 05:25:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH v1 net 06/15] bpf: Fix data-races around bpf_jit_kallsyms.
Date:   Mon, 15 Aug 2022 22:23:38 -0700
Message-ID: <20220816052347.70042-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220816052347.70042-1-kuniyu@amazon.com>
References: <20220816052347.70042-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D24UWB003.ant.amazon.com (10.43.161.222) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
CC: Daniel Borkmann <daniel@iogearbox.net>
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

