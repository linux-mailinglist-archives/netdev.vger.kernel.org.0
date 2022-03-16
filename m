Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D984B4DB6C3
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 17:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356913AbiCPQzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 12:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357588AbiCPQzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 12:55:05 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3807431341
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 09:53:50 -0700 (PDT)
Received: (qmail 18860 invoked by uid 89); 16 Mar 2022 16:53:49 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 16 Mar 2022 16:53:49 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next] ptp: ocp: Make debugfs variables the correct bitwidth
Date:   Wed, 16 Mar 2022 09:53:47 -0700
Message-Id: <20220316165347.599154-1-jonathan.lemon@gmail.com>
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

An earlier patch mistakenly changed these variables from u32 to u16,
leading to unintended truncation.  Restore the original logic.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index d8cefc89a588..d64a1ce5f5bc 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2983,11 +2983,12 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 {
 	struct device *dev = s->private;
 	struct ptp_system_timestamp sts;
-	u16 sma_val[4][2], ctrl, val;
 	struct ts_reg __iomem *ts_reg;
 	struct timespec64 ts;
 	struct ptp_ocp *bp;
+	u16 sma_val[4][2];
 	char *src, *buf;
+	u32 ctrl, val;
 	bool on, map;
 	int i;
 
-- 
2.31.1

