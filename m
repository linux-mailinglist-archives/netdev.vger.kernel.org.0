Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226A6391E02
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbhEZRYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:24:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:18091 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234395AbhEZRX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:23:59 -0400
IronPort-SDR: OZYUxUMqVVuRRnq1du0JbeF/Kbrdub0WgylukGsDt80eYAx4RfyusmyxorUrT8wrzy6zVDdrv+
 3NiMj8UztdZA==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415790"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415790"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:27 -0700
IronPort-SDR: dtViSMl6lTc5wMsACbeL3ov589GlfwH/YvQ25LlyVvqiO/N9SfEUeZnERyrA0FoL4LO/vSrA1K
 qaIgsqWadSyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149216"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 07/11] igb: override two checker warnings
Date:   Wed, 26 May 2021 10:23:42 -0700
Message-Id: <20210526172346.3515587-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The igb PTP code was using htons() on a constant to try to
byte swap the value before writing it to a register. This byte
swap has the consequence of triggering sparse conflicts between
the register write which expect cpu ordered input, and the code
which generated a big endian constant. Just override the cast
to make sure code doesn't change but silence the warning.

Can't do a __swab16 in this case because big endian systems
would then write the wrong value.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Warning Detail
  CHECK   .../igb/igb_ptp.c
.../igb/igb_ptp.c:1137:17: warning: incorrect type in argument 1 (different base types)
.../igb/igb_ptp.c:1137:17:    expected unsigned int val
.../igb/igb_ptp.c:1137:17:    got restricted __be16 [usertype]
.../igb/igb_ptp.c:1142:25: warning: incorrect type in argument 1 (different base types)
.../igb/igb_ptp.c:1142:25:    expected unsigned int val
.../igb/igb_ptp.c:1142:25:    got restricted __be16 [usertype]
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index ba61fe9bfaf4..de08ae8db4d5 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -1134,12 +1134,12 @@ static int igb_ptp_set_timestamp_mode(struct igb_adapter *adapter,
 			| E1000_FTQF_MASK); /* mask all inputs */
 		ftqf &= ~E1000_FTQF_MASK_PROTO_BP; /* enable protocol check */
 
-		wr32(E1000_IMIR(3), htons(PTP_EV_PORT));
+		wr32(E1000_IMIR(3), (__force unsigned int)htons(PTP_EV_PORT));
 		wr32(E1000_IMIREXT(3),
 		     (E1000_IMIREXT_SIZE_BP | E1000_IMIREXT_CTRL_BP));
 		if (hw->mac.type == e1000_82576) {
 			/* enable source port check */
-			wr32(E1000_SPQF(3), htons(PTP_EV_PORT));
+			wr32(E1000_SPQF(3), (__force unsigned int)htons(PTP_EV_PORT));
 			ftqf &= ~E1000_FTQF_MASK_SOURCE_PORT_BP;
 		}
 		wr32(E1000_FTQF(3), ftqf);
-- 
2.26.2

