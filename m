Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B455E97B5
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 03:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiIZB2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 21:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiIZB1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 21:27:54 -0400
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BC72B269;
        Sun, 25 Sep 2022 18:27:50 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id UAB00147;
        Mon, 26 Sep 2022 09:27:47 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2507.12; Mon, 26 Sep 2022 09:27:47 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] ptp: Remove usage of the deprecated ida_simple_xxx API
Date:   Sun, 25 Sep 2022 21:27:44 -0400
Message-ID: <20220926012744.3363-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20229260927472881b93d13ea070290ca676091240bcf
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ida_alloc_xxx()/ida_free() instead of
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/ptp/ptp_clock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 688cde320bb0..51cae72bb6db 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -174,7 +174,7 @@ static void ptp_clock_release(struct device *dev)
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	mutex_destroy(&ptp->n_vclocks_mux);
-	ida_simple_remove(&ptp_clocks_map, ptp->index);
+	ida_free(&ptp_clocks_map, ptp->index);
 	kfree(ptp);
 }
 
@@ -217,7 +217,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	if (ptp == NULL)
 		goto no_memory;
 
-	index = ida_simple_get(&ptp_clocks_map, 0, MINORMASK + 1, GFP_KERNEL);
+	index = ida_alloc_max(&ptp_clocks_map, MINORMASK, GFP_KERNEL);
 	if (index < 0) {
 		err = index;
 		goto no_slot;
@@ -332,7 +332,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	mutex_destroy(&ptp->n_vclocks_mux);
-	ida_simple_remove(&ptp_clocks_map, index);
+	ida_free(&ptp_clocks_map, index);
 no_slot:
 	kfree(ptp);
 no_memory:
-- 
2.27.0

