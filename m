Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1C652E1C3
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344366AbiETBQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344359AbiETBQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:16:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0460D38BF2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653009362; x=1684545362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y5alR8X1iiRzv2aqzNRWNZvPhKBChN/toGkywq+hTEA=;
  b=gsU7rC+RapGiNY9QiqRC+jCvvcCV/aES2idUKC/RI0SXw0Y3iLZN89J9
   /u9xtICqh/0taIUZwp/b4QXsvISqdm2gJktmUUn447HeHl3clmiW0XHGt
   xmMYNod1uTmepzok0kNQcaFw+U0PVaDPu4XWPI7UZfm/BOxpKJlwlFDh2
   D7+osHEyGobnBdpyMoM8eA81elR0TWwNIwsktiF11j1d/AjgB2u2cVrYH
   k6uZWFU9iBSH8R67tqvZJetOefhh/SWBDtvVbSbm6X+DjXNv2NoKV/9sf
   SFBScSnnIZ1YiG7IZp9VBxcekTrG/OihbMsS/WBQY/RUAndtvYRnWvORd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="333064168"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="333064168"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570534566"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v5 10/11] igc: Check incompatible configs for Frame Preemption
Date:   Thu, 19 May 2022 18:15:37 -0700
Message-Id: <20220520011538.1098888-11-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220520011538.1098888-1-vinicius.gomes@intel.com>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frame Preemption and LaunchTime cannot be enabled on the same queue.
If that situation happens, emit an error to the user, and log the
error.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 69e96e9a3ec8..96ad00e33f4b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5916,6 +5916,11 @@ static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
 	if (queue < 0 || queue >= adapter->num_tx_queues)
 		return -EINVAL;
 
+	if (ring->preemptible) {
+		netdev_err(adapter->netdev, "Cannot enable LaunchTime on a preemptible queue\n");
+		return -EINVAL;
+	}
+
 	ring = adapter->tx_ring[queue];
 	ring->launchtime_enable = enable;
 
-- 
2.35.3

