Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F202C51CCD3
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344152AbiEEXog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355936AbiEEXod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:44:33 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0F4606F8
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:40:52 -0700 (PDT)
Received: (qmail 24155 invoked by uid 89); 5 May 2022 23:40:51 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 5 May 2022 23:40:51 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH net] ptp: ocp: have adjtime handle negative delta_ns correctly
Date:   Thu,  5 May 2022 16:40:50 -0700
Message-Id: <20220505234050.3378-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

delta_ns is a s64, but it was being passed ptp_ocp_adjtime_coarse
as an u64.  Also, it turns out that timespec64_add_ns() only handles
positive values, so the math needs to be updated.

Fix by passing in the correct signed value, then adding to a
nanosecond version of the timespec.

Fixes: '90f8f4c0e3ce ("ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments")'
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index dd45471f6780..65e592ec272e 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -841,16 +841,18 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
 }
 
 static void
-ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
+ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, s64 delta_ns)
 {
 	struct timespec64 ts;
 	unsigned long flags;
 	int err;
+	s64 ns;
 
 	spin_lock_irqsave(&bp->lock, flags);
 	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
 	if (likely(!err)) {
-		timespec64_add_ns(&ts, delta_ns);
+		ns = timespec64_to_ns(&ts) + delta_ns;
+		ts = ns_to_timespec64(ns);
 		__ptp_ocp_settime_locked(bp, &ts);
 	}
 	spin_unlock_irqrestore(&bp->lock, flags);
-- 
2.31.1

