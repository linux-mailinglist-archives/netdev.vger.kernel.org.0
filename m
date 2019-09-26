Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA15BEA94
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 04:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388706AbfIZC2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 22:28:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:4884 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731812AbfIZC2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 22:28:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 19:28:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,550,1559545200"; 
   d="scan'208";a="183469400"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga008.jf.intel.com with ESMTP; 25 Sep 2019 19:28:24 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Hall <christopher.s.hall@intel.com>
Subject: [net-next v2 0/2] new PTP ioctl fixes
Date:   Wed, 25 Sep 2019 19:28:18 -0700
Message-Id: <20190926022820.7900-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.23.0.245.gf157bbb9169d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed recently that Filip added new versions of the PTP ioctls which
correctly honor the reserved fields (making it so that we can safely extend
them in the future).

Unfortunately, this breaks the old ioctls for a couple of reasons. First,
the flags for the old ioctls get cleared. This means that the external
timestamp request can never be enabled. Further, it means future new flags
will *not* be cleared, and thus old ioctl will potentially send non-zero
data and be mis-interpreted.

Additionally, new flags are not protected against in-driver, because no
current driver verifies that the flags are only one of the supported ones.
This means new flags will be mis-interpreted by the drivers.

This series provides patches to fix drivers to verify and reject unsupported
flags, as well as to fix the ioctls to clear flags on the old version of the
ioctl properly.

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Christopher Hall <christopher.s.hall@intel.com>

Range-diff from v1:
1:  c317dc1cc7eb = 1:  c317dc1cc7eb ptp: correctly disable flags on old ioctls
2:  08ce725c7f2a ! 2:  5537762fb9cc net: reject ptp requests with unsupported flags
    @@ drivers/net/phy/dp83640.c: static int ptp_dp83640_enable(struct ptp_clock_info *
      	switch (rq->type) {
      	case PTP_CLK_REQ_EXTTS:
     +		/* Reject requests with unsupported flags */
    -+		if (rq->extts.flags & ~(PTP_FEATURE_ENABLE |
    ++		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
     +					PTP_RISING_EDGE |
     +					PTP_FALLING_EDGE))
     +			return -EOPNOTSUPP;

Jacob Keller (2):
  ptp: correctly disable flags on old ioctls
  net: reject ptp requests with unsupported flags

 drivers/net/dsa/mv88e6xxx/ptp.c               |  5 +++++
 drivers/net/ethernet/broadcom/tg3.c           |  4 ++++
 drivers/net/ethernet/intel/igb/igb_ptp.c      |  8 +++++++
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 10 +++++++++
 drivers/net/ethernet/microchip/lan743x_ptp.c  |  4 ++++
 drivers/net/ethernet/renesas/ravb_ptp.c       |  9 ++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  4 ++++
 drivers/net/phy/dp83640.c                     |  8 +++++++
 drivers/ptp/ptp_chardev.c                     |  4 ++--
 include/uapi/linux/ptp_clock.h                | 22 +++++++++++++++++++
 10 files changed, 76 insertions(+), 2 deletions(-)

-- 
2.23.0.245.gf157bbb9169d

