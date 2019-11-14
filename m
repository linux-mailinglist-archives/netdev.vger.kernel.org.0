Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B24FCE0F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKNSpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:23 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34872 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfKNSpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id q13so4872324pff.2
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OffYFMf+ZOaY8ZSWvKSHW83/Ze95I/wpNSGexu7BXxI=;
        b=j2tGtcfxj1ga7Tqd36W0X/V5RQZLx6EpTYpyTuM5tdkGy7JuSR7UXcdQzREdkM3A3e
         e+AGxHhQ9ECeD/gxqV97/etfJVzIFKGByvmlowBdPPrnWLsE4mb+XXDXZp9b+rOZ4Pmb
         R9q64AQNdVb5At/1pqTK0MPTxGrO3dfhnxhwK18DxWeT1KObRlNYn2CSwyUnOFwr7TcR
         xihGKPNTSxfCbug7VjCtfD8WTnahq87qSzPYZTu2MoyPd7/HauyziE6sNN204u1CsxS/
         TBnswY0TspaL87u0pnxyNT08OV1lDrJIE4greHudGDQ9lmTZGkgkQvD9yBrU5kIAgzLB
         B7Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OffYFMf+ZOaY8ZSWvKSHW83/Ze95I/wpNSGexu7BXxI=;
        b=N3rbx/0XgY2JXzlL03a+kBEVVNsIDV6aF43pFK6TTKAZD1ylIIqNZ+YsqvXCoK9X0c
         j3EiuzVyJvssw3iIumnolVrCyvfoewiDckcjj5e4pIRjIObupLFxhRXxEytD+mVhpy2F
         ICiuI8zBhLeoE+CaytUaAWsbDQznBzzE31nJjDEKWbnFWEC4TMSXzCgN2EkLy/Ockh8a
         /U+2tFSKtS2C5KFT+nE2b6/2ZQc9w6Z0hc6K3SykyUeHgOwzqPMyR/2Y+xzg3ry7xbHG
         3KmJyznIMR9/WonQgpIIH6B+w4D4Nxmny8nbGYsjkFsXThBp2S/ttw2sf9cThJ1caFlU
         i+Ww==
X-Gm-Message-State: APjAAAX9N6lJyWOEdwR6vCk4nqouyb4FJW7Ba5r2MCnvJVeZP/8vmQNL
        U3WRBf6Rw6o3LToQ1RnieG2wW0dz
X-Google-Smtp-Source: APXvYqyRG6OMoXdvstk6lQ4vX+oJ+6MB6GqKUl+zWiqYwW99r1BlXyeVdDrRK+hCRjWeoYMefinvrw==
X-Received: by 2002:a17:90b:d88:: with SMTP id bg8mr14417315pjb.78.1573757121030;
        Thu, 14 Nov 2019 10:45:21 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:20 -0800 (PST)
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
        Stefan Sorensen <stefan.sorensen@spectralink.com>
Subject: [PATCH net 08/13] ptp: Introduce strict checking of external time stamp options.
Date:   Thu, 14 Nov 2019 10:45:02 -0800
Message-Id: <20191114184507.18937-9-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User space may request time stamps on rising edges, falling edges, or
both.  However, the particular mode may or may not be supported in the
hardware or in the driver.  This patch adds a "strict" flag that tells
drivers to ensure that the requested mode will be honored.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/ptp.c                     | 3 ++-
 drivers/net/ethernet/intel/igb/igb_ptp.c            | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 3 ++-
 drivers/net/ethernet/renesas/ravb_ptp.c             | 3 ++-
 drivers/net/phy/dp83640.c                           | 3 ++-
 drivers/ptp/ptp_chardev.c                           | 2 ++
 include/uapi/linux/ptp_clock.h                      | 4 +++-
 7 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 076e622a64d6..3b1985902f95 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -276,7 +276,8 @@ static int mv88e6352_ptp_enable_extts(struct mv88e6xxx_chip *chip,
 	/* Reject requests with unsupported flags */
 	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
 				PTP_RISING_EDGE |
-				PTP_FALLING_EDGE))
+				PTP_FALLING_EDGE |
+				PTP_STRICT_FLAGS))
 		return -EOPNOTSUPP;
 
 	pin = ptp_find_pin(chip->ptp_clock, PTP_PF_EXTTS, rq->extts.index);
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 0bce3e0f1af0..3fd60715bca7 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -524,7 +524,8 @@ static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
 		/* Reject requests with unsupported flags */
 		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
 					PTP_RISING_EDGE |
-					PTP_FALLING_EDGE))
+					PTP_FALLING_EDGE |
+					PTP_STRICT_FLAGS))
 			return -EOPNOTSUPP;
 
 		if (on) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 9a40f24e3193..819097d9b583 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -239,7 +239,8 @@ static int mlx5_extts_configure(struct ptp_clock_info *ptp,
 	/* Reject requests with unsupported flags */
 	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
 				PTP_RISING_EDGE |
-				PTP_FALLING_EDGE))
+				PTP_FALLING_EDGE |
+				PTP_STRICT_FLAGS))
 		return -EOPNOTSUPP;
 
 	if (rq->extts.index >= clock->ptp_info.n_pins)
diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 666dbee48097..6984bd5b7da9 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -185,7 +185,8 @@ static int ravb_ptp_extts(struct ptp_clock_info *ptp,
 	/* Reject requests with unsupported flags */
 	if (req->flags & ~(PTP_ENABLE_FEATURE |
 			   PTP_RISING_EDGE |
-			   PTP_FALLING_EDGE))
+			   PTP_FALLING_EDGE |
+			   PTP_STRICT_FLAGS))
 		return -EOPNOTSUPP;
 
 	if (req->index)
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 2781b0e2d947..3bba2bea3a88 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -472,7 +472,8 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 		/* Reject requests with unsupported flags */
 		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
 					PTP_RISING_EDGE |
-					PTP_FALLING_EDGE))
+					PTP_FALLING_EDGE |
+					PTP_STRICT_FLAGS))
 			return -EOPNOTSUPP;
 		index = rq->extts.index;
 		if (index >= N_EXT_TS)
diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index cbbe1237ff8d..9d72ab593f13 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -150,6 +150,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			break;
 		}
 		if (cmd == PTP_EXTTS_REQUEST2) {
+			/* Tell the drivers to check the flags carefully. */
+			req.extts.flags |= PTP_STRICT_FLAGS;
 			/* Make sure no reserved bit is set. */
 			if ((req.extts.flags & ~PTP_EXTTS_VALID_FLAGS) ||
 			    req.extts.rsv[0] || req.extts.rsv[1]) {
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 304059b1609d..9dc9d0079e98 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -31,6 +31,7 @@
 #define PTP_ENABLE_FEATURE (1<<0)
 #define PTP_RISING_EDGE    (1<<1)
 #define PTP_FALLING_EDGE   (1<<2)
+#define PTP_STRICT_FLAGS   (1<<3)
 #define PTP_EXTTS_EDGES    (PTP_RISING_EDGE | PTP_FALLING_EDGE)
 
 /*
@@ -38,7 +39,8 @@
  */
 #define PTP_EXTTS_VALID_FLAGS	(PTP_ENABLE_FEATURE |	\
 				 PTP_RISING_EDGE |	\
-				 PTP_FALLING_EDGE)
+				 PTP_FALLING_EDGE |	\
+				 PTP_STRICT_FLAGS)
 
 /*
  * flag fields valid for the original PTP_EXTTS_REQUEST ioctl.
-- 
2.20.1

