Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239121A0329
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgDGAHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgDGACB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8016F2083E;
        Tue,  7 Apr 2020 00:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217721;
        bh=RAwU162BS26ai5syTm5AqPDNd16wG2wCjwkS9R5Y0xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0pDEekeh3iXTwTxfJQHVif6oK8nTKfXcFIco6TtWCMAL9Wd9oWYSFMOtMu4FEUW2
         Pd0XBy2zz0H/om3mt6zrp4N4qk+681igQUVPkJvp2UUln0aQzstA6cS2H0ObJfZZ0J
         3O3+99ubAMxXdg/cI7OGnA/sPGxm6orfMIMiimbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/32] iwlwifi: yoyo: don't add TLV offset when reading FIFOs
Date:   Mon,  6 Apr 2020 20:01:25 -0400
Message-Id: <20200407000151.16768-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit a5688e600e78f9fc68102bf0fe5c797fc2826abe ]

The TLV offset is only used to read registers, while the offset used for
the FIFO addresses are hard coded in the driver and not given by the
TLV.

If we try to apply the TLV offset when reading the FIFOs, we'll read
from invalid addresses, causing the driver to hang.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: 8d7dea25ada7 ("iwlwifi: dbg_ini: implement Rx fifos dump")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151129.fbab869c26fa.I4ddac20d02f9bce41855a816aa6855c89bc3874e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 386ca67ec7b4e..ef65e1ea374fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1373,11 +1373,7 @@ static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
 		goto out;
 	}
 
-	/*
-	 * region register have absolute value so apply rxf offset after
-	 * reading the registers
-	 */
-	offs += rxf_data.offset;
+	offs = rxf_data.offset;
 
 	/* Lock fence */
 	iwl_write_prph_no_grab(fwrt->trans, RXF_SET_FENCE_MODE + offs, 0x1);
-- 
2.20.1

