Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A854036F7E9
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 11:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhD3J21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 05:28:27 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:56807 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhD3J21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 05:28:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UXFoPu5_1619774856;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UXFoPu5_1619774856)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 30 Apr 2021 17:27:37 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] vsock/vmci: Remove redundant assignment to err
Date:   Fri, 30 Apr 2021 17:27:34 +0800
Message-Id: <1619774854-121938-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'err' is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Clean up the following clang-analyzer warning:

net/vmw_vsock/vmci_transport.c:948:2: warning: Value stored to 'err' is
never read [clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/vmw_vsock/vmci_transport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 1c9ecb1..c99bc4c 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -944,8 +944,6 @@ static int vmci_transport_recv_listen(struct sock *sk,
 	bool old_request = false;
 	bool old_pkt_proto = false;
 
-	err = 0;
-
 	/* Because we are in the listen state, we could be receiving a packet
 	 * for ourself or any previous connection requests that we received.
 	 * If it's the latter, we try to find a socket in our list of pending
-- 
1.8.3.1

