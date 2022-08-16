Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738F5595479
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiHPIDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiHPIDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:03:08 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770897E338;
        Mon, 15 Aug 2022 22:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660627532; x=1692163532;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I9Q96aAATQFkHRHlBtYMnQxqL1NuXpUByIZYnpmWQtc=;
  b=uvv7lVfSgYevBscKMaqOXhNPxwMxUYYCyC47GxlRAgwqRfY8EqFOY8Oe
   LNaxFKryaXpipnPp0QqdRQRDbVLBJLqGzvbu0ObYDU/PzAfJgui5vw8rl
   re62M+sb9EfeQGL2vBk2EqdcZUpDqa43PVhbr9W5qpG9R8doPZ5oIrrtI
   M=;
X-IronPort-AV: E=Sophos;i="5.93,240,1654560000"; 
   d="scan'208";a="230039421"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:25:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com (Postfix) with ESMTPS id 13AB097DA1;
        Tue, 16 Aug 2022 05:25:29 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 05:25:28 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 05:25:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH v1 net 05/15] bpf: Fix data-races around bpf_jit_harden.
Date:   Mon, 15 Aug 2022 22:23:37 -0700
Message-ID: <20220816052347.70042-6-kuniyu@amazon.com>
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

While reading bpf_jit_harden, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 4f3446bb809f ("bpf: add generic constant blinding for use in jits")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Daniel Borkmann <daniel@iogearbox.net>
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

