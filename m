Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C30648E3F5
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbiANFs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:48:59 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:57225 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236473AbiANFs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:48:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1nM4f-_1642139335;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1nM4f-_1642139335)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 13:48:55 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [RFC PATCH net-next 1/6] net/smc: Spread CQs to differents completion vectors
Date:   Fri, 14 Jan 2022 13:48:47 +0800
Message-Id: <20220114054852.38058-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114054852.38058-1-tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This spreads recv/send CQs to different vectors. This removes the
limitation of single vector, which binds to some CPU.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_ib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index a3e2d3b89568..d1f337522bd5 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -823,6 +823,9 @@ long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 		smcibdev->roce_cq_send = NULL;
 		goto out;
 	}
+	/* spread to different completion vector */
+	if (smcibdev->ibdev->num_comp_vectors > 1)
+		cqattr.comp_vector = 1;
 	smcibdev->roce_cq_recv = ib_create_cq(smcibdev->ibdev,
 					      smc_wr_rx_cq_handler, NULL,
 					      smcibdev, &cqattr);
-- 
2.32.0.3.g01195cf9f

