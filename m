Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504B751CCEF
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386976AbiEEXxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386952AbiEEXxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:53:17 -0400
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B8C606FE
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:49:35 -0700 (PDT)
Received: (qmail 59253 invoked by uid 89); 5 May 2022 23:49:33 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 5 May 2022 23:49:33 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH net-next v1 08/10] ptp: ocp: fix PPS source selector reporting
Date:   Thu,  5 May 2022 16:49:19 -0700
Message-Id: <20220505234921.3728-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220505234921.3728-1-jonathan.lemon@gmail.com>
References: <20220505234921.3728-1-jonathan.lemon@gmail.com>
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

The NTL timecard design has a PPS1 selector which selects the
the PPS source automatically, according to Section 1.9 of the
documentation.

  If there is a SMA PPS input detected:
     - send signal to MAC and PPS slave selector.

  If there is a MAC PPS input detected:
     - send GNSS1 to the MAC
     - send MAC to the PPS slave

  If there is a GNSS1 input detected:
     - send GNSS1 to the MAC
     - send GNSS1 to the PPS slave.MAC

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4e22c445dad4..2b1f854270b0 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3072,10 +3072,10 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	struct device *dev = s->private;
 	struct ptp_system_timestamp sts;
 	struct ts_reg __iomem *ts_reg;
+	char *buf, *src, *mac_src;
 	struct timespec64 ts;
 	struct ptp_ocp *bp;
 	u16 sma_val[4][2];
-	char *src, *buf;
 	u32 ctrl, val;
 	bool on, map;
 	int i;
@@ -3238,17 +3238,26 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	if (bp->pps_select) {
 		val = ioread32(&bp->pps_select->gpio1);
 		src = &buf[80];
-		if (val & 0x01)
+		mac_src = "GNSS1";
+		if (val & 0x01) {
 			gpio_input_map(src, bp, sma_val, 0, NULL);
-		else if (val & 0x02)
+			mac_src = src;
+		} else if (val & 0x02)
 			src = "MAC";
 		else if (val & 0x04)
 			src = "GNSS1";
-		else
+		else {
 			src = "----";
+			mac_src = src;
+		}
 	} else {
 		src = "?";
+		mac_src = src;
 	}
+	seq_printf(s, "MAC PPS1 src: %s\n", mac_src);
+
+	gpio_input_map(buf, bp, sma_val, 1, "GNSS2");
+	seq_printf(s, "MAC PPS2 src: %s\n", buf);
 
 	/* assumes automatic switchover/selection */
 	val = ioread32(&bp->reg->select);
@@ -3273,12 +3282,6 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	seq_printf(s, "%7s: %s, state: %s\n", "PHC src", buf,
 		   val & OCP_STATUS_IN_SYNC ? "sync" : "unsynced");
 
-	/* reuses PPS1 src from earlier */
-	seq_printf(s, "MAC PPS1 src: %s\n", src);
-
-	gpio_input_map(buf, bp, sma_val, 1, "GNSS2");
-	seq_printf(s, "MAC PPS2 src: %s\n", buf);
-
 	if (!ptp_ocp_gettimex(&bp->ptp_info, &ts, &sts)) {
 		struct timespec64 sys_ts;
 		s64 pre_ns, post_ns, ns;
-- 
2.31.1

