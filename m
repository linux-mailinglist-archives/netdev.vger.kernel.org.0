Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B462645019D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhKOJs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:48:58 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:46457 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230405AbhKOJsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 04:48:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UwcO2ZL_1636969507;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0UwcO2ZL_1636969507)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 15 Nov 2021 17:45:13 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
        tonylu@linux.alibaba.com, dust.li@linux.alibaba.com,
        guwen@linux.alibaba.com
Subject: [PATCH net] net/smc: Make sure the link_id is unique
Date:   Mon, 15 Nov 2021 17:45:07 +0800
Message-Id: <1636969507-39355-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link_id is supposed to be unique, but smcr_next_link_id() doesn't
skip the used link_id as expected. So the patch fixes this.

Fixes: 026c381fb477 ("net/smc: introduce link_idx for link group array")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 49b8ba3..25ebd30 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -708,13 +708,14 @@ static u8 smcr_next_link_id(struct smc_link_group *lgr)
 	int i;
 
 	while (1) {
+again:
 		link_id = ++lgr->next_link_id;
 		if (!link_id)	/* skip zero as link_id */
 			link_id = ++lgr->next_link_id;
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			if (smc_link_usable(&lgr->lnk[i]) &&
 			    lgr->lnk[i].link_id == link_id)
-				continue;
+				goto again;
 		}
 		break;
 	}
-- 
1.8.3.1

