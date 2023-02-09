Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5127E6906E7
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjBILVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjBILUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:20:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2311A5AB3A;
        Thu,  9 Feb 2023 03:17:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F3961A2A;
        Thu,  9 Feb 2023 11:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C36C433D2;
        Thu,  9 Feb 2023 11:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941474;
        bh=u5OTeyvEI9BF11Q3e6rlK/Gtws2OGY6/oidQIVWTcdY=;
        h=From:To:Cc:Subject:Date:From;
        b=CedugU1tkhgKeCDcJ3Y9HqqwmezGNYoB45Xn4Uak0TUvZrz4U57vne4ZgkrjxHdfx
         zakNTNyyc7ZUbqhDpMkfDoO4hDVraYH7keUF1E6q2A2QwuU4BfhLZCxK8PQ4FnuAw7
         FbAuICWxMGdSbwiiYEXGKGhnAehGIq29vLGjYvIQ115K9nKPo6Wznln5xsF/yobt7p
         h94tG2uvBLdjM9ck5QXXX3IiJ6Pe52GX/DWpV85+dmSmFV+BXklGf8RD/JeNls0kUJ
         1D6fLIUx13mGujlzLZAo5IJKZlt5t28kIe3/j1/aP2MvZFeGTDvPi0bzfEp4W0PhAg
         Lcew9WiLRv89w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: [PATCH bpf-next] ice: update xdp_features with xdp multi-buff
Date:   Thu,  9 Feb 2023 12:17:25 +0100
Message-Id: <b564473cdefc82bda9a3cecd3c15538a418e8ad2.1675941199.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now ice driver supports xdp multi-buffer so add it to xdp_features.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 074b0e6d0e2d..7194888d2a3d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2913,7 +2913,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 			if (xdp_ring_err)
 				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
 		}
-		xdp_features_set_redirect_target(vsi->netdev, false);
+		xdp_features_set_redirect_target(vsi->netdev, true);
 		/* reallocate Rx queues that are used for zero-copy */
 		xdp_ring_err = ice_realloc_zc_buf(vsi, true);
 		if (xdp_ring_err)
@@ -3463,7 +3463,8 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 
 	ice_set_netdev_features(netdev);
 	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
+			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
+			       NETDEV_XDP_ACT_RX_SG;
 
 	ice_set_ops(netdev);
 
-- 
2.39.1

