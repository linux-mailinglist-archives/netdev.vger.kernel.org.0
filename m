Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D53932D321
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhCDMdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:37596 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240613AbhCDMdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:14 -0500
IronPort-SDR: CioQHSl8vrKy5M+Aq0fl59k2xZGhEmvxuTV3GonqE+1QFQi8+jOr+SdMtY2EQ7beU+KbSeOPGj
 rOT7hWErtznQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="207113146"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="207113146"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:29 -0800
IronPort-SDR: 5n3gJrn0wB4W3i2igPQKvofZRm9c8dfzD9od3nSAc0eIb3KVouGxW4rM7IxRxjnOWOnhxC6HVh
 ZgyLh8vxu79A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="407764313"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 04 Mar 2021 04:31:26 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 3BF3AB8; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 01/18] thunderbolt: Disable retry logic for intra-domain control packets
Date:   Thu,  4 Mar 2021 15:31:08 +0300
Message-Id: <20210304123125.43630-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In most cases the response packet is lost because the router in question
was disconnected by the user. Resending the control packet in that case
just adds unnecessary delays, so disable that for intra-domain control
packets. For inter-domain (XDomain) packets we continue retrying.

This also aligns the driver better what the Intel connection manager
firmware is doing.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index f1aeaff9f368..875922133782 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -17,7 +17,7 @@
 
 
 #define TB_CTL_RX_PKG_COUNT	10
-#define TB_CTL_RETRIES		4
+#define TB_CTL_RETRIES		1
 
 /**
  * struct tb_ctl - Thunderbolt control channel
-- 
2.30.1

