Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E15A72E
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfF1WtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:51494 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfF1WtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039143"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 08/15] iavf: Fix up debug print macro
Date:   Fri, 28 Jun 2019 15:49:25 -0700
Message-Id: <20190628224932.3389-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This aligns the iavf_debug() macro with the other Intel drivers.

Add the bus number, bus_id field to i40e_bus_info so output shows
each physical port(i.e func) in following format:
  [[[[<domain>]:]<bus>]:][<slot>][.[<func>]]
domains are numbered from 0 to ffff), bus (0-ff), slot (0-1f) and
function (0-7).

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_osdep.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
index d39684558597..a452ce90679a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
@@ -44,8 +44,12 @@ struct iavf_virt_mem {
 #define iavf_allocate_virt_mem(h, m, s) iavf_allocate_virt_mem_d(h, m, s)
 #define iavf_free_virt_mem(h, m) iavf_free_virt_mem_d(h, m)
 
-#define iavf_debug(h, m, s, ...)  iavf_debug_d(h, m, s, ##__VA_ARGS__)
-extern void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
-	__printf(3, 4);
+#define iavf_debug(h, m, s, ...)				\
+do {								\
+	if (((m) & (h)->debug_mask))				\
+		pr_info("iavf %02x:%02x.%x " s,			\
+			(h)->bus.bus_id, (h)->bus.device,	\
+			(h)->bus.func, ##__VA_ARGS__);		\
+} while (0)
 
 #endif /* _IAVF_OSDEP_H_ */
-- 
2.21.0

