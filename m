Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41CB482263
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 07:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhLaGI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 01:08:56 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:34072 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234461AbhLaGI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 01:08:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V0PKB2o_1640930933;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V0PKB2o_1640930933)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 31 Dec 2021 14:08:54 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH net] net/smc: add comments for smc_link_{usable|sendable}
Date:   Fri, 31 Dec 2021 14:08:53 +0800
Message-Id: <20211231060853.8106-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20211228090325.27263-2-dust.li@linux.alibaba.com>
References: <20211228090325.27263-2-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add comments for both smc_link_sendable() and smc_link_usable()
to help better distinguish and use them.

No function changes.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_core.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index d63b08274197..1e2926760eb0 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -407,7 +407,13 @@ static inline struct smc_connection *smc_lgr_find_conn(
 	return res;
 }
 
-/* returns true if the specified link is usable */
+/*
+ * Returns true if the specified link is usable.
+ *
+ * usable means the link is ready to receive RDMA messages, map memory
+ * on the link, etc. This doesn't ensure we are able to send RDMA messages
+ * on this link, if sending RDMA messages is needed, use smc_link_sendable()
+ */
 static inline bool smc_link_usable(struct smc_link *lnk)
 {
 	if (lnk->state == SMC_LNK_UNUSED || lnk->state == SMC_LNK_INACTIVE)
@@ -415,6 +421,15 @@ static inline bool smc_link_usable(struct smc_link *lnk)
 	return true;
 }
 
+/*
+ * Returns true if the specified link is ready to receive AND send RDMA
+ * messages.
+ *
+ * For the client side in first contact, the underlying QP may still in
+ * RESET or RTR when the link state is ACTIVATING, checks in smc_link_usable()
+ * is not strong enough. For those places that need to send any CDC or LLC
+ * messages, use smc_link_sendable(), otherwise, use smc_link_usable() instead
+ */
 static inline bool smc_link_sendable(struct smc_link *lnk)
 {
 	return smc_link_usable(lnk) &&
-- 
2.19.1.3.ge56e4f7

