Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D184251E1E2
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444813AbiEFWl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356030AbiEFWl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:41:29 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA47E496BF
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:37:44 -0700 (PDT)
Received: (qmail 16696 invoked by uid 89); 6 May 2022 22:37:42 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 6 May 2022 22:37:42 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net RESEND] ptp: ocp: Use DIV64_U64_ROUND_UP for rounding.
Date:   Fri,  6 May 2022 15:37:39 -0700
Message-Id: <20220506223739.1930-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220506223739.1930-1-jonathan.lemon@gmail.com>
References: <20220506223739.1930-1-jonathan.lemon@gmail.com>
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

The initial code used roundup() to round the starting time to
a multiple of a period.  This generated an error on 32-bit
systems, so was replaced with DIV_ROUND_UP_ULL().

However, this truncates to 32-bits on a 64-bit system.  Replace
with DIV64_U64_ROUND_UP() instead.

Fixes: b325af3cfab9 ("ptp: ocp: Add signal generators and update sysfs nodes")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
Resend to fix misquoted Fixes: tag
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 0feaa4b45317..dd45471f6780 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1557,7 +1557,7 @@ ptp_ocp_signal_set(struct ptp_ocp *bp, int gen, struct ptp_ocp_signal *s)
 	start_ns = ktime_set(ts.tv_sec, ts.tv_nsec) + NSEC_PER_MSEC;
 	if (!s->start) {
 		/* roundup() does not work on 32-bit systems */
-		s->start = DIV_ROUND_UP_ULL(start_ns, s->period);
+		s->start = DIV64_U64_ROUND_UP(start_ns, s->period);
 		s->start = ktime_add(s->start, s->phase);
 	}
 
-- 
2.31.1

