Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D11B40BDA5
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhIOCSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:21 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:16941 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhIOCSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:13 -0400
Received: (qmail 97137 invoked by uid 89); 15 Sep 2021 02:16:54 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 15 Sep 2021 02:16:54 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 15/18] ptp: ocp: Enable 4th timestamper / PPS generator
Date:   Tue, 14 Sep 2021 19:16:33 -0700
Message-Id: <20210915021636.153754-16-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A 4th timestamper is added which timestamps the output of the PHC.

The clock nanosecond offset is not always zero, so when compared
to other timestampers, this provides precise measurements.

Also, the timestamper interrupt from the PHC can be used to generate
a PPS signal for /dev/pps.

Also allow PTP_CLK_REQ_PEROUT requests for a 1PPS output, but do
not actually configure any output pins, this is done via sysfs.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 82 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index d0e3096f53f6..be8ab727a4ef 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -191,7 +191,7 @@ struct ptp_ocp_i2c_info {
 struct ptp_ocp_ext_info {
 	int index;
 	irqreturn_t (*irq_fcn)(int irq, void *priv);
-	int (*enable)(void *priv, bool enable);
+	int (*enable)(void *priv, u32 req, bool enable);
 };
 
 struct ptp_ocp_ext_src {
@@ -237,10 +237,14 @@ struct ptp_ocp {
 	int			nmea_port;
 	u8			serial[6];
 	bool			has_serial;
+	u32			pps_req_map;
 	int			flash_start;
 	u32			utc_tai_offset;
 };
 
+#define OCP_REQ_TIMESTAMP	BIT(0)
+#define OCP_REQ_PPS		BIT(1)
+
 struct ocp_resource {
 	unsigned long offset;
 	int size;
@@ -258,7 +262,7 @@ static int ptp_ocp_register_serial(struct ptp_ocp *bp, struct ocp_resource *r);
 static int ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r);
 static int ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r);
 static irqreturn_t ptp_ocp_ts_irq(int irq, void *priv);
-static int ptp_ocp_ts_enable(void *priv, bool enable);
+static int ptp_ocp_ts_enable(void *priv, u32 req, bool enable);
 
 #define bp_assign_entry(bp, res, val) ({				\
 	uintptr_t addr = (uintptr_t)(bp) + (res)->bp_offset;		\
@@ -284,7 +288,7 @@ static int ptp_ocp_ts_enable(void *priv, bool enable);
 	OCP_RES_LOCATION(member), .setup = ptp_ocp_register_ext
 
 /* This is the MSI vector mapping used.
- * 0: N/C
+ * 0: TS3 (and PPS)
  * 1: TS0
  * 2: TS1
  * 3: GNSS
@@ -329,6 +333,15 @@ static struct ocp_resource ocp_fb_resource[] = {
 			.enable = ptp_ocp_ts_enable,
 		},
 	},
+	{
+		OCP_EXT_RESOURCE(pps),
+		.offset = 0x010C0000, .size = 0x10000, .irq_vec = 0,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 3,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
 	{
 		OCP_MEM_RESOURCE(pps_to_ext),
 		.offset = 0x01030000, .size = 0x10000,
@@ -634,10 +647,12 @@ ptp_ocp_enable(struct ptp_clock_info *ptp_info, struct ptp_clock_request *rq,
 {
 	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
 	struct ptp_ocp_ext_src *ext = NULL;
+	u32 req;
 	int err;
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
+		req = OCP_REQ_TIMESTAMP;
 		switch (rq->extts.index) {
 		case 0:
 			ext = bp->ts0;
@@ -648,18 +663,30 @@ ptp_ocp_enable(struct ptp_clock_info *ptp_info, struct ptp_clock_request *rq,
 		case 2:
 			ext = bp->ts2;
 			break;
+		case 3:
+			ext = bp->pps;
+			break;
 		}
 		break;
 	case PTP_CLK_REQ_PPS:
+		req = OCP_REQ_PPS;
 		ext = bp->pps;
 		break;
+	case PTP_CLK_REQ_PEROUT:
+		if (on &&
+		    (rq->perout.period.sec != 1 || rq->perout.period.nsec != 0))
+			return -EINVAL;
+		/* This is a request for 1PPS on an output SMA.
+		 * Allow, but assume manual configuration.
+		 */
+		return 0;
 	default:
 		return -EOPNOTSUPP;
 	}
 
 	err = -ENXIO;
 	if (ext)
