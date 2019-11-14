Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F824FCE04
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfKNSpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:15 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34408 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfKNSpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:13 -0500
Received: by mail-pg1-f195.google.com with SMTP id z188so4359589pgb.1
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z+UNW9RTqPu3T1gTax5uZNwqLIoODkDfS7V+zmu+zvg=;
        b=PR+007x9ZRbsMnCbY0Pqm9sa4glZfBmTZjjAcWxuqaiJoF1Fa6hgSi/KxVJQ77q9vL
         XlGd91pcpcPBY1SdFMmTO5Bbr6hxpJMhIIoW7SF4dPGlLjwVLkowsKWz9XBrjHvv+n/7
         Bkq9bDI+k8nHo0p2bIGAC+0qYeVakGEYBr6gdPC9CJcOhtFEwq3HtRdd+lc1qytyACe7
         Vh3s4XCKF2+caDp1lV41w8p0qhbv5fXRtJACg20KJspHUs9PqF1qloDkQjOr2eX4IdaU
         lM43nnaTZ9wrxvUdx8HuG/0Fh8gcH/pVWFzO4ye3KNptd5MzmwMBJr24fVmEav5Ae9qq
         qXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z+UNW9RTqPu3T1gTax5uZNwqLIoODkDfS7V+zmu+zvg=;
        b=GI4m25+pMwHUg5YOiFvo41DExR4WTCtWJIYqaDN7qo3oe6wQ6lnK8xL63S49w7T6k2
         ypwOnKHq3qZVctK+c8ySMbEpx3GYbnlakiFQzEWZLi+5l0k1xDNcssHQIuylY8fp2y2+
         gaq2eK/RD/r3RAEDJZ75HgFgZ5Gk9TDtfW/16555EGYfMwck+QwA5ZfzTNztMO4GHLWn
         yH6bnUa0BFRiVO7CJTFSdVZYhrW/7obEM7MsNopIgDoLLrFXp13zk6uOV23RU8ndTLDi
         pisyVbdYPtusjwYMD4f555Igh8Y5qUtJCrP510QrXlviz98v7VdqiIWNLzjiZzypLYDe
         CgjQ==
X-Gm-Message-State: APjAAAXE35xmRC25R1wOIVNf6gc50dZr1L+j4xWGk6w9rfbmDS8tRcZo
        aIqCsaR50/WtGy9VikkoVFGVFjyQ
X-Google-Smtp-Source: APXvYqxGwNcbi0fDj61FGKMWWQ86GkM6Yuwf37wlDl54Jq8YFICgenQ23oVxP91PXyvf3ZUhArluPA==
X-Received: by 2002:a63:e84f:: with SMTP id a15mr11789853pgk.309.1573757112515;
        Thu, 14 Nov 2019 10:45:12 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:11 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Christopher Hall <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Stefan Sorensen <stefan.sorensen@spectralink.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH net 02/13] net: reject PTP periodic output requests with unsupported flags
Date:   Thu, 14 Nov 2019 10:44:56 -0800
Message-Id: <20191114184507.18937-3-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Commit 823eb2a3c4c7 ("PTP: add support for one-shot output") introduced
a new flag for the PTP periodic output request ioctl. This flag is not
currently supported by any driver.

Fix all drivers which implement the periodic output request ioctl to
explicitly reject any request with flags they do not understand. This
ensures that the driver does not accidentally misinterpret the
PTP_PEROUT_ONE_SHOT flag, or any new flag introduced in the future.

This is important for forward compatibility: if a new flag is
introduced, the driver should reject requests to enable the flag until
the driver has actually been modified to support the flag in question.

Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Christopher Hall <christopher.s.hall@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---
 drivers/net/ethernet/broadcom/tg3.c                 | 4 ++++
 drivers/net/ethernet/intel/igb/igb_ptp.c            | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 4 ++++
 drivers/net/ethernet/microchip/lan743x_ptp.c        | 4 ++++
 drivers/net/ethernet/renesas/ravb_ptp.c             | 4 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c    | 4 ++++
 drivers/net/phy/dp83640.c                           | 3 +++
 7 files changed, 27 insertions(+)

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
index fd3071f55bd3..4997963149f6 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -551,6 +551,10 @@ static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
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
index 0059b290e095..cff6b60de304 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -290,6 +290,10 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
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
index 9a42580693cb..638f1fc2166f 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -211,6 +211,10 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
 	unsigned long flags;
 	int error = 0;
 
+	/* Reject requests with unsupported flags */
+	if (req->flags)
+		return -EOPNOTSUPP;
+
 	if (req->index)
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index df638b18b72c..0989e2bb6ee3 100644
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
index 6580094161a9..04ad77758920 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -491,6 +491,9 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 		return 0;
 
 	case PTP_CLK_REQ_PEROUT:
+		/* Reject requests with unsupported flags */
+		if (rq->perout.flags)
+			return -EOPNOTSUPP;
 		if (rq->perout.index >= N_PER_OUT)
 			return -EINVAL;
 		return periodic_output(clock, rq, on, rq->perout.index);
-- 
2.20.1

