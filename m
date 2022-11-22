Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D73063430B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbiKVRyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbiKVRy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:54:29 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C71AFCC0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669139503; x=1700675503;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KHhaN0VLZ53QMKM6HDDsuPxoSiLFrJIfLbWHqOF7Azo=;
  b=GNsuh7gehd9mZOinmZaABVAUj76yWhkzHxO8WZR+cuszxroqfDWIysf5
   FNe5mlaeNfBYv9bJohVncGBlRRynwsRwYpKSBC8HcUTVLDqKJIbmeCzwf
   osfLxlwAbpOvjBzQesZO3Ny1QGPkjxc+chsQO9QVuLmef83POL6aR/OEG
   PDltzi7MEZDb2PH+wFXc1R62N71lwWYyJM9JDPk9/Jp4oFWq2GES1VGxw
   H3iWUljfu3WoxEWG96U92jiPBnXitgoe4BRxmscD5ub6bnY7mYiil79ka
   nJgBr3R3umzzATrHZ1xnYlyAf1DMqAUiJDagaxvwpZ7v/NGv+d98Plz/1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315695858"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="315695858"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 09:47:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="619300930"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="619300930"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by orsmga006.jf.intel.com with ESMTP; 22 Nov 2022 09:47:16 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com,
        edumazet@google.com, pabeni@redhat.com, didi.debian@cknow.org,
        Bonaccorso Salvatore <carnil@debian.org>
Subject: [PATCH net 2/4] net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
Date:   Tue, 22 Nov 2022 23:16:57 +0530
Message-Id: <20221122174657.3496826-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Fix build error reported on armhf while preparing 6.1-rc5
for Debian.

iosm_ipc_protocol.c:244:36: error: passing argument 3 of
'dma_alloc_coherent' from incompatible pointer type.

Change phy_ap_shm type from phys_addr_t to dma_addr_t.

Fixes: faed4c6f6f48 ("net: iosm: shared memory protocol")
Reported-by: Bonaccorso Salvatore <carnil@debian.org>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_protocol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol.h b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
index 9b3a6d86ece7..289397c4ea6c 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
@@ -122,7 +122,7 @@ struct iosm_protocol {
 	struct iosm_imem *imem;
 	struct ipc_rsp *rsp_ring[IPC_MEM_MSG_ENTRIES];
 	struct device *dev;
-	phys_addr_t phy_ap_shm;
+	dma_addr_t phy_ap_shm;
 	u32 old_msg_tail;
 };
 
-- 
2.34.1

