Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C164D43DBBD
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhJ1HQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:16:43 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:47113 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJ1HQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:16:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UtyxoYA_1635405254;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UtyxoYA_1635405254)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 15:14:14 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: [PATCH net v2 1/2] net/smc: Fix smc_link->llc_testlink_time overflow
Date:   Thu, 28 Oct 2021 15:13:45 +0800
Message-Id: <20211028071344.11168-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028071344.11168-1-tonylu@linux.alibaba.com>
References: <20211028071344.11168-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of llc_testlink_time is set to the value stored in
net->ipv4.sysctl_tcp_keepalive_time when linkgroup init. The value of
sysctl_tcp_keepalive_time is already jiffies, so we don't need to
multiply by HZ, which would cause smc_link->llc_testlink_time overflow,
and test_link send flood.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---

v1->v2:
- fix wrong email address.

---
 net/smc/smc_llc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 72f4b72eb175..f1d323439a2a 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1822,7 +1822,7 @@ void smc_llc_link_active(struct smc_link *link)
 			    link->smcibdev->ibdev->name, link->ibport);
 	link->state = SMC_LNK_ACTIVE;
 	if (link->lgr->llc_testlink_time) {
-		link->llc_testlink_time = link->lgr->llc_testlink_time * HZ;
+		link->llc_testlink_time = link->lgr->llc_testlink_time;
 		schedule_delayed_work(&link->llc_testlink_wrk,
 				      link->llc_testlink_time);
 	}
-- 
2.19.1.6.gb485710b

