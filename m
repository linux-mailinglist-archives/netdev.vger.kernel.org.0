Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE611C6968
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgEFGvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:51:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35322 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727067AbgEFGvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:51:44 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E7C20E2CA0B008BA9AF9;
        Wed,  6 May 2020 14:51:41 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 6 May 2020 14:51:33 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-s390@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net/smc: remove set but not used variables 'del_llc, del_llc_resp'
Date:   Wed, 6 May 2020 06:55:40 +0000
Message-ID: <20200506065540.171504-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

net/smc/smc_llc.c: In function 'smc_llc_cli_conf_link':
net/smc/smc_llc.c:753:31: warning:
 variable 'del_llc' set but not used [-Wunused-but-set-variable]
  struct smc_llc_msg_del_link *del_llc;
                               ^
net/smc/smc_llc.c: In function 'smc_llc_process_srv_delete_link':
net/smc/smc_llc.c:1311:33: warning:
 variable 'del_llc_resp' set but not used [-Wunused-but-set-variable]
    struct smc_llc_msg_del_link *del_llc_resp;
                                 ^

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/smc/smc_llc.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 4cc583678ac7..391237b601fe 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -750,7 +750,6 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
 				 enum smc_lgr_type lgr_new_t)
 {
 	struct smc_link_group *lgr = link->lgr;
-	struct smc_llc_msg_del_link *del_llc;
 	struct smc_llc_qentry *qentry = NULL;
 	int rc = 0;
 
@@ -764,7 +763,6 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
 	}
 	if (qentry->msg.raw.hdr.common.type != SMC_LLC_CONFIRM_LINK) {
 		/* received DELETE_LINK instead */
-		del_llc = &qentry->msg.delete_link;
 		qentry->msg.raw.hdr.flags |= SMC_LLC_FLAG_RESP;
 		smc_llc_send_message(link, &qentry->msg);
 		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
@@ -1308,16 +1306,12 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 		 * enqueued DELETE_LINK request (forward it)
 		 */
 		if (!smc_llc_send_message(lnk, &qentry->msg)) {
-			struct smc_llc_msg_del_link *del_llc_resp;
 			struct smc_llc_qentry *qentry2;
 
 			qentry2 = smc_llc_wait(lgr, lnk, SMC_LLC_WAIT_TIME,
 					       SMC_LLC_DELETE_LINK);
-			if (!qentry2) {
-			} else {
-				del_llc_resp = &qentry2->msg.delete_link;
+			if (qentry2)
 				smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
-			}
 		}
 	}
 	smcr_link_clear(lnk_del, true);



