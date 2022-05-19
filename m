Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A509252DF25
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244354AbiESVWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245155AbiESVWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:22:16 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B6110275B
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:22:11 -0700 (PDT)
Received: (qmail 9092 invoked by uid 89); 19 May 2022 21:22:06 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 19 May 2022 21:22:06 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v4 09/10] ptp: ocp: fix PPS source selector debugfs reporting
Date:   Thu, 19 May 2022 14:21:52 -0700
Message-Id: <20220519212153.450437-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220519212153.450437-1-jonathan.lemon@gmail.com>
References: <20220519212153.450437-1-jonathan.lemon@gmail.com>
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

Change the debugfs summary so it reflects the correct mapping,
for assistance in debugging.  No functional change.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 3856e9c24333..9fac96fd0fd4 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3099,10 +3099,10 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
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
@@ -3265,17 +3265,26 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	if (bp->pps_select) {
 		val = ioread32(&bp->pps_select->gpio1);
 		src = &buf[80];
-		if (val & 0x01)
+		mac_src = "GNSS1";
+		if (val & 0x01) {
 			gpio_input_map(src, bp, sma_val, 0, NULL);
-		else if (val & 0x02)
+			mac_src = src;
+		} else if (val & 0x02) {
 			src = "MAC";
-		else if (val & 0x04)
+		} else if (val & 0x04) {
 			src = "GNSS1";
-		else
+		} else {
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
@@ -3300,12 +3309,6 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
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

