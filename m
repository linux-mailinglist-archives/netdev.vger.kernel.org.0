Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9FB43C593
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbhJ0IzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:55:09 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33403 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235961AbhJ0IzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:55:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uts5VZA_1635324760;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uts5VZA_1635324760)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 16:52:40 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: [PATCH net 2/4] net/smc: Fix smc_link->llc_testlink_time overflow
Date:   Wed, 27 Oct 2021 16:52:08 +0800
Message-Id: <20211027085208.16048-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211027085208.16048-1-tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lu <tony.ly@linux.alibaba.com>

The value of llc_testlink_time is set to the value stored in
net->ipv4.sysctl_tcp_keepalive_time when linkgroup init. The value of
sysctl_tcp_keepalive_time is already jiffies, so we don't need to
multiply by HZ, which would cause smc_link->llc_testlink_time overflow,
and test_link send flood.

Fixes: 00a049cfde95 ("net/smc: move llc layer related init and clear into smc_llc.c")
Cc: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Tony Lu <tony.ly@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
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

