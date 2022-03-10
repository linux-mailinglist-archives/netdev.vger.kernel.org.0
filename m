Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F584D5304
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244983AbiCJUUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244909AbiCJUU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:20:29 -0500
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0306C180D07
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:19:23 -0800 (PST)
Received: (qmail 73589 invoked by uid 89); 10 Mar 2022 20:19:22 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 10 Mar 2022 20:19:22 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 07/10] ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT
Date:   Thu, 10 Mar 2022 12:19:09 -0800
Message-Id: <20220310201912.933172-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310201912.933172-1-jonathan.lemon@gmail.com>
References: <20220310201912.933172-1-jonathan.lemon@gmail.com>
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

The signal generators can be programmed either via the sysfs
file or through a PTP_CLK_REQ_PEROUT ioctl request.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 103 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 94 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 397e3e6b840f..002b3d00996e 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -332,6 +332,8 @@ static int ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r);
 static irqreturn_t ptp_ocp_ts_irq(int irq, void *priv);
 static irqreturn_t ptp_ocp_signal_irq(int irq, void *priv);
 static int ptp_ocp_ts_enable(void *priv, u32 req, bool enable);
+static int ptp_ocp_signal_from_perout(struct ptp_ocp *bp, int gen,
+				      struct ptp_perout_request *req);
 static int ptp_ocp_signal_enable(void *priv, u32 req, bool enable);
 static int ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr);
 
@@ -867,13 +869,27 @@ ptp_ocp_enable(struct ptp_clock_info *ptp_info, struct ptp_clock_request *rq,
 		ext = bp->pps;
 		break;
 	case PTP_CLK_REQ_PEROUT:
-		if (on &&
-		    (rq->perout.period.sec != 1 || rq->perout.period.nsec != 0))
-			return -EINVAL;
-		/* This is a request for 1PPS on an output SMA.
-		 * Allow, but assume manual configuration.
-		 */
-		return 0;
+		switch (rq->perout.index) {
+		case 0:
+			/* This is a request for 1PPS on an output SMA.
+			 * Allow, but assume manual configuration.
+			 */
+			if (on && (rq->perout.period.sec != 1 ||
+				   rq->perout.period.nsec != 0))
+				return -EINVAL;
+			return 0;
+		case 1:
+		case 2:
+		case 3:
+		case 4:
+			req = rq->perout.index - 1;
+			ext = bp->signal_out[req];
+			err = ptp_ocp_signal_from_perout(bp, req, &rq->perout);
+			if (err)
+				return err;
+			break;
+		}
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -885,6 +901,24 @@ ptp_ocp_enable(struct ptp_clock_info *ptp_info, struct ptp_clock_request *rq,
 	return err;
 }
 
+static int
+ptp_ocp_verify(struct ptp_clock_info *ptp_info, unsigned pin,
+	       enum ptp_pin_function func, unsigned chan)
+{
+	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
+	char buf[16];
+
+	if (func != PTP_PF_PEROUT)
+		return -EOPNOTSUPP;
+
+	if (chan)
+		sprintf(buf, "OUT: GEN%d", chan);
+	else
+		sprintf(buf, "OUT: PHC");
+
+	return ptp_ocp_sma_store(bp, buf, pin + 1);
+}
+
 static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= KBUILD_MODNAME,
@@ -895,9 +929,10 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.adjfine	= ptp_ocp_null_adjfine,
 	.adjphase	= ptp_ocp_null_adjphase,
 	.enable		= ptp_ocp_enable,
+	.verify		= ptp_ocp_verify,
 	.pps		= true,
 	.n_ext_ts	= 4,
-	.n_per_out	= 1,
+	.n_per_out	= 5,
 };
 
 static void
@@ -1465,6 +1500,30 @@ ptp_ocp_signal_set(struct ptp_ocp *bp, int gen, struct ptp_ocp_signal *s)
 	return 0;
 }
 
+static int
+ptp_ocp_signal_from_perout(struct ptp_ocp *bp, int gen,
+			   struct ptp_perout_request *req)
+{
+	struct ptp_ocp_signal s = { };
+
+	s.polarity = bp->signal[gen].polarity;
+	s.period = ktime_set(req->period.sec, req->period.nsec);
+	if (!s.period)
+		return 0;
+
+	if (req->flags & PTP_PEROUT_DUTY_CYCLE) {
+		s.pulse = ktime_set(req->on.sec, req->on.nsec);
+		s.duty = ktime_divns(s.pulse * 100, s.period);
+	}
+
+	if (req->flags & PTP_PEROUT_PHASE)
+		s.phase = ktime_set(req->phase.sec, req->phase.nsec);
+	else
+		s.start = ktime_set(req->start.sec, req->start.nsec);
+
+	return ptp_ocp_signal_set(bp, gen, &s);
+}
+
 static int
 ptp_ocp_signal_enable(void *priv, u32 req, bool enable)
 {
@@ -1740,11 +1799,32 @@ ptp_ocp_sma_init(struct ptp_ocp *bp)
 	}
 }
 
+static int
+ptp_ocp_fb_set_pins(struct ptp_ocp *bp)
+{
+	struct ptp_pin_desc *config;
+	int i;
+
+	config = kzalloc(sizeof(*config) * 4, GFP_KERNEL);
+	if (!config)
+		return -ENOMEM;
+
+	for (i = 0; i < 4; i++) {
+		sprintf(config[i].name, "sma%d", i + 1);
+		config[i].index = i;
+	}
+
+	bp->ptp_info.n_pins = 4;
+	bp->ptp_info.pin_config = config;
+
+	return 0;
+}
+
 /* FB specific board initializers; last "resource" registered. */
 static int
 ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 {
-	int ver;
+	int ver, err;
 
 	bp->flash_start = 1024 * 4096;
 	bp->eeprom_map = fb_eeprom_map;
@@ -1761,6 +1841,10 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	ptp_ocp_sma_init(bp);
 	ptp_ocp_signal_init(bp);
 
+	err = ptp_ocp_fb_set_pins(bp);
+	if (err)
+		return err;
+
 	return ptp_ocp_init_clock(bp);
 }
 
@@ -3238,6 +3322,7 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		pci_free_irq_vectors(bp->pdev);
 	if (bp->ptp)
 		ptp_clock_unregister(bp->ptp);
+	kfree(bp->ptp_info.pin_config);
 	device_unregister(&bp->dev);
 }
 
-- 
2.31.1

