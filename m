Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803B93A7C8A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhFOK6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:58:00 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:52206 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231516AbhFOK57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:57:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UcW4eD-_1623754544;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UcW4eD-_1623754544)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Jun 2021 18:55:52 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     mathew.j.martineau@linux.intel.com
Cc:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] mptcp: Remove redundant assignment to remaining
Date:   Tue, 15 Jun 2021 18:55:38 +0800
Message-Id: <1623754538-85616-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable remaining is assigned, but this value is never read as it is
not used later on, hence it is a redundant assignment and can be
removed.

Clean up the following clang-analyzer warning:

net/mptcp/options.c:779:3: warning: Value stored to 'remaining' is never
read [clang-analyzer-deadcode.DeadStores].

net/mptcp/options.c:547:3: warning: Value stored to 'remaining' is never
read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/mptcp/options.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 9b263f2..f99272f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -544,7 +544,6 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 
 		map_size = TCPOLEN_MPTCP_DSS_BASE + TCPOLEN_MPTCP_DSS_MAP64;
 
-		remaining -= map_size;
 		dss_size = map_size;
 		if (mpext)
 			opts->ext_copy = *mpext;
@@ -776,7 +775,6 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 
 	if (mptcp_established_options_mp_prio(sk, &opt_size, remaining, opts)) {
 		*size += opt_size;
-		remaining -= opt_size;
 		ret = true;
 	}
 
-- 
1.8.3.1

