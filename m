Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585F2526D2F
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 00:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359647AbiEMWwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 18:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356638AbiEMWwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 18:52:37 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5A61756B7
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 15:52:33 -0700 (PDT)
Received: (qmail 59114 invoked by uid 89); 13 May 2022 22:52:32 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 13 May 2022 22:52:32 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org, vfedorenko@novek.ru
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kernel-team@fb.com
Subject: [PATCH net v2] ptp: ocp: have adjtime handle negative delta_ns correctly
Date:   Fri, 13 May 2022 15:52:31 -0700
Message-Id: <20220513225231.1412-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

delta_ns is a s64, but it was being passed ptp_ocp_adjtime_coarse
as an u64.  Also, it turns out that timespec64_add_ns() only handles
positive values, so perform the math with set_normalized_timespec().

Fixes: 90f8f4c0e3ce ("ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments")
Suggested-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
v1->v2: Use set_normalized_timespec (Vadim)
---
 drivers/ptp/ptp_ocp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index dd45471f6780..36c0e188216b 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -841,7 +841,7 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
 }
 
 static void
-ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
+ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, s64 delta_ns)
 {
 	struct timespec64 ts;
 	unsigned long flags;
@@ -850,7 +850,8 @@ ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
 	spin_lock_irqsave(&bp->lock, flags);
 	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
 	if (likely(!err)) {
-		timespec64_add_ns(&ts, delta_ns);
+		set_normalized_timespec64(&ts, ts.tv_sec,
+					  ts.tv_nsec + delta_ns);
 		__ptp_ocp_settime_locked(bp, &ts);
 	}
 	spin_unlock_irqrestore(&bp->lock, flags);
-- 
2.31.1

