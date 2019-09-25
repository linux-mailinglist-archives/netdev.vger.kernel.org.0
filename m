Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F58BE8F6
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 01:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfIYXd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 19:33:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:32056 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbfIYXd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 19:33:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 16:33:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="201419368"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga002.jf.intel.com with ESMTP; 25 Sep 2019 16:33:27 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Hall <christopher.s.hall@intel.com>
Subject: [net-next 2/2] net: reject ptp requests with unsupported flags
Date:   Wed, 25 Sep 2019 16:33:12 -0700
Message-Id: <20190925233312.13977-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.23.0.245.gf157bbb9169d
In-Reply-To: <20190925233312.13977-1-jacob.e.keller@intel.com>
References: <20190925233312.13977-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix all of the drivers which implement support for the periodic output
or external timestamp requests to reject unsupported flags.

This is important for forward compatibility: if a new flag is
introduced, the driver should reject requests to enable the flag until
it has been modified to actually support the flag in question.

This patch may not be correct for individual drivers, especially
regarding the rising vs falling edge flags. I interpreted the default
behavior to be to timestamp the rising edge of a pin transition.

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Christopher Hall <christopher.s.hall@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/dsa/mv88e6xxx/ptp.c                     |  5 +++++
 drivers/net/ethernet/broadcom/tg3.c                 |  4 ++++
 drivers/net/ethernet/intel/igb/igb_ptp.c            |  8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 10 ++++++++++
 drivers/net/ethernet/microchip/lan743x_ptp.c        |  4 ++++
 drivers/net/ethernet/renesas/ravb_ptp.c             |  9 +++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c    |  4 ++++
 drivers/net/phy/dp83640.c                           |  8 ++++++++
 8 files changed, 52 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 073cbd0bb91b..2364b6b67a7b 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -273,6 +273,11 @@ static int mv88e6352_ptp_enable_extts(struct mv88e6xxx_chip *chip,
 	int pin;
 	int err;
 
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE))
+		return -EOPNOTSUPP;
+
 	pin = ptp_find_pin(chip->ptp_clock, PTP_PF_EXTTS, rq->extts.index);
 
 	if (pin < 0)
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 77f3511b97de..ca3aa1250dd1 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6280,6 +6280,10 @@ static int tg3_ptp_enable(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
+		/* Reject requests with unsupported flags */
+		if (rq->perout.flags)
+			return -EOPNOTSUPP;
+
 		if (rq->perout.index != 0)
 			return -EINVAL;
 
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index fd3071f55bd3..2867a2581a36 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -521,6 +521,10 @@ static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
+		/* Reject requests with unsupported flags */
+		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE | PTP_RISING_EDGE))
+			return -EOPNOTSUPP;
+
 		if (on) {
 			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_EXTTS,
 					   rq->extts.index);
@@ -551,6 +555,10 @@ static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
 		return 0;
 
 	case PTP_CLK_REQ_PEROUT:
+		/* Reject requests with unsupported flags */
+		if (rq->perout.flags)
+			return -EOPNOTSUPP;
+
 		if (on) {
 			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_PEROUT,
 					   rq->perout.index);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 0059b290e095..9a40f24e3193 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -236,6 +236,12 @@ static int mlx5_extts_configure(struct ptp_clock_info *ptp,
 	if (!MLX5_PPS_CAP(mdev))
 		return -EOPNOTSUPP;
 
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE |
+				PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
 	if (rq->extts.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
@@ -290,6 +296,10 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 	if (!MLX5_PPS_CAP(mdev))
 		return -EOPNOTSUPP;
 
+	/* Reject requests with unsupported flags */
+	if (rq->perout.flags)
+		return -EOPNOTSUPP;
+
 	if (rq->perout.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 57b26c2acf87..e8fe9a90fe4f 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -429,6 +429,10 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 	int pulse_width = 0;
 	int perout_bit = 0;
 
+	/* Reject requests with unsupported flags */
+	if (perout->flags)
+		return -EOPNOTSUPP;
+
 	if (!on) {
 		lan743x_ptp_perout_off(adapter);
 		return 0;
diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 9a42580693cb..fe66697aafec 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -182,6 +182,11 @@ static int ravb_ptp_extts(struct ptp_clock_info *ptp,
 	struct net_device *ndev = priv->ndev;
 	unsigned long flags;
 
+	/* Reject requests with unsupported flags */
+	if (req->flags & ~(PTP_ENABLE_FEATURE |
+			   PTP_RISING_EDGE))
+		return -EOPNOTSUPP;
+
 	if (req->index)
 		return -EINVAL;
 
@@ -211,6 +216,10 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
 	unsigned long flags;
 	int error = 0;
 
+	/* Reject requests with unsupported flags */
+	if (req->flags)
+		return -EOPNOTSUPP;
+
 	if (req->index)
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 173493db038c..352dc4c68625 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -140,6 +140,10 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
+		/* Reject requests with unsupported flags */
+		if (rq->perout.flags)
+			return -EOPNOTSUPP;
+
 		cfg = &priv->pps[rq->perout.index];
 
 		cfg->start.tv_sec = rq->perout.start.sec;
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 6580094161a9..eba0569b1928 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -469,6 +469,11 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
+		/* Reject requests with unsupported flags */
+		if (rq->extts.flags & ~(PTP_FEATURE_ENABLE |
+					PTP_RISING_EDGE |
+					PTP_FALLING_EDGE))
+			return -EOPNOTSUPP;
 		index = rq->extts.index;
 		if (index >= N_EXT_TS)
 			return -EINVAL;
@@ -491,6 +496,9 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 		return 0;
 
 	case PTP_CLK_REQ_PEROUT:
+		/* Reject requests with unsupported flags */
+		if (rq->perout.flags)
+			return -EOPNOTSUPP;
 		if (rq->perout.index >= N_PER_OUT)
 			return -EINVAL;
 		return periodic_output(clock, rq, on, rq->perout.index);
-- 
2.23.0.245.gf157bbb9169d

