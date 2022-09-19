Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF9B5BD77B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiISWes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiISWep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:34:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2134F63DD
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663626882; x=1695162882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yivsQMja2EPH946EGsfvynkOQH2VqeJo2IBuEqV5DDw=;
  b=j9foHlIT5jduEq8CMw0CKgoC222RdMifAq/d8a3KU1VCVehTHQaAuHDv
   vr/+LMSx5LyknOBXU4kewZ3kAeZgTL5g8Dxp7/r1hxStenOSYQ11Rb9Vv
   HjMmTosNi3Ei+UOqYH2pUofnbUzxYcllMR7zOXULzHuRqanW37M3Ssm8m
   HN2kq96ruUs8NGuoQ+I40mK6vhF6HB/mnabFOAqd/9/OuHftGRK7cxaPv
   FMFQYhkasILsEsys23l0NSMJoJr6C2G/KMOWRbz20QAckgY0iz7gyMryN
   kO+vo055qqFubuQ7Tu0b0gYzqF7TxkBRyiHairSQdUHSIfljwfCzLIu4L
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298265231"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="298265231"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 15:34:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="651855352"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Sep 2022 15:34:37 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Jaron <michalx.jaron@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/4] iavf: Fix set max MTU size with port VLAN and jumbo frames
Date:   Mon, 19 Sep 2022 15:34:26 -0700
Message-Id: <20220919223428.572091-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220919223428.572091-1-anthony.l.nguyen@intel.com>
References: <20220919223428.572091-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

After setting port VLAN and MTU to 9000 on VF with ice driver there
was an iavf error
"PF returned error -5 (IAVF_ERR_PARAM) to our request 6".

During queue configuration, VF's max packet size was set to
IAVF_MAX_RXBUFFER but on ice max frame size was smaller by VLAN_HLEN
due to making some space for port VLAN as VF is not aware whether it's
in a port VLAN. This mismatch in sizes caused ice to reject queue
configuration with ERR_PARAM error. Proper max_mtu is sent from ice PF
to VF with GET_VF_RESOURCES msg but VF does not look at this.

In iavf change max_frame from IAVF_MAX_RXBUFFER to max_mtu
received from pf with GET_VF_RESOURCES msg to make vf's
max_frame_size dependent from pf. Add check if received max_mtu is
not in eligible range then set it to IAVF_MAX_RXBUFFER.

Fixes: dab86afdbbd1 ("i40e/i40evf: Change the way we limit the maximum frame size for Rx")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 15ee85dc33bd..5a9e6563923e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -269,11 +269,14 @@ int iavf_get_vf_vlan_v2_caps(struct iavf_adapter *adapter)
 void iavf_configure_queues(struct iavf_adapter *adapter)
 {
 	struct virtchnl_vsi_queue_config_info *vqci;
-	struct virtchnl_queue_pair_info *vqpi;
+	int i, max_frame = adapter->vf_res->max_mtu;
 	int pairs = adapter->num_active_queues;
-	int i, max_frame = IAVF_MAX_RXBUFFER;
+	struct virtchnl_queue_pair_info *vqpi;
 	size_t len;
 
+	if (max_frame > IAVF_MAX_RXBUFFER || !max_frame)
+		max_frame = IAVF_MAX_RXBUFFER;
+
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
 		/* bail because we already have a command pending */
 		dev_err(&adapter->pdev->dev, "Cannot configure queues, command %d pending\n",
-- 
2.35.1