-		err = ext->info->enable(ext, on);
+		err = ext->info->enable(ext, req, on);
 
 	return err;
 }
@@ -675,7 +702,8 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.adjphase	= ptp_ocp_adjphase,
 	.enable		= ptp_ocp_enable,
 	.pps		= true,
-	.n_ext_ts	= 3,
+	.n_ext_ts	= 4,
+	.n_per_out	= 1,
 };
 
 static void
@@ -1163,6 +1191,16 @@ ptp_ocp_ts_irq(int irq, void *priv)
 	struct ptp_clock_event ev;
 	u32 sec, nsec;
 
+	if (ext == ext->bp->pps) {
+		if (ext->bp->pps_req_map & OCP_REQ_PPS) {
+			ev.type = PTP_CLOCK_PPS;
+			ptp_clock_event(ext->bp->ptp, &ev);
+		}
+
+		if ((ext->bp->pps_req_map & ~OCP_REQ_PPS) == 0)
+			goto out;
+	}
+
 	/* XXX should fix API - this converts s/ns -> ts -> s/ns */
 	sec = ioread32(&reg->time_sec);
 	nsec = ioread32(&reg->time_ns);
@@ -1173,16 +1211,31 @@ ptp_ocp_ts_irq(int irq, void *priv)
 
 	ptp_clock_event(ext->bp->ptp, &ev);
 
+out:
 	iowrite32(1, &reg->intr);	/* write 1 to ack */
 
 	return IRQ_HANDLED;
 }
 
 static int
-ptp_ocp_ts_enable(void *priv, bool enable)
+ptp_ocp_ts_enable(void *priv, u32 req, bool enable)
 {
 	struct ptp_ocp_ext_src *ext = priv;
 	struct ts_reg __iomem *reg = ext->mem;
+	struct ptp_ocp *bp = ext->bp;
+
+	if (ext == bp->pps) {
+		u32 old_map = bp->pps_req_map;
+
+		if (enable)
+			bp->pps_req_map |= req;
+		else
+			bp->pps_req_map &= ~req;
+
+		/* if no state change, just return */
+		if ((!!old_map ^ !!bp->pps_req_map) == 0)
+			return 0;
+	}
 
 	if (enable) {
 		iowrite32(1, &reg->enable);
@@ -1199,7 +1252,7 @@ ptp_ocp_ts_enable(void *priv, bool enable)
 static void
 ptp_ocp_unregister_ext(struct ptp_ocp_ext_src *ext)
 {
-	ext->info->enable(ext, false);
+	ext->info->enable(ext, ~0, false);
 	pci_free_irq(ext->bp->pdev, ext->irq_vec, ext);
 	kfree(ext);
 }
@@ -1889,8 +1942,8 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	struct timespec64 ts;
 	struct ptp_ocp *bp;
 	const char *src;
+	bool on, map;
 	char *buf;
-	bool on;
 
 	buf = (char *)__get_free_page(GFP_KERNEL);
 	if (!buf)
@@ -1938,6 +1991,19 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 			   on ? " ON" : "OFF", src);
 	}
 
+	if (bp->pps) {
+		ts_reg = bp->pps->mem;
+		src = "PHC";
+		on = ioread32(&ts_reg->enable);
+		map = !!(bp->pps_req_map & OCP_REQ_TIMESTAMP);
+		seq_printf(s, "%7s: %s, src: %s\n", "TS3",
+			   on & map ? " ON" : "OFF", src);
+
+		map = !!(bp->pps_req_map & OCP_REQ_PPS);
+		seq_printf(s, "%7s: %s, src: %s\n", "PPS",
+			   on & map ? " ON" : "OFF", src);
+	}
+
 	if (bp->irig_out) {
 		ctrl = ioread32(&bp->irig_out->ctrl);
 		on = ctrl & IRIG_M_CTRL_ENABLE;
-- 
2.31.1

