Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF9A6CB72A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 08:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjC1G3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 02:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjC1G3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 02:29:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2035D7
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 23:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679984987; x=1711520987;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QExTMLWZn+h4Grurg9zf9tkYjjGzgdLToDUp66g2UvA=;
  b=PoSBVJDGC6wovFkFn6VKyTpVQ7FPU0Q7eaV1DLC4Bc0/1dIOOVqH2Gwo
   w1uRb8iPS8/Qy2t9N8p0N9JIyO/bDgn0blQIt4P0BisecHMdUFv9BVvmz
   w2pSTl+qor6ustZKyKkycY7gbtvca8xOZSDDXx5guxm2GqqwELjXg8pqU
   qwjIPWTP4y8glUmgD/NisMk9nrfKsJse7Hk5nOF7ID6w4slfkqToKnkgH
   IfT2qk5g6Vucy94eIZB4ECym+P3PERdsTiksLHDwxoS+7a7Mq9wkrAJUI
   7QVVoTlkpC98XfLScztueMtKolpt+GK9ceOU9LeGDthBHXDZ4gXyYrySc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="320136695"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="320136695"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 23:29:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="716363080"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="716363080"
Received: from bswcg4446240.iind.intel.com ([10.224.174.140])
  by orsmga001.jf.intel.com with ESMTP; 27 Mar 2023 23:29:40 -0700
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        shaneparslow808@gmail.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Martin <mwolf@adiumentum.com>
Subject: [PATCH net] net: wwan: iosm: fixes 7560 modem crash
Date:   Tue, 28 Mar 2023 11:58:44 +0530
Message-Id: <b5b3b67ed4dcbc508961dfd3e196857d6ae1385c.1679983314.git.m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

ModemManger/Apps probing the wwan0xmmrpc0 port for 7560 Modem results in
modem crash.

7560 Modem FW uses the MBIM interface for control command communication
whereas 7360 uses Intel RPC interface so disable wwan0xmmrpc0 port for
7560.

Fixes: d08b0f8f46e4 ("net: wwan: iosm: add rpc interface for xmm modems")
Reported-and-tested-by: Martin <mwolf@adiumentum.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217200
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 1e6a47976642..c066b0040a3f 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -587,6 +587,13 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 	while (ctrl_chl_idx < IPC_MEM_MAX_CHANNELS) {
 		if (!ipc_chnl_cfg_get(&chnl_cfg_port, ctrl_chl_idx)) {
 			ipc_imem->ipc_port[ctrl_chl_idx] = NULL;
+
+			if (ipc_imem->pcie->pci->device == INTEL_CP_DEVICE_7560_ID &&
+			    chnl_cfg_port.wwan_port_type == WWAN_PORT_XMMRPC) {
+				ctrl_chl_idx++;
+				continue;
+			}
+
 			if (ipc_imem->pcie->pci->device == INTEL_CP_DEVICE_7360_ID &&
 			    chnl_cfg_port.wwan_port_type == WWAN_PORT_MBIM) {
 				ctrl_chl_idx++;
--
2.34.1

